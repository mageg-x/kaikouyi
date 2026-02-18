import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/user_provider.dart';
import '../../providers/word_provider.dart';
import '../../components/common_widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final todayProgress = ref.watch(todayProgressProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _Header(
                  name: userState.nickname.isEmpty ? '小王' : userState.nickname),
              const SizedBox(height: AppSpacing.lg),
              _TodayProgressCard(
                progress: ((todayProgress['newWords']! +
                            todayProgress['reviewWords']!) /
                        17)
                    .clamp(0.0, 1.0),
              ),
              const SizedBox(height: AppSpacing.lg),
              _QuickEntrySection(),
              const SizedBox(height: AppSpacing.lg),
              _RecommendationCard(
                title: '基于你的听力薄弱点',
                subtitle: '连读弱读专项训练 (第3天)',
                example: '"want to" → "wanna"',
                onTap: () => context.go('/listening'),
              ),
              const SizedBox(height: AppSpacing.md),
              _TodayWordsCard(
                learned: todayProgress['newWords']!,
                reviewed: todayProgress['reviewWords']!,
                onTap: () => context.go('/words/learning'),
              ),
              const SizedBox(height: AppSpacing.md),
              _TodayListeningCard(
                onTap: () => context.go('/listening'),
              ),
              const SizedBox(height: AppSpacing.md),
              _TodaySpeakingCard(
                onTap: () => context.go('/speaking'),
              ),
              const SizedBox(height: AppSpacing.lg),
              _HotScenesSection(onTap: () => context.go('/scene')),
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String name;

  const _Header({required this.name});

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = '早上好';
    } else if (hour < 14) {
      greeting = '中午好';
    } else if (hour < 18) {
      greeting = '下午好';
    } else {
      greeting = '晚上好';
    }

    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: const Icon(Icons.notifications_none, color: AppColors.primary),
        ),
        const Spacer(),
        Text(
          '开口易',
          style: AppTextStyles.headline3.copyWith(color: AppColors.primary),
        ),
        const Spacer(),
        Row(
          children: [
            Text('$greeting, ', style: AppTextStyles.body2),
            Text(name, style: AppTextStyles.subtitle1),
          ],
        ),
      ],
    );
  }
}

class _TodayProgressCard extends StatelessWidget {
  final double progress;

  const _TodayProgressCard({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '今日三维进度',
                style: AppTextStyles.subtitle1.copyWith(color: Colors.white),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: AppTextStyles.headline3.copyWith(color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.sm),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withValues(alpha: 0.3),
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
              minHeight: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickEntrySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('快捷入口', style: AppTextStyles.subtitle1),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: QuickEntryCard(
                icon: Icons.book,
                title: '今日单词',
                subtitle: '5新+12复',
                color: AppColors.primary,
                onTap: () => context.go('/words/learning'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: QuickEntryCard(
                icon: Icons.headphones,
                title: '今日听力',
                subtitle: '连读专项',
                color: AppColors.secondary,
                onTap: () => context.go('/listening'),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: QuickEntryCard(
                icon: Icons.mic,
                title: '今日口语',
                subtitle: '影子跟读',
                color: AppColors.accent,
                onTap: () => context.go('/speaking'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RecommendationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String example;
  final VoidCallback onTap;

  const _RecommendationCard({
    required this.title,
    required this.subtitle,
    required this.example,
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
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: const Icon(Icons.local_fire_department,
                      color: AppColors.warning, size: 16),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(title, style: AppTextStyles.caption),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(subtitle, style: AppTextStyles.subtitle1),
            Text(example, style: AppTextStyles.body2),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: onTap,
                  child: const Text('继续训练 →'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayWordsCard extends StatelessWidget {
  final int learned;
  final int reviewed;
  final VoidCallback onTap;

  const _TodayWordsCard({
    required this.learned,
    required this.reviewed,
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
                const Icon(Icons.book, color: AppColors.primary),
                const SizedBox(width: AppSpacing.sm),
                Text('记词 - 今日单词', style: AppTextStyles.subtitle1),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            ProgressCard(
              title: '新词学习',
              current: learned,
              total: 5,
              color: AppColors.primary,
            ),
            const SizedBox(height: AppSpacing.sm),
            ProgressCard(
              title: '复习',
              current: reviewed,
              total: 12,
              color: AppColors.secondary,
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: onTap,
                  child: const Text('继续学习 →'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TodayListeningCard extends StatelessWidget {
  final VoidCallback onTap;

  const _TodayListeningCard({required this.onTap});

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
                const Icon(Icons.headphones, color: AppColors.secondary),
                const SizedBox(width: AppSpacing.sm),
                Text('听力 - 今日训练', style: AppTextStyles.subtitle1),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text('三层剥离训练', style: AppTextStyles.body1),
            Text('今日句子：5句', style: AppTextStyles.caption),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                _LevelChip(label: 'L1', count: 3, done: true),
                const SizedBox(width: AppSpacing.sm),
                _LevelChip(label: 'L2', count: 2, done: false),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: onTap,
                  child: const Text('继续训练 →'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  final String label;
  final int count;
  final bool done;

  const _LevelChip(
      {required this.label, required this.count, required this.done});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: done
            ? AppColors.success.withValues(alpha: 0.1)
            : AppColors.textHint.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(
        '$label:$count句 ${done ? "✓" : ""}',
        style: AppTextStyles.caption
            .copyWith(color: done ? AppColors.success : AppColors.textHint),
      ),
    );
  }
}

class _TodaySpeakingCard extends StatelessWidget {
  final VoidCallback onTap;

  const _TodaySpeakingCard({required this.onTap});

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
                const Icon(Icons.mic, color: AppColors.accent),
                const SizedBox(width: AppSpacing.sm),
                Text('口语 - 今日练习', style: AppTextStyles.subtitle1),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text('影子跟读：老友记', style: AppTextStyles.body1),
            Text('"How you doin\'?"', style: AppTextStyles.body2),
            Text('昨日评分：77分', style: AppTextStyles.caption),
            const SizedBox(height: AppSpacing.sm),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: onTap,
                  child: const Text('开始跟读 →'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HotScenesSection extends StatelessWidget {
  final VoidCallback onTap;

  const _HotScenesSection({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final scenes = ['咖啡店', '机场', '面试', '酒店'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('热门场景', style: AppTextStyles.subtitle1),
            TextButton(
              onPressed: onTap,
              child: const Text('查看全部 →'),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          children: scenes.map((scene) {
            return ActionChip(
              label: Text(scene),
              onPressed: onTap,
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              labelStyle:
                  AppTextStyles.body2.copyWith(color: AppColors.primary),
            );
          }).toList(),
        ),
      ],
    );
  }
}
