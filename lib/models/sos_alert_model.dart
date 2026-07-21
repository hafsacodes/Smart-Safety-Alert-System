class SosAlertModel {
  final String alertId;
  final String userId;
  final String userName;
  final double latitude;
  final double longitude;
  final String location;
  final String mapUrl;
  final String status;

  SosAlertModel({
    required this.alertId,
    required this.userId,
    required this.userName,
    required this.latitude,
    required this.longitude,
    required this.location,
    required this.mapUrl,
    required this.status,
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
    };
  }
}