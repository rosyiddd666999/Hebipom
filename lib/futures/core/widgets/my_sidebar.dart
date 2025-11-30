// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hebipom/futures/core/utils/vectors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../configs/routes/routes.dart';

class MySidebar extends StatelessWidget {
  const MySidebar({super.key});

  final String _recipientEmail = 'abdulrosyid696969@gmail.com';
  final String _emailSubject = 'Feedback untuk Aplikasi Hebipom';
  final String _emailBody =
      'Halo Tim Hebipom,\n\nSaya ingin memberikan feedback:';

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map(
          (e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}',
        )
        .join('&');
  }

  Future<void> _sendEmail(BuildContext context) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: _recipientEmail,
      query: _encodeQueryParameters(<String, String>{
        'subject': _emailSubject,
        'body': _emailBody,
      }),
    );

    try {
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Tidak dapat membuka aplikasi email. Pastikan ada klien email terinstal.',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saat meluncurkan email: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.zero,
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.zero,
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Column(
              children: [
                SvgPicture.asset(
                  Theme.of(context).brightness == Brightness.light
                      ? 'assets/vectors/habit_dark.svg'
                      : 'assets/vectors/habit_light.svg',
                  width: 80,
                  height: 80,
                ),
                const SizedBox(height: 10),
                Text(
                  "HABIPOM",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  ListTile(
                    onTap: () {
                      context.go(RouteNames.theme);
                    },
                    leading: SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.light
                          ? AppVectors.moon
                          : AppVectors.moonLight,
                      width: 35,
                      height: 35,
                    ),
                    title: Text(
                      'THEMES',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),

                  ListTile(
                    onTap: () {
                      context.go(RouteNames.notification);
                    },
                    leading: SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.light
                          ? AppVectors.notification
                          : AppVectors.notificationLight,
                      width: 35,
                      height: 35,
                    ),
                    title: Text(
                      'NOTIFICATION',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),

                  ListTile(
                    onTap: () {
                      _sendEmail(context);
                    },
                    leading: SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.light
                          ? AppVectors.feedback
                          : AppVectors.feedbackLight,
                      width: 35,
                      height: 35,
                    ),
                    title: Text(
                      'FEEDBACK',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
