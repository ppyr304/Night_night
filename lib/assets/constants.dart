import 'package:flutter/material.dart';

const Color lightPrimary = Color.fromRGBO(245, 239, 231, 1);
const Color lightSecondary = Color.fromRGBO(216, 196, 182, 1);
const Color lightSecondaryAccent = Color.fromRGBO(130, 94, 69, 1);
const Color lightTertiary = Color.fromRGBO(33, 53, 85, 1);

const Color darkPrimary = Color.fromRGBO(53, 47, 68, 1);
const Color darkSecondaryAccent = Color.fromRGBO(92, 84, 112, 1);
const Color darkSecondary = Color.fromRGBO(185, 180, 199, 1);
const Color darkTertiary = Color.fromRGBO(250, 240, 230, 1);

ThemeData CustomLightTheme() {
  return ThemeData(
    useMaterial3: true,
    primaryColor: lightPrimary,
    canvasColor: lightTertiary,
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: lightSecondary,
      onPrimary: lightTertiary,
      secondary: lightSecondary,
      onSecondary: lightSecondaryAccent,
      error: Colors.red,
      onError: Colors.red,
      background: lightPrimary,
      onBackground: lightTertiary,
      surface: lightSecondary,
      onSurface: lightTertiary,
    ),
    indicatorColor: lightSecondaryAccent,
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: lightSecondaryAccent,
    ),
    dividerColor: lightSecondaryAccent,
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: lightSecondaryAccent),
      labelStyle: TextStyle(color: lightSecondaryAccent),
      hoverColor: lightSecondaryAccent,
    ),
    iconTheme: const IconThemeData(color: lightTertiary),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          const TextStyle(color: lightTertiary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: MaterialStateProperty.all(lightSecondary),
        foregroundColor: MaterialStateProperty.all(lightTertiary),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          const TextStyle(color: lightTertiary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: MaterialStateProperty.all(lightSecondary),
        foregroundColor: MaterialStateProperty.all(lightTertiary),
      ),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: lightPrimary,
      foregroundColor: lightTertiary,
    ),
    cardTheme: const CardTheme(
      color: lightPrimary,
      surfaceTintColor: lightSecondary,
      shadowColor: lightTertiary,
    ),
    listTileTheme: const ListTileThemeData(
      tileColor: lightSecondary,
    ),
    tabBarTheme: const TabBarTheme(
      indicatorColor: lightTertiary,
      unselectedLabelColor: Colors.grey,
      labelColor: lightTertiary,
      labelStyle: TextStyle(
        fontSize: 17,
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: lightSecondaryAccent,
    ),
  );
}

ThemeData CustomDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    primaryColor: darkPrimary,
    canvasColor: darkTertiary,
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: darkSecondaryAccent,
      onPrimary: darkTertiary,
      secondary: darkSecondaryAccent,
      onSecondary: darkSecondary,
      error: Colors.red,
      onError: Colors.red,
      background: darkPrimary,
      onBackground: darkTertiary,
      surface: darkSecondaryAccent,
      onSurface: darkTertiary,
    ),
    progressIndicatorTheme: const ProgressIndicatorThemeData(
      color: darkSecondary,
    ),
    inputDecorationTheme: const InputDecorationTheme(
      hintStyle: TextStyle(color: darkSecondary),
      labelStyle: TextStyle(color: darkSecondary),
      hoverColor: darkSecondaryAccent,
    ),
    iconTheme: const IconThemeData(color: darkTertiary),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          const TextStyle(color: darkTertiary, fontWeight: FontWeight.bold),
        ),
        backgroundColor: MaterialStateProperty.all(darkSecondaryAccent),
        foregroundColor: MaterialStateProperty.all(darkTertiary),
      ),
    ),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: darkPrimary,
      foregroundColor: darkTertiary,
    ),
    cardTheme: const CardTheme(
      color: darkPrimary,
      surfaceTintColor: darkSecondaryAccent,
      shadowColor: darkTertiary,
    ),
    listTileTheme: const ListTileThemeData(
      tileColor: darkSecondary,
    ),
    tabBarTheme: const TabBarTheme(
      indicatorColor: darkTertiary,
      unselectedLabelColor: Colors.grey,
      labelColor: darkTertiary,
      labelStyle: TextStyle(
        fontSize: 17,
      ),
    ),
  );
}

List<String> prefixes = ['k', 'M', 'G', 'T', 'P'];

String SubCount(double subCount) {
  double num = subCount;

  String count = "$num subscribers";

  for (int x = 0; num > 1000; x++) {
    num /= 1000;
    num = double.parse(num.toStringAsFixed(3));

    count = "$num${prefixes[x]} subscribers";
  }

  return count;
}

String timeAgo(DateTime? dateTime) {
  if (dateTime == null) {
    return 'idk';
  }

  Duration difference = DateTime.now().difference(dateTime);

  if (difference.inDays >= 365) {
    int years = (difference.inDays / 365).floor();
    return '$years year${years == 1 ? '' : 's'} ago';
  } else if (difference.inDays >= 30) {
    int months = (difference.inDays / 30).floor();
    return '$months month${months == 1 ? '' : 's'} ago';
  } else if (difference.inDays >= 7) {
    int weeks = (difference.inDays / 7).floor();
    return '$weeks week${weeks == 1 ? '' : 's'} ago';
  } else if (difference.inDays >= 1) {
    return '${difference.inDays} day${difference.inDays == 1 ? '' : 's'} ago';
  } else if (difference.inHours >= 1) {
    return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
  } else if (difference.inMinutes >= 1) {
    return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
  } else {
    return 'just now';
  }
}

String formatDuration(Duration? inDuration) {
  if (inDuration == null) {
    return 'Unknown duration';
  }

  Duration duration = inDuration;

  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);

  if (hours > 0) {
    return '$hours:${minutes < 10 ? '0$minutes' : '$minutes'}:${seconds < 10 ? '0$seconds' : '$seconds'}';
  } else {
    return '${minutes < 10 ? '0$minutes' : '$minutes'}:${seconds < 10 ? '0$seconds' : '$seconds'}';
  }
}

class EndOfList extends StatelessWidget {
  const EndOfList({super.key, required this.condition});
  final bool condition;

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("Couldn't find more"),
      );
    } else {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
