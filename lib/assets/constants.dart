import 'dart:js';

import 'package:flutter/material.dart';

const Color lightPrimary = Color.fromRGBO(245, 239, 231, 1);
const Color lightSecondary = Color.fromRGBO(216, 196, 182, 1);
const Color lightSecondaryAccent = Color.fromRGBO(37, 124, 155, 1);
const Color lightTertiary = Color.fromRGBO(33, 53, 85, 1);

const Color darkPrimary = Color.fromRGBO(53, 47, 68, 1);
const Color darkSecondaryAccent = Color.fromRGBO(92, 84, 112, 1);
const Color darkSecondary = Color.fromRGBO(185, 180, 199, 1);
const Color darkTertiary = Color.fromRGBO(250, 240, 230, 1);

ThemeData CustomLightTheme() {
  return ThemeData(
    useMaterial3: true,
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightPrimary,
    cardColor: lightSecondary,
    dividerColor: lightSecondaryAccent,
    canvasColor: lightTertiary,
    iconTheme: const IconThemeData(color: lightTertiary),
    appBarTheme: const AppBarTheme(
      elevation: 0,
      backgroundColor: lightPrimary,
      foregroundColor: lightTertiary,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(lightSecondary),
        foregroundColor: MaterialStateProperty.all(lightTertiary),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: MaterialStateProperty.all(lightSecondary),
        foregroundColor: MaterialStateProperty.all(lightTertiary),
      ),
    ),
    cardTheme: const CardTheme(
      color: lightPrimary,
      surfaceTintColor: lightSecondary,
      shadowColor: lightTertiary,
    ),
    listTileTheme: const ListTileThemeData(
      textColor: lightTertiary,
      iconColor: lightTertiary,
      tileColor: lightSecondary,
    ),
    tabBarTheme: const TabBarTheme(
      labelStyle: TextStyle(
        fontSize: 17,
      ),
    ),
  );
}

ThemeData CustomDarkTheme() {
  return ThemeData(
    useMaterial3: true,
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkPrimary,
    cardColor: darkSecondary,
    dividerColor: darkSecondaryAccent,
    canvasColor: darkTertiary,
    iconTheme: const IconThemeData(color: darkTertiary),
    appBarTheme: const AppBarTheme(
      backgroundColor: darkPrimary,
      foregroundColor: darkTertiary,
    ),
    textButtonTheme: TextButtonThemeData(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(darkSecondary),
        foregroundColor: MaterialStateProperty.all(darkTertiary),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ButtonStyle(
        textStyle: MaterialStateProperty.all(
          const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: MaterialStateProperty.all(darkSecondary),
        foregroundColor: MaterialStateProperty.all(darkTertiary),
      ),
    ),
    cardTheme: const CardTheme(
      color: darkPrimary,
      surfaceTintColor: darkSecondaryAccent,
      shadowColor: darkTertiary,
    ),
    listTileTheme: const ListTileThemeData(
      textColor: darkTertiary,
      iconColor: darkTertiary,
      tileColor: darkSecondary,
    ),
    tabBarTheme: const TabBarTheme(
      unselectedLabelColor: darkTertiary,
      labelColor: darkTertiary,
      labelStyle: TextStyle(
        fontSize: 17,
      ),
    ),
  );
}

List<String> prefixes = ['k', 'M', 'G', 'T', 'P'];

String SubCount(double subCount) {
  double num = subCount ?? 0;

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

  Duration difference = DateTime.now().difference(dateTime!);

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

  Duration duration = inDuration!;

  int hours = duration.inHours;
  int minutes = duration.inMinutes.remainder(60);
  int seconds = duration.inSeconds.remainder(60);

  if (hours > 0) {
    return '$hours:${minutes < 10 ? '0$minutes' : '$minutes'}:${seconds < 10 ? '0$seconds' : '$seconds'}';
  } else {
    return '${minutes < 10 ? '0$minutes' : '$minutes'}:${seconds < 10 ? '0$seconds' : '$seconds'}';
  }
}
