import 'package:flutter/material.dart';
import '../models/incident_model.dart';
import '../models/user_model.dart';
import '../services/firestore_service.dart';



class ReportDetailsScreen extends StatefulWidget {
  final IncidentModel incident;

  const ReportDetailsScreen({
    super.key,
    required this.incident,
  });

  @override
  State<ReportDetailsScreen> createState() =>
      _ReportDetailsScreenState();
}

class _ReportDetailsScreenState
    extends State<ReportDetailsScreen> {

  final FirestoreService _firestoreService =
  FirestoreService();

  UserModel? reporter;

  @override
  void initState() {
    super.initState();
    loadReporter();
  }

  Future<void> loadReporter() async {

    reporter = await _firestoreService.getUser(
      widget.incident.userId,
    );

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        title: const Text("Report Details"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),

        body: reporter == null
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              //==========================
              // INCIDENT IMAGE
              //==========================

              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: widget.incident.imageUrl.isNotEmpty
                    ? Image.network(
                  widget.incident.imageUrl,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 220,
                      color: Colors.grey.shade300,
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.broken_image,
                            size: 60,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text("Unable to load image"),
                        ],
                      ),
                    );
                  },
                )
                    : Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                  ),
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image_not_supported,
                        size: 60,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "No image uploaded",
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 25),

              //==========================
              // INCIDENT INFORMATION
              //==========================

              const Text(
                "Incident Information",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 15),

              infoTile(
                Icons.report,
                "Incident Type",
                widget.incident.incidentType,
              ),

              infoTile(
                Icons.location_on,
                "Location",
                widget.incident.location,
              ),

              infoTile(
                Icons.description,
                "Description",
                widget.incident.description,
              ),

              infoTile(
                Icons.access_time,
                "Reported At",
                widget.incident.createdAt.toString(),
              ),

              infoTile(
                Icons.info,
                "Status",
                widget.incident.status,
              ),

              infoTile(
                Icons.visibility_off,
                "Anonymous",
                widget.incident.anonymousReport
                    ? "Yes"
                    : "No",
              ),

              const SizedBox(height: 30),

              //==========================
              // REPORTER INFORMATION
              //==========================

              const Text(
                "Reporter Information",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: CircleAvatar(
                  radius: 45,
                  backgroundImage:
                  reporter!.profileImage.isNotEmpty
                      ? NetworkImage(
                    reporter!.profileImage,
                  )
                      : null,
                  child: reporter!.profileImage.isEmpty
                      ? const Icon(
                    Icons.person,
                    size: 45,
                  )
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              infoTile(
                Icons.person,
                "Name",
                reporter!.fullName,
              ),

              infoTile(
                Icons.email,
                "Email",
                reporter!.email,
              ),

              infoTile(
                Icons.phone,
                "Phone",
                reporter!.phone,
              ),

              const SizedBox(height: 35),

              //==========================
              // ACTION BUTTONS
              //==========================

              Row(
                children: [

                  Expanded(
                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),

                      onPressed: () async {

                        final navigator = Navigator.of(context);

                        await _firestoreService.updateIncidentStatus(
                          incidentId: widget.incident.incidentId,
                          status: "Approved",
                        );

                        if (!mounted) return;

                        navigator.pop();
                      },

                      child: const Text(
                        "Approve",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 15),

                  Expanded(
                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),

                      onPressed: () async {

                        final navigator = Navigator.of(context);

                        await _firestoreService.updateIncidentStatus(
                          incidentId: widget.incident.incidentId,
                          status: "Rejected",
                        );

                        if (!mounted) return;

                        navigator.pop();
                      },

                      child: const Text(
                        "Reject",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                ],
              ),

              const SizedBox(height: 30),

            ],
          ),
        ),
    );
  }
  Widget infoTile(
      IconData icon,
      String title,
      String value,
      ) {

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),

      child: Row(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          Icon(
            icon,
            color: Colors.blue,
          ),

          const SizedBox(width: 15),

          Expanded(

            child: Column(

              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [

                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}