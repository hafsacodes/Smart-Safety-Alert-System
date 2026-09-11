// Automated unit tests for GuardianAIService — the rule-based chat assistant
// that matches user questions against known safety topics.
//
// Run with:  flutter test test/guardian_ai_service_test.dart
// Or run every test file in the project with:  flutter test

import 'package:flutter_test/flutter_test.dart';
import 'package:fyp/services/guardian_ai_service.dart';

void main() {
  group('GuardianAIService.getResponse — recognised topics', () {
    test('responds to a greeting', () {
      final response = GuardianAIService.getResponse('hello');
      expect(response, contains('Guardian AI'));
    });

    test('is case-insensitive for greetings', () {
      final response = GuardianAIService.getResponse('HELLO');
      expect(response, contains('Guardian AI'));
    });

    test('explains what the app does', () {
      final response =
          GuardianAIService.getResponse('what does this app do');
      expect(response, contains('SOS alerts'));
    });

    test('explains how to use the SOS button', () {
      final response = GuardianAIService.getResponse('how do I use sos');
      expect(response, contains('SOS button'));
    });

    test('explains how to report an incident', () {
      final response =
          GuardianAIService.getResponse('how do I report an incident');
      expect(response, contains('Report Incident'));
    });
  });

  group('GuardianAIService.getResponse — fallback behaviour', () {
    test('returns the default guidance for an unrelated question', () {
      final response =
          GuardianAIService.getResponse('what is the capital of France');
      expect(response, contains("I'm Guardian AI"));
      expect(response, contains('Please ask a question related to safety'));
    });

    test('never returns an empty response', () {
      final response = GuardianAIService.getResponse('asdkjhasjkdh');
      expect(response.isNotEmpty, true);
    });
  });
}
