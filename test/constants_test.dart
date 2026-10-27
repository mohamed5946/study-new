import 'package:flutter_test/flutter_test.dart';
import 'package:study_assistant/core/constants/app_constants.dart';

void main() {
  test('app identity is the new standalone app', () {
    expect(AppConstants.appName, 'study');
    expect(AppConstants.packageName, 'com.mohamed5946.newstudy');
    expect(AppConstants.packageName, isNot('com.valor.studyassistant'));
    expect(AppConstants.packageName, isNot('com.mohamed5946.study'));
  });

  test('groq model and pomodoro defaults', () {
    expect(AppConstants.groqModel, 'openai/gpt-oss-20b');
    expect(AppConstants.groqBaseUrl, 'https://api.groq.com/openai/v1');
    expect(AppConstants.defaultFocusMinutes, 25);
    expect(AppConstants.defaultShortBreakMinutes, 5);
    expect(AppConstants.defaultLongBreakMinutes, 15);
    expect(AppConstants.sessionsBeforeLongBreak, 4);
  });
}
