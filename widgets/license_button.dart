import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class LicenseButton extends StatelessWidget {
  const LicenseButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () async {
          PackageInfo info = await PackageInfo.fromPlatform();
          showAboutDialog(
              context: context,
              applicationIcon: Image.asset('assets/app_icon.png'),
              applicationVersion: info.version,
              applicationName: info.appName);
        },
        child: Text('Over deze App',
            style: Theme.of(context).textTheme.headline4?.copyWith(
                color: Theme.of(context).colorScheme.onSecondary)));
  }
}
