import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

/// 听力测试状态数据类
class ListeningTestState {
  final int currentQuestion;
  final int correctAnswers;
  final List<String?> answers;
  final int playCount;
  final bool isPlaying;

  ListeningTestState({
    this.currentQuestion = 0,
    this.correctAnswers = 0,
    this.answers = const [],
    this.playCount = 0,
    this.isPlaying = false,
  });

  ListeningTestState copyWith({
    int? currentQuestion,
    int? correctAnswers,
    List<String?>? answers,
    int? playCount,
    bool? isPlaying,
  }) {
    return ListeningTestState(
      currentQuestion: currentQuestion ?? this.currentQuestion,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      answers: answers ?? this.answers,
      playCount: playCount ?? this.playCount,
      isPlaying: isPlaying ?? this.isPlaying,
    );
  }
}

/// 听力测试Notifier
class ListeningTestNotifier extends Notifier<ListeningTestState> {
  @override
  ListeningTestState build() {
    return ListeningTestState(
      answers: List.filled(AppConstants.listeningTestQuestions, null),
    );
  }

  void setPlaying(bool playing) {
    state = state.copyWith(isPlaying: playing);
  }

  void incrementPlayCount() {
    state = state.copyWith(playCount: state.playCount + 1);
  }

  void answer(String answer) {
    final newAnswers = List<String?>.from(state.answers);
    newAnswers[state.currentQuestion] = answer;
    state = state.copyWith(answers: newAnswers);
  }

  void nextQuestion() {
    if (state.currentQuestion < AppConstants.listeningTestQuestions - 1) {
      state = state.copyWith(
        currentQuestion: state.currentQuestion + 1,
        playCount: 0,
      );
    }
  }

  void calculateScore() {
    int correct = 0;
    for (int i = 0; i < listeningQuestions.length; i++) {
      if (state.answers[i] == listeningQuestions[i].correctAnswer) {
        correct++;
      }
    }
    state = state.copyWith(correctAnswers: correct);
  }
}

/// 听力测试状态Provider
final listeningTestStateProvider = NotifierProvider<ListeningTestNotifier, ListeningTestState>(() {
  return ListeningTestNotifier();
});

/// 听力测试题目数据类
class ListeningQuestion {
  final String audioText;
  final List<String> options;
  final String correctAnswer;

  ListeningQuestion({
    required this.audioText,
    required this.options,
    required this.correctAnswer,
  });
}

/// 听力测试题目列表
final listeningQuestions = [
  ListeningQuestion(audioText: 'I want to go home', options: ['I want to go home', 'I wanna go home', 'I went to go home', '没听清'], correctAnswer: 'I want to go home'),
  ListeningQuestion(audioText: 'What are you doing?', options: ['What are you doing?', 'What do you doing?', 'How are you doing?', 'What you doing?'], correctAnswer: 'What are you doing?'),
  ListeningQuestion(audioText: 'I\'m going to the store', options: ['I\'m going to the store', 'I\'m going to the star', 'I\'m going to the sport', 'I\'m going to the door'], correctAnswer: 'I\'m going to the store'),
  ListeningQuestion(audioText: 'Can you help me?', options: ['Can you help me?', 'Can you hold me?', 'Can you tell me?', 'Can you ask me?'], correctAnswer: 'Can you help me?'),
  ListeningQuestion(audioText: 'It\'s very kind of you', options: ['It\'s very kind of you', 'It\'s very cute of you', 'It\'s very cold of you', 'It\'s very mind of you'], correctAnswer: 'It\'s very kind of you'),
  ListeningQuestion(audioText: 'Where do you live?', options: ['Where do you live?', 'Where do you leave?', 'Where are you live?', 'Where you live?'], correctAnswer: 'Where do you live?'),
  ListeningQuestion(audioText: 'I\'d like a cup of coffee', options: ['I\'d like a cup of coffee', 'I\'d like a cup of tea', 'I\'d like a cup of water', 'I\'d like a cup of juice'], correctAnswer: 'I\'d like a cup of coffee'),
  ListeningQuestion(audioText: 'What time is it now?', options: ['What time is it now?', 'What time is it?', 'What time is now?', 'What time now?'], correctAnswer: 'What time is it now?'),
  ListeningQuestion(audioText: 'Nice to meet you', options: ['Nice to meet you', 'Nice to see you', 'Nice to know you', 'Nice to tell you'], correctAnswer: 'Nice to meet you'),
  ListeningQuestion(audioText: 'How much is this?', options: ['How much is this?', 'How many is this?', 'How is this?', 'What is this?'], correctAnswer: 'How much is this?'),
];

/// 听力测试屏幕
class ListeningTestScreen extends ConsumerWidget {
  const ListeningTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testState = ref.watch(listeningTestStateProvider);
    final question = listeningQuestions[testState.currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text('听力测试 (${testState.currentQuestion + 1}/${AppConstants.listeningTestQuestions})'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.go('/onboarding'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          children: [
            LinearProgressIndicator(
              value: (testState.currentQuestion + 1) / AppConstants.listeningTestQuestions,
              backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
            ),
            const SizedBox(height: AppSpacing.xl),
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
              child: Column(
                children: [
                  Icon(
                    testState.isPlaying ? Icons.volume_up : Icons.headphones,
                    size: 64,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    testState.isPlaying ? '播放中...' : '点击播放',
                    style: AppTextStyles.subtitle1.copyWith(color: AppColors.secondary),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    '(可播放2次，已播放${testState.playCount}次)',
                    style: AppTextStyles.caption,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ElevatedButton.icon(
                    onPressed: testState.playCount < 2
                        ? () {
                            ref.read(listeningTestStateProvider.notifier).setPlaying(true);
                            ref.read(listeningTestStateProvider.notifier).incrementPlayCount();
                            Future.delayed(const Duration(seconds: 2), () {
                              ref.read(listeningTestStateProvider.notifier).setPlaying(false);
                            });
                          }
                        : null,
                    icon: const Icon(Icons.play_arrow),
                    label: const Text('播放音频'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text('你听到了什么？', style: AppTextStyles.body1),
            const SizedBox(height: AppSpacing.lg),
            Expanded(
              child: ListView.separated(
                itemCount: question.options.length,
                separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                itemBuilder: (context, index) {
                  final option = question.options[index];
                  final isSelected = testState.answers[testState.currentQuestion] == option;
                  
                  return InkWell(
                    onTap: () {
                      ref.read(listeningTestStateProvider.notifier).answer(option);
                    },
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.secondary.withValues(alpha: 0.1) : AppColors.card,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: isSelected ? AppColors.secondary : AppColors.textHint.withValues(alpha: 0.3),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        option,
                        style: AppTextStyles.body1.copyWith(
                          color: isSelected ? AppColors.secondary : AppColors.textPrimary,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            ElevatedButton(
              onPressed: testState.answers[testState.currentQuestion] != null
                  ? () {
                      ref.read(listeningTestStateProvider.notifier).nextQuestion();
                      if (testState.currentQuestion == AppConstants.listeningTestQuestions - 1) {
                        ref.read(listeningTestStateProvider.notifier).calculateScore();
                        context.go('/test/speaking');
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: AppColors.secondary,
              ),
              child: const Text('下一题'),
            ),
          ],
        ),
      ),
    );
  }
}
