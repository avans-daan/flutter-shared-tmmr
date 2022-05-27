import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared-tmmr/models/timer/timer.dart';

class TimerDescriptionField extends ConsumerStatefulWidget {
  const TimerDescriptionField({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TimerDescriptionFieldState();
}

class _TimerDescriptionFieldState extends ConsumerState<TimerDescriptionField> {
  final _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textEditingController.text =
        ref.read(TimerDescriptionNotifier.provider) ?? '';
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String?>(TimerDescriptionNotifier.provider, (previous, next) {
      if (_textEditingController.text != next) {
        _textEditingController.text = next ?? '';
      }
    });

    return TextFormField(
        onChanged: (s) {
          ref
              .read(TimerStateNotifier.provider.notifier)
              .setDescription(description: s);
        },
        maxLines: 6,
        controller: _textEditingController,
        keyboardType: TextInputType.multiline,
        validator: (value) {
          if (value != null && value.length > 255) {
            return 'Omschrijving mag maximaal 255 karakters bevatten';
          }

          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
            hintText: 'Omschrijving',
            hintStyle:
                TextStyle(color: Theme.of(context).colorScheme.onSecondary),
            fillColor: Theme.of(context).colorScheme.secondary,
            border: const OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.all(Radius.circular(16)))));
  }
}
