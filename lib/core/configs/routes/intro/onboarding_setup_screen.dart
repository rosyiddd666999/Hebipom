import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../services/permission_check.dart';
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

class _OnboardingPageState extends State<OnboardingPage>
    with WidgetsBindingObserver {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  Map<String, bool> _permissions = {
    'notification': false,
    'exactAlarm': false,
    'batteryOptimization': false,
  };

  bool _isLoading = false;
  bool _showManualSteps = false;
  bool _isRequestingPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPermissions();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _pageController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.resumed && _isRequestingPermission) {
      debugPrint('📱 App resumed from settings, re-checking permissions...');
      _isRequestingPermission = false;
      _checkPermissions();
    }
  }

  Future<void> _checkPermissions() async {
    if (!mounted) return;

    setState(() => _isLoading = true);
    final permissions = await widget.notificationService.checkAllPermissions();

    if (mounted) {
      setState(() {
        _permissions = permissions;
        _isLoading = false;
      });

      final allGranted = _permissions.values.every((granted) => granted);
      if (allGranted && _currentPage == 2) {
        // ✅ Mark setup completed di SharedPreferences
        await PermissionChecker.markSetupCompleted();
        _showSuccessDialog();
      }
    }
  }

  Future<void> _requestPermissionsSequentially() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      // Step 1: Request Notification
      if (!_permissions['notification']!) {
        final granted =
            await widget.notificationService.requestNotificationPermission();
        setState(() => _permissions['notification'] = granted);

        if (!granted) {
          _showPermissionDeniedDialog('Notifikasi');
          setState(() => _isLoading = false);
          return;
        }
      }

      // Step 2: Request Exact Alarm
      if (!_permissions['exactAlarm']!) {
        setState(() => _isRequestingPermission = true);
        await widget.notificationService.requestExactAlarmPermission();
        setState(() => _isLoading = false);
        return; // Wait for user to come back from settings
      }

      // Step 3: Request Battery Optimization
      if (!_permissions['batteryOptimization']!) {
        setState(() => _isRequestingPermission = true);
        await widget.notificationService
            .requestBatteryOptimizationPermission();
        setState(() => _isLoading = false);
        return; // Wait for user to come back from settings
      }

      // All permissions granted
      await _checkPermissions();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showPermissionDeniedDialog(String permissionName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ Izin Ditolak'),
        content: Text(
          'Izin $permissionName diperlukan agar aplikasi dapat mengirim pengingat tepat waktu. '
          'Silakan aktifkan di pengaturan aplikasi.',
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('✅ Berhasil!'),
        content: const Text(
          'Semua izin telah diberikan. Aplikasi siap digunakan!',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              widget.onCompleted?.call();
              context.go(RouteNames.habit);
            },
            child: const Text('MULAI'),
          ),
        ],
      ),
    );
  }

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

  String _getPermissionInstruction(String key) {
    switch (key) {
      case 'notification':
        return 'Klik tombol di bawah untuk mengaktifkan notifikasi';
      case 'exactAlarm':
        return 'Anda akan diarahkan ke pengaturan. Aktifkan "Alarms & reminders" untuk aplikasi ini';
      case 'batteryOptimization':
        return 'Anda akan diarahkan ke pengaturan. Pilih "Don\'t optimize" atau "Unrestricted"';
      default:
        return '';
    }
  }

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

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
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
                      onPressed:  allGranted
                              ? () async {
                                  await PermissionChecker.markSetupCompleted();
                                  widget.onCompleted?.call();
                                  if (mounted) {
                                    // ignore: use_build_context_synchronously
                                    context.goNamed('habit');
                                  }
                                }
                              : _requestPermissionsSequentially,
                      label: _isLoading
                          ? "MEMPROSES..."
                          : allGranted
                              ? "MULAI"
                              : "IZINKAN",
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
                ? "✅ Semua sudah siap! Klik tombol Mulai di bawah."
                : "Untuk memastikan notifikasi muncul tepat waktu, kami membutuhkan izin berikut:",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: allGranted ? Colors.green : null,
              fontWeight: allGranted ? FontWeight.w600 : null,
            ),
          ),
          const SizedBox(height: 30),

          ..._permissions.entries.map((entry) {
            final isGranted = entry.value;
            return Card(
              elevation: 0,
              color: isGranted
                  ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                  : Theme.of(context).colorScheme.secondary,
              margin: const EdgeInsets.only(bottom: 12),
              child: ExpansionTile(
                leading: Icon(
                  _getPermissionIcon(entry.key),
                  color: isGranted
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey,
                ),
                title: Text(_getPermissionLabel(entry.key)),
                subtitle: Text(
                  _getPermissionDescription(entry.key),
                  style: const TextStyle(fontSize: 12),
                ),
                trailing: Icon(
                  isGranted ? Icons.check_circle : Icons.cancel,
                  color: isGranted
                      ? Theme.of(context).colorScheme.primary
                      : Colors.red,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      _getPermissionInstruction(entry.key),
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 20),

          Center(
            child: TextButton.icon(
              onPressed: () =>
                  setState(() => _showManualSteps = !_showManualSteps),
              icon: Icon(
                _showManualSteps ? Icons.expand_less : Icons.expand_more,
              ),
              label: const Text("Panduan Manual (Opsional)"),
            ),
          ),
          if (_showManualSteps) _buildManualStepsCard(),
        ],
      ),
    );
  }

  Widget _buildManualStepsCard() {
    return Card(
      color: Colors.orange.shade50,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.orange.shade700),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    "Penting untuk beberapa perangkat:",
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const Divider(),
            _manualText(
              "Xiaomi/POCO/Redmi",
              "Settings > Apps > Manage apps > Hebipom > Autostart (ON)",
            ),
            _manualText(
              "Samsung",
              "Settings > Apps > Hebipom > Battery > Unrestricted",
            ),
            _manualText(
              "Oppo/Realme",
              "Settings > Battery > App power management > Hebipom (Allow)",
            ),
            _manualText(
              "Vivo",
              "Settings > Battery > Background power consumption > Hebipom (High)",
            ),
          ],
        ),
      ),
    );
  }

  Widget _manualText(String brand, String instruction) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.smartphone, size: 14),
            const SizedBox(width: 8),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: const TextStyle(fontSize: 11, color: Colors.black87),
                  children: [
                    TextSpan(
                      text: '$brand: ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: instruction),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
}