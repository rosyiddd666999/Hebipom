import 'package:auto_start_flutter/auto_start_flutter.dart';
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
    'autoStart': false,
  };

  bool _isLoading = false;
  bool _showManualSteps = false;
  bool _isRequestingPermission = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializePermissions();
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
      debugPrint('App resumed from settings, re-checking permissions...');
      _isRequestingPermission = false;
      _checkPermissions();
    }
  }

  Future<void> _initializePermissions() async {
    await _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    if (!mounted) return;
    setState(() => _isLoading = true);

    try {
      final permissions = await widget.notificationService
          .checkAllPermissions();

      if (mounted) {
        setState(() {
          _permissions = Map<String, bool>.from(permissions);
          _isLoading = false;
        });

        final allGranted = _permissions.values.every((granted) => granted);

        if (allGranted && _currentPage == 2) {
          await PermissionChecker.markSetupCompleted();
          _showSuccessDialog();
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _requestPermissionsSequentially() async {
    if (!mounted) return;

    setState(() => _isLoading = true);

    try {
      if (!_permissions['notification']!) {
        debugPrint('Requesting notification permission...');
        final granted = await widget.notificationService
            .requestNotificationPermission();

        if (mounted) {
          setState(() => _permissions['notification'] = granted);
        }

        if (!granted) {
          _showPermissionDeniedDialog('Notifikasi');
          if (mounted) setState(() => _isLoading = false);
          return;
        }
      }

      if (!_permissions['exactAlarm']!) {
        debugPrint('Requesting exact alarm permission...');
        setState(() => _isRequestingPermission = true);
        await widget.notificationService.requestExactAlarmPermission();
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      if (!_permissions['batteryOptimization']!) {
        debugPrint('Requesting battery optimization permission...');
        setState(() => _isRequestingPermission = true);
        await widget.notificationService.requestBatteryOptimizationPermission();
        if (mounted) setState(() => _isLoading = false);
        return;
      }

      if (!_permissions['autoStart']!) {
        final isAvailable = await isAutoStartAvailable ?? false;
        if (isAvailable) {
          setState(() => _isRequestingPermission = true);
          await widget.notificationService.requestAutoStartPermission();
          return;
        } else {
          await widget.notificationService.confirmAutoStartEnabled();
          await _checkPermissions();
        }
      }

      await _checkPermissions();
    } catch (e) {
      debugPrint('❌ Error in permission request flow: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showPermissionDeniedDialog(String permissionName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Izin Ditolak'),
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
        title: const Text('Berhasil!'),
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
      case 'autoStart':
        return 'Auto Start';
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
      case 'autoStart':
        return Icons.power_settings_new;
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
      case 'autoStart':
        return 'Aplikasi otomatis berjalan saat reboot';
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
      case 'autoStart':
        return 'Anda akan diarahkan ke pengaturan. Aktifkan "Autostart" atau "Auto-launch" untuk aplikasi ini';
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
                      onPressed: allGranted
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
                ? "Semua sudah siap! Klik tombol Mulai di bawah."
                : "Untuk memastikan notifikasi muncul tepat waktu, kami membutuhkan izin berikut:",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: allGranted ? Colors.green : null,
              fontWeight: allGranted ? FontWeight.w600 : null,
            ),
          ),
          const SizedBox(height: 30),

          // Permission cards
          _buildPermissionCard('notification'),
          _buildPermissionCard('exactAlarm'),
          _buildPermissionCard('batteryOptimization'),
          _buildPermissionCard('autoStart'),

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

  Widget _buildPermissionCard(String key) {
    final isGranted = _permissions[key] ?? false;

    return Card(
      elevation: 0,
      color: isGranted
          ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
          : Theme.of(context).colorScheme.secondary,
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        leading: Icon(
          _getPermissionIcon(key),
          color: isGranted
              ? Theme.of(context).colorScheme.primary
              : Colors.grey,
        ),
        title: Text(_getPermissionLabel(key)),
        subtitle: Text(
          _getPermissionDescription(key),
          style: const TextStyle(fontSize: 12),
        ),
        trailing: Icon(
          isGranted ? Icons.check_circle : Icons.cancel,
          color: isGranted ? Theme.of(context).colorScheme.primary : Colors.red,
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _getPermissionInstruction(key),
              style: const TextStyle(fontSize: 12),
            ),
          ),
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
              "Settings > Apps > Manage apps > Hebipom > Autostart (ON)\nSettings > AutoStart apps > Hebipom (Allow)",
            ),
            _manualText(
              "Samsung",
              "Settings > Apps > Hebipom > Battery > Unrestricted\nSettings > AutoStart apps > Hebipom (Allow)",
            ),
            _manualText(
              "Oppo/Realme",
              "Settings > Battery > App power management > Hebipom (Allow)\nSettings > AutoStart apps > Hebipom (Allow)",
            ),
            _manualText(
              "Vivo",
              "Settings > Battery > Background power consumption > Hebipom (High)\nSettings > AutoStart apps > Hebipom (Allow)",
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
