import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/vibe_provider.dart';
import 'views/home_view.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => VibeProvider()),
      ],
      child: const VibeRouteApp(),
    ),
  );
}

class VibeRouteApp extends StatelessWidget {
  const VibeRouteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VibeRoute',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
        useMaterial3: true,
        fontFamily: 'Inter', // Defaulting to system font but style-wise looking for modern
      ),
      home: const HomeView(),
    );
  }
}
