import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/scene_model.dart';
import '../../providers/scene_provider.dart';

class SceneDetailScreen extends ConsumerWidget {
  const SceneDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scene = ref.watch(currentSceneProvider);

    if (scene == null) {
      return const Scaffold(
        body: Center(child: Text('请先选择场景')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(scene.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SceneHeader(scene: scene),
            const SizedBox(height: AppSpacing.lg),
            _TrainingSteps(sceneId: scene.id),
          ],
        ),
      ),
    );
  }
}

class _SceneHeader extends StatelessWidget {
  final Scene scene;

  const _SceneHeader({required this.scene});

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
        children: [
          Text(scene.icon, style: const TextStyle(fontSize: 60)),
          const SizedBox(height: AppSpacing.md),
          Text(
            scene.name,
            style: AppTextStyles.headline2.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            scene.description,
            style: AppTextStyles.body2.copyWith(color: Colors.white.withValues(alpha: 0.9)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.sm,
            children: scene.tags.map((tag) => Chip(
              label: Text(tag),
              backgroundColor: Colors.white.withValues(alpha: 0.2),
              labelStyle: const TextStyle(color: Colors.white),
            )).toList(),
          ),
        ],
      ),
    );
  }
}

class _TrainingSteps extends StatelessWidget {
  final String sceneId;

  const _TrainingSteps({required this.sceneId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('三合一训练', style: AppTextStyles.subtitle1),
        const SizedBox(height: AppSpacing.md),
        _StepCard(
          step: '1',
          title: '学场景词',
          description: '学习该场景的核心词汇',
          icon: Icons.book,
          color: AppColors.primary,
          onTap: () {},
        ),
        _StepCard(
          step: '2',
          title: '听场景对话',
          description: '练习场景听力理解',
          icon: Icons.headphones,
          color: AppColors.secondary,
          onTap: () {},
        ),
        _StepCard(
          step: '3',
          title: '练场景口语',
          description: '进行场景对话练习',
          icon: Icons.mic,
          color: AppColors.accent,
          onTap: () {},
        ),
      ],
    );
  }
}

class _StepCard extends StatelessWidget {
  final String step;
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _StepCard({
    required this.step,
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
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
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  step,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.subtitle1),
                  Text(description, style: AppTextStyles.caption),
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
