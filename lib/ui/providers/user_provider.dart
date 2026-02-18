import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/storage_service.dart';
import '../../data/models/user_model.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be initialized before use');
});

class UserState {
  final bool isLoggedIn;
  final bool isOnboardingComplete;
  final String userId;
  final String username;
  final String name;
  final UserLevelInfo level;
  final StudyStats stats;

  UserState({
    this.isLoggedIn = false,
    this.isOnboardingComplete = false,
    this.userId = '',
    this.username = '',
    this.name = '',
    UserLevelInfo? level,
    StudyStats? stats,
  })  : level = level ?? UserLevelInfo.initial(),
        stats = stats ?? StudyStats();

  UserState copyWith({
    bool? isLoggedIn,
    bool? isOnboardingComplete,
    String? userId,
    String? username,
    String? name,
    UserLevelInfo? level,
    StudyStats? stats,
  }) {
    return UserState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      userId: userId ?? this.userId,
      username: username ?? this.username,
      name: name ?? this.name,
      level: level ?? this.level,
      stats: stats ?? this.stats,
    );
  }
}

class UserNotifier extends Notifier<UserState> {
  late StorageService _storage;

  @override
  UserState build() {
    _storage = ref.watch(storageServiceProvider);
    _checkLoginStatus();
    return UserState();
  }

  void _checkLoginStatus() {
    final currentUserId = _storage.getString('currentUserId');
    if (currentUserId != null) {
      _storage.setCurrentUser(currentUserId);
      _loadUserData(currentUserId);
    }
  }

  void _loadUserData(String userId) {
    _storage.setCurrentUser(userId);
    
    final isOnboardingComplete = _storage.getBool('isOnboardingComplete') ?? false;
    final name = _storage.getString('userName') ?? '';
    final username = _storage.getString('username') ?? '';
    
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
      isLoggedIn: true,
      isOnboardingComplete: isOnboardingComplete,
      userId: userId,
      username: username,
      name: name,
      level: level,
      stats: stats,
    );
  }

  Future<bool> login(String username, String password) async {
    if (_storage.userExists(username)) {
      final userId = _storage.getUserIdByUsername(username);
      if (userId != null && _storage.checkUserCredentials(username, password)) {
        await _storage.setString('currentUserId', userId);
        _loadUserData(userId);
        return true;
      }
    }
    return false;
  }

  Future<bool> register(String username, String password, String name) async {
    if (_storage.userExists(username)) {
      return false;
    }
    
    await _storage.createUser(username, password);
    final userId = _storage.getUserIdByUsername(username);
    if (userId != null) {
      await _storage.setString('currentUserId', userId);
      _storage.setCurrentUser(userId);
      await _storage.setString('username', username);
      await _storage.setString('userName', name);
      await _storage.setBool('isOnboardingComplete', false);
      _loadUserData(userId);
      return true;
    }
    return false;
  }

  Future<void> logout() async {
    await _storage.remove('currentUserId');
    _storage.setCurrentUser(null);
    state = UserState();
  }

  Future<void> completeOnboarding(String name) async {
    await _storage.setBool('isOnboardingComplete', true);
    await _storage.setString('userName', name);
    if (state.name.isEmpty && name.isNotEmpty) {
      await _storage.setString('userName', name);
    }
    state = state.copyWith(
      isOnboardingComplete: true,
      name: name.isNotEmpty ? name : state.name,
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

final userProvider = NotifierProvider<UserNotifier, UserState>(UserNotifier.new);

final initializeStorageProvider = FutureProvider<StorageService>((ref) async {
  return await StorageService.getInstance();
});
