package product

import (
	"regexp"
	"strconv"
	"strings"
)

func GetUnitAmountParts(s string) (amount float64, unit string) {
	// Define regular expressions for matching the amount and unit
	amountRegex := regexp.MustCompile(`^[\d.]+`)
	unitRegex := regexp.MustCompile(`[a-zA-Z]+$`)

	// Find the amount in the string
	amountStr := amountRegex.FindString(s)
	if amountStr != "" {
		// Parse the amount as a float64
		amount, _ = strconv.ParseFloat(amountStr, 64)
	}

	// Find the unit in the string
	unitStr := unitRegex.FindString(s)

	// Remove leading/trailing whitespace and convert to lowercase
	unit = strings.TrimSpace(strings.ToLower(unitStr))

	return amount, unit
}
