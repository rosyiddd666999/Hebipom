# Isar Database
-keep class io.isar.** { *; }
-keepclassmembers class * {
    @io.isar.* <fields>;
}

# Flutter Local Notifications
-keep class com.dexterous.** { *; }
-keep class androidx.core.app.** { *; }

# Model classes
-keep class **$IsarSchema { *; }
-keep class **.HabitIsar { *; }
-keep class **.HabitIsarSchema { *; }

# General Android
-keep class * extends android.app.Service
-keep class * implements android.os.Parcelable { *; }