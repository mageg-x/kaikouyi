import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/app_constants.dart';

/// 口语测试状态数据类
class SpeakingTestState {
  final int currentQuestion;
  final int score;
  final bool isRecording;
  final bool hasRecording;

  SpeakingTestState({
    this.currentQuestion = 0,
    this.score = 0,
    this.isRecording = false,
    this.hasRecording = false,
  });

  SpeakingTestState copyWith({
    int? currentQuestion,
    int? score,
    bool? isRecording,
    bool? hasRecording,
  }) {
    return SpeakingTestState(
      currentQuestion: currentQuestion ?? this.currentQuestion,
      score: score ?? this.score,
      isRecording: isRecording ?? this.isRecording,
      hasRecording: hasRecording ?? this.hasRecording,
    );
  }
}

/// 口语测试Notifier
class SpeakingTestNotifier extends Notifier<SpeakingTestState> {
  @override
  SpeakingTestState build() {
    return SpeakingTestState();
  }

  void setRecording(bool recording) {
    state = state.copyWith(isRecording: recording);
  }

  void setHasRecording(bool hasRecording) {
    state = state.copyWith(hasRecording: hasRecording);
  }

  void nextQuestion() {
    if (state.currentQuestion < AppConstants.speakingTestQuestions - 1) {
      state = state.copyWith(
        currentQuestion: state.currentQuestion + 1,
        hasRecording: false,
      );
    } else {
      _calculateFinalScore();
    }
  }

  void _calculateFinalScore() {
    final baseScore = 60 + (state.score * 10);
    state = state.copyWith(score: baseScore.clamp(0, 100));
  }

  void addScore(int score) {
    state = state.copyWith(score: state.score + score);
  }
}

/// 口语测试状态Provider
final speakingTestStateProvider = NotifierProvider<SpeakingTestNotifier, SpeakingTestState>(() {
  return SpeakingTestNotifier();
});

/// 口语测试题目列表
final speakingTestQuestions = [
  'How are you doing today?',
  'What is your name?',
  'Where are you from?',
  'What do you do for a living?',
  'Tell me about your hobbies.',
];

/// 口语测试屏幕
class SpeakingTestScreen extends ConsumerWidget {
  const SpeakingTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testState = ref.watch(speakingTestStateProvider);
    final question = speakingTestQuestions[testState.currentQuestion];

    return Scaffold(
      appBar: AppBar(
        title: Text('口语测试 (${testState.currentQuestion + 1}/${AppConstants.speakingTestQuestions})'),
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
              value: (testState.currentQuestion + 1) / AppConstants.speakingTestQuestions,
              backgroundColor: AppColors.accent.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent),
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    '请跟读下面这句话：',
                    style: AppTextStyles.subtitle1,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    '"$question"',
                    style: AppTextStyles.headline3,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _ActionButton(
                        icon: Icons.volume_up,
                        label: '听原声',
                        color: AppColors.primary,
                        onTap: () {},
                      ),
                      const SizedBox(width: AppSpacing.lg),
                      _ActionButton(
                        icon: testState.isRecording ? Icons.stop : Icons.mic,
                        label: testState.isRecording ? '松开结束' : '按住录音',
                        color: AppColors.error,
                        isRecording: testState.isRecording,
                        onTap: () {
                          if (testState.isRecording) {
                            ref.read(speakingTestStateProvider.notifier).setRecording(false);
                            ref.read(speakingTestStateProvider.notifier).setHasRecording(true);
                            ref.read(speakingTestStateProvider.notifier).addScore(20);
                          } else {
                            ref.read(speakingTestStateProvider.notifier).setRecording(true);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: AppColors.info, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      '测试仅用于评估，不计较对错',
                      style: AppTextStyles.caption.copyWith(color: AppColors.info),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: testState.hasRecording
                  ? () {
                      ref.read(speakingTestStateProvider.notifier).nextQuestion();
                      if (testState.currentQuestion == AppConstants.speakingTestQuestions - 1) {
                        context.go('/test/result');
                      }
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                backgroundColor: AppColors.accent,
              ),
              child: const Text('下一题'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final bool isRecording;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    this.isRecording = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: color),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
