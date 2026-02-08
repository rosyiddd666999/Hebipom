import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/services/notification_service.dart';

class PermissionPage extends StatefulWidget {
  final NotificationService notificationService;

  const PermissionPage({super.key, required this.notificationService});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  Map<String, bool> _permissions = {
    'notification': false,
    'exactAlarm': false,
    'batteryOptimization': false,
  };

  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
  }

  Future<void> _checkPermissions() async {
    setState(() => _isLoading = true);

    final permissions = await widget.notificationService.checkAllPermissions();

    if (mounted) {
      setState(() {
        _permissions = {
          'notification': permissions['notification'] ?? false,
          'exactAlarm': permissions['exactAlarm'] ?? false,
          'batteryOptimization': permissions['batteryOptimization'] ?? false,
        };
        _isLoading = false;
      });
    }
  }

  String _getPermissionLabel(String key) {
    switch (key) {
      case 'notification':
        return 'Notifikasi Dasar';
      case 'exactAlarm':
        return 'Alarm Tepat Waktu (Android 12+)';
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
        return 'Agar app tidak dimatikan paksa di background oleh sistem';
      default:
        return '';
    }
  }

  Widget _buildPermissionListItem(
    BuildContext context,
    MapEntry<String, bool> entry,
  ) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      elevation: 0,
      color: Theme.of(context).cardColor,
      child: ListTile(
        leading: Icon(
          _getPermissionIcon(entry.key),
          color: entry.value ? Colors.green.shade500 : Colors.grey,
          size: 24,
        ),
        title: Text(
          _getPermissionLabel(entry.key),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        subtitle: Text(
          _getPermissionDescription(entry.key),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Icon(
          entry.value ? Icons.check : Icons.close,
          color: entry.value
              ? const Color.fromARGB(255, 136, 226, 139)
              : Colors.red.shade500,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
      ),
    );
  }

  // void _checkNotifButton() {
  //   widget.notificationService.getPendingNotifications();
  // }

  Widget _buildManualStepsCard(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        color: Theme.of(context).cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '📖 Panduan Manual: Autostart & Baterai',
                style: Theme.of(context).textTheme.titleLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Langkah ini memastikan aplikasi tidak dimatikan paksa di latar belakang (background) oleh HP Anda:',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const Divider(height: 24),

              _buildManualStep(
                context,
                '1. Xiaomi / Redmi / POCO:',
                '• Autostart: Buka Settings → Apps → Cari Hebipom → Aktifkan Autostart.\n'
                    '• Penghemat Baterai: Cari Hebipom → Battery Saver (Penghemat Baterai) → Pilih No restrictions (Tidak ada pembatasan).',
              ),
              const SizedBox(height: 16),

              _buildManualStep(
                context,
                '2. Oppo / Realme:',
                '• Aktivitas Latar Belakang: Settings → Battery → App Battery Management → Cari Hebipom → Pilih Allow background activity (Izinkan aktivitas latar belakang).\n'
                    '• Autostart: Settings → Security/Privacy → Startup Manager → Aktifkan Hebipom.',
              ),
              const SizedBox(height: 16),

              _buildManualStep(
                context,
                '3. Vivo:',
                '• Autostart Manager: Buka iManager → App Manager → Autostart Manager → Aktifkan Hebipom.\n'
                    '• Background Running: Pastikan Background running untuk Hebipom diizinkan.',
              ),
              const SizedBox(height: 16),

              _buildManualStep(
                context,
                '4. Samsung:',
                '• Baterai: Settings → Apps → Hebipom → Battery (Baterai) → Pilih Unrestricted (Tidak terbatas).\n'
                    '• Aplikasi Tidur: Pastikan Hebipom dihapus dari daftar Sleeping apps (Aplikasi Tidur) di Pengaturan Baterai.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildManualStep(BuildContext context, String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),

        Text(
          content,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(height: 1.5),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'PERMISSIONS',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: BackButton(onPressed: () => context.pop()),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ..._permissions.entries.map(
                    (entry) => _buildPermissionListItem(context, entry),
                  ),
                  _buildManualStepsCard(context),
                  const SizedBox(height: 20),
                ],
              ),
            ),
    );
  }
}
