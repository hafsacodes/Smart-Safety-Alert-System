class GuardianAIService {
  static String getResponse(String question) {
    final text = question.toLowerCase().trim();

    //====================================================
    // GREETINGS
    //====================================================

    if (text == "hi" ||
        text == "hello" ||
        text == "hey" ||
        text.contains("good morning") ||
        text.contains("good evening")) {
      return "Hello! 👋 I'm Guardian AI, your personal safety assistant. I can help you with safety tips, emergency guidance, and explain how to use the Smart Safety Alert System.";
    }

    //====================================================
    // ABOUT GUARDIAN AI
    //====================================================

    if (text.contains("guardian ai") ||
        text.contains("who are you") ||
        text.contains("what are you")) {
      return "I am Guardian AI, your built-in safety assistant. I provide emergency guidance, personal safety advice, and information about the Smart Safety Alert System to help keep you safe.";
    }

    //====================================================
    // APP INTRODUCTION
    //====================================================

    if (text.contains("what does this app do") ||
        text.contains("about app") ||
        text.contains("what is this app")) {
      return "The Smart Safety Alert System helps users stay safe by providing SOS alerts, emergency contacts, incident reporting, AI-based risk analysis, safety alerts, and nearby danger information.";
    }

    //====================================================
    // SOS
    //====================================================

    if (text.contains("sos") ||
        text.contains("emergency button") ||
        text.contains("panic")) {
      return "Press the SOS button during an emergency. The app will immediately send your current location and emergency alert to your saved emergency contacts so they can assist you quickly.";
    }

    //====================================================
    // REPORT INCIDENT
    //====================================================

    if (text.contains("report") ||
        text.contains("incident")) {
      return "To report an incident, open the Report Incident screen, enter the incident details, attach an image if available, allow location access, and press Submit. Guardian AI will automatically analyze the report severity.";
    }

    //====================================================
    // MAP
    //====================================================

    if (text.contains("map") ||
        text.contains("location") ||
        text.contains("danger area")) {
      return "The Safety Map displays your current location along with approved incident reports and danger zones. It helps you avoid risky locations and choose safer routes.";
    }

    //====================================================
    // ALERTS
    //====================================================

    if (text.contains("alert") ||
        text.contains("alerts")) {
      return "The Alerts section displays approved public safety incidents reported by users. These alerts help you stay informed about dangerous activities happening nearby.";
    }

    //====================================================
    // EMERGENCY CONTACTS
    //====================================================

    if (text.contains("contact") ||
        text.contains("emergency contact")) {
      return "You can add trusted family members or friends as emergency contacts. Whenever SOS is activated, these contacts receive your emergency alert and live location.";
    }

    //====================================================
    // PROFILE
    //====================================================

    if (text.contains("profile")) {
      return "You can update your profile information, including your name, phone number, and profile picture, from the Profile screen.";
    }

    //====================================================
    // AI SEVERITY
    //====================================================

    if (text.contains("severity") ||
        text.contains("risk level") ||
        text.contains("high risk")) {
      return "Guardian AI analyzes incident descriptions and classifies them as High, Medium, or Low risk. This helps prioritize emergency situations more effectively.";
    }

    //====================================================
    // SAFE AREA
    //====================================================

    if (text.contains("safe area") ||
        text.contains("safe place") ||
        text.contains("is this area safe")) {
      return "Use the Map screen to view recent incidents nearby. Avoid isolated places, stay in well-lit public areas, and always inform someone you trust when travelling alone.";
    }

    //====================================================
    // SAFE ROUTE
    //====================================================

    if (text.contains("safe route") ||
        text.contains("safest route")) {
      return "Choose routes with more public activity and fewer reported incidents. Avoid shortcuts through isolated areas, especially at night.";
    }

    //====================================================
    // HARASSMENT
    //====================================================

    if (text.contains("harass") ||
        text.contains("harassment")) {
      return "If you are being harassed, move toward a crowded public place, avoid confrontation, contact someone you trust, and use the SOS feature immediately if you feel threatened.";
    }

    //====================================================
    // STALKING
    //====================================================

    if (text.contains("stalk") ||
        text.contains("following me")) {
      return "If someone appears to be following you, do not go home. Enter a busy public location, call someone you trust, and activate SOS if you feel unsafe.";
    }

    //====================================================
    // ROBBERY
    //====================================================

    if (text.contains("robbery") ||
        text.contains("rob") ||
        text.contains("thief")) {
      return "During a robbery, prioritize your safety over belongings. Stay calm, avoid resisting if it increases danger, move to a safe place afterward, and contact the police immediately.";
    }

    //====================================================
    // FIRE
    //====================================================

    if (text.contains("fire")) {
      return "If a fire occurs, evacuate immediately using the nearest safe exit. Avoid elevators, call emergency services, and never return inside until authorities declare the area safe.";
    }

    //====================================================
    // ACCIDENT
    //====================================================

    if (text.contains("accident")) {
      return "If you witness an accident, ensure your own safety first, call emergency services, provide first aid only if trained, and report the incident using the app if appropriate.";
    }

    //====================================================
    // MEDICAL EMERGENCY
    //====================================================

    if (text.contains("medical") ||
        text.contains("ambulance")) {
      return "For medical emergencies, call your local emergency medical service immediately. Stay with the injured person if it is safe to do so and provide basic first aid if you are trained.";
    }

    //====================================================
    // SUSPICIOUS PERSON
    //====================================================

    if (text.contains("suspicious")) {
      return "If you notice suspicious activity, avoid approaching the individual, move to a safe location, observe from a distance if possible, and report the incident through the app.";
    }
    //====================================================
    // WOMEN SAFETY
    //====================================================

    if (text.contains("women") ||
        text.contains("girl safety") ||
        text.contains("female safety")) {
      return "Stay in well-lit public places, avoid isolated areas, share your live location with someone you trust, and use the SOS feature immediately if you feel threatened.";
    }

    //====================================================
    // NIGHT SAFETY
    //====================================================

    if (text.contains("night") ||
        text.contains("late night")) {
      return "Avoid walking alone late at night whenever possible. Choose well-lit roads, stay alert, avoid distractions like headphones, and inform a trusted person about your journey.";
    }

    //====================================================
    // KIDNAPPING
    //====================================================

    if (text.contains("kidnap") ||
        text.contains("abduction")) {
      return "If you believe someone is attempting to abduct you, make as much noise as possible, run toward crowded places, activate SOS immediately, and call emergency services.";
    }

    //====================================================
    // POLICE
    //====================================================

    if (text.contains("police") ||
        text.contains("call police")) {
      return "If you are in immediate danger or witness a serious crime, contact your local police immediately. Use the SOS feature while waiting for assistance.";
    }

    //====================================================
    // HELP
    //====================================================

    if (text.contains("help") ||
        text.contains("i am scared") ||
        text.contains("i need help")) {
      return "Stay calm. Move to a safe public location, contact someone you trust, activate the SOS feature if necessary, and call emergency services if you are in immediate danger.";
    }

    //====================================================
    // AI RECOMMENDATION
    //====================================================

    if (text.contains("ai recommendation") ||
        text.contains("recommendation")) {
      return "Guardian AI analyzes your incident description and provides safety recommendations based on the detected risk level to help you respond appropriately.";
    }

    //====================================================
    // SAFE TRAVEL
    //====================================================

    if (text.contains("travel") ||
        text.contains("journey")) {
      return "Before travelling, share your route with a trusted person, keep your phone charged, avoid isolated shortcuts, and monitor nearby alerts using the Safety Map.";
    }

    //====================================================
    // EMERGENCY NUMBERS
    //====================================================

    if (text.contains("emergency number") ||
        text.contains("helpline")) {
      return "In an emergency, contact your local police, ambulance, or fire department immediately. You can also activate the SOS feature to notify your emergency contacts.";
    }

    //====================================================
    // THANK YOU
    //====================================================

    if (text.contains("thank")) {
      return "You're welcome! Stay safe, and remember that Guardian AI is always here to provide safety guidance and explain the features of the Smart Safety Alert System.";
    }

    //====================================================
    // GOODBYE
    //====================================================

    if (text.contains("bye") ||
        text.contains("goodbye")) {
      return "Goodbye! Stay safe and take care. If you ever need safety guidance or help using the Smart Safety Alert System, I'm here for you.";
    }

    //====================================================
    // DEFAULT RESPONSE
    //====================================================

    return "I'm Guardian AI, your personal safety assistant. I can answer questions about:\n\n"
        "• Personal Safety\n"
        "• Emergency Guidance\n"
        "• SOS Feature\n"
        "• Incident Reporting\n"
        "• Safety Map\n"
        "• Public Alerts\n"
        "• Emergency Contacts\n"
        "• AI Risk Analysis\n"
        "• Smart Safety Alert System\n\n"
        "Please ask a question related to safety or this application.";

  }
}