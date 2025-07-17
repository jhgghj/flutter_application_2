import 'package:flutter/material.dart';
import '../services/word_book_manager.dart';
import 'flashcard_screen.dart';
import 'word_search_screen.dart';  // 引入查找单词的页面

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCount = 10; // 默认背诵的单词数量
  final List<int> _options = [10, 20, 30, 50, 100]; // 预设的选项
  final TextEditingController _customCountController = TextEditingController();
  String _errorMessage = ''; // 错误信息

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('背单词'),
        actions: [
          // 查找单词按钮
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // 跳转到查找单词页面
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WordSearchScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
            // 选择背诵的单词数量
            const Text('选择本次计划背诵的单词数量：', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
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
                  _customCountController.clear(); // 清除输入框内容
                  _errorMessage = ''; // 清除错误信息
              });
            },
          ),
            const SizedBox(height: 12),
            // 自定义背诵数量输入框
          TextField(
            controller: _customCountController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: '自定义背诵数量',
                border: const OutlineInputBorder(),
              errorText: _errorMessage.isEmpty ? null : _errorMessage,
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                setState(() {
                    _selectedCount = int.tryParse(value) ?? 10; // 如果输入无效则使用默认值
                    _errorMessage = ''; // 清除错误信息
                });
              }
            },
          ),
            const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
                // 自定义输入验证
              if (_customCountController.text.isNotEmpty &&
                  int.tryParse(_customCountController.text) == null) {
                setState(() {
                  _errorMessage = '请输入有效的数字';
                });
                return;
              }

                // 确保词库被选择
              if (WordBookManager.selectedBook == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('请先选择词库')),
                );
                return;
              }

                // 跳转到学习页面，传递计划背诵数量
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlashcardStudyScreen(planCount: _selectedCount),
                ),
              );
            },
              child: const Text('开始背单词'),
          ),
        ],
        ),
      ),
    );
  }
}
