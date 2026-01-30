// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:go_router/go_router.dart';

// import '../utils/vectors.dart';

// class MyBottomNav extends StatelessWidget {
//   final StatefulNavigationShell shell;

//   const MyBottomNav({super.key, required this.shell});

//   // Aset untuk TEMA CERAH (Background terang, jadi ikon harus gelap)
//   static const List<_NavItemData> _navItemsLight = [
//     _NavItemData(
//       label: 'Home',
//       svgIconEnable: AppVectors.habitDark, // Terpilih (Dark)
//       svgIconDisable: AppVectors.habitLight, // Tidak terpilih (Light)
//     ),
//     _NavItemData(
//       label: 'Pomodoro',
//       svgIconEnable: AppVectors.pomodoroDark,
//       svgIconDisable: AppVectors.pomodoroLight,
//     ),
//     _NavItemData(
//       label: 'Calender',
//       svgIconEnable: AppVectors.calenderDark,
//       svgIconDisable: AppVectors.calenderLight,
//     ),
//     _NavItemData(
//       label: 'Settings',
//       svgIconEnable: AppVectors.settingsDark,
//       svgIconDisable: AppVectors.settingsLight,
//     ),
//   ];

//   // Aset untuk TEMA GELAP (Background gelap, jadi ikon harus terang)
//   static const List<_NavItemData> _navItemsDark = [
//     _NavItemData(
//       label: 'Home',
//       svgIconEnable: AppVectors.habitLight, // Terpilih (Light)
//       svgIconDisable: AppVectors.habitDark, // Tidak terpilih (Dark)
//     ),
//     _NavItemData(
//       label: 'Pomodoro',
//       svgIconEnable: AppVectors.pomodoroLight,
//       svgIconDisable: AppVectors.pomodoroDark,
//     ),
//     _NavItemData(
//       label: 'Calender',
//       svgIconEnable: AppVectors.calenderLight,
//       svgIconDisable: AppVectors.calenderDark,
//     ),
//     _NavItemData(
//       label: 'Settings',
//       svgIconEnable: AppVectors.settingsLight,
//       svgIconDisable: AppVectors.settingsDark,
//     ),
//   ];

//   @override
//   Widget build(BuildContext context) {
//     // Tentukan daftar aset mana yang akan digunakan berdasarkan tema saat ini
//     final isLightMode = Theme.of(context).brightness == Brightness.light;

//     // Catatan: Anda mungkin ingin menggunakan _navItemsLight untuk Light mode
//     // (karena itu adalah nama aset yang dirancang untuk Light Mode background)
//     // dan _navItemsDark untuk Dark mode. Saya akan mengikuti logika penamaan Anda
//     // namun Anda mungkin perlu memvalidasi mana yang harus dipakai:
//     final List<_NavItemData> currentNavItems = isLightMode
//         ? _navItemsLight // Background terang -> Gunakan aset Light
//         : _navItemsDark; // Background gelap -> Gunakan aset Dark

//     return Scaffold(
//       body: shell,
//       bottomNavigationBar: SizedBox(
//         height: 90,
//         child: BottomNavigationBar(
//           currentIndex: shell.currentIndex,

//           onTap: (index) => shell.goBranch(index),

//           type: BottomNavigationBarType.fixed,

//           backgroundColor: Theme.of(
//             context,
//           ).colorScheme.secondary,
//           elevation: 0,

//           // Warna teks label (gunakan warna yang kontras dengan surface)
//           selectedItemColor: Theme.of(context).colorScheme.onSurface,
//           unselectedItemColor: Theme.of(context).colorScheme.surface,

//           showSelectedLabels: true,
//           showUnselectedLabels: true,
//           selectedLabelStyle: const TextStyle(
//             fontSize: 10,
//             fontWeight: FontWeight.bold,
//           ),
//           unselectedLabelStyle: const TextStyle(
//             fontSize: 10,
//             fontWeight: FontWeight.bold,
//           ),

//           // Memperbaiki: Pastikan `.toList()` dipanggil di akhir pemetaan.
//           items: currentNavItems
//               .asMap()
//               .entries
//               .map(
//                 (entry) => _buildBottomNavItem(
//                   context,
//                   data: entry.value,
//                   isSelected: entry.key == shell.currentIndex,
//                 ),
//               )
//               .toList(), // WAJIB ADA `.toList()`
//         ),
//       ),
//     );
//   }

//   BottomNavigationBarItem _buildBottomNavItem(
//     BuildContext context, {
//     required _NavItemData data,
//     required bool isSelected,
//   }) {
//     // Ambil path aset SVG yang sesuai (enable/disable) dari objek data
//     final iconAsset = isSelected ? data.svgIconEnable : data.svgIconDisable;

//     // Catatan: Karena Anda menggunakan dua set aset SVG (Light/Dark),
//     // Anda TIDAK PERLU lagi menggunakan ColorFilter di sini. Cukup tampilkan asetnya.

//     return BottomNavigationBarItem(
//       icon: Padding(
//         padding: const EdgeInsets.only(bottom: 4.0),
//         // SvgPicture akan merender aset yang sudah benar warnanya
//         child: SvgPicture.asset(iconAsset, height: 24),
//       ),
//       label: data.label,
//     );
//   }
// }

// class _NavItemData {
//   final String label;
//   final String svgIconEnable;
//   final String svgIconDisable;

//   const _NavItemData({
//     required this.label,
//     required this.svgIconEnable,
//     required this.svgIconDisable,
//   });
// }
