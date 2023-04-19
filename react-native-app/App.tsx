import { NavigationContainer } from "@react-navigation/native";
import MainLayout from "./domain/shared/components/Layout";
import {
  MD3LightTheme,
  MD3Theme,
  Provider as PaperProvider,
} from "react-native-paper";
import { createNativeStackNavigator } from "@react-navigation/native-stack";
import SplashScreen from "./domain/splash/SplashScreen";
import Login from "./domain/auth/LoginScreen";
import { RootStackParamList } from "./domain/navigator";
import { initializeApp } from "firebase/app";
import { Platform, PlatformColor } from "react-native";

const Stack = createNativeStackNavigator<RootStackParamList>();

export const firebaseApp = initializeApp({
  projectId: "pantrypal-3d54e",
  authDomain: "pantrypal-3d54e.firebaseapp.com",
  apiKey: "AIzaSyB9dk4S1m7KsZsvMJpKFhsumK2eP7kZe9w",
  appId:
    Platform.OS === "ios"
      ? "1:135361706279:ios:047db9cc8ef52fc5785102"
      : "1:135361706279:android:ce993cfda18a929a785102  ",
});

const theme: MD3Theme = {
  ...MD3LightTheme,
  colors: {
    primary: "rgb(169, 0, 169)",
    onPrimary: "rgb(255, 255, 255)",
    primaryContainer: "rgb(255, 215, 245)",
    onPrimaryContainer: "rgb(56, 0, 56)",
    secondary: "rgb(110, 88, 105)",
    onSecondary: "rgb(255, 255, 255)",
    secondaryContainer: "rgb(247, 218, 239)",
    onSecondaryContainer: "rgb(39, 22, 36)",
    tertiary: "rgb(130, 83, 69)",
    onTertiary: "rgb(255, 255, 255)",
    tertiaryContainer: "rgb(255, 219, 209)",
    onTertiaryContainer: "rgb(50, 18, 8)",
    error: "rgb(186, 26, 26)",
    onError: "rgb(255, 255, 255)",
    errorContainer: "rgb(255, 218, 214)",
    onErrorContainer: "rgb(65, 0, 2)",
    background: "rgb(255, 251, 255)",
    onBackground: "rgb(30, 26, 29)",
    surface: "rgb(255, 251, 255)",
    onSurface: "rgb(30, 26, 29)",
    surfaceVariant: "rgb(238, 222, 231)",
    onSurfaceVariant: "rgb(78, 68, 75)",
    outline: "rgb(128, 116, 124)",
    outlineVariant: "rgb(209, 194, 203)",
    shadow: "rgb(0, 0, 0)",
    scrim: "rgb(0, 0, 0)",
    inverseSurface: "rgb(52, 47, 50)",
    inverseOnSurface: "rgb(248, 238, 242)",
    inversePrimary: "rgb(255, 171, 243)",
    elevation: {
      level0: "transparent",
      level1: "rgb(251, 238, 251)",
      level2: "rgb(248, 231, 248)",
      level3: "rgb(246, 223, 246)",
      level4: "rgb(245, 221, 245)",
      level5: "rgb(243, 216, 243)",
    },
    surfaceDisabled: "rgba(30, 26, 29, 0.12)",
    onSurfaceDisabled: "rgba(30, 26, 29, 0.38)",
    backdrop: "rgba(55, 46, 52, 0.4)",
  },
};

export default function App() {
  return (
    <NavigationContainer>
      <PaperProvider theme={theme}>
        <Stack.Navigator initialRouteName="Splash">
          <Stack.Screen
            name="Splash"
            component={SplashScreen}
            options={{ headerShown: false }}
          />
          <Stack.Screen
            name="Login"
            component={Login}
            options={{ headerBackVisible: false, headerShown: false }}
          />
          <Stack.Screen
            name="Main"
            component={MainLayout}
            options={{ headerShown: false }}
          />
        </Stack.Navigator>
      </PaperProvider>
    </NavigationContainer>
  );
}
