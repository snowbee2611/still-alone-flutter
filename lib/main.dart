import 'package:flutter/material.dart';
import 'screens/question_screen.dart';
import 'services/notification_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NotificationService.init();

  runApp(const StillAloneApp());
}

class StillAloneApp extends StatelessWidget {
  const StillAloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Still Alone',
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),
      navigatorKey: navigatorKey,
      home: const HomeGate(),
    );
  }
}

class HomeGate extends StatefulWidget {
  const HomeGate({super.key});

  @override
  State<HomeGate> createState() => _HomeGateState();
}

class _HomeGateState extends State<HomeGate> {
  @override
  void initState() {
    super.initState();
    _checkAndShowPermission();
  }

  Future<void> _checkAndShowPermission() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeen = prefs.getBool('permission_prompt_shown') ?? false;

    // Check actual notification permission status
    final isGranted = await NotificationService.isPermissionGranted();

    // Show dialog again ONLY if permission is still denied
    if (!isGranted) {
      // If user has never seen it OR permission is still denied
      await Future.delayed(const Duration(seconds: 1));
      _showFloatingReminder();
    }
  }

  void _showFloatingReminder() {
    showGeneralDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: true,
      barrierLabel: "",
      barrierColor: Colors.black.withOpacity(0.3),
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(color: Colors.black.withOpacity(0.2)),
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E8FF),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 25,
                      offset: Offset(0, 12),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.notifications_active,
                        color: Color(0xFFD1C4E9), size: 55),
                    const SizedBox(height: 20),
                    const Text(
                      "Enable gentle reminders?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "We send soft check-ins sometimes 💜",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool('permission_prompt_shown', true);
                              Navigator.pop(navigatorKey.currentContext!);
                            },
                            child: const Text("Not now"),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD1C4E9),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () async {
                              final prefs = await SharedPreferences.getInstance();
                              await prefs.setBool('permission_prompt_shown', true);
                              Navigator.pop(navigatorKey.currentContext!);
                              await NotificationService.requestPermission();
                            },
                            child: const Text(
                              "Enable 💜",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
      transitionBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOut,
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.1),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutBack,
            )),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const QuestionScreen();
  }
}