import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../http_client.dart';
import '../theme.dart';
import 'api-resources/user.dart';

enum Themes { dark, light }

extension ThemeDataExtension on Themes {
  ThemeData getThemeData() {
    switch (this) {
      case Themes.dark:
        return darkThemeSchema;
      case Themes.light:
        return lightThemeSchema;
      default:
        return darkThemeSchema;
    }
  }
}

@immutable
class CurrentUser {
  const CurrentUser({
    required this.user,
  });

  final AsyncValue<User> user;

  Themes getCurrentTheme() {
    return user.when(
        loading: () => Themes.dark,
        error: (err, stack) => Themes.dark,
        data: (user) {
          if (user.settings != null && user.settings['theme'] != null) {
            switch (user.settings['theme']) {
              case 'dark':
                return Themes.dark;
              case 'light':
                return Themes.light;
            }
          }

          return Themes.dark;
        }
    );
  }

  String getCurrentUsername() {
    return user.when(
        loading: () => 'Loading...',
        error: (err, stack) => 'User not found',
        data: (user) {
          return user.name;
        }
    );
  }

  bool getNotification() {
    return user.when(
        loading: () => false,
        error: (err, stack) => false,
        data: (user) {
          if (user.settings != null && user.settings['notification'] != null) {
            return user.settings['notification'];
          }

          return false;
        }
    );
  }

  CurrentUser copyWith({
    AsyncValue<User>? user,
  }) {
    return CurrentUser(
      user: user ?? this.user,
    );
  }
}

class CurrentUserStateNotifier extends StateNotifier<CurrentUser> {
  CurrentUserStateNotifier(CurrentUser state) : super(state);

  Future<void> updateToApi() async {
    var user = state.user.asData?.value;
    if (user == null) return;

    try {
        final response = await HttpClient()
          .getAuthorizedClient()
          .put('/api/user', data: user.toMap());

        if (response.statusCode != 200)  {
          throw Exception('Could not save user');
        }
    } catch (err) {
      // TODO Error handling user story?
    }
  }

  Future<void> setCurrentTheme(Themes theme) async {
      var user = state.user.asData?.value;
      if (user == null) return;
      var settings = user.settings;

      switch (theme) {
        case Themes.dark:
          settings['theme'] = 'dark';
          break;
        case Themes.light:
          settings['theme'] = 'light';
          break;
      }

      var newUser = user.copyWith(settings: settings);
      state = state.copyWith(user: AsyncValue.data(newUser));
      await updateToApi();
  }

  Future<void> setNotifications(bool notification) async {
    var user = state.user.asData?.value;
    if (user == null) return;
    var settings = user.settings;

    settings['notification'] = notification;

    var newUser = user.copyWith(settings: settings);
    state = state.copyWith(user: AsyncValue.data(newUser));
    await updateToApi();
  }

  static final provider = StateNotifierProvider<CurrentUserStateNotifier, CurrentUser>((ref) {
    var user = ref.watch(fetcher);
    return CurrentUserStateNotifier(CurrentUser(user: user));
  });


  static final fetcher = FutureProvider<User>((ref) async {
    final response = await HttpClient()
        .getAuthorizedClient()
        .get('/api/user');
    return User.fromJson(response.data['data']);
  });
}


class CurrentUserThemeNotifier {
  static final provider = StateProvider<Themes>((ref) {
    var state = ref.watch(CurrentUserStateNotifier.provider.select((value) => value.getCurrentTheme()));
    return state;
  });
}

class CurrentUsernameNotifier {
  static final provider = StateProvider<String>((ref) {
    var state = ref.watch(CurrentUserStateNotifier.provider.select((value) => value.getCurrentUsername()));
    return state;
  });
}

class CurrentUserNotificationsNotifier {
  static final provider = StateProvider<bool>((ref) {
    var state = ref.watch(CurrentUserStateNotifier.provider.select((value) => value.getNotification()));
    return state;
  });
}
