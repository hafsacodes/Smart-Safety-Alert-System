import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_model.dart';
import '../models/contact_model.dart';
import '../models/sos_alert_model.dart';
import '../models/incident_model.dart';
import '../models/analytics_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //====================================================
  // USER
  //====================================================

  Future<void> saveUser({
    required String uid,
    required String fullName,
    required String email,
    required String phone,
  }) async {
    await _firestore.collection("users").doc(uid).set({
      "uid": uid,
      "fullName": fullName,
      "email": email,
      "phone": phone,
      "profileImage": "",
      "role": "user",
      "createdAt": FieldValue.serverTimestamp(),
    });
  }

  Future<UserModel?> getUser(String uid) async {
    final doc =
    await _firestore.collection("users").doc(uid).get();

    if (!doc.exists) {
      return null;
    }

    return UserModel.fromMap(doc.data()!);
  }
  Stream<List<UserModel>> getUsers() {
    return _firestore
        .collection("users")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => UserModel.fromMap(doc.data()),
      )
          .toList(),
    );
  }

  Future<void> updateUserProfile({
    required String uid,
    required String fullName,
    required String phone,
  }) async {
    await _firestore.collection("users").doc(uid).update({
      "fullName": fullName,
      "phone": phone,
    });
  }
  Future<void> updateProfileImage({
    required String uid,
    required String imageUrl,
  }) async {
    await _firestore.collection("users").doc(uid).update({
      "profileImage": imageUrl,
    });
  }
  Future<void> deleteUser(String uid) async {
    await _firestore.collection("users").doc(uid).delete();
  }
  //====================================================
  // EMERGENCY CONTACTS
  //====================================================

  Future<void> addEmergencyContact({
    required String userId,
    required String name,
    required String phone,
    required String relationship,
  }) async {
    final doc = _firestore
        .collection("users")
        .doc(userId)
        .collection("emergency_contacts")
        .doc();

    await doc.set({
      "id": doc.id,
      "name": name,
      "phone": phone,
      "relationship": relationship,
    });
  }

  Stream<List<ContactModel>> getEmergencyContacts(String userId) {
    return _firestore
        .collection("users")
        .doc(userId)
        .collection("emergency_contacts")
        .snapshots()
        .map((snapshot) =>
        snapshot.docs
            .map(
              (doc) =>
              ContactModel.fromMap(
                doc.data(),
                doc.id,
              ),
        )
            .toList());
  }

  Future<void> updateEmergencyContact({
    required String userId,
    required String contactId,
    required String name,
    required String phone,
    required String relationship,
  }) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("emergency_contacts")
        .doc(contactId)
        .update({
      "name": name,
      "phone": phone,
      "relationship": relationship,
    });
  }

  Future<void> deleteEmergencyContact({
    required String userId,
    required String contactId,
  }) async {
    await _firestore
        .collection("users")
        .doc(userId)
        .collection("emergency_contacts")
        .doc(contactId)
        .delete();
  }

  //====================================================
// SOS ALERTS
//====================================================

  Future<void> sendSOSAlert({
    required String userId,
    required String userName,
    required double latitude,
    required double longitude,
    required String location,
  }) async {
    final doc = _firestore.collection("sos_alerts").doc();

    final alert = SosAlertModel(
      alertId: doc.id,
      userId: userId,
      userName: userName,
      latitude: latitude,
      longitude: longitude,
      location: location,
      mapUrl:
      "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude",
      status: "Active",
    );

    await doc.set({
      ...alert.toMap(),
      "createdAt": FieldValue.serverTimestamp(),
    });
  }
  Stream<List<SosAlertModel>> getSOSAlerts() {
    return _firestore
        .collection("sos_alerts")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => SosAlertModel.fromMap(doc.data()),
      )
          .toList(),
    );
  }
  Future<SosAlertModel?> getSOSAlertById(String alertId) async {

    final doc = await _firestore
        .collection("sos_alerts")
        .doc(alertId)
        .get();

    if (!doc.exists) {
      return null;
    }

    return SosAlertModel.fromMap(doc.data()!);
  }
  Future<void> updateSOSStatus({
    required String alertId,
    required String status,
  }) async {

    await _firestore
        .collection("sos_alerts")
        .doc(alertId)
        .update({
      "status": status,
    });
  }
  //====================================================
// INCIDENT REPORTS
//====================================================

  Future<void> submitIncident({
    required IncidentModel incident,
  }) async {
    await _firestore
        .collection("incidents")
        .doc(incident.incidentId)
        .set(incident.toMap());
  }

  Stream<List<IncidentModel>> getIncidents() {
    return _firestore
        .collection("incidents")
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => IncidentModel.fromMap(
          doc.data(),
          doc.id,
        ),
      )
          .toList(),
    );
  }

  Future<void> updateIncidentStatus({
    required String incidentId,
    required String status,
  }) async {
    await _firestore
        .collection("incidents")
        .doc(incidentId)
        .update({
      "status": status,
    });
  }

  Future<void> deleteIncident(String incidentId) async {
    await _firestore
        .collection("incidents")
        .doc(incidentId)
        .delete();
  }
  Stream<AnalyticsModel> getAnalytics() {
    return _firestore
        .collection("incidents")
        .snapshots()
        .map((snapshot) {

      final incidents = snapshot.docs.map((e) => e.data()).toList();

      int totalReports = incidents.length;

      int approvedReports = incidents
          .where((e) => e["status"] == "Approved")
          .length;

      int highRiskReports = incidents
          .where((e) => e["severity"] == "High")
          .length;
      int mediumRiskReports = incidents
          .where((e) => e["severity"] == "Medium")
          .length;

      int lowRiskReports = incidents
          .where((e) => e["severity"] == "Low")
          .length;

      int harassment = incidents
          .where((e) => e["incidentType"] == "Harassment")
          .length;

      int robbery = incidents
          .where((e) => e["incidentType"] == "Robbery")
          .length;

      int suspicious = incidents
          .where((e) => e["incidentType"] == "Suspicious Activity")
          .length;

      int stalking = incidents
          .where((e) => e["incidentType"] == "Stalking")
          .length;

      double percent(int value) {
        if (totalReports == 0) return 0;
        return value / totalReports;
      }

      final Map<String, int> areaCount = {};

      for (final incident in incidents) {
        final location = incident["location"] ?? "Unknown";
        areaCount[location] = (areaCount[location] ?? 0) + 1;
      }

      final List<RiskArea> riskAreas = areaCount.entries
          .map((e) {
        String level = "Low";

        if (e.value >= 5) {
          level = "High";
        } else if (e.value >= 3) {
          level = "Medium";
        }

        return RiskArea(
          location: e.key,
          level: level,
        );
      })
          .toList();
      String aiSummary;

      if (totalReports == 0) {
        aiSummary =
        "Guardian AI has not detected any incident reports yet. The monitored areas are currently considered safe.";
      } else if (highRiskReports >= 5) {
        aiSummary =
        "Guardian AI has detected $highRiskReports high-risk incidents out of $totalReports total reports. Immediate attention is recommended in the highlighted locations.";
      } else if (highRiskReports >= 2) {
        aiSummary =
        "Guardian AI detected several medium to high-risk incidents recently. Citizens should remain cautious in the highlighted areas.";
      } else {
        aiSummary =
        "Guardian AI indicates that overall community safety is stable. Continue reporting suspicious activities to keep the system updated.";
      }
      return AnalyticsModel(
        totalReports: totalReports,
        approvedReports: approvedReports,
        highRiskReports: highRiskReports,
        mediumRiskReports: mediumRiskReports,
        lowRiskReports: lowRiskReports,
        harassmentPercentage: percent(harassment),
        robberyPercentage: percent(robbery),
        suspiciousPercentage: percent(suspicious),
        stalkingPercentage: percent(stalking),
        aiSummary: aiSummary,
        highRiskAreas: riskAreas,
        weeklyActivity: [
          WeeklyActivity(day: "Monday", count: 0),
          WeeklyActivity(day: "Tuesday", count: 0),
          WeeklyActivity(day: "Wednesday", count: 0),
          WeeklyActivity(day: "Thursday", count: 0),
          WeeklyActivity(day: "Friday", count: 0),
          WeeklyActivity(day: "Saturday", count: 0),
          WeeklyActivity(day: "Sunday", count: 0),
        ],
      );
    });
  }
}
