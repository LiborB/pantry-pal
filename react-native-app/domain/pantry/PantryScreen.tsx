import { SafeAreaView, ScrollView, Text, View } from "react-native";
import { FAB } from "react-native-paper";
import styled from "styled-components/native";

export default function PantryScreen() {
  return (
    <Container>
      <AddItemButton icon="plus" />
    </Container>
  );
}

const AddItemButton = styled(FAB)`
  margin: 16px;
`;

const Container = styled.ScrollView`
  position: absolute;
  right: 0;
  bottom: 0;
`;
