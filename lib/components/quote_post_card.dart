import 'package:flutter/material.dart';

class QuotePostCard extends StatelessWidget {
  final String title;
  final String quote;

  const QuotePostCard({
    super.key,
    required this.title,
    required this.quote,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),

        // 🌈 Soft dreamy gradient
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFF7F9),
            Color(0xFFF2F4FF),
          ],
        ),

        // 🌫️ Premium depth (NO deprecated API)
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 30), // ≈ 12%
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),

      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✉️ Header
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.mail_outline_rounded,
                size: 20,
                color: Colors.deepPurple.withValues(alpha: 200),
              ),
              const SizedBox(width: 8),
              const Text(
                'Still alone?',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // ✨ Accent divider
          Container(
            width: 48,
            height: 3,
            decoration: BoxDecoration(
              color: Colors.deepPurple.withValues(alpha: 64),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          const SizedBox(height: 24),

          // 💬 Quote
          Text(
            quote,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              height: 1.45,
              color: Colors.black87,
            ),
          ),

          const SizedBox(height: 24),

          // 🌙 Footer
          Text(
            '— Still alone?',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.black.withValues(alpha: 120),
            ),
          ),
        ],
      ),
    );
  }
}
