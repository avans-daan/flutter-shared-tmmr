import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../models/timer/timer.dart';

class TimerLabel extends ConsumerWidget {
  const TimerLabel({Key? key, this.style}) : super(key: key);

  final TextStyle? style;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var timestamp = ref.watch(TimerDurationNotifier.provider);

    return Text(timestamp,
        style: style ?? Theme.of(context).textTheme.headline1?.copyWith(fontSize: 72),
        textAlign: TextAlign.center
    );
  }
}
