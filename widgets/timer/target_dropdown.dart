import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared-tmmr/models/tenant_targets.dart';
import '../../../shared-tmmr/models/api-resources/target.dart';

abstract class SetTargetDropdownNotifier {
  Future<void> setTarget({required Target? target});
}

class TargetDropdown extends ConsumerWidget {
  const TargetDropdown(
      {required this.provider, required this.notifier, Key? key})
      : super(key: key);

  final StateProvider<Target?> provider;
  final AlwaysAliveProviderBase<SetTargetDropdownNotifier> notifier;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var targets = ref.watch(TenantTargets.provider);
    var selectedTarget = ref.watch(provider);

    return targets.when(
        data: (targets) {
          // Check if target exists in list by looking at ids (not dart object reference)
          if (!targets.any((element) => element.id == selectedTarget?.id)) {
            selectedTarget = null;
          }
          return DropdownButtonFormField(
              isExpanded: true,
              decoration: const InputDecoration(
                  filled: false,
                  contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)))),
              value: selectedTarget,
              items: targets
                  .map<DropdownMenuItem<Target>>((Target target) =>
                      DropdownMenuItem<Target>(
                          value: target.id == selectedTarget?.id ? selectedTarget : target,
                          child: Text(target.name,
                              style: Theme.of(context).textTheme.bodyMedium)))
                  .toList(),
              onChanged: (Target? s) {
                ref.read(notifier).setTarget(target: s);
              });
        },
        error: (err, stack) => const Text('Failed to load'),
        loading: () => const CircularProgressIndicator());
  }
}
