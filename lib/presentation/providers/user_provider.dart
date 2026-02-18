import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/storage_service.dart';
import '../../data/models/user_model.dart';

/// 存储服务Provider
final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be initialized before use');
});

/// 用户状态数据类
class UserState {
  final bool isOnboardingComplete;
  final String name;
  final UserLevelInfo level;
  final StudyStats stats;

  UserState({
    this.isOnboardingComplete = false,
    this.name = '',
    UserLevelInfo? level,
    StudyStats? stats,
  })  : level = level ?? UserLevelInfo.initial(),
        stats = stats ?? StudyStats();

  UserState copyWith({
    bool? isOnboardingComplete,
    String? name,
    UserLevelInfo? level,
    StudyStats? stats,
  }) {
    return UserState(
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      name: name ?? this.name,
      level: level ?? this.level,
      stats: stats ?? this.stats,
    );
  }
}

/// 用户状态管理器 (使用Riverpod 3.x的Notifier)
class UserNotifier extends Notifier<UserState> {
  late StorageService _storage;

  @override
  UserState build() {
    _storage = ref.watch(storageServiceProvider);
    _loadUserData();
    return UserState();
  }

  void _loadUserData() {
    final isOnboardingComplete = _storage.getBool('isOnboardingComplete') ?? false;
    final name = _storage.getString('userName') ?? '';
    
    final levelMap = <String, dynamic>{};
    levelMap['vocabularyLevel'] = _storage.getString('vocabularyLevel') ?? 'A1';
    levelMap['vocabularyScore'] = _storage.getInt('vocabularyScore') ?? 0;
    levelMap['listeningLevel'] = _storage.getString('listeningLevel') ?? 'A1';
    levelMap['listeningScore'] = _storage.getInt('listeningScore') ?? 0;
    levelMap['speakingLevel'] = _storage.getString('speakingLevel') ?? 'A1';
    levelMap['speakingScore'] = _storage.getInt('speakingScore') ?? 0;
    levelMap['overallLevel'] = _storage.getString('overallLevel') ?? 'A1';
    final level = UserLevelInfo.fromMap(levelMap);

    final statsMap = <String, dynamic>{};
    statsMap['totalStudyDays'] = _storage.getInt('totalStudyDays') ?? 0;
    statsMap['currentStreak'] = _storage.getInt('currentStreak') ?? 0;
    statsMap['totalWordsLearned'] = _storage.getInt('totalWordsLearned') ?? 0;
    statsMap['totalListeningMinutes'] = _storage.getInt('totalListeningMinutes') ?? 0;
    statsMap['totalSpeakingMinutes'] = _storage.getInt('totalSpeakingMinutes') ?? 0;
    final stats = StudyStats.fromMap(statsMap);

    state = UserState(
      isOnboardingComplete: isOnboardingComplete,
      name: name,
      level: level,
      stats: stats,
    );
  }

  Future<void> completeOnboarding(String name) async {
    await _storage.setBool('isOnboardingComplete', true);
    await _storage.setString('userName', name);
    state = state.copyWith(
      isOnboardingComplete: true,
      name: name,
    );
  }

  Future<void> updateLevel(UserLevelInfo level) async {
    await _storage.setString('vocabularyLevel', level.vocabularyLevel);
    await _storage.setInt('vocabularyScore', level.vocabularyScore);
    await _storage.setString('listeningLevel', level.listeningLevel);
    await _storage.setInt('listeningScore', level.listeningScore);
    await _storage.setString('speakingLevel', level.speakingLevel);
    await _storage.setInt('speakingScore', level.speakingScore);
    await _storage.setString('overallLevel', level.overallLevel);
    state = state.copyWith(level: level);
  }

  Future<void> updateStats(StudyStats stats) async {
    await _storage.setInt('totalStudyDays', stats.totalStudyDays);
    await _storage.setInt('currentStreak', stats.currentStreak);
    await _storage.setInt('totalWordsLearned', stats.totalWordsLearned);
    await _storage.setInt('totalListeningMinutes', stats.totalListeningMinutes);
    await _storage.setInt('totalSpeakingMinutes', stats.totalSpeakingMinutes);
    state = state.copyWith(stats: stats);
  }

  Future<void> incrementWordsLearned() async {
    final newStats = state.stats.copyWith(
      totalWordsLearned: state.stats.totalWordsLearned + 1,
    );
    await updateStats(newStats);
  }

  Future<void> recordStudy() async {
    final now = DateTime.now();
    final lastDate = state.stats.lastStudyDate;
    
    int newStreak = state.stats.currentStreak;
    if (lastDate == null) {
      newStreak = 1;
    } else {
      final daysDiff = now.difference(lastDate).inDays;
      if (daysDiff == 1) {
        newStreak = state.stats.currentStreak + 1;
      } else if (daysDiff > 1) {
        newStreak = 1;
      }
    }

    final newStats = state.stats.copyWith(
      lastStudyDate: now,
      currentStreak: newStreak,
      totalStudyDays: state.stats.totalStudyDays + 1,
    );
    await updateStats(newStats);
  }
}

/// 用户状态Provider
final userProvider = NotifierProvider<UserNotifier, UserState>(UserNotifier.new);

/// 初始化存储服务Provider
final initializeStorageProvider = FutureProvider<StorageService>((ref) async {
  return await StorageService.getInstance();
});
