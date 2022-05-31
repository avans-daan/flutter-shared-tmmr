
import 'package:flutter/material.dart';
import 'package:tmmr_desktop/shared-tmmr/widgets/timer/target_dropdown.dart';
import 'package:tmmr_desktop/shared-tmmr/widgets/timer/timer_buttons.dart';
import 'package:tmmr_desktop/shared-tmmr/widgets/timer/timer_description_field.dart';
import 'package:tmmr_desktop/shared-tmmr/widgets/timer/timer_label.dart';

import '../../models/timer/timer.dart';

class TimerEditRow extends StatelessWidget {
  const TimerEditRow({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const SizedBox(
          width: 300,
          child: TimerDescriptionField(maxLines: 1),
        ),
        const SizedBox(width: 10),
        SizedBox(
            width: 150,
            child: TargetDropdown(provider: TimerTargetNotifier.provider, notifier: TimerStateNotifier.provider.notifier)
        ),
        const SizedBox(width: 10),
        // const TimerDescriptionField(),
        TimerLabel(
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const TimerButtons(small: true)
      ],
    );
  }
}
