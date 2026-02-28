import 'package:flutter/material.dart';
import 'result_screen.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  void _onSelect(BuildContext context, String choice) {
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
              Color(0xFFC7D2EB), // pastel blue
              Color(0xFFD8CCE9), // pastel purple
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
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
                  onTap: () => _onSelect(context, 'Yes'),
                ),
                const SizedBox(height: 16),

                _PillButton(
                  label: 'No',
                  onTap: () => _onSelect(context, 'No'),
                ),
                const SizedBox(height: 16),

                _PillButton(
                  label: 'Not sure',
                  onTap: () => _onSelect(context, 'Not sure'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PillButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _PillButton({
    required this.label,
    required this.onTap,
  });

  Color _backgroundForLabel() {
    switch (label.toLowerCase()) {
      case 'yes':
        return const Color(0xFFE6EDFF);
      case 'no':
        return const Color(0xFFEDE8FF);
      default:
        return const Color(0xFFFFEEF6);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 240,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: _backgroundForLabel(),
          borderRadius: BorderRadius.circular(999),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}
