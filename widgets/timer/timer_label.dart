import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/timer/timer.dart';

class TimerLabel extends ConsumerWidget {
  const TimerLabel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var timestamp = ref.watch(TimerDurationNotifier.provider);

    return Column(children: [
      Text(timestamp,
          style: Theme.of(context).textTheme.headline1?.copyWith(fontSize: 72),
          textAlign: TextAlign.center),
    ]);
  }
}
