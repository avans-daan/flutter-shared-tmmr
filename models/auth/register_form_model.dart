import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../http_client.dart';
import 'form_item_model.dart';

@immutable
class RegisterFormModel {
  const RegisterFormModel({
    this.email = const FormItem(''),
    this.name = const FormItem(''),
    this.password = const FormItem(''),
    this.passwordConfirm = const FormItem(''),
    this.isPasswordVisible = false,
    this.isLoading = false,
  });

  final FormItem<String> email;
  final FormItem<String> name;
  final FormItem<String> password;
  final FormItem<String> passwordConfirm;
  final bool isPasswordVisible;
  final bool isLoading;

  RegisterFormModel copyWith(
      {FormItem<String>? email,
      FormItem<String>? name,
      FormItem<String>? password,
      FormItem<String>? passwordConfirm,
      bool? isPasswordVisible,
      bool? isLoading}) {
    return RegisterFormModel(
      email: email ?? this.email,
      password: password ?? this.password,
      name: name ?? this.name,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class RegisterFormNotifier extends StateNotifier<RegisterFormModel> {
  RegisterFormNotifier() : super(const RegisterFormModel());

  void switchPasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void setEmail(String? email) {
    state = state.copyWith(email: FormItem(email!));
  }

  void setName(String? name) {
    state = state.copyWith(name: FormItem(name!));
  }

  void setPassword(String? password) {
    state = state.copyWith(password: FormItem(password!));
  }

  void setPasswordConfirm(String? passwordConfirm) {
    state = state.copyWith(passwordConfirm: FormItem(passwordConfirm!));
  }

  Future<bool> tryRegister() async {
    try {
      state = state.copyWith(isLoading: true);
      var client = HttpClient();
      var data = {
        'email': state.email.value,
        'name': state.name.value,
        'password': state.password.value,
        'password_confirmation': state.password.value,
      };
      var result =
          await client.getClient().post('/api/user/register', data: data);
      state = state.copyWith(
          isLoading: false,
          password: null,
          passwordConfirm: null,
          name: null,
          email: null);
      return result.data != null;
    } on DioError catch (error) {
      if (error.response?.statusCode == 422) {
        if (error.response?.data != null) {
          state = state.copyWith(
              email: FormItem(state.email.value,
                  error: error.response?.data['errors']['email'] != null
                      ? error.response?.data['errors']['email'][0]
                      : ''),
              password: FormItem(state.password.value,
                  error: error.response?.data['errors']['password'] != null
                      ? error.response?.data['errors']['password'][0]
                      : ''),
              name: FormItem(state.name.value,
                  error: error.response?.data['errors']['name'] != null
                      ? error.response?.data['errors']['name'][0]
                      : ''));
        }
      }
      state = state.copyWith(isLoading: false);
      return false;
    } catch (error) {
      state = state.copyWith(
          email: FormItem(state.email.value,
              error: 'Een onbekende fout is opgetreden'),
          isLoading: false);
      return false;
    }
  }
}

final registerFormNotifier =
    StateNotifierProvider<RegisterFormNotifier, RegisterFormModel>((ref) {
  return RegisterFormNotifier();
});
