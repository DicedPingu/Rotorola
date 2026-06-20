import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quiz.dart';
import '../core/constants/quiz_data.dart';

class QuizState {
  final int currentQuestionIndex;
  final int? selectedAnswerIndex;
  final int correctAnswersCount;
  final bool isCompleted;
  final List<QuizQuestion> questions;

  const QuizState({
    required this.currentQuestionIndex,
    this.selectedAnswerIndex,
    required this.correctAnswersCount,
    required this.isCompleted,
    required this.questions,
  });

  QuizState copyWith({
    int? currentQuestionIndex,
    int? selectedAnswerIndex,
    bool clearSelection = false,
    int? correctAnswersCount,
    bool? isCompleted,
    List<QuizQuestion>? questions,
  }) {
    return QuizState(
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      selectedAnswerIndex: clearSelection ? null : (selectedAnswerIndex ?? this.selectedAnswerIndex),
      correctAnswersCount: correctAnswersCount ?? this.correctAnswersCount,
      isCompleted: isCompleted ?? this.isCompleted,
      questions: questions ?? this.questions,
    );
  }
}

class QuizNotifier extends StateNotifier<QuizState> {
  QuizNotifier()
      : super(QuizState(
          currentQuestionIndex: 0,
          correctAnswersCount: 0,
          isCompleted: false,
          questions: quizQuestionsList,
        ));

  void selectAnswer(int index) {
    if (state.selectedAnswerIndex != null) return; // Prevent changing answer

    final currentQuestion = state.questions[state.currentQuestionIndex];
    final isCorrect = currentQuestion.correctIndex == index;

    state = state.copyWith(
      selectedAnswerIndex: index,
      correctAnswersCount: isCorrect
          ? state.correctAnswersCount + 1
          : state.correctAnswersCount,
    );
  }
  void nextQuestion() {
    if (state.currentQuestionIndex + 1 < state.questions.length) {
      state = state.copyWith(
        currentQuestionIndex: state.currentQuestionIndex + 1,
        clearSelection: true,
      );
    } else {
      state = state.copyWith(
        isCompleted: true,
      );
    }
  }

  void reset() {
    state = QuizState(
      currentQuestionIndex: 0,
      correctAnswersCount: 0,
      isCompleted: false,
      questions: quizQuestionsList,
    );
  }
}

final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  return QuizNotifier();
});
