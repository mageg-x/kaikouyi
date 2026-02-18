import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/user_model.dart';
import '../../providers/user_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('我的'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.go('/profile/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            _ProfileHeader(
              name: userState.nickname.isEmpty ? '用户' : userState.nickname,
              level: userState.level.overallLevel,
            ),
            const SizedBox(height: AppSpacing.lg),
            _StatsSection(stats: userState.stats),
            const SizedBox(height: AppSpacing.lg),
            _LevelSection(level: userState.level),
            const SizedBox(height: AppSpacing.lg),
            _MenuSection(),
          ],
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  final String name;
  final String level;

  const _ProfileHeader({required this.name, required this.level});

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
      child: Row(
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(35),
            ),
            child: Center(
              child: Text(
                name.isNotEmpty ? name[0] : 'U',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.headline3.copyWith(color: Colors.white),
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                  child: Text(
                    '等级 $level',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class _StatsSection extends StatelessWidget {
  final StudyStats stats;

  const _StatsSection({required this.stats});

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
      child: Row(
        children: [
          Expanded(
            child: _StatItem(
              icon: Icons.local_fire_department,
              value: '${stats.currentStreak}',
              label: '连续天数',
              color: AppColors.warning,
            ),
          ),
          Expanded(
            child: _StatItem(
              icon: Icons.calendar_today,
              value: '${stats.totalStudyDays}',
              label: '学习天数',
              color: AppColors.primary,
            ),
          ),
          Expanded(
            child: _StatItem(
              icon: Icons.book,
              value: '${stats.totalWordsLearned}',
              label: '已学单词',
              color: AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: AppSpacing.xs),
        Text(value, style: AppTextStyles.headline3),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

class _LevelSection extends StatelessWidget {
  final UserLevelInfo level;

  const _LevelSection({required this.level});

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
          Text('能力雷达', style: AppTextStyles.subtitle1),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: _LevelIndicator(
                  level: level.vocabularyLevel,
                  label: '词汇',
                  score: level.vocabularyScore,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _LevelIndicator(
                  level: level.listeningLevel,
                  label: '听力',
                  score: level.listeningScore,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: _LevelIndicator(
                  level: level.speakingLevel,
                  label: '口语',
                  score: level.speakingScore,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LevelIndicator extends StatelessWidget {
  final String level;
  final String label;
  final int score;
  final Color color;

  const _LevelIndicator({
    required this.level,
    required this.label,
    required this.score,
    required this.color,
  });

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
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              level,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(label, style: AppTextStyles.caption),
          Text('$score%', style: AppTextStyles.subtitle2.copyWith(color: color)),
        ],
      ),
    );
  }
}

class _MenuSection extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
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
        children: [
          _MenuItem(
            icon: Icons.emoji_events,
            title: '成就墙',
            onTap: () => context.go('/profile/achievements'),
          ),
          const Divider(height: 1, indent: 56),
          _MenuItem(
            icon: Icons.bookmark,
            title: '我的收藏',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),
          _MenuItem(
            icon: Icons.error_outline,
            title: '错题本',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),
          _MenuItem(
            icon: Icons.analytics,
            title: '学习报告',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),
          _MenuItem(
            icon: Icons.info_outline,
            title: '关于我们',
            onTap: () {},
          ),
          const Divider(height: 1, indent: 56),
          _MenuItem(
            icon: Icons.logout,
            title: '退出登录',
            textColor: AppColors.error,
            onTap: () => _showLogoutDialog(context, ref),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('退出登录'),
        content: const Text('确定要退出登录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(userProvider.notifier).logout();
              if (context.mounted) {
                context.go('/login');
              }
            },
            child: Text('退出', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color? textColor;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Row(
          children: [
            Icon(icon, color: textColor ?? AppColors.primary),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Text(
                title,
                style: textColor != null
                    ? AppTextStyles.body1.copyWith(color: textColor)
                    : AppTextStyles.body1,
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textHint),
          ],
        ),
      ),
    );
  }
}
