import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/word_model.dart';
import '../../data/services/database_service.dart';

/// 数据库服务Provider
final databaseServiceProvider = FutureProvider<DatabaseService>((ref) async {
  return await DatabaseService.getInstance();
});

/// 单词列表Notifier
class WordsNotifier extends AsyncNotifier<List<Word>> {
  @override
  Future<List<Word>> build() async {
    final db = await ref.read(databaseServiceProvider.future);
    final result = await db.query('words');
    return result.map((map) => Word.fromMap(map)).toList();
  }

  Future<void> updateWordStatus(String wordId, WordStatus status) async {
    try {
      final db = await ref.read(databaseServiceProvider.future);
      await db.update('words', {'status': status.index}, where: 'id = ?', whereArgs: [wordId]);
      ref.invalidateSelf();
    } catch (e) {
      // Handle error
    }
  }
}

/// 单词列表Provider
final wordsProvider = AsyncNotifierProvider<WordsNotifier, List<Word>>(() => WordsNotifier());

/// 新词列表
final newWordsProvider = Provider<List<Word>>((ref) {
  final wordsAsync = ref.watch(wordsProvider);
  return wordsAsync.when(
    data: (words) => words.where((w) => w.status == WordStatus.newWord).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

/// 复习词列表
final reviewWordsProvider = Provider<List<Word>>((ref) {
  final wordsAsync = ref.watch(wordsProvider);
  return wordsAsync.when(
    data: (words) => words.where((w) => w.status != WordStatus.newWord).toList(),
    loading: () => [],
    error: (_, __) => [],
  );
});

/// 词书列表
final wordBooksProvider = FutureProvider<List<WordBook>>((ref) async {
  final db = await ref.read(databaseServiceProvider.future);
  final result = await db.query('word_books');
  return result.map((map) => WordBook(
    id: map['id'] as String,
    name: map['name'] as String,
    description: map['description'] as String? ?? '',
    totalWords: map['totalWords'] as int? ?? 0,
    learnedWords: map['learnedWords'] as int? ?? 0,
    reviewedWords: map['reviewedWords'] as int? ?? 0,
    isMain: (map['isMain'] as int? ?? 0) == 1,
    isCompleted: (map['isCompleted'] as int? ?? 0) == 1,
  )).toList();
});

/// 今日进度
final todayProgressProvider = Provider<Map<String, int>>((ref) {
  final newWords = ref.watch(newWordsProvider);
  final reviewWords = ref.watch(reviewWordsProvider);
  return {
    'newWords': newWords.length >= 5 ? 5 : newWords.length,
    'reviewWords': reviewWords.length >= 12 ? 12 : reviewWords.length,
  };
});
