import 'package:flutter/material.dart';

class StoryCanvas extends StatelessWidget {
  final String quote;
  final String answer;

  const StoryCanvas({
    super.key,
    required this.quote,
    required this.answer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 360,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 26),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFF6F1FF),
            Color(0xFFEDE6FF),
          ],
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 30,
            offset: Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Title
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.mail_outline, color: Color(0xFF6A4BC3)),
              SizedBox(width: 8),
              Text(
                'Still alone?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),

          const SizedBox(height: 6),
          Container(
            width: 42,
            height: 4,
            decoration: BoxDecoration(
              color: const Color(0xFF6A4BC3),
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          const SizedBox(height: 18),

          // ✅ User answer (NEW)
          Text(
            'Answer: $answer',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black.withValues(alpha: 130),
              fontStyle: FontStyle.italic,
            ),
          ),

          const SizedBox(height: 18),

          // Quote
          Text(
            quote,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20,
              height: 1.4,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 22),

          const Text(
            '— Still alone?',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black45,
            ),
          ),
        ],
      ),
    );
  }
}
