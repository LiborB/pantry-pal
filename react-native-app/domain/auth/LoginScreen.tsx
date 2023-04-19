import { getAuth, signInWithEmailAndPassword } from "firebase/auth";
import { Controller, useForm } from "react-hook-form";
import { View } from "react-native";
import { Button, Headline, Text, TextInput } from "react-native-paper";
import { SafeAreaView } from "react-native-safe-area-context";
import styled from "styled-components/native";
import { firebaseApp } from "../../App";
import { useUserStore } from "../store/store";
import { NativeStackScreenProps } from "@react-navigation/native-stack";
import { RootStackParamList } from "../navigator";
import { useState } from "react";

const Title = styled(Text)`
  text-align: center;
  margin-bottom: 12px;
`;
const PageContainer = styled.View`
  padding: 8px;
  margin-top: 20%;
`;
const FormFieldContainer = styled.View`
  padding: 6px;
`;
const SubmitButton = styled(Button)`
  margin-top: 6px;
`;

interface FormFields {
  email: string;
  password: string;
}

export default function Login({
  navigation,
}: NativeStackScreenProps<RootStackParamList, "Login">) {
  const {
    control,
    handleSubmit,
    formState: { errors },
    clearErrors,
    setError,
  } = useForm<FormFields>();
  const setUser = useUserStore((store) => store.setUser);
  const [isLoading, setIsLoading] = useState(false);

  async function onSubmit(form: FormFields) {
    clearErrors();

    setIsLoading(true);

    try {
      const { user } = await signInWithEmailAndPassword(
        getAuth(firebaseApp),
        form.email,
        form.password
      );

      setUser(user);
      navigation.navigate("Main");
    } catch (e) {
      console.log(e);
    } finally {
      setIsLoading(false);
    }
  }

  return (
    <SafeAreaView>
      <PageContainer>
        <Title variant="headlineLarge">Login to your account</Title>
        <FormFieldContainer>
          <Controller
            rules={{ required: true }}
            name="email"
            control={control}
            render={({ field }) => (
              <TextInput
                {...field}
                autoCorrect={false}
                autoCapitalize="none"
                keyboardType="email-address"
                onChangeText={field.onChange}
                error={!!errors.email}
                label="Username"
              />
            )}
          />
        </FormFieldContainer>

        <FormFieldContainer>
          <Controller
            rules={{ required: true }}
            name="password"
            control={control}
            render={({ field }) => (
              <TextInput
                {...field}
                autoCorrect={false}
                autoCapitalize="none"
                onChangeText={field.onChange}
                error={!!errors.password}
                label="Password"
              />
            )}
          />
        </FormFieldContainer>

        <SubmitButton
          loading={isLoading}
          mode="contained"
          onPress={handleSubmit(onSubmit)}
        >
          Login
        </SubmitButton>
      </PageContainer>
    </SafeAreaView>
  );
}
