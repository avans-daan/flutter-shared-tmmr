import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/timer/timer.dart';

class TimerButtons extends ConsumerWidget {
  const TimerButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var status = ref.watch(TimerStatusNotifier.provider);

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            height: 40,
            color: Colors.transparent,
          ),
          Container(
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
            height: 100,
            color: Theme.of(context).colorScheme.secondary,
            child: Text(
              status.getMessage(),
              style: Theme.of(context)
                  .textTheme
                  .headline4
                  ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
              textAlign: TextAlign.center,
            ),
          ),
        ]),
        Positioned(top: 0, left: 0, right: 0, child: buildButtons(context, ref))
      ],
    );
  }

  Widget buildButtons(BuildContext context, WidgetRef ref) {
    var status = ref.read(TimerStatusNotifier.provider);

    var pauseButton = ElevatedButton(
        onPressed: () {
          ref.read(TimerStateNotifier.provider.notifier).tryPauseTimer();
        },
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(8),
            primary: Theme.of(context).colorScheme.error),
        child: const Icon(Icons.pause_rounded, size: 64));

    var resumeButton = ElevatedButton(
        onPressed: () {
          ref.read(TimerStateNotifier.provider.notifier).tryStartTimer();
        },
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(8),
            primary: Theme.of(context).colorScheme.primary),
        child: const Icon(Icons.play_arrow_rounded, size: 64));

    var stopButton = ElevatedButton(
        onPressed: () {
          ref.read(TimerStateNotifier.provider.notifier).tryStopTimer();
        },
        style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(8),
            primary: Theme.of(context).colorScheme.onSecondary),
        child: const Icon(Icons.stop_rounded, size: 64));

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
