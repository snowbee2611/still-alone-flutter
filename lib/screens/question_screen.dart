import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/notification_services.dart';
import 'result_screen.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  Future<void> _handleSelection(
      BuildContext context, String choice) async {

    final prefs = await SharedPreferences.getInstance();

    // 🔥 Save last choice
    await prefs.setString('lastChoice', choice);

    // 🔥 Save last open time
    await prefs.setInt(
      'last_open_time',
      DateTime.now().millisecondsSinceEpoch,
    );

    // 🔥 DO NOT AWAIT (very important)
    NotificationService.sendInstantAfterAnswer(choice);

    // 🔥 Schedule weekly notifications (this is fast)
    await NotificationService.scheduleWeeklyNotifications();

    // Navigate immediately
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResultScreen(choice: choice),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFC7D2EB),
              Color(0xFFD8CCE9),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment:
              MainAxisAlignment.center,
              children: [
                const Text(
                  'Still alone?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 40),

                _PillButton(
                  label: 'Yes',
                  onTap: () =>
                      _handleSelection(context, 'Yes'),
                ),
                const SizedBox(height: 16),

                _PillButton(
                  label: 'No',
                  onTap: () =>
                      _handleSelection(context, 'No'),
                ),
                const SizedBox(height: 16),

                _PillButton(
                  label: 'Not sure',
                  onTap: () => _handleSelection(
                      context, 'Not sure'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PillButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.onTap,
  });

  @override
  State<_PillButton> createState() => _PillButtonState();
}

class _PillButtonState extends State<_PillButton>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool _isPressed = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.92).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOut,
          ),
        );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Color _backgroundForLabel() {
    switch (widget.label.toLowerCase()) {
      case 'yes':
        return const Color(0xFFE6EDFF);
      case 'no':
        return const Color(0xFFEDE8FF);
      default:
        return const Color(0xFFFFEEF6);
    }
  }

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
    setState(() => _isPressed = false);
    widget.onTap();
  }

  void _onTapCancel() {
    _controller.reverse();
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final baseColor = _backgroundForLabel();

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 100),
          width: 240,
          padding:
          const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: _isPressed
                ? baseColor.withOpacity(0.85)
                : baseColor,
            borderRadius:
            BorderRadius.circular(999),
            boxShadow: _isPressed
                ? []
                : [
              BoxShadow(
                color:
                Colors.black.withOpacity(0.1),
                blurRadius: 18,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Center(
            child: Text(
              widget.label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ),
    );
  }
}