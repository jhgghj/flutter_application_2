import json
import os

# 输入文件路径
input_path = r"G:\android_app\flutter_application_2\assets\words\english-vocabulary-master\json\5-考研-顺序.json"
output_path = r"G:\android_app\flutter_application_2\assets\words\english-vocabulary-master\json\converted-5-考研-顺序.json"

# 设置词库名称
wordbook_name = "5-考研-顺序词库"

# 读取原始 JSON 数据
with open(input_path, "r", encoding="utf-8") as f:
    original_data = json.load(f)

# 创建目标结构
converted_data = {
    "name": wordbook_name,
    "words": []
}

# 转换数据结构
for entry in original_data:
    word_item = {
        "word": entry.get("word", ""),
        "translations": [],
        "phrases": []
    }

    for t in entry.get("translations", []):
        word_item["translations"].append({
            "type": t.get("type", ""),
            "translation": t.get("translation", "")
        })

    for p in entry.get("phrases", []):
        word_item["phrases"].append({
            "phrase": p.get("phrase", ""),
            "translation": p.get("translation", "")
        })

    converted_data["words"].append(word_item)

# 保存转换后的数据
with open(output_path, "w", encoding="utf-8") as f:
    json.dump(converted_data, f, ensure_ascii=False, indent=2)

print(f"✅ 转换完成，保存路径为：{output_path}")
