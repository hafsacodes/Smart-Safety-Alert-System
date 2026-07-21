import 'package:flutter/material.dart';

class GuardianAiScreen extends StatefulWidget {
  const GuardianAiScreen({super.key});

  @override
  State<GuardianAiScreen> createState() => _GuardianAiScreenState();
}

class _GuardianAiScreenState extends State<GuardianAiScreen> {
  final TextEditingController messageController =
  TextEditingController();

  final List<Map<String, dynamic>> messages = [
    {
      "isUser": false,
      "message":
      "Hello! 👋 I am Guardian AI.\n\nI'm here to help you stay safe.\n\nAsk me anything related to personal safety, emergency guidance, safe routes or nearby danger."
    }
  ];

  void askQuestion(String question) {
    setState(() {
      messages.add({
        "isUser": true,
        "message": question,
      });

      messages.add({
        "isUser": false,
        "message":
        "This is a demo response.\nLater this answer will come from Google Gemini AI."
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
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        title: const Text(
          "Guardian AI",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Column(
        children: [

        // AI HEADER

        Container(
        width: double.infinity,
        color: Colors.white,
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            CircleAvatar(
              radius: 40,
              backgroundColor:
              const Color(0xFF1565FF),

              child: const Icon(
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
              "Ask anything related to your safety.",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 10),

      // SUGGESTED QUESTIONS

      SizedBox(
        height: 50,

        child: ListView(
          scrollDirection: Axis.horizontal,

          padding:
          const EdgeInsets.symmetric(horizontal: 15),

          children: [

            questionChip(
                "Is this area safe?"),

            questionChip(
                "Safest route nearby"),

            questionChip(
                "Emergency tips"),

            questionChip(
                "Nearby danger"),

            questionChip(
                "Call police?"),

          ],
        ),
      ),

      const SizedBox(height: 10),

      // CHAT AREA

      Expanded(
        child: ListView.builder(
          padding: const EdgeInsets.all(15),

          itemCount: messages.length,

          itemBuilder: (context, index) {

            bool isUser =
            messages[index]["isUser"];

            return Align(
              alignment: isUser
                  ? Alignment.centerRight
                  : Alignment.centerLeft,

              child: Container(
                margin:
                const EdgeInsets.only(bottom: 12),

                padding: const EdgeInsets.all(15),

                constraints:
                const BoxConstraints(
                  maxWidth: 300,
                ),

                decoration: BoxDecoration(
                  color: isUser
                      ? const Color(0xFF1565FF)
                      : Colors.white,

                  borderRadius:
                  BorderRadius.circular(18),
                ),

                child: Text(
                  messages[index]["message"],

                  style: TextStyle(
                    color: isUser
                        ? Colors.white
                        : Colors.black87,
                    fontSize: 15,
                  ),
                ),
              ),
            );
          },
        ),
      ),          // MESSAGE INPUT

          Container(
            padding: const EdgeInsets.all(15),
            color: Colors.white,

            child: Row(
              children: [

                Expanded(
                  child: TextField(
                    controller: messageController,

                    decoration: InputDecoration(
                      hintText: "Ask Guardian AI...",

                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),

                      filled: true,
                      fillColor:
                      Colors.grey.shade100,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                CircleAvatar(
                  radius: 26,
                  backgroundColor:
                  const Color(0xFF1565FF),

                  child: IconButton(
                    icon: const Icon(
                      Icons.send,
                      color: Colors.white,
                    ),

                    onPressed: () {

                      if (messageController
                          .text
                          .trim()
                          .isEmpty) {
                        return;
                      }

                      askQuestion(
                          messageController.text);

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

  //==========================
  // QUESTION CHIP
  //==========================

  Widget questionChip(String question) {

    return Padding(
      padding: const EdgeInsets.only(right: 10),

      child: ActionChip(

        backgroundColor:
        const Color(0xFF1565FF),

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