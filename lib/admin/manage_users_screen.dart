import 'package:flutter/material.dart';

import '../models/user_model.dart';
import '../services/firestore_service.dart';

class ManageUsersScreen extends StatefulWidget {
  const ManageUsersScreen({super.key});

  @override
  State<ManageUsersScreen> createState() =>
      _ManageUsersScreenState();
}

class _ManageUsersScreenState
    extends State<ManageUsersScreen> {

  final FirestoreService _firestoreService =
  FirestoreService();

  final TextEditingController searchController =
  TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

        backgroundColor: const Color(0xFFF7F9FC),

        appBar: AppBar(

          title: const Text("Manage Users"),

          backgroundColor: Colors.white,

          foregroundColor: Colors.black,

          elevation: 0,

        ),

        body: Padding(

          padding: const EdgeInsets.all(20),

          child: Column(

            crossAxisAlignment:
            CrossAxisAlignment.start,

            children: [

            const Text(

            "Registered Users",

            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),

          ),

          const SizedBox(height: 8),

          const Text(

            "View and manage all registered users.",

            style: TextStyle(
              color: Colors.grey,
              fontSize: 16,
            ),

          ),

          const SizedBox(height: 25),

          TextField(

            controller: searchController,

            decoration: InputDecoration(

              hintText: "Search user...",

              prefixIcon:
              const Icon(Icons.search),

              filled: true,

              fillColor: Colors.white,

              border: OutlineInputBorder(

                borderRadius:
                BorderRadius.circular(18),

                borderSide: BorderSide.none,

              ),

            ),

            onChanged: (value) {
              setState(() {});
            },

          ),

          const SizedBox(height: 25),
              Expanded(

                child: StreamBuilder<List<UserModel>>(

                  stream: _firestoreService.getUsers(),

                  builder: (context, snapshot) {

                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {

                      return const Center(
                        child: CircularProgressIndicator(),
                      );

                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.isEmpty) {

                      return const Center(
                        child: Text(
                          "No users found",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      );

                    }

                    List<UserModel> users =
                    snapshot.data!;

                    if (searchController
                        .text
                        .isNotEmpty) {

                      users = users.where((user) {

                        return user.fullName
                            .toLowerCase()
                            .contains(
                          searchController.text
                              .toLowerCase(),
                        ) ||

                            user.email
                                .toLowerCase()
                                .contains(
                              searchController.text
                                  .toLowerCase(),
                            );

                      }).toList();

                    }

                    return ListView.builder(

                      itemCount: users.length,

                      itemBuilder: (context, index) {

                        return buildUserCard(
                          users[index],
                        );

                      },

                    );

                  },

                ),

              ),

            ],

          ),

        ),

    );

  }

  Widget buildUserCard(
      UserModel user,
      ) {

    Color statusColor = Colors.green;

    return Container(

      margin:
      const EdgeInsets.only(bottom: 18),

      padding:
      const EdgeInsets.all(18),

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
        BorderRadius.circular(22),

        boxShadow: [

          BoxShadow(

            color: Colors.grey.shade200,

            blurRadius: 8,

            offset: const Offset(0, 4),

          ),

        ],

      ),

      child: Column(

        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

      Row(

      children: [

      CircleAvatar(

      radius: 28,

        backgroundColor:
        Colors.blue.withValues(
          alpha: 0.15,
        ),

        child: const Icon(
          Icons.person,
          color: Colors.blue,
        ),

      ),

      const SizedBox(width: 15),

      Expanded(

        child: Column(

          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            Text(

              user.fullName,

              style: const TextStyle(
                fontSize: 20,
                fontWeight:
                FontWeight.bold,
              ),

            ),

            const SizedBox(height: 5),

            Text(
              user.email,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

            const SizedBox(height: 3),

            Text(
              user.phone,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),

          ],

        ),

      ),

      Container(

        padding:
        const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 6,
        ),

        decoration: BoxDecoration(

          color:
          statusColor.withValues(
            alpha: 0.15,
          ),

          borderRadius:
          BorderRadius.circular(
            20,
          ),

        ),

        child: Text(

          "Active",

          style: TextStyle(

            color: statusColor,

            fontWeight:
            FontWeight.bold,

          ),

        ),

      ),

      ],

    ),

    const SizedBox(height: 20),
    Row(
    children: [

    Expanded(
    child: OutlinedButton.icon(

    icon: const Icon(Icons.visibility),

    label: const Text("View"),

    onPressed: () {

    showDialog(

    context: context,

    builder: (context) {

    return AlertDialog(

    title: const Text(
    "User Details",
    ),

    content: Column(

    mainAxisSize:
    MainAxisSize.min,

    crossAxisAlignment:
    CrossAxisAlignment.start,

    children: [

    Text(
    "Name: ${user.fullName}",
    ),

    const SizedBox(height: 10),

    Text(
    "Email: ${user.email}",
    ),

    const SizedBox(height: 10),

    Text(
    "Phone: ${user.phone}",
    ),

    const SizedBox(height: 10),

    Text(
    "Role: ${user.role}",
    ),

    ],

    ),

    actions: [

    TextButton(

    onPressed: () {

    Navigator.pop(
    context,
    );

    },

    child: const Text(
    "Close",
    ),

    ),

    ],

    );

    },

    );

    },

    ),

    ),

    const SizedBox(width: 10),
      Expanded(
        child: ElevatedButton.icon(

          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
          ),

          icon: const Icon(
            Icons.delete,
            color: Colors.white,
          ),

          label: const Text(
            "Delete",
            style: TextStyle(
              color: Colors.white,
            ),
          ),

          onPressed: () {

            showDialog(

              context: context,

              builder: (dialogContext) {

                return AlertDialog(

                  title: const Text(
                    "Delete User",
                  ),

                  content: Text(
                    "Delete ${user.fullName}?",
                  ),

                  actions: [

                    TextButton(

                      onPressed: () {

                        Navigator.pop(
                          dialogContext,
                        );

                      },

                      child: const Text(
                        "Cancel",
                      ),

                    ),

                    ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),

                      onPressed: () async {

                        final navigator = Navigator.of(dialogContext);

                        await _firestoreService.deleteUser(
                          user.uid,
                        );

                        if (!mounted) return;

                        navigator.pop();

                      },

                      child: const Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),

                    ),

                  ],

                );

              },

            );

          },

        ),

      ),

    ],

    ),

        ],

      ),

    );

  }

}