import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/theme/app_theme.dart';
import '../../providers/user_provider.dart';

class TestResultScreen extends ConsumerWidget {
  const TestResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ignore: unused_local_variable
    final userState = ref.watch(userProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            children: [
              const SizedBox(height: AppSpacing.xl),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primaryLight],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.emoji_events,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                '你的英语能力画像',
                style: AppTextStyles.headline2,
              ),
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.lg),
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
                  children: [
                    Text(
                      '综合评级：B1 (中级)',
                      style: AppTextStyles.headline3.copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    SizedBox(
                      height: 250,
                      child: RadarChart(
                        RadarChartData(
                          dataSets: [
                            RadarDataSet(
                              fillColor: AppColors.primary.withValues(alpha: 0.2),
                              borderColor: AppColors.primary,
                              borderWidth: 2,
                              entryRadius: 3,
                              dataEntries: const [
                                RadarEntry(value: 75),
                                RadarEntry(value: 50),
                                RadarEntry(value: 40),
                              ],
                            ),
                          ],
                          radarBackgroundColor: Colors.transparent,
                          borderData: FlBorderData(show: false),
                          radarBorderData: const BorderSide(color: Colors.transparent),
                          titlePositionPercentageOffset: 0.2,
                          titleTextStyle: AppTextStyles.caption,
                          getTitle: (index, angle) {
                            const titles = ['词汇', '听力', '口语'];
                            return RadarChartTitle(
                              text: titles[index],
                              angle: 0,
                              positionPercentageOffset: 0.2,
                            );
                          },
                          tickCount: 3,
                          ticksTextStyle: AppTextStyles.caption,
                          tickBorderData: const BorderSide(color: Colors.transparent),
                          gridBorderData: BorderSide(color: AppColors.textHint.withValues(alpha: 0.3)),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _LevelItem(
                      icon: Icons.book,
                      title: '词汇量',
                      score: '3500',
                      level: 'B1',
                      status: '良好',
                      color: AppColors.primary,
                    ),
                    _LevelItem(
                      icon: Icons.headphones,
                      title: '听力',
                      score: '30%',
                      level: 'A2',
                      status: '急需提升',
                      color: AppColors.error,
                    ),
                    _LevelItem(
                      icon: Icons.mic,
                      title: '口语',
                      score: '20%',
                      level: 'A1',
                      status: '急需提升',
                      color: AppColors.error,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('推荐学习重点：', style: AppTextStyles.subtitle1),
                    const SizedBox(height: AppSpacing.sm),
                    _RecommendationItem(number: '1', text: '每日单词复习 (保持词汇)'),
                    _RecommendationItem(number: '2', text: '连读弱读专项 (打通听力)'),
                    _RecommendationItem(number: '3', text: '影子跟读训练 (打开嘴巴)'),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ElevatedButton(
                onPressed: () async {
                  final userNotifier = ref.read(userProvider.notifier);
                  await userNotifier.completeOnboarding('用户');
                  await userNotifier.updateLevel(
                    ref.read(userProvider).level.copyWith(
                      vocabularyLevel: 'B1',
                      vocabularyScore: 75,
                      listeningLevel: 'A2',
                      listeningScore: 30,
                      speakingLevel: 'A1',
                      speakingScore: 20,
                      overallLevel: 'B1',
                    ),
                  );
                  if (context.mounted) {
                    context.go('/home');
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('开始定制学习'),
              ),
              const SizedBox(height: AppSpacing.md),
              TextButton(
                onPressed: () => context.go('/home'),
                child: const Text('查看详细报告'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LevelItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String score;
  final String level;
  final String status;
  final Color color;

  const _LevelItem({
    required this.icon,
    required this.title,
    required this.score,
    required this.level,
    required this.status,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.subtitle2),
                Text('$score ($status)', style: AppTextStyles.caption),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppRadius.sm),
            ),
            child: Text(
              level,
              style: AppTextStyles.subtitle2.copyWith(color: color),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecommendationItem extends StatelessWidget {
  final String number;
  final String text;

  const _RecommendationItem({required this.number, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(
              number,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(text, style: AppTextStyles.body2),
        ],
      ),
    );
  }
}
