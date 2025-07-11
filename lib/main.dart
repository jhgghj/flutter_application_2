import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await WordBookManager.loadWordBooks();
  runApp(MyApp());
}

class Translation {
  final String type;
  final String translation;

  Translation({required this.type, required this.translation});

  factory Translation.fromJson(Map<String, dynamic> json) {
    return Translation(
      type: json['type'] ?? '',
      translation: json['translation'],
    );
  }
}

class Phrase {
  final String phrase;
  final String translation;

  Phrase({required this.phrase, required this.translation});

  factory Phrase.fromJson(Map<String, dynamic> json) {
    return Phrase(
      phrase: json['phrase'],
      translation: json['translation'],
    );
  }
}

class WordEntry {
  final String word;
  final List<Translation> translations;
  final List<Phrase> phrases;

  WordEntry({required this.word, required this.translations, required this.phrases});

  factory WordEntry.fromJson(Map<String, dynamic> json) {
    return WordEntry(
      word: json['word'],
      translations: (json['translations'] as List)
          .map((e) => Translation.fromJson(e))
          .toList(),
      phrases: (json['phrases'] as List)
          .map((e) => Phrase.fromJson(e))
          .toList(),
    );
  }
}

class WordBook {
  final String name;
  final List<WordEntry> words;

  WordBook({required this.name, required this.words});

  factory WordBook.fromJson(Map<String, dynamic> json) {
    return WordBook(
      name: json['name'],
      words: (json['words'] as List)
          .map((e) => WordEntry.fromJson(e))
          .toList(),
    );
  }
}

class WordBookManager {
  static WordBook? selectedBook;
  static final List<WordBook> wordBooks = [];

  static Future<void> loadWordBooks() async {
    final jsonString = await rootBundle.loadString('assets/words/english-vocabulary-master/json/converted-5-考研-顺序.json');
    final Map<String, dynamic> jsonData = json.decode(jsonString);
    wordBooks.add(WordBook.fromJson(jsonData));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 底部导航示例',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    WordLibraryScreen(),
    StatisticsScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '首页',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: '词库',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '统计',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: '我的',
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCount = 10;
  final List<int> _options = [10, 20, 30, 50, 100];
  final TextEditingController _customCountController = TextEditingController();
  String _errorMessage = '';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('选择本次计划背诵的单词数量：', style: TextStyle(fontSize: 18)),
          SizedBox(height: 12),
          DropdownButton<int>(
            value: _selectedCount,
            items: _options.map((count) {
              return DropdownMenuItem<int>(
                value: count,
                child: Text('$count 个'),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedCount = value!;
                _customCountController.clear(); // Clear custom input when option is selected
                _errorMessage = ''; // Clear error message
              });
            },
          ),
          SizedBox(height: 12),
          // Custom Input Field
          TextField(
            controller: _customCountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '自定义背诵数量',
              border: OutlineInputBorder(),
              errorText: _errorMessage.isEmpty ? null : _errorMessage,
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                  _selectedCount = int.tryParse(value) ?? 10;
                  _errorMessage = ''; // Clear error message if valid
                });
              }
            },
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              // Validate custom input before proceeding
              if (_customCountController.text.isNotEmpty &&
                  int.tryParse(_customCountController.text) == null) {
                setState(() {
                  _errorMessage = '请输入有效的数字';
                });
                return;
              }

              // Ensure a wordbook is selected
              if (WordBookManager.selectedBook == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('请先选择词库')),
                );
                return;
              }

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlashcardStudyScreen(planCount: _selectedCount),
                ),
              );
            },
            child: Text('开始背单词'),
          ),
        ],
      ),
    );
  }
}

class WordLibraryScreen extends StatelessWidget {
  const WordLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (WordBookManager.wordBooks.isEmpty) {
      return Center(child: CircularProgressIndicator());
    }
    return ListView.builder(
      itemCount: WordBookManager.wordBooks.length,
      itemBuilder: (context, index) {
        final book = WordBookManager.wordBooks[index];
        return ListTile(
          title: Text(book.name),
          onTap: () {
            WordBookManager.selectedBook = book;
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => WordListScreen(book: book),
              ),
            );
          },
        );
      },
    );
  }
}

class WordListScreen extends StatelessWidget {
  final WordBook book;

  const WordListScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.name)),
      body: ListView.builder(
        itemCount: book.words.length,
        itemBuilder: (context, index) {
          final word = book.words[index];
          return ListTile(
            title: Text(word.word),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WordDetailScreen(word: word),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class WordDetailScreen extends StatefulWidget {
  final WordEntry word;

  const WordDetailScreen({super.key, required this.word});

  @override
  State<WordDetailScreen> createState() => _WordDetailScreenState();
}

class _WordDetailScreenState extends State<WordDetailScreen> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final phrases = widget.word.phrases;
    // 显示三条短语，若已展开则显示全部
    final displayedPhrases = _expanded ? phrases : phrases.take(3).toList();

    return Scaffold(
      appBar: AppBar(title: Text(widget.word.word)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('释义：', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...widget.word.translations.map((t) => Text('${t.type}. ${t.translation}')),
            if (phrases.isNotEmpty) ...[
              SizedBox(height: 16),
              Text('短语：', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              // 展示短语列表
              ...displayedPhrases.map((p) => Text('${p.phrase}：${p.translation}')),
              // 如果短语超过三条，显示折叠按钮
              if (phrases.length > 3)
                TextButton(
                  onPressed: () => setState(() => _expanded = !_expanded),
                  child: Text(_expanded ? '收起' : '展开更多短语'),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        '统计内容',
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('我的内容'),
    );
  }
}

class FlashcardStudyScreen extends StatefulWidget {
  final int planCount;

  const FlashcardStudyScreen({super.key, required this.planCount});

  @override
  _FlashcardStudyScreenState createState() => _FlashcardStudyScreenState();
}

class _FlashcardStudyScreenState extends State<FlashcardStudyScreen> {
  int _currentIndex = 0;
  bool _showDetails = false;

  void _nextBatch() {
    setState(() {
      _currentIndex += 4;
      if (_currentIndex >= widget.planCount) {
        _currentIndex = 0;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已到达计划背诵量，重新开始')),
        );
      }
      _showDetails = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final book = WordBookManager.selectedBook;

    if (book == null || book.words.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('背单词')),
        body: Center(child: Text('请先选择词库')),
      );
    }

    final planWords = book.words.take(widget.planCount).toList();
    final words = planWords.skip(_currentIndex).take(4).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('背单词 - ${book.name}'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(child: Text('${_currentIndex + 1}-${_currentIndex + words.length}/${widget.planCount}')),
          )
        ],
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          setState(() {
            if (_showDetails) {
              _nextBatch();
            } else {
              _showDetails = true;
            }
          });
        },
        child: GridView.builder(
          padding: EdgeInsets.all(16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.5,
          ),
          itemCount: words.length,
          itemBuilder: (context, index) {
            final word = words[index];
            return Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      word.word,
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    if (_showDetails) ...[
                      SizedBox(height: 12),
                      ...word.translations.map(
                          (t) => Text(
                            '${t.type.isNotEmpty ? "${t.type}. " : ""}${t.translation}',
                            style: TextStyle(fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                      ),
                      if (word.phrases.isNotEmpty) ...[ 
                        SizedBox(height: 8),
                          Text('短语：', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ...word.phrases.take(3).map(
                            (p) => Text('${p.phrase}：${p.translation}', style: TextStyle(fontSize: 12)),
                        ),
                        ],
                    ]
                  ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
