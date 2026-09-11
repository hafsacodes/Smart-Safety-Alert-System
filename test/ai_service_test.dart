// Automated unit tests for AIService — the rule-based engine that classifies
// incident/SOS severity and returns a matching safety recommendation.
//
// Run with:  flutter test test/ai_service_test.dart
// Or run every test file in the project with:  flutter test

import 'package:flutter_test/flutter_test.dart';
import 'package:fyp/services/ai_service.dart';

void main() {
  group('AIService.analyzeIncident — High risk keywords', () {
    test('detects "gun" as High', () {
      expect(AIService.analyzeIncident('A man pulled out a gun near me'),
          'High');
    });

    test('detects "knife" as High', () {
      expect(AIService.analyzeIncident('He threatened me with a knife'),
          'High');
    });

    test('detects "fire" as High', () {
      expect(AIService.analyzeIncident('There is a fire in the building'),
          'High');
    });

    test('is case-insensitive', () {
      expect(AIService.analyzeIncident('I SAW A GUN in the parking lot'),
          'High');
    });
  });

  group('AIService.analyzeIncident — Medium risk keywords', () {
    test('detects "harass" as Medium', () {
      expect(
          AIService.analyzeIncident('A stranger began to harass me'),
          'Medium');
    });

    test('detects "stalk" as Medium', () {
      expect(
          AIService.analyzeIncident('I think someone is stalking me'),
          'Medium');
    });

    test('detects "follow" as Medium', () {
      expect(
          AIService.analyzeIncident('A car has been following me for a mile'),
          'Medium');
    });
  });

  group('AIService.analyzeIncident — Low / default', () {
    test('returns Low when no risk keywords are present', () {
      expect(
          AIService.analyzeIncident('Everything seems calm in the area'),
          'Low');
    });

    test('returns Low for an empty description', () {
      expect(AIService.analyzeIncident(''), 'Low');
    });
  });

  group('AIService.analyzeIncident — priority ordering', () {
    test('High keyword wins even if a Medium keyword is also present', () {
      // Contains both "harass" (Medium) and "gun" (High) — High must win
      // because the High-risk check runs first in the engine.
      expect(
          AIService.analyzeIncident('He harassed me and pulled a gun'),
          'High');
    });
  });

  group('AIService.getSafetyRecommendation', () {
    test('High severity returns an urgent recommendation', () {
      final rec = AIService.getSafetyRecommendation('High');
      expect(rec, contains('emergency services'));
    });

    test('Medium severity returns a cautionary recommendation', () {
      final rec = AIService.getSafetyRecommendation('Medium');
      expect(rec, contains('trusted person'));
    });

    test('Low / unrecognised severity returns the default recommendation',
        () {
      final rec = AIService.getSafetyRecommendation('Low');
      expect(rec, contains('cautious'));
    });
  });
}
