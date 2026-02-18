import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/scene_model.dart';
import '../../providers/scene_provider.dart';

class SceneListScreen extends ConsumerWidget {
  const SceneListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scenes = ref.watch(scenesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('场景学院'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _HeaderSection(),
          const SizedBox(height: AppSpacing.lg),
          Text('热门场景', style: AppTextStyles.subtitle1),
          const SizedBox(height: AppSpacing.md),
          ...scenes.map((scene) => _SceneCard(
            scene: scene,
            onTap: () {
              ref.read(currentSceneProvider.notifier).set(scene);
              Navigator.pushNamed(context, '/scene/detail');
            },
          )),
        ],
      ),
    );
  }
}

class _HeaderSection extends StatelessWidget {
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
          const Icon(Icons.theater_comedy, size: 48, color: Colors.white),
          const SizedBox(height: AppSpacing.md),
          Text(
            '场景学院',
            style: AppTextStyles.headline3.copyWith(color: Colors.white),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            '三合一训练：记词+听力+口语',
            style: AppTextStyles.body2.copyWith(color: Colors.white.withValues(alpha: 0.9)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _SceneCard extends StatelessWidget {
  final Scene scene;
  final VoidCallback onTap;

  const _SceneCard({required this.scene, required this.onTap});

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
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Center(
                child: Text(scene.icon, style: const TextStyle(fontSize: 30)),
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(scene.name, style: AppTextStyles.subtitle1),
                  Text(scene.description, style: AppTextStyles.caption),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      _InfoChip(icon: Icons.book, label: '${scene.wordCount}词'),
                      const SizedBox(width: AppSpacing.sm),
                      _InfoChip(icon: Icons.chat, label: '${scene.dialogueCount}对话'),
                    ],
                  ),
                  if (scene.progress > 0) ...[
                    const SizedBox(height: AppSpacing.sm),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(AppRadius.sm),
                      child: LinearProgressIndicator(
                        value: scene.progress,
                        backgroundColor: AppColors.primary.withValues(alpha: 0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                        minHeight: 4,
                      ),
                    ),
                  ],
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

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 12, color: AppColors.textHint),
        const SizedBox(width: 2),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}
