import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../repositories/token_repository.dart';
import '../../http_client.dart';
import 'form_item_model.dart';

@immutable
class LoginFormModel {
  const LoginFormModel(
      {this.email = const FormItem(''),
      this.password = const FormItem(''),
      this.isPasswordVisible = false,
      this.isLoading = false});

  final FormItem<String> email;
  final FormItem<String> password;
  final bool isPasswordVisible;
  final bool isLoading;

  LoginFormModel copyWith(
      {FormItem<String>? email,
        FormItem<String>? password,
      bool? isPasswordVisible,
      bool? isLoading}) {
    return LoginFormModel(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class LoginFormNotifier extends StateNotifier<LoginFormModel> {
  LoginFormNotifier() : super(const LoginFormModel());

  void switchPasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  void setEmail(String? email) {
    state = state.copyWith(email: FormItem(email!));
  }

  void setPassword(String? password) {
    state = state.copyWith(password: FormItem(password!));
  }

  Future<bool> tryLogin() async {
    try {
      state = state.copyWith(isLoading: true);
      var client = HttpClient();
      var data = {
        'email': state.email.value,
        'password': state.password.value,
        'device_name': 'test'
      };
      var result = await client.getClient().post('/api/token', data: data);
      await TokenRepository().setToken(result.data['token']);
      await TokenRepository().setExpiresAt(result.data['expired_at']);
      state = state.copyWith(isLoading: false, password: null, email: null);
      return true;
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

final loginFormNotifier =
    StateNotifierProvider<LoginFormNotifier, LoginFormModel>((ref) {
  return LoginFormNotifier();
});
