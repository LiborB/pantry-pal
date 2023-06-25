package household

import (
	"errors"
	"github.com/gin-gonic/gin"
	"gorm.io/gorm"
	"log"
	"net/http"
	"pantry_pal_backend/domain/common"
	"pantry_pal_backend/domain/database"
	"strconv"
)

func AddRoutes(r *gin.Engine) {
	r.POST("/household", createHousehold)
	r.GET("/household", getHouseholds)
	r.GET("/household/invites", getPendingInvites)
	r.POST("/household/invites/respond", respondInvite)

	householdGroup := r.Group("/household/:householdId", common.HouseholdValidator)
	householdGroup.POST("", updateHousehold)
	householdGroup.GET("/members", getMembers)
	householdGroup.POST("/members", addMember)

}

type householdMember struct {
	UserId      string `json:"userId"`
	Email       string `json:"email"`
	Status      string `json:"status"`
	IsOwner     bool   `json:"isOwner"`
	CreatedAt   int    `json:"createdAt"`
	HouseholdId int    `json:"householdId"`
}

func getMembers(c *gin.Context) {
	householdId := c.GetInt("householdId")

	var dbMembers []database.HouseholdMember

	database.DB.Where(database.HouseholdMember{HouseholdID: householdId}).Joins("User").Find(&dbMembers)

	output := []householdMember{}
	for _, member := range dbMembers {
		output = append(output, householdMember{
			UserId:      member.UserID,
			Email:       member.User.Email,
			Status:      member.Status,
			IsOwner:     member.IsOwner,
			CreatedAt:   int(member.CreatedAt.UnixMilli()),
			HouseholdId: member.HouseholdID,
		})
	}

	c.JSON(http.StatusOK, output)
}

type addMemberPayload struct {
	Email string `json:"email"`
}

func addMember(c *gin.Context) {
	householdId := c.GetInt("householdId")
	userId := c.GetString("userId")

	var body addMemberPayload
	common.GetJson(c, &body)

	var user database.User
	tx := database.DB.Where(&database.User{Email: body.Email}).First(&user)

	if errors.Is(tx.Error, gorm.ErrRecordNotFound) {
		c.JSON(http.StatusNotFound, gin.H{
			"code": "user_not_found",
		})
		return
	}

	if userId == user.ID {
		c.JSON(http.StatusBadRequest, gin.H{
			"code": "cannot_add_self",
		})
		return
	}

	var member database.HouseholdMember
	tx = database.DB.Where(&database.HouseholdMember{
		HouseholdID: householdId,
		UserID:      user.ID,
	}).First(&member)

	if tx.Error == nil {
		c.JSON(http.StatusBadRequest, gin.H{
			"code": "member_exists",
		})
		return
	}

	database.DB.Create(&database.HouseholdMember{
		HouseholdID: householdId,
		UserID:      user.ID,
		Status:      "pending",
		IsOwner:     false,
	})

	c.Status(http.StatusNoContent)
}

type createHouseholdPayload struct {
	Name string `json:"name"`
}

func createHousehold(c *gin.Context) {
	userId := c.GetString("userId")

	var body createHouseholdPayload
	common.GetJson(c, &body)

	household := database.Household{
		UserID: userId,
		Name:   body.Name,
	}
	database.DB.Create(&household)

	database.DB.Create(&database.HouseholdMember{
		HouseholdID: household.ID,
		UserID:      userId,
		Status:      "accepted",
		IsOwner:     true,
	})

	c.Status(http.StatusNoContent)
}

type household struct {
	Id        int    `json:"id"`
	Name      string `json:"name"`
	CreatedAt int    `json:"createdAt"`
}

func getHouseholds(c *gin.Context) {
	userId := c.GetString("userId")

	var memberships []database.HouseholdMember

	database.DB.Where(&database.HouseholdMember{UserID: userId,
		Status: "accepted"}).Find(&memberships)

	output := []household{}

	for _, m := range memberships {
		hh := database.Household{
			ID: m.HouseholdID,
		}
		database.DB.Find(&hh)

		output = append(output, household{
			Id:        hh.ID,
			Name:      hh.Name,
			CreatedAt: int(hh.CreatedAt.UnixMilli()),
		})
	}

	c.JSON(http.StatusOK, output)
}

type updateHouseholdPayload struct {
	Name string `json:"name"`
}

func updateHousehold(c *gin.Context) {
	householdId := c.GetInt("householdId")

	var body updateHouseholdPayload
	common.GetJson(c, &body)

	database.DB.Updates(database.Household{
		ID:   householdId,
		Name: body.Name,
	})

	c.Status(http.StatusNoContent)
}

func getPendingInvites(c *gin.Context) {
	userId := c.GetString("userId")

	var memberships []database.HouseholdMember

	database.DB.Where(&database.HouseholdMember{UserID: userId,
		Status: "pending"}).Find(&memberships)

	if len(memberships) == 0 {
		c.JSON(http.StatusOK, []householdMember{})
		return
	}

	output := []householdMember{}

	for _, m := range memberships {
		user := database.User{
			ID: m.UserID,
		}
		database.DB.Find(&user)

		output = append(output, householdMember{
			UserId:      m.UserID,
			Email:       user.Email,
			Status:      m.Status,
			IsOwner:     m.IsOwner,
			HouseholdId: m.HouseholdID,
		})
	}

	c.JSON(http.StatusOK, output)
}

func respondInvite(c *gin.Context) {
	householdId, _ := strconv.Atoi(c.Query("householdId"))
	userId := c.GetString("userId")
	accept := c.Query("accept")

	log.Println(c.Query("householdId"))

	var member database.HouseholdMember
	database.DB.Where(&database.HouseholdMember{
		HouseholdID: householdId,
		UserID:      userId,
	}).First(&member)

	if member.Status != "pending" {
		c.JSON(http.StatusBadRequest, gin.H{
			"code": "not_pending",
		})
		return
	}

	if accept == "false" {
		database.DB.Delete(&member)
		c.Status(http.StatusNoContent)
		return
	} else {
		member.Status = "accepted"
		database.DB.Save(&member)
		c.Status(http.StatusNoContent)
		return
	}
}
