import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/timer/timer.dart';

class TimerButtons extends ConsumerWidget {
  const TimerButtons({Key? key, this.small = false}) : super(key: key);

  final bool small;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var status = ref.watch(TimerStatusNotifier.provider);

    var pauseButton = ElevatedButton(
        onPressed: () {
          ref.read(TimerStateNotifier.provider.notifier).tryPauseTimer();
        },
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.all(small ? 4 : 8),
            primary: Theme.of(context).colorScheme.error),
        child: Icon(Icons.pause_rounded, size: small ? 24 : 64));

    var resumeButton = ElevatedButton(
        onPressed: () {
          ref.read(TimerStateNotifier.provider.notifier).tryStartTimer();
        },
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.all(small ? 4 : 8),
            primary: Theme.of(context).colorScheme.primary),
        child: Icon(Icons.play_arrow_rounded, size: small ? 24 : 64));

    var stopButton = ElevatedButton(
        onPressed: () {
          ref.read(TimerStateNotifier.provider.notifier).tryStopTimer();
        },
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: EdgeInsets.all(small ? 4 : 8),
            primary: Theme.of(context).colorScheme.onSecondary),
        child: Icon(Icons.stop_rounded, size: small ? 24 : 64));

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (status == TimerState.running) ...[
          stopButton,
          pauseButton
        ] else if (status == TimerState.paused) ...[
          stopButton,
          resumeButton
        ] else ...[
          resumeButton
        ]
      ],
    );
  }
}
