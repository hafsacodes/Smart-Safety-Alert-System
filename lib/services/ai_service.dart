class AIService {
  static String analyzeIncident(String description) {
    final text = description.toLowerCase();

    // High Risk
    if (text.contains("gun") ||
        text.contains("knife") ||
        text.contains("kidnap") ||
        text.contains("abduction") ||
        text.contains("murder") ||
        text.contains("shoot") ||
        text.contains("blood") ||
        text.contains("attack") ||
        text.contains("rape") ||
        text.contains("fire")) {
      return "High";
    }

    // Medium Risk
    if (text.contains("harass") ||
        text.contains("stalk") ||
        text.contains("rob") ||
        text.contains("theft") ||
        text.contains("fight") ||
        text.contains("threat") ||
        text.contains("follow") ||
        text.contains("suspicious")) {
      return "Medium";
    }

    return "Low";
  }

  static String getSafetyRecommendation(String severity) {
    switch (severity) {
      case "High":
        return "Move to a safe location immediately and contact emergency services.";

      case "Medium":
        return "Stay alert, avoid isolated areas, and inform a trusted person.";

      default:
        return "Remain cautious and report any suspicious activity if it continues.";
    }
  }
}