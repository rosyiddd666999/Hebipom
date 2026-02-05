// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hebipom/core/utils/vectors.dart';
import 'package:url_launcher/url_launcher.dart';

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
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // HEADER
            Column(
              children: [
                Image.asset(
                  Theme.of(context).brightness == Brightness.light
                      ? 'assets/images/logo_dark.png'
                      : 'assets/images/logo_light.png',
                  width: 60,
                  height: 60,
                ),
                const SizedBox(height: 10),
                Text(
                  "HEBIPOM",
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

            // MENU UTAMA (Gunakan Expanded + Column agar Spacer bekerja)
            Expanded(
              child: Column(
                children: [
                  _buildDivider(context),
                  ListTile(
                    onTap: () => context.goNamed('statistics'),
                    leading: SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.light
                          ? AppVectors.chartDark
                          : AppVectors.chartLight,
                      width: 24,
                      height: 24,
                    ),
                    title: Text(
                      'STATISTICS',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),

                  ListTile(
                    onTap: () => context.goNamed('theme'),
                    leading: SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.light
                          ? AppVectors.moon
                          : AppVectors.moonLight,
                      width: 24,
                      height: 24,
                    ),
                    title: Text(
                      'THEMES',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),

                  ListTile(
                    onTap: () => context.goNamed('history'),
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
                  ),

                  ListTile(
                    onTap: () => context.goNamed('notification-permissions'),
                    leading: SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.light
                          ? AppVectors.notification
                          : AppVectors.notificationLight,
                      width: 24,
                      height: 24,
                    ),
                    title: Text(
                      'NOTIF\nPERMISSIONS',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),

                  // SPACER SEKARANG AKAN BERFUNGSI MENDORONG MENU DI BAWAHNYA
                  const Spacer(),

                  _buildDivider(context),
                  ListTile(
                    onTap: () => _sendEmail(context),
                    leading: SvgPicture.asset(
                      Theme.of(context).brightness == Brightness.light
                          ? AppVectors.feedback
                          : AppVectors.feedbackLight,
                      width: 24,
                      height: 24,
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

  Widget _buildDivider(BuildContext context) {
    return Divider(
      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.2),
    );
  }
}
