import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../widgets/my_button.dart';
import '../routes.dart';
import '../../../services/notivication_service.dart';

class PermissionSetupPage extends StatefulWidget {
  final NotificationService notificationService;
  final VoidCallback? onCompleted;

  const PermissionSetupPage({
    super.key,
    required this.notificationService,
    this.onCompleted,
  });

  @override
  State<PermissionSetupPage> createState() => _PermissionSetupPageState();
}

class _PermissionSetupPageState extends State<PermissionSetupPage> {
  Map<String, bool> _permissions = {
    'notification': false,
    'exactAlarm': false,
    'batteryOptimization': false,
  };

  bool _isLoading = false;
  bool _showManualSteps = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    setState(() => _isLoading = true);
    final permissions = await widget.notificationService.checkAllPermissions();
    setState(() {
      _permissions = permissions;
      _isLoading = false;
    });
  }

  Future<void> _requestAllPermissions() async {
    setState(() => _isLoading = true);

    try {
      final results = await widget.notificationService.requestAllPermissions();
      // Show results dialog
      if (mounted) {
        _showResultsDialog(results);
      }
      // Refresh status
      await _checkPermissions();
      // Jika semua granted, panggil onCompleted
      if (_permissions.values.every((granted) => granted)) {
        widget.onCompleted?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              allGranted
                  ? 'Semua izin telah diberikan!'
                  : 'Beberapa izin masih perlu diatur:',
            ),
            const SizedBox(height: 16),
            ...results.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Icon(
                      entry.value ? Icons.check_circle : Icons.cancel,
                      color: entry.value ? Colors.green : Colors.red,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(child: Text(_getPermissionLabel(entry.key))),
                  ],
                ),
              ),
            ),
          ],
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

  String _getPermissionLabel(String key) {
    switch (key) {
      case 'notification':
        return 'Notifikasi';
      case 'exactAlarm':
        return 'Alarm Tepat Waktu';
      case 'batteryOptimization':
        return 'Pengabaian Optimasi Baterai';
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
        return 'Diperlukan untuk menampilkan pengingat habit';
      case 'exactAlarm':
        return 'Agar notifikasi muncul tepat waktu yang dijadwalkan';
      case 'batteryOptimization':
        return 'Agar app tetap berjalan di background';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final allGranted = _permissions.values.every((granted) => granted);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Setup Notifikasi'.toUpperCase(),
          style: const TextStyle(fontSize: 16, letterSpacing: 5),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header Info
                  Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Icon(
                            allGranted ? Icons.check_circle : Icons.info_sharp,
                            color: allGranted
                                ? Colors.green.shade500
                                : Colors.orange.shade500,
                            size: 40,
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Text(
                              allGranted
                                  ? 'Semua izin telah diberikan! Notifikasi akan berjalan dengan sempurna.'
                                  : 'Beberapa izin diperlukan agar notifikasi dapat berjalan di latar belakang.',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Permission List
                  const Text(
                    'STATUS IZIN:',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 5,
                    ),
                  ),
                  const SizedBox(height: 16),

                  ..._permissions.entries.map(
                    (entry) => Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 0,
                      color: Colors.white,
                      child: ListTile(
                        leading: Icon(
                          _getPermissionIcon(entry.key),
                          color: entry.value
                              ? Colors.green.shade500
                              : Colors.grey,
                          size: 24,
                        ),
                        title: Text(
                          _getPermissionLabel(entry.key),
                          style: const TextStyle(fontSize: 14),
                        ),
                        subtitle: Text(
                          _getPermissionDescription(entry.key),
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Icon(
                          entry.value ? Icons.check : Icons.cancel,
                          color: entry.value
                              ? Colors.green.shade500
                              : Colors.red.shade500,
                        ),
                      ),
                    ),
                  ),
                  // Request Button
                  if (!allGranted)
                    MyButton(
                      onPressed: _requestAllPermissions,
                      label: 'Izinkan Semua',
                    ),
                  const SizedBox(height: 12),
                  // Manual Steps Toggle
                  TextButton.icon(
                    onPressed: () {
                      setState(() => _showManualSteps = !_showManualSteps);
                    },
                    icon: Icon(
                      _showManualSteps ? Icons.expand_less : Icons.expand_more,
                      size: 24,
                    ),
                    label: Text(
                      _showManualSteps
                          ? 'Sembunyikan Panduan Manual'
                          : 'Lihat Panduan Manual',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  // Manual Steps
                  if (_showManualSteps) _buildManualStepsCard(),
                  const SizedBox(height: 12),
                  // Test Notification Button
                  MyButton(
                    onPressed: () async {
                      await widget.notificationService.testNotification();
                      if (mounted) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Test notifikasi akan muncul dalam 5 detik',
                            ),
                          ),
                        );
                      }
                    },
                    label: 'Test Notifikasi',
                    isOutline: true,
                  ),
                  const SizedBox(height: 12),
                  // Refresh Button
                  MyButton(
                    onPressed: _checkPermissions,
                    label: 'Refresh Status',
                    isOutline: true,
                  ),

                  if (allGranted) ...[
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          widget.onCompleted?.call();
                          context.go(RouteNames.home);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          'Lanjutkan'.toUpperCase(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '📖 Panduan Manual: Autostart & Baterai',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            Text(
              'Langkah ini memastikan aplikasi tidak dimatikan paksa di latar belakang (background) oleh HP Anda:',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Divider(height: 24),
            _buildManualStep(
              '1. Xiaomi / Redmi / POCO:',
              '• Autostart: Buka Settings → Apps → Cari Hebipom → Aktifkan Autostart.\n'
                  '• Penghemat Baterai: Cari Hebipom → Battery Saver (Penghemat Baterai) → Pilih No restrictions (Tidak ada pembatasan).',
            ),
            const SizedBox(height: 16),
            _buildManualStep(
              '2. Oppo / Realme:',
              '• Aktivitas Latar Belakang: Settings → Battery → App Battery Management → Cari Hebipom → Pilih Allow background activity (Izinkan aktivitas latar belakang).\n'
                  '• Autostart: Settings → Security/Privacy → Startup Manager → Aktifkan Hebipom.',
            ),
            const SizedBox(height: 16),
            _buildManualStep(
              '3. Vivo:',
              '• Autostart Manager: Buka iManager → App Manager → Autostart Manager → Aktifkan Hebipom.\n'
                  '• Background Running: Pastikan Background running untuk Hebipom diizinkan.',
            ),
            const SizedBox(height: 16),
            _buildManualStep(
              '4. Samsung:',
              '• Baterai: Settings → Apps → Hebipom → Battery (Baterai) → Pilih Unrestricted (Tidak terbatas).\n'
                  '• Aplikasi Tidur: Pastikan Hebipom dihapus dari daftar Sleeping apps (Aplikasi Tidur) di Pengaturan Baterai.',
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildManualStep(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text(content, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
