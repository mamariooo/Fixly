import 'package:flutter_dotenv/flutter_dotenv.dart';

class AiConfig {
  AiConfig._();

  static const String _envDefineKey = String.fromEnvironment('GEMINI_API_KEY');

  static String get geminiApiKey {
    final dotEnvKey = dotenv.maybeGet('GEMINI_API_KEY')?.trim() ?? '';
    if (dotEnvKey.isNotEmpty) return dotEnvKey;
    return _envDefineKey.trim();
  }

  static const String geminiModel = 'gemini-2.5-flash';

  static bool get hasApiKey => geminiApiKey.isNotEmpty;
}
