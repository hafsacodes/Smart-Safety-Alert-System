# Automated Tests

This project's automated test coverage focuses on the **business-logic layer**
(the two rule-based engines the app relies on), because these are pure Dart
classes with no Firebase/Flutter dependency, so they can run instantly with
`flutter test` and no emulator or mocked backend.

- `ai_service_test.dart` — tests `AIService.analyzeIncident()` and
  `getSafetyRecommendation()` (the incident/SOS severity classifier).
- `guardian_ai_service_test.dart` — tests `GuardianAIService.getResponse()`
  (the in-app safety chat assistant).

## Run all tests

```
flutter test
```

## Note on widget/UI testing

Full widget tests (pumping real screens like `LoginScreen`) were not added
here because several screens construct `AuthService()` / access
`FirebaseAuth.instance` directly in their `State` fields, which requires
Firebase to already be initialized. Plain `flutter test` runs on the Dart VM
without platform channels, so this throws unless Firebase is mocked (e.g.
with the `firebase_auth_mocks` / `fake_cloud_firestore` packages). Adding
that mocking layer is listed as future work — it was intentionally left out
here rather than shipping a test that only pretends to pass.
