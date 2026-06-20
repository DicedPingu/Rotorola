import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_theme.dart';
import '../../providers/quiz_provider.dart';

class QuizGamePage extends ConsumerWidget {
  const QuizGamePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizProvider);

    return Scaffold(
      backgroundColor: AppTheme.background,
      appBar: AppBar(
        title: const Text('Operator Test'),
        backgroundColor: AppTheme.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
          child: quizState.isCompleted
              ? _buildResultScreen(context, ref, quizState)
              : _buildQuestionScreen(context, ref, quizState),
        ),
      ),
    );
  }

  Widget _buildResultScreen(BuildContext context, WidgetRef ref, dynamic state) {
    final int score = state.correctAnswersCount;
    final int total = state.questions.length;
    final double percentage = score / total;

    String feedbackTitle;
    String feedbackDesc;
    IconData feedbackIcon;
    Color feedbackColor;

    if (percentage == 1.0) {
      feedbackTitle = 'Elite Operator';
      feedbackDesc = 'Perfect score! You understand partition tables, Magisk, and bootloader integrity. You are ready to tweak fogorow.';
      feedbackIcon = Icons.military_tech_rounded;
      feedbackColor = AppTheme.cyanAccent;
    } else if (percentage >= 0.6) {
      feedbackTitle = 'Certified User';
      feedbackDesc = 'Good job! You have a solid grasp of key principles, but review your mistakes to prevent unexpected bootloops.';
      feedbackIcon = Icons.verified_user_rounded;
      feedbackColor = Colors.greenAccent;
    } else {
      feedbackTitle = 'High Risk Detected';
      feedbackDesc = 'We recommend retaking the test. Modifying partitions or locking custom bootloaders carries high bricking risks.';
      feedbackIcon = Icons.dangerous_rounded;
      feedbackColor = Colors.redAccent;
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: feedbackColor.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(
                color: feedbackColor.withOpacity(0.3),
                width: 2,
              ),
            ),
            child: Icon(
              feedbackIcon,
              color: feedbackColor,
              size: 72,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            feedbackTitle,
            style: GoogleFonts.outfit(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Score: $score / $total',
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: feedbackColor,
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              feedbackDesc,
              style: GoogleFonts.outfit(
                fontSize: 15,
                color: AppTheme.textSecondary,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ref.read(quizProvider.notifier).reset();
              },
              child: Text(
                'RETRY EVALUATION',
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
    );
  }

  Widget _buildQuestionScreen(BuildContext context, WidgetRef ref, dynamic state) {
    final int questionIndex = state.currentQuestionIndex;
    final question = state.questions[questionIndex];
    final bool hasAnswered = state.selectedAnswerIndex != null;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Category & Counter
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppTheme.cyanAccent.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppTheme.cyanAccent.withOpacity(0.25),
                    width: 1,
                  ),
                ),
                child: Text(
                  question.category.toUpperCase(),
                  style: GoogleFonts.outfit(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.cyanAccent,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
              Text(
                'Q: ${questionIndex + 1} of ${state.questions.length}',
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Question Card
          Text(
            question.question,
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppTheme.textPrimary,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // Options list
          ...List.generate(
            question.options.length,
            (index) {
              final optionText = question.options[index];
              Color buttonBorderColor = Colors.white.withOpacity(0.05);
              Color buttonBgColor = AppTheme.cardBg;
              Color textColor = AppTheme.textPrimary;
              IconData? suffixIcon;

              if (hasAnswered) {
                if (index == question.correctIndex) {
                  // Correct answer: always green
                  buttonBorderColor = Colors.greenAccent;
                  buttonBgColor = Colors.greenAccent.withOpacity(0.1);
                  textColor = Colors.greenAccent;
                  suffixIcon = Icons.check_circle_outline_rounded;
                } else if (index == state.selectedAnswerIndex) {
                  // Selected incorrect answer: red
                  buttonBorderColor = Colors.redAccent;
                  buttonBgColor = Colors.redAccent.withOpacity(0.1);
                  textColor = Colors.redAccent;
                  suffixIcon = Icons.highlight_off_rounded;
                } else {
                  // Other incorrect options: faded
                  textColor = AppTheme.textSecondary.withOpacity(0.5);
                }
              }

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: hasAnswered
                        ? null
                        : () {
                            ref.read(quizProvider.notifier).selectAnswer(index);
                          },
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: buttonBgColor,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: buttonBorderColor,
                          width: hasAnswered && (index == question.correctIndex || index == state.selectedAnswerIndex)
                              ? 2
                              : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              optionText,
                              style: GoogleFonts.outfit(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: textColor,
                                height: 1.4,
                              ),
                            ),
                          ),
                          if (suffixIcon != null) ...[
                            const SizedBox(width: 12),
                            Icon(suffixIcon, color: textColor, size: 20),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 12),

          // Explanation Card if answered
          if (hasAnswered) ...[
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.06),
                  width: 1,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.info_outline_rounded, color: AppTheme.cyanAccent, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        'EXPLANATION',
                        style: GoogleFonts.outfit(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.cyanAccent,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    question.explanation,
                    style: GoogleFonts.outfit(
                      fontSize: 13.5,
                      color: AppTheme.textSecondary,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Next Question Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  ref.read(quizProvider.notifier).nextQuestion();
                },
                child: Text(
                  questionIndex + 1 < state.questions.length ? 'NEXT QUESTION' : 'VIEW SCORE',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}
