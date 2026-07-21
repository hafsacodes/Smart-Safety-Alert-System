class IncidentModel {
  final String incidentId;
  final String userId;
  final String userName;
  final String incidentType;
  final String description;
  final String severity;
  final String aiRecommendation;
  final String location;
  final double latitude;
  final double longitude;
  final String imageUrl;
  final bool anonymousReport;
  final String status;
  final DateTime? createdAt;

  IncidentModel({
    required this.incidentId,
    required this.userId,
    required this.userName,
    required this.incidentType,
    required this.description,
    required this.severity,
    required this.aiRecommendation,
    required this.location,
    required this.latitude,
    required this.longitude,
    required this.imageUrl,
    required this.anonymousReport,
    required this.status,
    this.createdAt,
  });

  factory IncidentModel.fromMap(
      Map<String, dynamic> map,
      String documentId,
      ) {
    return IncidentModel(
      incidentId: documentId,
      userId: map["userId"] ?? "",
      userName: map["userName"] ?? "",
      incidentType: map["incidentType"] ?? "",
      description: map["description"] ?? "",
      severity: map["severity"] ?? "",
      aiRecommendation: map["aiRecommendation"] ?? "",
      location: map["location"] ?? "",
      latitude: (map["latitude"] ?? 0).toDouble(),
      longitude: (map["longitude"] ?? 0).toDouble(),
      imageUrl: map["imageUrl"] ?? "",
      anonymousReport: map["anonymousReport"] ?? false,
      status: map["status"] ?? "Pending",
      createdAt: map["createdAt"]?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "incidentId": incidentId,
      "userId": userId,
      "userName": userName,
      "incidentType": incidentType,
      "description": description,
      severity: severity,
      aiRecommendation: aiRecommendation,
      "location": location,
      "latitude": latitude,
      "longitude": longitude,
      "imageUrl": imageUrl,
      "anonymousReport": anonymousReport,
      "status": status,
      "createdAt": createdAt,
    };
  }
}