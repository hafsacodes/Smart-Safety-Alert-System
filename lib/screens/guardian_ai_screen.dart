import 'package:flutter/material.dart';
import '../services/guardian_ai_service.dart';

class GuardianAiScreen extends StatefulWidget {
  const GuardianAiScreen({super.key});

  @override
  State<GuardianAiScreen> createState() => _GuardianAiScreenState();
}

class _GuardianAiScreenState extends State<GuardianAiScreen> {
  final TextEditingController messageController = TextEditingController();

  final List<Map<String, dynamic>> messages = [
    {
      "isUser": false,
      "message":
      "Hello! 👋 I am Guardian AI.\n\nI'm your personal safety assistant.\n\nAsk me anything about:\n\n• Personal Safety\n• SOS\n• Incident Reporting\n• Emergency Contacts\n• Safety Map\n• Public Alerts\n• Safe Routes\n• Emergency Guidance",
    }
  ];

  void askQuestion(String question) {
    final response = GuardianAIService.getResponse(question);

    setState(() {
      messages.add({
        "isUser": true,
        "message": question,
      });

      messages.add({
        "isUser": false,
        "message": response,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
        title: const Text(
          "Guardian AI",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      body: Column(
        children: [

        //=========================
        // HEADER
        //=========================

        Container(
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            const CircleAvatar(
              radius: 40,
              backgroundColor: Color(0xFF1565FF),
              child: Icon(
                Icons.smart_toy,
                color: Colors.white,
                size: 45,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              "Guardian AI Assistant",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              "Ask me anything related to your safety or this application.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),

      const SizedBox(height: 10),

      //=========================
      // SUGGESTED QUESTIONS
      //=========================

      SizedBox(
        height: 50,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 15),

          children: [

            questionChip("How do I use SOS?"),

            questionChip("Report an incident"),

            questionChip("Emergency tips"),

            questionChip("Is this area safe?"),

            questionChip("Safe route"),

            questionChip("Emergency contacts"),

            questionChip("Women's safety"),
          ],
        ),
      ),

      const SizedBox(height: 10),

      //=========================
      // CHAT AREA
      //=========================

      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(15),

          itemCount: messages.length,

          itemBuilder: (context, index) {

            final bool isUser = messages[index]["isUser"];

            return Align(
              alignment: isUser
                  ? Alignment.centerRight
                  : Alignment.centerLeft,

              child: Container(
                margin: const EdgeInsets.only(bottom: 12),

                padding: const EdgeInsets.all(15),

                constraints: const BoxConstraints(
                  maxWidth: 320,
                ),

                decoration: BoxDecoration(
                  color: isUser
                      ? const Color(0xFF1565FF)
                      : Colors.white,

                  borderRadius: BorderRadius.circular(18),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade200,
                      blurRadius: 5,
                    )
                  ],
                ),

                child: Text(
                  messages[index]["message"],
                  style: TextStyle(
                    color: isUser
                        ? Colors.white
                        : Colors.black87,
                    fontSize: 15,
                    height: 1.5,
                  ),
                ),
              ),
            );
          },
        ),
      ),

    // MESSAGE INPUT CONTAINER STARTS HERE
          //=========================
          // MESSAGE INPUT
          //=========================

          Container(
            padding: const EdgeInsets.all(15),
            color: Colors.white,
            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: messageController,

                    textInputAction: TextInputAction.send,

                    onSubmitted: (value) {
                      if (value.trim().isEmpty) return;

                      askQuestion(value.trim());

                      messageController.clear();
                    },

                    decoration: InputDecoration(
                      hintText: "Ask Guardian AI...",

                      filled: true,
                      fillColor: Colors.grey.shade100,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),

                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 15,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                CircleAvatar(
                  radius: 26,
                  backgroundColor: const Color(0xFF1565FF),

                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),

                    onPressed: () {

                      if (messageController.text.trim().isEmpty) {
                        return;
                      }

                      askQuestion(
                        messageController.text.trim(),
                      );

                      messageController.clear();
                    },
                  ),
                ),

              ],
            ),
          ),

        ],
      ),
    );
  }

  //==========================================
  // QUESTION CHIP
  //==========================================

  Widget questionChip(String question) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),

      child: ActionChip(

        backgroundColor: const Color(0xFF1565FF),

        label: Text(
          question,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),

        onPressed: () {
          askQuestion(question);
        },
      ),
    );
  }

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }
}