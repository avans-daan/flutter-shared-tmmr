import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tmmr_desktop/shared-tmmr/widgets/timer/timer_buttons.dart';

import '../../models/timer/timer.dart';

class TimerButtonPane extends ConsumerWidget {
  const TimerButtonPane({Key? key}) : super(key: key);

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
        const Positioned(top: 0, left: 0, right: 0, child: TimerButtons())
      ],
    );
  }
}
