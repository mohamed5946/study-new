import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../core/constants/app_constants.dart';

class AIService {
  static const String _baseUrl = AppConstants.groqBaseUrl;
  static const String _model = AppConstants.groqModel;

  /// Returns the raw error message on failure so the Settings "Test Connection"
  /// can show the real code / message.
  static Future<String> testConnection() async {
    final key = AppConstants.groqApiKey;
    if (key.isEmpty) {
      return 'ERROR: GROQ_API_KEY is empty. Pass it with --dart-define=GROQ_API_KEY=your_key';
    }

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $key',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': [
            {'role': 'user', 'content': 'Say "ok" only.'}
          ],
          'max_tokens': 5,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        return 'OK';
      } else {
        return 'HTTP ${response.statusCode}: ${response.body}';
      }
    } catch (e) {
      return 'EXCEPTION: $e';
    }
  }

  static Future<String> chat({
    required List<Map<String, String>> messages,
    String? systemPrompt,
  }) async {
    final key = AppConstants.groqApiKey;
    if (key.isEmpty) {
      return 'مفتاح الـ API غير موجود. مرّره وقت البناء بـ --dart-define=GROQ_API_KEY=...';
    }

    final fullMessages = <Map<String, String>>[];
    if (systemPrompt != null) {
      fullMessages.add({'role': 'system', 'content': systemPrompt});
    }
    fullMessages.addAll(messages);

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/chat/completions'),
        headers: {
          'Authorization': 'Bearer $key',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': _model,
          'messages': fullMessages,
          'temperature': 0.7,
          'max_tokens': 2048,
        }),
      ).timeout(const Duration(seconds: 45));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'] as String;
      } else {
        return 'خطأ من الخادم (${response.statusCode}): ${response.body}';
      }
    } catch (e) {
      return 'فشل الاتصال: $e';
    }
  }

  static Future<String> dailyTip({required bool isArabic}) async {
    final prompt = isArabic
        ? 'أعطني نصيحة مذاكرة قصيرة ومفيدة لطالب علوم حاسب (جملة أو جملتين فقط).'
        : 'Give a short useful study tip for a computer science student (one or two sentences only).';

    return chat(
      messages: [
        {'role': 'user', 'content': prompt}
      ],
      systemPrompt: isArabic
          ? 'أنت مساعد مذاكرة ودود. أجب بالعربية الفصحى المبسطة فقط.'
          : 'You are a friendly study assistant. Answer in English only.',
    );
  }

  static Future<String> generateExamFromText(String text, {required bool isArabic}) async {
    final prompt = isArabic
        ? 'من النص التالي، ولّد امتحان قصير من 5 أسئلة (اختيار من متعدد + مقالي). ضع الإجابات في النهاية:\n\n$text'
        : 'From the following text, generate a short 5-question exam (MCQ + short answer). Put answers at the end:\n\n$text';

    return chat(messages: [
      {'role': 'user', 'content': prompt}
    ]);
  }

  static Future<String> generateMindMapJson(String text, {required bool isArabic}) async {
    final prompt = isArabic
        ? 'حوّل النص التالي إلى خريطة ذهنية بهيكل JSON بسيط: { "root": "عنوان", "children": [ { "title": "...", "children": [] } ] }\n\n$text'
        : 'Convert the following text into a simple mind-map JSON: { "root": "title", "children": [ { "title": "...", "children": [] } ] }\n\n$text';

    return chat(messages: [
      {'role': 'user', 'content': prompt}
    ]);
  }
}
