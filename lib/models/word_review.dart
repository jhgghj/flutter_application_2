// lib/models/word_review.dart
class WordReview {
  final String word;
  int reviewInterval;  // 下一次复习的间隔（天数）
  int reviewCount;     // 已经复习过的次数
  double easeFactor;   // 易度因子

  WordReview({
    required this.word,
    this.reviewInterval = 1,
    this.reviewCount = 0,
    this.easeFactor = 2.5,
  });

  // 更新复习间隔与易度因子
  void update(int quality) {
    // 更新易度因子 (SM2公式)
    easeFactor = easeFactor + 0.1 - (5 - quality) * (0.08 + (5 - quality) * 0.02);

    // 保证易度因子不小于1.3
    easeFactor = easeFactor < 1.3 ? 1.3 : easeFactor;

    // 更新复习间隔
    if (reviewCount == 0) {
      reviewInterval = 1;
    } else if (reviewCount == 1) {
      reviewInterval = 6;
    } else {
      reviewInterval = (reviewInterval * easeFactor).round();
    }

    // 增加复习次数
    reviewCount++;
  }
}
