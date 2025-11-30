class HabitUtils {
  /// Normalisasi DateTime ke midnight (00:00:00)
  static DateTime normalizeToDay(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Hitung nomor minggu dalam tahun
  static int getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).floor() + 1;
  }

  /// Check apakah habit sudah completed untuk periode saat ini
  static bool isCompletedForCurrentPeriod({
    required bool isCompleted,
    required DateTime? lastCompletedDate,
    required String habitFrequency,
  }) {
    if (!isCompleted || lastCompletedDate == null) {
      return false;
    }

    final now = DateTime.now();
    final today = normalizeToDay(now);
    final lastDay = normalizeToDay(lastCompletedDate);

    switch (habitFrequency) {
      case 'daily':
        // Daily: completed jika hari yang sama
        return today.isAtSameMomentAs(lastDay);

      case 'thirdlyPerWeek':
      case 'weekly':
        // Weekly: completed jika masih dalam minggu yang sama
        final lastWeek = getWeekNumber(lastCompletedDate);
        final currentWeek = getWeekNumber(now);
        return currentWeek == lastWeek;

      case 'monthly':
        // Monthly: completed jika masih dalam bulan yang sama
        return lastCompletedDate.year == now.year &&
            lastCompletedDate.month == now.month;

      default:
        return false;
    }
  }

  /// Check apakah habit perlu reset isCompleted
  static bool shouldResetCompleted({
    required bool isCompleted,
    required DateTime? lastCompletedDate,
    required String habitFrequency,
  }) {
    if (!isCompleted || lastCompletedDate == null) {
      return false;
    }

    final now = DateTime.now();
    final today = normalizeToDay(now);
    final lastDay = normalizeToDay(lastCompletedDate);

    switch (habitFrequency) {
      case 'daily':
        // Reset jika bukan hari yang sama
        return !today.isAtSameMomentAs(lastDay);

      case 'thirdlyPerWeek':
      case 'weekly':
        // Reset jika sudah beda hari (biar bisa complete lagi dalam minggu yang sama)
        return !today.isAtSameMomentAs(lastDay);

      case 'monthly':
        // Reset jika sudah beda hari (biar bisa complete lagi dalam bulan yang sama)
        return !today.isAtSameMomentAs(lastDay);

      default:
        return false;
    }
  }

  /// Check apakah habit perlu reset streak (karena melewatkan deadline)
  static bool shouldResetStreak({
    required DateTime? lastCompletedDate,
    required String habitFrequency,
  }) {
    if (lastCompletedDate == null) {
      return false;
    }

    final now = DateTime.now();
    final today = normalizeToDay(now);
    final lastDay = normalizeToDay(lastCompletedDate);
    final daysSinceLastCompleted = today.difference(lastDay).inDays;

    switch (habitFrequency) {
      case 'daily':
        // Reset jika melewatkan lebih dari 1 hari
        final yesterday = today.subtract(const Duration(days: 1));
        return !lastDay.isAtSameMomentAs(yesterday) &&
            !lastDay.isAtSameMomentAs(today);

      case 'thirdlyPerWeek':
      case 'weekly':
        // Reset jika melewatkan lebih dari 7 hari
        return daysSinceLastCompleted > 7;

      case 'monthly':
        // Reset jika melewatkan lebih dari 30 hari
        return daysSinceLastCompleted > 30;

      default:
        return false;
    }
  }

  /// Hitung streak baru ketika habit di-complete
  static int calculateNewStreak({
    required int currentStreak,
    required DateTime? lastCompletedDate,
    required String habitFrequency,
    required DateTime completedAt,
  }) {
    // Jika belum pernah completed, mulai dari 1
    if (lastCompletedDate == null) {
      return 1;
    }

    final today = normalizeToDay(completedAt);
    final lastDay = normalizeToDay(lastCompletedDate);

    switch (habitFrequency) {
      case 'daily':
        final yesterday = today.subtract(const Duration(days: 1));
        // Lanjutkan streak jika kemarin completed
        if (lastDay.isAtSameMomentAs(yesterday)) {
          return currentStreak + 1;
        }
        // Reset ke 1 jika terputus
        return 1;

      case 'thirdlyPerWeek':
        final lastWeek = getWeekNumber(lastCompletedDate);
        final currentWeek = getWeekNumber(completedAt);
        // Lanjutkan streak jika minggu yang sama atau minggu berikutnya
        if (currentWeek == lastWeek || currentWeek == lastWeek + 1) {
          return currentStreak + 1;
        }
        return 1;

      case 'weekly':
        final lastWeek = getWeekNumber(lastCompletedDate);
        final currentWeek = getWeekNumber(completedAt);
        // Lanjutkan streak hanya jika minggu berikutnya
        if (currentWeek == lastWeek + 1) {
          return currentStreak + 1;
        } else if (currentWeek > lastWeek + 1) {
          return 1;
        }
        // Jika masih minggu yang sama, tetap
        return currentStreak;

      default:
        return 1;
    }
  }

  /// Check apakah bisa complete habit saat ini
  static bool canBeCompleted({
    required bool isCompleted,
    required DateTime? lastCompletedDate,
    required String habitFrequency,
  }) {
    // Jika sudah completed untuk periode saat ini, tidak bisa
    if (isCompletedForCurrentPeriod(
      isCompleted: isCompleted,
      lastCompletedDate: lastCompletedDate,
      habitFrequency: habitFrequency,
    )) {
      return false;
    }

    return true;
  }

  /// Get pesan untuk user berdasarkan frequency
  static String getAlreadyCompletedMessage(String habitFrequency) {
    switch (habitFrequency) {
      case 'daily':
        return 'Habit already completed today';
      case 'thirdlyPerWeek':
      case 'weekly':
        return 'Habit already completed this week';
      case 'monthly':
        return 'Habit already completed this month';
      default:
        return 'Habit already completed';
    }
  }

  /// Check apakah sudah waktunya untuk complete (opsional, untuk reminder)
  static bool isTimeToComplete({
    required int reminderHour,
    required int reminderMinute,
  }) {
    final now = DateTime.now();
    return now.hour >= reminderHour && now.minute >= reminderMinute;
  }
}