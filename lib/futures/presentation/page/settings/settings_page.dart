import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hebipom/core/utils/vectors.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SETTINGS', style: Theme.of(context).textTheme.titleMedium),
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ListView(
            children: [
              ListTile(
                leading: SvgPicture.asset(
                  Theme.of(context).brightness == Brightness.light
                      ? AppVectors.moon
                      : AppVectors.moonLight,
                  width: 24,
                  height: 24,
                ),
                title: Text(
                  'THEME SETTINGS',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onTap: () => context.goNamed('theme'),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: SvgPicture.asset(
                  Theme.of(context).brightness == Brightness.light
                      ? AppVectors.notification
                      : AppVectors.notificationLight,
                  width: 24,
                  height: 24,
                ),
                title: Text(
                  'NOTIF PERMISSIONS',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onTap: () => context.goNamed('notification-permissions'),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: SvgPicture.asset(
                  Theme.of(context).brightness == Brightness.light
                      ? AppVectors.historyDark
                      : AppVectors.historyLight,
                  width: 24,
                  height: 24,
                ),
                title: Text(
                  'HISTORY',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onTap: () => context.goNamed('history'),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: SvgPicture.asset(
                  Theme.of(context).brightness == Brightness.light
                      ? AppVectors.feedback
                      : AppVectors.feedbackLight,
                  width: 24,
                  height: 24,
                ),
                title: Text(
                  'SUPPORT & FEEDBACK',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                onTap: () => _launchEmailSupport(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchEmailSupport(BuildContext context) async {
    const email =
        'abdulrosyid696969@gmail.com';
    const subject = 'Feedback & Support [HeBiPom App]';
    const body =
        'Halo Tim HeBiPom,\n\nSaya ingin memberikan feedback/meminta support mengenai...';

    // Membuat URI mailto:
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject': subject,
        'body': body,
      }),
    );

    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    } else {
      // Tampilkan notifikasi jika tidak bisa membuka email (misalnya, tidak ada aplikasi email)
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Tidak dapat membuka aplikasi email. Silakan kirim email ke support@hebipomapp.com',
          ),
        ),
      );
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }
}
