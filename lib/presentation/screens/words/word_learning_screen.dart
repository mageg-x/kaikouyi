import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/word_model.dart';
import '../../providers/word_provider.dart';

class WordLearningScreen extends ConsumerStatefulWidget {
  const WordLearningScreen({super.key});

  @override
  ConsumerState<WordLearningScreen> createState() => _WordLearningScreenState();
}

class _WordLearningScreenState extends ConsumerState<WordLearningScreen> {
  int _currentIndex = 0;
  bool _showDetails = false;

  @override
  Widget build(BuildContext context) {
    final wordsAsync = ref.watch(wordsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('单词学习'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
        ],
      ),
      body: wordsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('加载失败: $e')),
        data: (words) {
          final newWords = words.where((w) => w.status == WordStatus.newWord).toList();
          if (newWords.isEmpty) {
            return _EmptyState();
          }
          
          if (_currentIndex >= newWords.length) {
            return _CompletedState();
          }
          
          final word = newWords[_currentIndex];
          
          return Column(
            children: [
              LinearProgressIndicator(
                value: (_currentIndex + 1) / newWords.length,
                backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(AppRadius.xl),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 20,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${_currentIndex + 1}/${newWords.length}',
                              style: AppTextStyles.caption,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              word.word,
                              style: AppTextStyles.headline1.copyWith(fontSize: 36),
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(word.phonetic, style: AppTextStyles.phonetic),
                                const SizedBox(width: AppSpacing.sm),
                                const Icon(Icons.volume_up, color: AppColors.primary, size: 20),
                              ],
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Text(
                              word.meaning,
                              style: AppTextStyles.headline3.copyWith(color: AppColors.primary),
                            ),
                            if (_showDetails) ...[
                              const SizedBox(height: AppSpacing.lg),
                              if (word.memoryTip != null)
                                _DetailSection(
                                  title: '记忆技巧',
                                  content: word.memoryTip!,
                                ),
                              if (word.examples.isNotEmpty)
                                _DetailSection(
                                  title: '双语例句',
                                  content: word.examples.join('\n'),
                                ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      TextButton(
                        onPressed: () => setState(() => _showDetails = !_showDetails),
                        child: Text(_showDetails ? '收起详情' : '展开详情'),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: _FeedbackButton(
                        label: '忘记',
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
                        label: '认识',
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
      final newWords = words.where((w) => w.status == WordStatus.newWord).toList();
      if (_currentIndex < newWords.length) {
        final word = newWords[_currentIndex];
        
        final db = await ref.read(databaseServiceProvider.future);
        await db.update(
          'words',
          {'status': status.index},
          where: 'id = ?',
          whereArgs: [word.id],
        );
        
        ref.invalidate(wordsProvider);
        
        if (_currentIndex < newWords.length - 1) {
          setState(() {
            _currentIndex++;
            _showDetails = false;
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

class _DetailSection extends StatelessWidget {
  final String title;
  final String content;

  const _DetailSection({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.subtitle2),
          const SizedBox(height: AppSpacing.xs),
          Text(content, style: AppTextStyles.body2),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.check_circle, size: 80, color: AppColors.success),
          const SizedBox(height: AppSpacing.lg),
          Text('今日新词已学完！', style: AppTextStyles.headline3),
          const SizedBox(height: AppSpacing.sm),
          Text('快去复习吧', style: AppTextStyles.body2),
        ],
      ),
    );
  }
}

class _CompletedState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.celebration, size: 80, color: AppColors.primary),
          const SizedBox(height: AppSpacing.lg),
          Text('太棒了！', style: AppTextStyles.headline2),
          const SizedBox(height: AppSpacing.sm),
          Text('今日单词学习完成', style: AppTextStyles.body1),
        ],
      ),
    );
  }
}
