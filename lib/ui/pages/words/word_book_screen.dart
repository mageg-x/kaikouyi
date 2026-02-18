import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/word_provider.dart';

class WordBookScreen extends ConsumerWidget {
  const WordBookScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wordBooksAsync = ref.watch(wordBooksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的词书'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {},
          ),
        ],
      ),
      body: wordBooksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('加载失败: $e')),
        data: (books) => ListView(
          padding: const EdgeInsets.all(AppSpacing.md),
          children: [
            Text('主词书', style: AppTextStyles.subtitle1),
            const SizedBox(height: AppSpacing.sm),
            if (books.isNotEmpty)
              _WordBookCard(
                name: books.first.name,
                description: books.first.description,
                progress: books.first.progress,
                learnedWords: books.first.learnedWords,
                totalWords: books.first.totalWords,
                todayNew: 5,
                toReview: 24,
                isMain: true,
                onContinue: () => context.go('/words/learning'),
                onManage: () {},
              ),
            const SizedBox(height: AppSpacing.lg),
            Text('个人词库', style: AppTextStyles.subtitle1),
            const SizedBox(height: AppSpacing.sm),
            _PersonalWordCard(
              name: '从阅读收藏',
              count: 127,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class _WordBookCard extends StatelessWidget {
  final String name;
  final String description;
  final double progress;
  final int learnedWords;
  final int totalWords;
  final int todayNew;
  final int toReview;
  final bool isMain;
  final VoidCallback onContinue;
  final VoidCallback onManage;

  const _WordBookCard({
    required this.name,
    required this.description,
    required this.progress,
    required this.learnedWords,
    required this.totalWords,
    required this.todayNew,
    required this.toReview,
    required this.isMain,
    required this.onContinue,
    required this.onManage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (isMain)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Text('主词书', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: onManage,
              ),
            ],
          ),
          Text(name, style: AppTextStyles.headline3),
          Text(description, style: AppTextStyles.caption),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Text('进度 $learnedWords/$totalWords', style: AppTextStyles.body2),
              const Spacer(),
              Text('${(progress * 100).toInt()}%', style: AppTextStyles.subtitle2),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.primary.withValues(alpha: 0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _StatItem(label: '今日新词', value: '$todayNew/15', color: AppColors.primary),
              ),
              Expanded(
                child: _StatItem(label: '待复习', value: '$toReview', color: AppColors.warning),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onContinue,
                  child: const Text('继续学习'),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              OutlinedButton(
                onPressed: () => context.go('/words/review'),
                child: const Text('复习'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        children: [
          Text(label, style: AppTextStyles.caption),
          Text(value, style: AppTextStyles.subtitle1.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _PersonalWordCard extends StatelessWidget {
  final String name;
  final int count;
  final VoidCallback onTap;

  const _PersonalWordCard({
    required this.name,
    required this.count,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: AppColors.textHint.withValues(alpha: 0.3)),
        ),
        child: Row(
          children: [
            const Icon(Icons.bookmark, color: AppColors.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppTextStyles.subtitle1),
                  Text('共$count词', style: AppTextStyles.caption),
                ],
              ),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
