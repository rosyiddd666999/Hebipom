import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../widgets/my_button.dart';
import '../routes.dart';
import '../../../services/notivication_service.dart';

class OnboardingPage extends StatefulWidget {
  final NotificationService notificationService;
  final VoidCallback? onCompleted;

  const OnboardingPage({
    super.key,
    required this.notificationService,
    this.onCompleted,
  });

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // --- State Permission ---
  Map<String, bool> _permissions = {
    'notification': false,
    'exactAlarm': false,
    'batteryOptimization': false,
  };

  // ignore: unused_field
  bool _isLoading = false;
  bool _showManualSteps = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  // --- Logika Permission Service ---
  Future<void> _checkPermissions() async {
    setState(() => _isLoading = true);
    final permissions = await widget.notificationService.checkAllPermissions();
    if (mounted) {
      setState(() {
        _permissions = permissions;
        _isLoading = false;
      });
    }
  }

  Future<void> _requestAllPermissions() async {
    setState(() => _isLoading = true);
    try {
      final results = await widget.notificationService.requestAllPermissions();
      if (mounted) _showResultsDialog(results);
      await _checkPermissions();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // --- Helper UI Permission ---
  String _getPermissionLabel(String key) {
    switch (key) {
      case 'notification':
        return 'Notifikasi';
      case 'exactAlarm':
        return 'Alarm Tepat Waktu';
      case 'batteryOptimization':
        return 'Optimasi Baterai';
      default:
        return key;
    }
  }

  IconData _getPermissionIcon(String key) {
    switch (key) {
      case 'notification':
        return Icons.notifications_active;
      case 'exactAlarm':
        return Icons.alarm;
      case 'batteryOptimization':
        return Icons.battery_full;
      default:
        return Icons.settings;
    }
  }

  String _getPermissionDescription(String key) {
    switch (key) {
      case 'notification':
        return 'Menampilkan pengingat habit';
      case 'exactAlarm':
        return 'Notifikasi muncul tepat waktu';
      case 'batteryOptimization':
        return 'Agar app tetap jalan di background';
      default:
        return '';
    }
  }

  void _showResultsDialog(Map<String, bool> results) {
    final allGranted = results.values.every((granted) => granted);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(allGranted ? '✅ Berhasil!' : '⚠️ Perhatian'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: results.entries
              .map(
                (entry) => Row(
                  children: [
                    Icon(
                      entry.value ? Icons.check_circle : Icons.cancel,
                      color: entry.value
                          ? Theme.of(context).colorScheme.primary
                          : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_getPermissionLabel(entry.key))),
                  ],
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // --- Build UI ---
  @override
  Widget build(BuildContext context) {
    final allGranted = _permissions.values.every((granted) => granted);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) => setState(() => _currentPage = index),
                children: [
                  _buildIntroSlide(
                    title: "Reminder Aplikasi",
                    desc:
                        "Bangun kebiasaan positif dengan sistem pengingat yang disiplin dan mudah dikelola.",
                    icon: SvgPicture.asset(
                      'assets/vectors/onboarding_1.svg',
                      height: 200,
                      width: 200,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  _buildIntroSlide(
                    title: "Fokus Pomodoro",
                    desc:
                        "Gunakan fitur timer Pomodoro untuk membantu Anda tetap fokus pada satu tugas tanpa gangguan.",
                    icon: SvgPicture.asset(
                      'assets/vectors/onboarding_2.svg',
                      height: 200,
                      width: 200,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  _buildPermissionSlide(allGranted),
                ],
              ),
            ),

            // Bottom Navigation Area
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dot Indicator
                  SmoothPageIndicator(
                    controller: _pageController,
                    count: 3,
                    effect: ExpandingDotsEffect(
                      dotHeight: 10,
                      dotWidth: 10,
                      activeDotColor: Theme.of(context).primaryColor,
                      dotColor: Colors.grey.shade300,
                    ),
                  ),

                  // Action Button
                  if (_currentPage < 2)
                    MyButton(
                      onPressed: () => _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      ),
                      label: "LANJUT",
                      icon: const Icon(Icons.arrow_right_alt, size: 16),
                    )
                  else
                    MyButton(
                      onPressed: allGranted
                          ? () {
                              widget.onCompleted?.call();
                              context.go(RouteNames.habit);
                            }
                          : () {
                              _requestAllPermissions();
                            },
                      label: allGranted ? "MULAI" : "IZINKAN DULU",
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntroSlide({
    required String title,
    required String desc,
    required Widget icon,
  }) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          Text(
            desc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionSlide(bool allGranted) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Center(
            child: SvgPicture.asset(
              'assets/vectors/onboarding_3.svg',
              height: 100,
              width: 100,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "Izin Perangkat",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            allGranted
                ? "Semua sudah siap! Klik tombol Mulai di bawah."
                : "Untuk memastikan notifikasi muncul tepat waktu, kami membutuhkan izin berikut:",
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),

          ..._permissions.entries.map(
            (entry) => Card(
              elevation: 0,
              color: Theme.of(context).colorScheme.secondary,
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(
                  _getPermissionIcon(entry.key),
                  color: entry.value
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                title: Text(_getPermissionLabel(entry.key)),
                subtitle: Text(
                  _getPermissionDescription(entry.key),
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Icon(
                  entry.value ? Icons.check_circle : Icons.cancel,
                  color: entry.value
                      ? Theme.of(context).colorScheme.primary
                      : Colors.red,
                ),
              ),
            ),
          ),

          if (!allGranted)
            MyButton(onPressed: _requestAllPermissions, label: 'Izinkan Semua'),

          const SizedBox(height: 10),
          Center(
            child: TextButton.icon(
              onPressed: () =>
                  setState(() => _showManualSteps = !_showManualSteps),
              icon: Icon(
                _showManualSteps ? Icons.expand_less : Icons.expand_more,
              ),
              label: const Text("Panduan Manual (Saran)"),
            ),
          ),
          if (_showManualSteps) _buildManualStepsCard(),
        ],
      ),
    );
  }

  Widget _buildManualStepsCard() {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              "Penting: Beberapa HP (Xiaomi, Samsung, Oppo) memerlukan pengaturan 'Autostart' manual agar pengingat tidak mati.",
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            const Divider(),
            _manualText("Xiaomi: Settings > Apps > Permissions > Autostart"),
            _manualText("Samsung: Settings > Apps > Battery > Unrestricted"),
          ],
        ),
      ),
    );
  }

  Widget _manualText(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        const Icon(Icons.info_outline, size: 14),
        const SizedBox(width: 8),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 11))),
      ],
    ),
  );
}
