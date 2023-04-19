import { createNativeStackNavigator } from "@react-navigation/native-stack";
import { NavigationContainer } from "@react-navigation/native";
import HomeScreen from "../../home/HomeScreen";
import { SafeAreaView, Text } from "react-native";
import PantryScreen from "../../pantry/PantryScreen";
import BottomNav from "./BottomNav";

export default function MainLayout() {
  return <BottomNav />;
}
