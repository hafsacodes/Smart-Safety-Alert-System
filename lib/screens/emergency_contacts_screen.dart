import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/contact_model.dart';
import '../services/firestore_service.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() =>
      _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState
    extends State<EmergencyContactsScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  final String userId = FirebaseAuth.instance.currentUser!.uid;

  //==========================
  // ADD CONTACT
  //==========================

  Future<void> addContact() async {
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final relationshipController = TextEditingController();

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Add Emergency Contact"),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: relationshipController,
                  decoration: const InputDecoration(
                    labelText: "Relationship",
                  ),
                ),
              ],
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {

                if (nameController.text.trim().isEmpty ||
                    phoneController.text.trim().isEmpty ||
                    relationshipController.text.trim().isEmpty) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please fill all fields"),
                    ),
                  );
                  return;
                }

                final messenger = ScaffoldMessenger.of(context);

                await _firestoreService.addEmergencyContact(
                  userId: userId,
                  name: nameController.text.trim(),
                  phone: phoneController.text.trim(),
                  relationship: relationshipController.text.trim(),
                );

                if (!dialogContext.mounted) return;

                Navigator.of(dialogContext).pop();

                messenger.showSnackBar(
                  const SnackBar(
                    content: Text("Contact Added"),
                  ),
                );
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  //==========================
  // EDIT CONTACT
  //==========================

  Future<void> editContact(ContactModel contact) async {

    final nameController =
    TextEditingController(text: contact.name);

    final phoneController =
    TextEditingController(text: contact.phone);

    final relationshipController =
    TextEditingController(
      text: contact.relationship,
    );

    await showDialog(
      context: context,
      builder: (dialogContext) {

        return AlertDialog(
          title: const Text("Edit Contact"),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [

                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                  ),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: relationshipController,
                  decoration: const InputDecoration(
                    labelText: "Relationship",
                  ),
                ),
              ],
            ),
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () async {

                final messenger = ScaffoldMessenger.of(context);

                await _firestoreService.updateEmergencyContact(
                  userId: userId,
                  contactId: contact.id,
                  name: nameController.text.trim(),
                  phone: phoneController.text.trim(),
                  relationship: relationshipController.text.trim(),
                );

                if (!dialogContext.mounted) return;

                Navigator.of(dialogContext).pop();

                messenger.showSnackBar(
                  const SnackBar(
                    content: Text("Contact Updated"),
                  ),
                );
              },
              child: const Text("Update"),
            ),
          ],
        );
      },
    );
  }

  //==========================
  // DELETE CONTACT
  //==========================

  Future<void> deleteContact(ContactModel contact) async {

    final result = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {

        return AlertDialog(
          title: const Text("Delete Contact"),

          content: Text(
            "Delete ${contact.name}?",
          ),

          actions: [

            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext, false);
              },
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                Navigator.pop(dialogContext, true);
              },
              child: const Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );

    if (result != true) return;

    await _firestoreService.deleteEmergencyContact(
      userId: userId,
      contactId: contact.id,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Contact Deleted"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        title: const Text(
          "Emergency Contacts",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),

      body: StreamBuilder<List<ContactModel>>(
        stream: _firestoreService.getEmergencyContacts(userId),

        builder: (context, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          final contacts = snapshot.data ?? [];

          if (contacts.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [

                  Icon(
                    Icons.contact_phone,
                    size: 90,
                    color: Colors.grey,
                  ),

                  SizedBox(height: 20),

                  Text(
                    "No Emergency Contacts",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 10),

                  Text(
                    "Tap the + button to add one.",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: contacts.length,

            itemBuilder: (context, index) {

              final contact = contacts[index];

              return Card(
                margin: const EdgeInsets.only(
                  bottom: 15,
                ),

                elevation: 2,

                shape: RoundedRectangleBorder(
                  borderRadius:
                  BorderRadius.circular(18),
                ),

                child: ListTile(

                  leading: const CircleAvatar(
                    backgroundColor:
                    Color(0xFF1565FF),

                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),

                  title: Text(
                    contact.name,
                    style: const TextStyle(
                      fontWeight:
                      FontWeight.bold,
                    ),
                  ),

                  subtitle: Text(
                    "${contact.relationship}\n${contact.phone}",
                  ),

                  isThreeLine: true,

                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,

                    children: [

                      IconButton(
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),

                        onPressed: () {
                          editContact(contact);
                        },
                      ),

                      IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),

                        onPressed: () {
                          deleteContact(contact);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),

      floatingActionButton:
      FloatingActionButton(

        backgroundColor:
        const Color(0xFF1565FF),

        onPressed: addContact,

        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}