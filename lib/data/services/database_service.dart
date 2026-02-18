import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../core/constants/app_constants.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static Database? _database;

  DatabaseService._();

  static Future<DatabaseService> getInstance() async {
    if (_instance == null) {
      _instance = DatabaseService._();
      _database = await _instance!._initDatabase();
    }
    return _instance!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), AppConstants.dbName);
    return await openDatabase(
      path,
      version: AppConstants.dbVersion,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE words (
        id TEXT PRIMARY KEY,
        word TEXT NOT NULL,
        phonetic TEXT,
        meaning TEXT NOT NULL,
        memoryTip TEXT,
        examples TEXT,
        translations TEXT,
        status INTEGER DEFAULT 0,
        nextReviewTime INTEGER,
        reviewCount INTEGER DEFAULT 0,
        correctCount INTEGER DEFAULT 0,
        bookId TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE word_books (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT,
        totalWords INTEGER DEFAULT 0,
        learnedWords INTEGER DEFAULT 0,
        reviewedWords INTEGER DEFAULT 0,
        isMain INTEGER DEFAULT 0,
        isCompleted INTEGER DEFAULT 0
      )
    ''');

    await db.execute('''
      CREATE TABLE study_records (
        id TEXT PRIMARY KEY,
        date TEXT NOT NULL,
        type TEXT NOT NULL,
        count INTEGER DEFAULT 0,
        duration INTEGER DEFAULT 0,
        score REAL
      )
    ''');

    await db.execute('''
      CREATE TABLE user_progress (
        id TEXT PRIMARY KEY,
        type TEXT NOT NULL,
        progress REAL DEFAULT 0,
        lastUpdate INTEGER
      )
    ''');

    await _insertInitialData(db);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<void> _insertInitialData(Database db) async {
    final mainBookId = 'main_book_1';
    await db.insert('word_books', {
      'id': mainBookId,
      'name': '雅思核心词汇',
      'description': '涵盖雅思考试高频核心词汇',
      'totalWords': 100,
      'learnedWords': 0,
      'reviewedWords': 0,
      'isMain': 1,
      'isCompleted': 0,
    });

    final sampleWords = [
      {
        'id': 'w1',
        'word': 'abandon',
        'phonetic': '/əˈbændən/',
        'meaning': 'v. 放弃，遗弃',
        'memoryTip': 'a(不)+band(捆绑)→不捆绑→放弃',
        'examples': 'He abandoned his car.|She abandoned her job.',
        'translations': '他遗弃了他的车。|她放弃了她的工作。',
        'status': 0,
        'bookId': mainBookId
      },
      {
        'id': 'w2',
        'word': 'ability',
        'phonetic': '/əˈbɪləti/',
        'meaning': 'n. 能力',
        'memoryTip': 'able(能够)+ity(名词后缀)',
        'examples': 'She has the ability to speak French.',
        'translations': '她有说法语的能力。',
        'status': 0,
        'bookId': mainBookId
      },
      {
        'id': 'w3',
        'word': 'able',
        'phonetic': '/ˈeɪbl/',
        'meaning': 'adj. 能够的，有能力的',
        'memoryTip': '来源于拉丁语abilis',
        'examples': 'He is able to swim.',
        'translations': '他会游泳。',
        'status': 0,
        'bookId': mainBookId
      },
      {
        'id': 'w4',
        'word': 'about',
        'phonetic': '/əˈbaʊt/',
        'meaning': 'prep. 关于',
        'memoryTip': 'a+about',
        'examples': 'What is the book about?',
        'translations': '这本书是关于什么的？',
        'status': 0,
        'bookId': mainBookId
      },
      {
        'id': 'w5',
        'word': 'above',
        'phonetic': '/əˈbʌv/',
        'meaning': 'prep. 在...上面',
        'memoryTip': 'ab+ove',
        'examples': 'The bird flew above the tree.',
        'translations': '鸟从树上方飞过。',
        'status': 0,
        'bookId': mainBookId
      },
      {
        'id': 'w6',
        'word': 'abroad',
        'phonetic': '/əˈbrɔːd/',
        'meaning': 'adv. 在国外',
        'memoryTip': 'a+broad(宽阔的)',
        'examples': 'She went abroad to study.',
        'translations': '她出国留学了。',
        'status': 0,
        'bookId': mainBookId
      },
      {
        'id': 'w7',
        'word': 'absence',
        'phonetic': '/ˈæbsəns/',
        'meaning': 'n. 缺席，不在',
        'memoryTip': 'absent(缺席的)+ce',
        'examples': 'His absence was noted.',
        'translations': '他的缺席被注意到了。',
        'status': 0,
        'bookId': mainBookId
      },
      {
        'id': 'w8',
        'word': 'absolute',
        'phonetic': '/ˈæbsəluːt/',
        'meaning': 'adj. 绝对的',
        'memoryTip': 'absolute power',
        'examples': 'It is an absolute necessity.',
        'translations': '这是绝对必要的。',
        'status': 0,
        'bookId': mainBookId
      },
      {
        'id': 'w9',
        'word': 'absorb',
        'phonetic': '/əbˈzɔːrb/',
        'meaning': 'v. 吸收',
        'memoryTip': 'ab+sorb(吸)',
        'examples': 'Plants absorb water.',
        'translations': '植物吸收水分。',
        'status': 0,
        'bookId': mainBookId
      },
      {
        'id': 'w10',
        'word': 'abstract',
        'phonetic': '/ˈæbstrækt/',
        'meaning': 'adj. 抽象的',
        'memoryTip': 'abs+tract(拉)',
        'examples': 'The concept of beauty is abstract.',
        'translations': '美的概念是抽象的。',
        'status': 0,
        'bookId': mainBookId
      },
      {
        'id': 'w11',
        'word': 'academic',
        'phonetic': '/ˌækəˈdemɪk/',
        'meaning': 'adj. 学术的',
        'memoryTip': 'academy(学术)+ic',
        'examples': 'She has an academic mind.',
        'translations': '她有学术头脑。',
        'status': 0,
        'bookId': mainBookId
      },
      {
        'id': 'w12',
        'word': 'accept',
        'phonetic': '/əkˈsept/',
        'meaning': 'v. 接受',
        'memoryTip': 'ac+cept(拿)',
        'examples': 'Please accept my apology.',
        'translations': '请接受我的道歉。',
        'status': 0,
        'bookId': mainBookId
      },
      {
        'id': 'w13',
        'word': 'access',
        'phonetic': '/ˈækses/',
        'meaning': 'n. 入口，访问',
        'memoryTip': 'ac+cess(走)',
        'examples': 'The building has wheelchair access.',
        'translations': '这座建筑有轮椅通道。',
        'status': 0,
        'bookId': mainBookId
      },
      {
        'id': 'w14',
        'word': 'accident',
        'phonetic': '/ˈæksɪdənt/',
        'meaning': 'n. 事故',
        'memoryTip': 'accident insurance',
        'examples': 'There was a car accident.',
        'translations': '发生了车祸。',
        'status': 0,
        'bookId': mainBookId
      },
      {
        'id': 'w15',
        'word': 'accompany',
        'phonetic': '/əˈkʌmpəni/',
        'meaning': 'v. 陪伴',
        'memoryTip': 'ac+company(公司)',
        'examples': 'She accompanied her friend to the doctor.',
        'translations': '她陪朋友去看医生。',
        'status': 0,
        'bookId': mainBookId
      },
    ];

    for (var word in sampleWords) {
      await db.insert('words', word);
    }
  }

  Future<List<Map<String, dynamic>>> query(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    return await _database!.query(table, where: where, whereArgs: whereArgs);
  }

  Future<int> insert(String table, Map<String, dynamic> data) async {
    return await _database!
        .insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> update(String table, Map<String, dynamic> data,
      {String? where, List<dynamic>? whereArgs}) async {
    return await _database!
        .update(table, data, where: where, whereArgs: whereArgs);
  }

  Future<int> delete(String table,
      {String? where, List<dynamic>? whereArgs}) async {
    return await _database!.delete(table, where: where, whereArgs: whereArgs);
  }

  Future<List<Map<String, dynamic>>> rawQuery(String sql,
      [List<dynamic>? arguments]) async {
    return await _database!.rawQuery(sql, arguments);
  }

  Future<void> close() async {
    await _database?.close();
    _database = null;
    _instance = null;
  }
}
