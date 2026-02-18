import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final achievements = [
      _Achievement(
        icon: Icons.emoji_events,
        title: '初次见面',
        description: '完成首次学习',
        isUnlocked: true,
        color: Colors.amber,
      ),
      _Achievement(
        icon: Icons.local_fire_department,
        title: '坚持不懈',
        description: '连续学习7天',
        isUnlocked: true,
        color: Colors.orange,
      ),
      _Achievement(
        icon: Icons.book,
        title: '词汇达人',
        description: '学习100个单词',
        isUnlocked: true,
        color: AppColors.primary,
      ),
      _Achievement(
        icon: Icons.headphones,
        title: '听力达人',
        description: '完成50次听力训练',
        isUnlocked: false,
        color: AppColors.secondary,
      ),
      _Achievement(
        icon: Icons.mic,
        title: '口语达人',
        description: '完成30次口语练习',
        isUnlocked: false,
        color: AppColors.accent,
      ),
      _Achievement(
        icon: Icons.star,
        title: '学富五车',
        description: '学习500个单词',
        isUnlocked: false,
        color: Colors.purple,
      ),
      _Achievement(
        icon: Icons.calendar_month,
        title: '月度学习',
        description: '累计学习30天',
        isUnlocked: false,
        color: Colors.teal,
      ),
      _Achievement(
        icon: Icons.school,
        title: '英语大师',
        description: '达到C1等级',
        isUnlocked: false,
        color: Colors.red,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('成就墙'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(AppSpacing.md),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppSpacing.md,
          mainAxisSpacing: AppSpacing.md,
          childAspectRatio: 0.9,
        ),
        itemCount: achievements.length,
        itemBuilder: (context, index) {
          return _AchievementCard(achievement: achievements[index]);
        },
      ),
    );
  }
}

class _Achievement {
  final IconData icon;
  final String title;
  final String description;
  final bool isUnlocked;
  final Color color;

  _Achievement({
    required this.icon,
    required this.title,
    required this.description,
    required this.isUnlocked,
    required this.color,
  });
}

class _AchievementCard extends StatelessWidget {
  final _Achievement achievement;

  const _AchievementCard({required this.achievement});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: achievement.isUnlocked 
            ? achievement.color.withValues(alpha: 0.1)
            : AppColors.card,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: achievement.isUnlocked
            ? Border.all(color: achievement.color.withValues(alpha: 0.3))
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: achievement.isUnlocked 
                  ? achievement.color
                  : AppColors.textHint.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Icon(
              achievement.icon,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            achievement.title,
            style: AppTextStyles.subtitle1.copyWith(
              color: achievement.isUnlocked 
                  ? AppColors.textPrimary 
                  : AppColors.textHint,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            achievement.description,
            style: AppTextStyles.caption.copyWith(
              color: achievement.isUnlocked 
                  ? AppColors.textSecondary 
                  : AppColors.textHint,
            ),
            textAlign: TextAlign.center,
          ),
          if (achievement.isUnlocked) ...[
            const SizedBox(height: AppSpacing.sm),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
              decoration: BoxDecoration(
                color: achievement.color.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(AppRadius.sm),
              ),
              child: Text(
                '已获得',
                style: AppTextStyles.caption.copyWith(color: achievement.color),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
