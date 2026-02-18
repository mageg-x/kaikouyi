import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

/// 词汇测试状态数据类
class VocabTestState {
  final int currentQuestion;
  final int correctAnswers;
  final List<String?> answers;
  final bool isCompleted;

  VocabTestState({
    this.currentQuestion = 0,
    this.correctAnswers = 0,
    this.answers = const [],
    this.isCompleted = false,
  });

  VocabTestState copyWith({
    int? currentQuestion,
    int? correctAnswers,
    List<String?>? answers,
    bool? isCompleted,
  }) {
    return VocabTestState(
      currentQuestion: currentQuestion ?? this.currentQuestion,
      correctAnswers: correctAnswers ?? this.correctAnswers,
      answers: answers ?? this.answers,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

/// 词汇测试Notifier
class VocabTestNotifier extends Notifier<VocabTestState> {
  @override
  VocabTestState build() {
    return VocabTestState(
      answers: List.filled(AppConstants.vocabularyTestQuestions, null),
    );
  }

  void answer(String answer) {
    final newAnswers = List<String?>.from(state.answers);
    newAnswers[state.currentQuestion] = answer;
    state = state.copyWith(answers: newAnswers);
  }

  void nextQuestion() {
    if (state.currentQuestion < AppConstants.vocabularyTestQuestions - 1) {
      state = state.copyWith(currentQuestion: state.currentQuestion + 1);
    } else {
      state = state.copyWith(isCompleted: true);
    }
  }

  void calculateScore() {
    int correct = 0;
    for (int i = 0; i < testQuestions.length; i++) {
      if (state.answers[i] == testQuestions[i].correctAnswer) {
        correct++;
      }
    }
    state = state.copyWith(correctAnswers: correct);
  }
}

/// 词汇测试状态Provider
final vocabularyTestStateProvider = NotifierProvider<VocabTestNotifier, VocabTestState>(() {
  return VocabTestNotifier();
});

/// 词汇测试题目数据类
class VocabQuestion {
  final String word;
  final List<String> options;
  final String correctAnswer;

  VocabQuestion({
    required this.word,
    required this.options,
    required this.correctAnswer,
  });
}

/// 测试题目列表
final testQuestions = [
  VocabQuestion(word: 'significant', options: ['小的', '重要的', '漂亮的', '奇怪的'], correctAnswer: '重要的'),
  VocabQuestion(word: 'abandon', options: ['开始', '放弃', '接受', '关于'], correctAnswer: '放弃'),
  VocabQuestion(word: 'ability', options: ['能力', '机会', '责任', '速度'], correctAnswer: '能力'),
  VocabQuestion(word: 'absolute', options: ['相对的', '绝对的', '可能的', '必要的'], correctAnswer: '绝对的'),
  VocabQuestion(word: 'abstract', options: ['具体的', '抽象的', '实际的', '虚假的'], correctAnswer: '抽象的'),
  VocabQuestion(word: 'academic', options: ['学术的', '运动的', '音乐的', '艺术的'], correctAnswer: '学术的'),
  VocabQuestion(word: 'accompany', options: ['反对', '竞争', '陪伴', '庆祝'], correctAnswer: '陪伴'),
  VocabQuestion(word: 'accumulate', options: ['分配', '积累', '计算', '交流'], correctAnswer: '积累'),
  VocabQuestion(word: 'accurate', options: ['准确的', '模糊的', '粗心的', '随意的'], correctAnswer: '准确的'),
  VocabQuestion(word: 'achieve', options: ['失败', '达到', '尝试', '避免'], correctAnswer: '达到'),
  VocabQuestion(word: 'acknowledge', options: ['否认', '承认', '忽略', '忘记'], correctAnswer: '承认'),
  VocabQuestion(word: 'acquire', options: ['失去', '获得', '寻找', '研究'], correctAnswer: '获得'),
  VocabQuestion(word: 'adapt', options: ['适应', '采用', '采纳', '调整'], correctAnswer: '适应'),
  VocabQuestion(word: 'adequate', options: ['不足的', '足够的', '过度的', '平均的'], correctAnswer: '足够的'),
  VocabQuestion(word: 'advocate', options: ['反对', '主张', '接受', '拒绝'], correctAnswer: '主张'),
];

/// 词汇测试屏幕
class VocabularyTestScreen extends ConsumerWidget {
  const VocabularyTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testState = ref.watch(vocabularyTestStateProvider);
    final question = testQuestions[testState.currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text('词汇测试 (${testState.currentQuestion + 1}/${AppConstants.vocabularyTestQuestions})'),
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
              value: (testState.currentQuestion + 1) / AppConstants.vocabularyTestQuestions,
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              question.word,
              style: AppTextStyles.headline1,
            ),
            const SizedBox(height: AppSpacing.xl),
            Text(
              '以下哪个最接近以上单词的意思？',
              style: AppTextStyles.body1,
            ),
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
                      ref.read(vocabularyTestStateProvider.notifier).answer(option);
                    },
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      decoration: BoxDecoration(
                        color: isSelected ? AppColors.primary.withValues(alpha: 0.1) : AppColors.card,
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: isSelected ? AppColors.primary : AppColors.textHint.withValues(alpha: 0.3),
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Text(
                        option,
                        style: AppTextStyles.body1.copyWith(
                          color: isSelected ? AppColors.primary : AppColors.textPrimary,
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
                      ref.read(vocabularyTestStateProvider.notifier).nextQuestion();
                      if (testState.currentQuestion == AppConstants.vocabularyTestQuestions - 1) {
                        ref.read(vocabularyTestStateProvider.notifier).calculateScore();
                        context.go('/test/listening');
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text('下一题'),
            ),
          ],
        ),
      ),
    );
  }
}
