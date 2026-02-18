import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/screens/onboarding/onboarding_screen.dart';
import '../../presentation/screens/test/vocabulary_test_screen.dart';
import '../../presentation/screens/test/listening_test_screen.dart';
import '../../presentation/screens/test/speaking_test_screen.dart';
import '../../presentation/screens/test/test_result_screen.dart';
import '../../presentation/screens/home/home_screen.dart';
import '../../presentation/screens/words/word_learning_screen.dart';
import '../../presentation/screens/words/word_review_screen.dart';
import '../../presentation/screens/words/word_book_screen.dart';
import '../../presentation/screens/listening/listening_level_screen.dart';
import '../../presentation/screens/listening/listening_training_screen.dart';
import '../../presentation/screens/speaking/shadow_reading_screen.dart';
import '../../presentation/screens/speaking/practice_dialogue_screen.dart';
import '../../presentation/screens/scene/scene_list_screen.dart';
import '../../presentation/screens/scene/scene_detail_screen.dart';
import '../../presentation/screens/profile/profile_screen.dart';
import '../../presentation/screens/profile/settings_screen.dart';
import '../../presentation/screens/profile/achievements_screen.dart';
import '../../presentation/widgets/main_scaffold.dart';
import '../../presentation/providers/user_provider.dart';
import '../utils/logger.dart';

/// 路由Provider
/// 根据用户状态返回不同的路由配置
final routerProvider = Provider<GoRouter>((ref) {
  AppLogger.debug('routerProvider 被初始化');
  // ignore: unused_local_variable
  final userState = ref.watch(userProvider);
  
  return GoRouter(
    initialLocation: '/onboarding',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) {
          AppLogger.logRouteChange('/onboarding');
          return const OnboardingScreen();
        },
      ),
      GoRoute(
        path: '/test/vocabulary',
        builder: (context, state) {
          AppLogger.logRouteChange('/test/vocabulary');
          return const VocabularyTestScreen();
        },
      ),
      GoRoute(
        path: '/test/listening',
        builder: (context, state) {
          AppLogger.logRouteChange('/test/listening');
          return const ListeningTestScreen();
        },
      ),
      GoRoute(
        path: '/test/speaking',
        builder: (context, state) {
          AppLogger.logRouteChange('/test/speaking');
          return const SpeakingTestScreen();
        },
      ),
      GoRoute(
        path: '/test/result',
        builder: (context, state) {
          AppLogger.logRouteChange('/test/result');
          return const TestResultScreen();
        },
      ),
      ShellRoute(
        builder: (context, state, child) {
          AppLogger.logRouteChange('ShellRoute: ${state.uri.path}');
          return MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) {
              AppLogger.logRouteChange('/home');
              return const HomeScreen();
            },
          ),
          GoRoute(
            path: '/words',
            builder: (context, state) {
              AppLogger.logRouteChange('/words');
              return const WordBookScreen();
            },
            routes: [
              GoRoute(
                path: 'learning',
                builder: (context, state) {
                  AppLogger.logRouteChange('/words/learning');
                  return const WordLearningScreen();
                },
              ),
              GoRoute(
                path: 'review',
                builder: (context, state) {
                  AppLogger.logRouteChange('/words/review');
                  return const WordReviewScreen();
                },
              ),
            ],
          ),
          GoRoute(
            path: '/listening',
            builder: (context, state) {
              AppLogger.logRouteChange('/listening');
              return const ListeningLevelScreen();
            },
            routes: [
              GoRoute(
                path: 'training',
                builder: (context, state) {
                  AppLogger.logRouteChange('/listening/training');
                  return const ListeningTrainingScreen();
                },
              ),
            ],
          ),
          GoRoute(
            path: '/speaking',
            builder: (context, state) {
              AppLogger.logRouteChange('/speaking');
              return const ShadowReadingScreen();
            },
            routes: [
              GoRoute(
                path: 'dialogue',
                builder: (context, state) {
                  AppLogger.logRouteChange('/speaking/dialogue');
                  return const PracticeDialogueScreen();
                },
              ),
            ],
          ),
          GoRoute(
            path: '/scene',
            builder: (context, state) {
              AppLogger.logRouteChange('/scene');
              return const SceneListScreen();
            },
            routes: [
              GoRoute(
                path: 'detail',
                builder: (context, state) {
                  AppLogger.logRouteChange('/scene/detail');
                  return const SceneDetailScreen();
                },
              ),
            ],
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) {
              AppLogger.logRouteChange('/profile');
              return const ProfileScreen();
            },
            routes: [
              GoRoute(
                path: 'settings',
                builder: (context, state) {
                  AppLogger.logRouteChange('/profile/settings');
                  return const SettingsScreen();
                },
              ),
              GoRoute(
                path: 'achievements',
                builder: (context, state) {
                  AppLogger.logRouteChange('/profile/achievements');
                  return const AchievementsScreen();
                },
              ),
            ],
          ),
        ],
      ),
    ],
  );
});
