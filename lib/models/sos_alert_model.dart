class SosAlertModel {
  final String alertId;
  final String userId;
  final String userName;
  final double latitude;
  final double longitude;
  final String location;
  final String mapUrl;
  final String status;

  // NEW
  final String severity;
  final String aiRecommendation;

  // Which channels the user selected to notify when raising this alert.
  // NOTE: this currently only records the user's intent in the database —
  // actually dispatching a push notification / SMS to these channels is
  // not implemented yet (see project future work).
  final bool notifyEmergencyContacts;
  final bool notifyNearbyUsers;
  final bool notifyPolice;

  SosAlertModel({
    required this.alertId,
    required this.userId,
    required this.userName,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.mapUrl,
    required this.status,

    // NEW
    required this.severity,
    required this.aiRecommendation,

    this.notifyEmergencyContacts = true,
    this.notifyNearbyUsers = true,
    this.notifyPolice = true,
  });

  factory SosAlertModel.fromMap(Map<String, dynamic> map) {
    return SosAlertModel(
      alertId: map["alertId"] ?? "",
      userId: map["userId"] ?? "",
      userName: map["userName"] ?? "",
      latitude: (map["latitude"] ?? 0).toDouble(),
      longitude: (map["longitude"] ?? 0).toDouble(),
      location: map["location"] ?? "",
      mapUrl: map["mapUrl"] ?? "",
      status: map["status"] ?? "",

      // NEW
      severity: map["severity"] ?? "Medium",
      aiRecommendation:
      map["aiRecommendation"] ?? "Stay alert and remain cautious.",

      notifyEmergencyContacts: map["notifyEmergencyContacts"] ?? true,
      notifyNearbyUsers: map["notifyNearbyUsers"] ?? true,
      notifyPolice: map["notifyPolice"] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "alertId": alertId,
      "userId": userId,
      "userName": userName,
      "latitude": latitude,
      "longitude": longitude,
      "location": location,
      "mapUrl": mapUrl,
      "status": status,

      // NEW
      "severity": severity,
      "aiRecommendation": aiRecommendation,

      "notifyEmergencyContacts": notifyEmergencyContacts,
      "notifyNearbyUsers": notifyNearbyUsers,
      "notifyPolice": notifyPolice,
    };
  }
}