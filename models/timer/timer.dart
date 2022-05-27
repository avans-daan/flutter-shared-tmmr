import 'dart:async' as async;
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../helpers/timeout.dart';
import '../../models/api-resources/target.dart';
import '../../http_client.dart';
import '../../models/api-resources/tenant.dart';
import '../../models/tenant_targets.dart';
import '../../models/user_tenant_timer.dart';
import '../../models/user_tenants.dart';
import '../../widgets/timer/target_dropdown.dart';

String formatDuration(Duration duration) {
  String twoDigits(int n) => n.toString().padLeft(2, '0');
  String twoDigitHours = twoDigits(duration.inHours);
  String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
  String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
  return '$twoDigitHours:$twoDigitMinutes:$twoDigitSeconds';
}

enum TimerState {
  stopped,
  running,
  paused,
}

extension TimerStateMessages on TimerState {
  String getMessage() {
    switch (this) {
      case TimerState.stopped:
        return 'Uw timer staat uit';
      case TimerState.paused:
        return 'Uw timer is gepauzeerd';
      case TimerState.running:
        return 'Uw timer loopt';
    }
  }
}

@immutable
class Timer {
  const Timer(
      {required this.status,
      this.startTime,
      this.description,
      this.target,
      required this.tenant});

  final TimerState status;
  final DateTime? startTime;
  final String? description;
  final Target? target;
  final Tenant? tenant;

  Timer copyWith({
    TimerState? status,
    DateTime? startTime,
    String? description,
    Target? target,
  }) {
    return Timer(
        status: status ?? this.status,
        startTime: startTime ?? this.startTime,
        description: description ?? this.description,
        target: target ?? this.target,
        tenant: tenant);
  }

  Timer copyNull(
      {bool startTime = false, bool target = false, bool description = false}) {
    return Timer(
        status: status,
        startTime: startTime ? null : this.startTime,
        description: description ? null : this.description,
        target: target ? null : this.target,
        tenant: tenant);
  }
}

class _TimerTicker {
  Stream<void> tick() {
    return Stream.periodic(const Duration(seconds: 1));
  }
}

class TimerStateNotifier extends StateNotifier<Timer>
    implements SetTargetDropdownNotifier {
  TimerStateNotifier(
      {required TimerState status,
      required DateTime? startTime,
      required String? description,
      required Target? target,
      required Tenant? tenant})
      : super(Timer(
            status: status,
            startTime: startTime,
            description: description,
            target: target,
            tenant: tenant)) {
    // Auto start timer ticker when initialised in running state
    if (status == TimerState.running) {
      _tickerSubscription = _ticker.tick().listen(_handleTicker);
    }
  }

  async.Timer? _timer;

  static TimerStateNotifier _createStoppedTimer(Tenant? tenant) {
    return TimerStateNotifier(
        tenant: tenant,
        status: TimerState.stopped,
        description: null,
        target: null,
        startTime: null);
  }

  static final provider =
      StateNotifierProvider<TimerStateNotifier, Timer>((ref) {
    var tenant = ref.watch(UserSelectedTenantNotifier.provider);
    var userTimer = ref.watch(UserTenantTimer.provider);
    var targets = ref.watch(TenantTargets.provider);
    return userTimer.when(
        data: (timeEntry) {
          if (timeEntry == null) {
            return _createStoppedTimer(tenant);
          }

          // Check if time entry has a target if so search for it
          if (timeEntry.target == null) {
            return TimerStateNotifier(
                tenant: tenant,
                status: TimerState.running,
                startTime: timeEntry.start,
                description: timeEntry.description,
                target: null);
          }

          // Fetch targets to see if the current timers tenant is available in the list
          return targets.when(
              data: (targets) {
                return TimerStateNotifier(
                    tenant: tenant,
                    status: TimerState.running,
                    startTime: timeEntry.start,
                    description: timeEntry.description,
                    target: targets.isNotEmpty
                        ? targets.firstWhere(
                            (element) => element.id == timeEntry.target!.id,
                            orElse: () => targets[0])
                        : null);
              },
              error: (err, stack) => TimerStateNotifier(
                  tenant: tenant,
                  status: TimerState.running,
                  startTime: timeEntry.start,
                  description: timeEntry.description,
                  target: null),
              loading: () => TimerStateNotifier(
                  tenant: tenant,
                  status: TimerState.running,
                  startTime: timeEntry.start,
                  description: timeEntry.description,
                  target: null));
        },
        error: (err, stack) => _createStoppedTimer(tenant),
        loading: () => _createStoppedTimer(tenant));
  });

  Future<void> setDescription({required String description}) async {
    if (description.isEmpty) {
      state = state.copyNull(description: true);
    } else {
      state = state.copyWith(description: description);
    }

    updateToApi();
  }

  @override
  Future<void> setTarget({required Target? target}) async {
    if (target == null) {
      state = state.copyNull(target: true);
    } else {
      state = state.copyWith(target: target);
    }

    updateToApi();
  }

  void _handleTicker(_) {
    state = state.copyWith();
  }

  Future<void> refreshFromApi(WidgetRef ref) async {
    try {
      ref.refresh(TenantTargets.provider);
      await ref.read(TenantTargets.provider.future);
      ref.refresh(UserTenantTimer.provider);
      await ref.read(UserTenantTimer.provider.future);
    } catch (err) {
      // TODO Error handling user story?
    }
  }

  String _getApiEndpoint() {
    return '/api/tenants/${state.tenant?.id}/timer';
  }

  dynamic _getApiMessageBody({bool stop = false}) {
    if (stop == true) {
      return {'stop': true};
    }

    return {
      'target_id': state.target?.id,
      'description': state.description,
      'stop': stop
    };
  }

  void updateToApi() {
    // Send updates to api after 3 seconds of not being called anymore
    clearTimeout(_timer);
    _timer = setTimeout(() {
      try {
        if (state.status != TimerState.running) return;
        var http = HttpClient().getAuthorizedClient();
        http.put(_getApiEndpoint(), data: _getApiMessageBody());
      } catch (err) {
        // TODO Error handling user story?
        log(err.toString());
      }
    }, 3000);
  }

  Future<void> tryStartTimer() async {
    await _tickerSubscription?.cancel();
    var oldState = state;
    state =
        state.copyWith(status: TimerState.running, startTime: DateTime.now());
    try {
      var http = HttpClient().getAuthorizedClient();
      await http.post(_getApiEndpoint(), data: _getApiMessageBody());
      _tickerSubscription = _ticker.tick().listen(_handleTicker);
    } catch (err) {
      // TODO Error handling user story?
      state = oldState;
    }
  }

  Future<void> tryStopTimer() async {
    var oldState = state;

    if (state.status == TimerState.running) {
      try {
        var http = HttpClient().getAuthorizedClient();
        await http.put(_getApiEndpoint(), data: _getApiMessageBody(stop: true));
        state = state
            .copyWith(status: TimerState.stopped)
            .copyNull(startTime: true, description: true, target: true);
        await _tickerSubscription?.cancel();
      } catch (err) {
        // TODO Error handling user story?
        state = oldState;
      }
    } else {
      state = state
          .copyWith(status: TimerState.stopped)
          .copyNull(startTime: true, description: true, target: true);
    }
  }

  Future<void> tryPauseTimer() async {
    var oldState = state;
    state = state.copyWith(status: TimerState.paused);

    try {
      var http = HttpClient().getAuthorizedClient();
      await http.put(_getApiEndpoint(), data: _getApiMessageBody(stop: true));
      await _tickerSubscription?.cancel();
    } catch (err) {
      // TODO Error handling user story?
      state = oldState;
    }
  }

  final _TimerTicker _ticker = _TimerTicker();
  async.StreamSubscription<void>? _tickerSubscription;

  @override
  void dispose() {
    _tickerSubscription?.cancel();
    super.dispose();
  }
}

class TimerStatusNotifier {
  static final provider = StateProvider<TimerState>((ref) {
    var state =
        ref.watch(TimerStateNotifier.provider.select((value) => value.status));
    return state;
  });
}

class TimerTargetNotifier {
  static final provider = StateProvider<Target?>((ref) {
    var state =
        ref.watch(TimerStateNotifier.provider.select((value) => value.target));
    return state;
  });
}

class TimerDescriptionNotifier {
  static final provider = StateProvider<String?>((ref) {
    var state = ref.watch(
        TimerStateNotifier.provider.select((value) => value.description));
    return state;
  });
}

class TimerDurationNotifier {
  static final provider = StateProvider<String>((ref) {
    var state = ref.watch(TimerStateNotifier.provider);
    if (state.startTime == null) return '00:00:00';
    return formatDuration(DateTime.now().difference(state.startTime!));
  });
}
