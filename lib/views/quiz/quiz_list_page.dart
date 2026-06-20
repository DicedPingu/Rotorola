import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/quiz_provider.dart';
import 'quiz_game_page.dart';

class QuizListPage extends ConsumerWidget {
  const QuizListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Knowledge Quizzes'),
        backgroundColor: AppTheme.background,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppTheme.background,
              AppTheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                // Visual header
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.cyanAccent.withOpacity(0.1),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: AppTheme.cyanAccent.withOpacity(0.3),
                      width: 2,
                    ),
                  ),
                  child: const Icon(
                    Icons.terminal,
                    color: AppTheme.cyanAccent,
                    size: 64,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Operator Evaluation',
                  style: GoogleFonts.outfit(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textPrimary,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Test your understanding of root architecture, partition management, and secure modding rules on the Motorola G24.',
                  style: GoogleFonts.outfit(
                    fontSize: 15,
                    color: AppTheme.textSecondary,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Spacer(),

                // Summary details / categories card
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.cardBg,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.05),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildDetailRow(context, Icons.help_outline_rounded, 'Questions', '5 Scenarios'),
                      const SizedBox(height: 12),
                      _buildDetailRow(context, Icons.shield_outlined, 'Safety Rating', 'Crucial Knowledge'),
                      const SizedBox(height: 12),
                      _buildDetailRow(context, Icons.list_alt_rounded, 'Topics', 'Bootloaders, Zygisk, Partitions'),
                    ],
                  ),
                ),
                const Spacer(),

                // Start button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      ref.read(quizProvider.notifier).reset();
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const QuizGamePage(),
                        ),
                      );
                    },
                    child: Text(
                      'START EVALUATION',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppTheme.cyanAccent, size: 20),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppTheme.textSecondary,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}
