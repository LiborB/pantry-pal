import { useEffect } from "react";
import { ActivityIndicator, MD3Colors } from "react-native-paper";
import { useUserStore } from "../store/store";
import { NativeStackScreenProps } from "@react-navigation/native-stack";
import { RootStackParamList } from "../navigator";
import { getAuth } from "firebase/auth";
import { View } from "react-native";
import styled from "styled-components/native";

const Container = styled(View)`
  display: flex;
  height: 100%;
  align-items: center;
  justify-content: center;
`;

export default function SplashScreen({
  navigation,
}: NativeStackScreenProps<RootStackParamList, "Splash">) {
  const setUser = useUserStore((store) => store.setUser);

  useEffect(() => {
    const currentUser = getAuth().currentUser;

    if (!currentUser) {
      navigation.navigate("Login");
    } else {
      setUser(currentUser);
      navigation.navigate("Main");
    }
  }, []);

  return (
    <Container>
      <ActivityIndicator size="large" animating={true} />
    </Container>
  );
}
