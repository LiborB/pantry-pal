import { createBottomTabNavigator } from "@react-navigation/bottom-tabs";
import HomeScreen from "../../home/HomeScreen";
import PantryScreen from "../../pantry/PantryScreen";
import { BottomNavigation, Appbar } from "react-native-paper";
import Icon from "react-native-vector-icons/MaterialCommunityIcons";
import TopAppBar from "./TopAppBar";

const Tab = createBottomTabNavigator();

export default function BottomNav() {
  return (
    <Tab.Navigator
      initialRouteName="Home"
      screenOptions={{
        header: (props) => <TopAppBar {...props} />,
      }}
      tabBar={({ navigation, state, descriptors, insets }) => (
        <BottomNavigation.Bar
          navigationState={state}
          safeAreaInsets={insets}
          onTabPress={({ route, preventDefault }) => {
            const event = navigation.emit({
              type: "tabPress",
              target: route.key,
              canPreventDefault: true,
            });

            if (event.defaultPrevented) {
              preventDefault();
            } else {
              navigation.navigate(route.name, route.params);
            }
          }}
          renderIcon={({ route, focused, color }) => {
            const { options } = descriptors[route.key];
            if (options.tabBarIcon) {
              return options.tabBarIcon({ focused, color, size: 24 });
            }

            return null;
          }}
          getLabelText={({ route }) => {
            const { options } = descriptors[route.key];
            const label = options.tabBarLabel as string;

            return label;
          }}
        ></BottomNavigation.Bar>
      )}
    >
      <Tab.Screen
        name="Home"
        component={HomeScreen}
        options={{
          tabBarLabel: "Home",
          tabBarIcon: ({ color, size }) => (
            <Icon name="home" color={color} size={size} />
          ),
        }}
      />
      <Tab.Screen
        name="Pantry"
        component={PantryScreen}
        options={{
          tabBarLabel: "Pantry",
          tabBarIcon: ({ color, size }) => (
            <Icon name="format-list-bulleted" color={color} size={size} />
          ),
        }}
      />
    </Tab.Navigator>
  );
}
