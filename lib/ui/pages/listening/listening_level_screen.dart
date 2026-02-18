import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/listening_model.dart';
import '../../providers/listening_provider.dart';

class ListeningLevelScreen extends ConsumerWidget {
  const ListeningLevelScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final materials = ref.watch(listeningMaterialsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('听力训练'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          _LevelSelector(),
          const SizedBox(height: AppSpacing.lg),
          Text('选择训练材料', style: AppTextStyles.subtitle1),
          const SizedBox(height: AppSpacing.md),
          ...materials.map((material) => _MaterialCard(
            material: material,
            onTap: () {
              ref.read(currentListeningMaterialProvider.notifier).set(material);
              context.go('/listening/training');
            },
          )),
        ],
      ),
    );
  }
}

class _LevelSelector extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLevel = ref.watch(currentListeningLevelProvider);

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
          Text('选择难度', style: AppTextStyles.subtitle1),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              _LevelChip(
                label: 'L1',
                title: '字幕全开',
                subtitle: '安全感',
                color: AppColors.listeningL1,
                isSelected: currentLevel == ListeningLevel.l1,
                onTap: () => ref.read(currentListeningLevelProvider.notifier).set(ListeningLevel.l1),
              ),
              const SizedBox(width: AppSpacing.sm),
              _LevelChip(
                label: 'L2',
                title: '关键词',
                subtitle: '抓重点',
                color: AppColors.listeningL2,
                isSelected: currentLevel == ListeningLevel.l2,
                onTap: () => ref.read(currentListeningLevelProvider.notifier).set(ListeningLevel.l2),
              ),
              const SizedBox(width: AppSpacing.sm),
              _LevelChip(
                label: 'L3',
                title: '无字幕',
                subtitle: '纯听力',
                color: AppColors.listeningL3,
                isSelected: currentLevel == ListeningLevel.l3,
                onTap: () => ref.read(currentListeningLevelProvider.notifier).set(ListeningLevel.l3),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LevelChip extends StatelessWidget {
  final String label;
  final String title;
  final String subtitle;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _LevelChip({
    required this.label,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected ? color.withValues(alpha: 0.2) : AppColors.background,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: isSelected ? color : Colors.transparent,
              width: 2,
            ),
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
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(title, style: AppTextStyles.caption),
              Text(subtitle, style: AppTextStyles.caption),
            ],
          ),
        ),
      ),
    );
  }
}

class _MaterialCard extends StatelessWidget {
  final ListeningMaterial material;
  final VoidCallback onTap;

  const _MaterialCard({required this.material, required this.onTap});

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
                color: AppColors.secondary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: const Icon(Icons.headphones, color: AppColors.secondary, size: 30),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(material.title, style: AppTextStyles.subtitle1),
                  Text(material.subtitle, style: AppTextStyles.caption),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      _Tag(label: material.difficulty),
                      const SizedBox(width: AppSpacing.xs),
                      _Tag(label: '${material.duration}s'),
                    ],
                  ),
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

class _Tag extends StatelessWidget {
  final String label;

  const _Tag({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.textHint.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Text(label, style: AppTextStyles.caption),
    );
  }
}
