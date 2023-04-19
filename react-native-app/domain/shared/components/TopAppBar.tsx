import { BottomTabHeaderProps } from "@react-navigation/bottom-tabs";
import { Appbar } from "react-native-paper";
import { getHeaderTitle } from "@react-navigation/elements";

export default function TopAppBar(props: BottomTabHeaderProps) {
  const title = getHeaderTitle(props.options, props.route.name);

  return (
    <Appbar.Header mode="center-aligned" elevated>
      <Appbar.Content title={title} />
    </Appbar.Header>
  );
}
