import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/word_model.dart';
import '../../providers/word_provider.dart';

class WordReviewScreen extends ConsumerStatefulWidget {
  const WordReviewScreen({super.key});

  @override
  ConsumerState<WordReviewScreen> createState() => _WordReviewScreenState();
}

class _WordReviewScreenState extends ConsumerState<WordReviewScreen> {
  int _currentIndex = 0;
  bool _showAnswer = false;

  @override
  Widget build(BuildContext context) {
    final wordsAsync = ref.watch(wordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('单词复习'),
      ),
      body: wordsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('加载失败: $e')),
        data: (words) {
          final reviewWords = words.where((w) => w.status != WordStatus.newWord).toList();
          
          if (reviewWords.isEmpty) {
            return const _EmptyState();
          }
          
          if (_currentIndex >= reviewWords.length) {
            return _CompletedState(count: reviewWords.length);
          }
          
          final word = reviewWords[_currentIndex];
          
          return Column(
            children: [
              LinearProgressIndicator(
                value: (_currentIndex + 1) / reviewWords.length,
                backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _showAnswer = !_showAnswer),
                  child: Container(
                    margin: const EdgeInsets.all(AppSpacing.lg),
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_currentIndex + 1}/${reviewWords.length}',
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          word.word,
                          style: AppTextStyles.headline1.copyWith(fontSize: 36),
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(word.phonetic, style: AppTextStyles.phonetic),
                        const SizedBox(height: AppSpacing.xl),
                        AnimatedCrossFade(
                          firstChild: const SizedBox(height: 50),
                          secondChild: Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(AppRadius.lg),
                            ),
                            child: Text(
                              word.meaning,
                              style: AppTextStyles.headline3.copyWith(color: AppColors.secondary),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          crossFadeState: _showAnswer ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                          duration: const Duration(milliseconds: 300),
                        ),
                        const SizedBox(height: AppSpacing.xl),
                        Text(
                          _showAnswer ? '' : '点击显示答案',
                          style: AppTextStyles.caption,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (_showAnswer)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: _FeedbackButton(
                          label: '又忘了',
                          color: AppColors.error,
                          onTap: () => _handleFeedback(WordStatus.forgotten),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _FeedbackButton(
                          label: '模糊',
                          color: AppColors.warning,
                          onTap: () => _handleFeedback(WordStatus.fuzzy),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: _FeedbackButton(
                          label: '记得',
                          color: AppColors.success,
                          onTap: () => _handleFeedback(WordStatus.known),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _handleFeedback(WordStatus status) async {
    final wordsAsync = ref.read(wordsProvider);
    wordsAsync.whenData((words) async {
      final reviewWords = words.where((w) => w.status != WordStatus.newWord).toList();
      if (_currentIndex < reviewWords.length) {
        final word = reviewWords[_currentIndex];
        
        final db = await ref.read(databaseServiceProvider.future);
        await db.update(
          'words',
          {'status': status.index},
          where: 'id = ?',
          whereArgs: [word.id],
        );
        
        ref.invalidate(wordsProvider);
        
        if (_currentIndex < reviewWords.length - 1) {
          setState(() {
            _currentIndex++;
            _showAnswer = false;
          });
        } else {
          setState(() {
            _currentIndex++;
          });
        }
      }
    });
  }
}

class _FeedbackButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _FeedbackButton({
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: color),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: AppTextStyles.button.copyWith(color: color),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.library_books, size: 80, color: AppColors.textHint),
          const SizedBox(height: AppSpacing.lg),
          Text('暂无需要复习的单词', style: AppTextStyles.headline3),
          const SizedBox(height: AppSpacing.sm),
          Text('先去学习一些新单词吧', style: AppTextStyles.body2),
        ],
      ),
    );
  }
}

class _CompletedState extends StatelessWidget {
  final int count;

  const _CompletedState({required this.count});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 80, color: AppColors.success),
          const SizedBox(height: AppSpacing.lg),
          Text('复习完成！', style: AppTextStyles.headline2),
          const SizedBox(height: AppSpacing.sm),
          Text('共复习 $count 个单词', style: AppTextStyles.body1),
        ],
      ),
    );
  }
}
