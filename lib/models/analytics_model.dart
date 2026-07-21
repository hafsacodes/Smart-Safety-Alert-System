class RiskArea {
  final String location;
  final String level;

  RiskArea({
    required this.location,
    required this.level,
  });
}

class WeeklyActivity {
  final String day;
  final int count;

  WeeklyActivity({
    required this.day,
    required this.count,
  });
}

class AnalyticsModel {
  final int totalReports;
  final int approvedReports;
  final int highRiskReports;
  final int mediumRiskReports;
  final int lowRiskReports;

  final double harassmentPercentage;
  final double robberyPercentage;
  final double suspiciousPercentage;
  final double stalkingPercentage;

  final String aiSummary;

  final List<RiskArea> highRiskAreas;
  final List<WeeklyActivity> weeklyActivity;

  AnalyticsModel({
    required this.totalReports,
    required this.approvedReports,
    required this.highRiskReports,
    required this.mediumRiskReports,
    required this.lowRiskReports,
    required this.harassmentPercentage,
    required this.robberyPercentage,
    required this.suspiciousPercentage,
    required this.stalkingPercentage,
    required this.aiSummary,
    required this.highRiskAreas,
    required this.weeklyActivity,
  });
}