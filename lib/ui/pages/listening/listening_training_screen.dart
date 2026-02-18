import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/listening_model.dart';
import '../../providers/listening_provider.dart';

class ListeningTrainingScreen extends ConsumerStatefulWidget {
  const ListeningTrainingScreen({super.key});

  @override
  ConsumerState<ListeningTrainingScreen> createState() => _ListeningTrainingScreenState();
}

class _ListeningTrainingScreenState extends ConsumerState<ListeningTrainingScreen> {
  int _currentIndex = 0;
  bool _isPlaying = false;

  @override
  Widget build(BuildContext context) {
    final material = ref.watch(currentListeningMaterialProvider);
    final level = ref.watch(currentListeningLevelProvider);

    if (material == null) {
      return const Scaffold(
        body: Center(child: Text('请先选择训练材料')),
      );
    }

    final sentence = material.sentences[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: Text(material.title),
        actions: [
          PopupMenuButton<double>(
            icon: const Icon(Icons.speed),
            onSelected: (speed) {},
            itemBuilder: (context) => [
              PopupMenuItem(value: 0.75, child: Text('0.75x')),
              PopupMenuItem(value: 1.0, child: Text('1.0x')),
              PopupMenuItem(value: 1.25, child: Text('1.25x')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentIndex + 1) / material.sentences.length,
            backgroundColor: AppColors.secondary.withValues(alpha: 0.2),
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.secondary),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: Column(
                children: [
                  Container(
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
                          '${_currentIndex + 1}/${material.sentences.length}',
                          style: AppTextStyles.caption,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Container(
                          padding: const EdgeInsets.all(AppSpacing.lg),
                          decoration: BoxDecoration(
                            color: level == ListeningLevel.l1
                                ? AppColors.listeningL1.withValues(alpha: 0.1)
                                : level == ListeningLevel.l2
                                    ? AppColors.listeningL2.withValues(alpha: 0.1)
                                    : AppColors.listeningL3.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(AppRadius.lg),
                          ),
                          child: Column(
                            children: [
                              if (level == ListeningLevel.l1 || level == ListeningLevel.l2)
                                Text(
                                  sentence.text,
                                  style: AppTextStyles.headline3,
                                  textAlign: TextAlign.center,
                                )
                              else
                                Text(
                                  '???',
                                  style: AppTextStyles.headline1.copyWith(color: AppColors.textHint),
                                ),
                              if (level == ListeningLevel.l2) ...[
                                const SizedBox(height: AppSpacing.md),
                                Wrap(
                                  spacing: AppSpacing.sm,
                                  children: sentence.keywords.map((kw) => Chip(
                                    label: Text(kw),
                                    backgroundColor: AppColors.warning.withValues(alpha: 0.2),
                                  )).toList(),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        if (level != ListeningLevel.l3)
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.background,
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            child: Text(
                              sentence.translation,
                              style: AppTextStyles.body1,
                              textAlign: TextAlign.center,
                            ),
                          ),
                        const SizedBox(height: AppSpacing.lg),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.replay_10),
                              onPressed: () {},
                              iconSize: 32,
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                shape: BoxShape.circle,
                              ),
                              child: IconButton(
                                icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                                color: Colors.white,
                                iconSize: 40,
                                onPressed: () {
                                  setState(() => _isPlaying = !_isPlaying);
                                  if (_isPlaying) {
                                    Future.delayed(const Duration(seconds: 3), () {
                                      if (mounted) setState(() => _isPlaying = false);
                                    });
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            IconButton(
                              icon: const Icon(Icons.forward_10),
                              onPressed: () {},
                              iconSize: 32,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _currentIndex > 0
                              ? () => setState(() => _currentIndex--)
                              : null,
                          child: const Text('上一句'),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            if (_currentIndex < material.sentences.length - 1) {
                              setState(() => _currentIndex++);
                            } else {
                              _showCompletionDialog();
                            }
                          },
                          child: Text(
                            _currentIndex < material.sentences.length - 1 ? '下一句' : '完成',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('训练完成'),
        content: const Text('恭喜你完成了本次听力训练！'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('返回'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 0);
            },
            child: const Text('再来一次'),
          ),
        ],
      ),
    );
  }
}
