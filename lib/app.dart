import 'package:flutter/material.dart';
import 'package:oxford/screens/home/home_screen.dart';
import 'package:oxford/theme/oxford_colors.dart';

class OxfordApp extends StatelessWidget {
  const OxfordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Oxford',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        fontFamily: 'GolosText',
        fontFamilyFallback: const ['GolosTextLatin'],
        scaffoldBackgroundColor: OxfordColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: OxfordColors.header,
          primary: OxfordColors.header,
          surface: OxfordColors.background,
        ),
        splashFactory: InkRipple.splashFactory,
      ),
      home: const HomeScreen(),
    );
  }
}
