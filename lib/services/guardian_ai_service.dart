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
text.contains("what is this app") ||
text.contains("purpose of the app") ||
text.contains("how does this app help")) {
return "The Smart Safety Alert System helps users stay safe by providing SOS alerts, emergency contacts, incident reporting, AI-based risk analysis, safety alerts, and nearby danger information.";
}

//====================================================
// HOW TO USE THE APP
//====================================================

if (text.contains("how do i use this app") ||
text.contains("how to use the app") ||
text.contains("how can i use this app")) {
return "You can use the app to send SOS alerts, report incidents, check safety alerts, view nearby incidents on the Safety Map, manage emergency contacts, and get safety guidance from Guardian AI.";
}

//====================================================
// WHAT TO DO IN DANGER
//====================================================

if (text.contains("what should i do if i am in danger") ||
text.contains("what to do if i am in danger") ||
text.contains("i am in danger") ||
text.contains("danger what should i do")) {
return "If you are in immediate danger, stay calm and move toward a safe public place if possible. Activate the SOS feature, contact someone you trust, share your location, and contact local emergency services when necessary.";
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
// WHAT HAPPENS AFTER SOS
//====================================================

if (text.contains("what happens after sos") ||
text.contains("what happens when i send sos") ||
text.contains("after pressing sos") ||
text.contains("after i press sos")) {
return "When SOS is activated, the app creates an emergency alert and uses your available location information to help notify your saved emergency contacts. Stay in a safe place and contact emergency services if the situation requires immediate assistance.";
}

//====================================================
// ACCIDENTAL SOS
//====================================================

if (text.contains("accidentally send sos") ||
text.contains("accidentally pressed sos") ||
text.contains("wrongly pressed sos") ||
text.contains("false sos")) {
return "If you activate SOS accidentally, stay calm and inform your emergency contacts that it was accidental. If the alert has already been created, check your Alerts section and follow the available options in the app.";
}

//====================================================
// REPORT INCIDENT
//====================================================

if (text.contains("how do i report") ||
text.contains("how to report") ||
text.contains("report an incident") ||
text.contains("report incident")) {
return "To report an incident, open the Report Incident screen, enter the incident details, attach an image if available, allow location access, and press Submit. Guardian AI will automatically analyze the report severity.";
}

//====================================================
// ANONYMOUS REPORT
//====================================================

if (text.contains("anonymous") ||
text.contains("report anonymously") ||
text.contains("anonymous report")) {
return "If the Incident Reporting feature provides the anonymous reporting option, you can enable it before submitting your report. This allows the report to be shared without publicly displaying your identity.";
}

//====================================================
// INCIDENT IMAGE
//====================================================

if (text.contains("attach image") ||
text.contains("add image") ||
text.contains("photo to report") ||
text.contains("picture to report")) {
return "You can attach an image to an incident report when you have relevant visual evidence. Only upload an image that is safe and appropriate to share.";
}

//====================================================
// AFTER REPORTING
//====================================================

if (text.contains("what happens after reporting") ||
text.contains("after i report") ||
text.contains("after submitting report") ||
text.contains("what happens to my report")) {
return "After you submit an incident report, it is stored in the system for review. The incident information can be analyzed for its threat level and, when approved by the admin, can become visible as a public safety alert.";
}

//====================================================
// DELETE REPORT
//====================================================

if (text.contains("delete my report") ||
text.contains("remove my report") ||
text.contains("delete incident")) {
return "You can delete your own incident reports through the available options in the Alerts section. Only delete a report when you are sure it is no longer needed.";
}

//====================================================
// MAP
//====================================================

if (text.contains("safety map") ||
text.contains("what is the map") ||
text.contains("how does the map work")) {
return "The Safety Map displays your current location along with approved incident reports and danger zones. It helps you understand safety conditions around different locations.";
}

//====================================================
// CURRENT LOCATION
//====================================================

if (text.contains("current location") ||
text.contains("where am i") ||
text.contains("my location")) {
return "The app can use your device location to help provide location-based safety features. Make sure location permission is enabled so the app can access your current position when required.";
}

//====================================================
// LOCATION NOT WORKING
//====================================================

if (text.contains("location is not working") ||
text.contains("location not working") ||
text.contains("cannot get location") ||
text.contains("location unavailable")) {
return "If your location is not working, make sure your phone's Location service is enabled and that the app has permission to access your location. You can also check your internet connection and try again.";
}

//====================================================
// ALERTS
//====================================================

if (text.contains("what are alerts") ||
text.contains("what is an alert") ||
text.contains("public alerts") ||
text.contains("nearby alerts")) {
return "The Alerts section displays safety incidents and SOS alerts available to users. Nearby alerts can help you stay informed about potentially dangerous situations around you.";
}

//====================================================
// MY ALERTS
//====================================================

if (text.contains("my alerts") ||
text.contains("my previous alerts") ||
text.contains("view my alerts")) {
return "The My Alerts section allows you to view alerts associated with your activity. You can review your submitted safety information and available alert details there.";
}

//====================================================
// THREAT LEVELS
//====================================================

if (text.contains("threat level") ||
text.contains("risk level") ||
text.contains("severity")) {
return "Guardian AI analyzes incident descriptions and classifies them as High, Medium, or Low risk. This helps identify the seriousness of reported incidents and prioritize safety situations.";
}

//====================================================
// HIGH THREAT
//====================================================

if (text.contains("high threat") ||
text.contains("high risk") ||
text.contains("high severity")) {
return "A High threat level indicates that an incident may represent a serious safety concern. Move to a safe location, avoid the dangerous situation, and contact emergency services if you are in immediate danger.";
}

//====================================================
// MEDIUM THREAT
//====================================================

if (text.contains("medium threat") ||
text.contains("medium risk") ||
text.contains("medium severity")) {
return "A Medium threat level indicates a situation that may require caution. Stay alert, avoid unnecessary exposure to the area, and consider choosing a safer route.";
}

//====================================================
// LOW THREAT
//====================================================

if (text.contains("low threat") ||
text.contains("low risk") ||
text.contains("low severity")) {
return "A Low threat level indicates a lower level of reported risk. However, you should still remain aware of your surroundings and follow normal safety precautions.";
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
text.contains("safest route") ||
text.contains("which route is safe")) {
return "Choose routes with more public activity and fewer reported incidents. Avoid shortcuts through isolated areas, especially at night, and check the Safety Map before travelling.";
}

//====================================================
// EMERGENCY CONTACTS
//====================================================

if (text.contains("emergency contact") ||
text.contains("trusted contact") ||
text.contains("emergency contacts")) {
return "You can add trusted family members or friends as emergency contacts. Whenever SOS is activated, these contacts can receive your emergency alert and available location information.";
}

//====================================================
// ADD EMERGENCY CONTACT
//====================================================

if (text.contains("add emergency contact") ||
text.contains("add a contact") ||
text.contains("add trusted contact")) {
return "Open the Emergency Contacts or My Contact section of the app and add a trusted family member or friend. Choose someone who can respond quickly during an emergency.";
}

//====================================================
// PROFILE
//====================================================

if (text.contains("profile") ||
text.contains("edit my profile") ||
text.contains("change profile")) {
return "You can update your profile information, including your name, phone number, and profile picture, from the Profile screen.";
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
text.contains("following me") ||
text.contains("someone is following")) {
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
// SUSPICIOUS PERSON
//====================================================

if (text.contains("suspicious person") ||
text.contains("suspicious activity") ||
text.contains("suspicious")) {
return "If you notice suspicious activity, avoid approaching the individual, move to a safe location, observe from a distance if possible, and report the incident through the app.";
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
text.contains("ambulance") ||
text.contains("injured")) {
return "For medical emergencies, contact your local emergency medical service immediately. Stay with the injured person if it is safe to do so and provide basic first aid if you are trained.";
}

//====================================================
// WOMEN SAFETY
//====================================================

if (text.contains("women") ||
text.contains("girl safety") ||
text.contains("female safety")) {
return "Stay in well-lit public places, avoid isolated areas, share your location with someone you trust, and use the SOS feature immediately if you feel threatened.";
}

//====================================================
// NIGHT SAFETY
//====================================================

if (text.contains("night") ||
text.contains("late night")) {
return "Avoid walking alone late at night whenever possible. Choose well-lit roads, stay alert, avoid distractions like headphones, and inform a trusted person about your journey.";
}

//====================================================
// TRAVEL SAFETY
//====================================================

if (text.contains("travel") ||
text.contains("journey") ||
text.contains("travelling alone")) {
return "Before travelling, share your route with a trusted person, keep your phone charged, avoid isolated shortcuts, and monitor nearby alerts using the Safety Map.";
}

//====================================================
// KIDNAPPING
//====================================================

if (text.contains("kidnap") ||
text.contains("abduction")) {
return "If you believe someone is attempting to abduct you, move toward a crowded and safe place, attract attention if possible, activate SOS immediately, and contact emergency services.";
}

//====================================================
// POLICE
//====================================================

if (text.contains("police") ||
text.contains("call police")) {
return "If you are in immediate danger or witness a serious crime, contact your local police immediately. Use the SOS feature while waiting for assistance.";
}

//====================================================
// EMERGENCY NUMBERS
//====================================================

if (text.contains("emergency number") ||
text.contains("helpline")) {
return "In an emergency, contact your local police, ambulance, or fire department immediately. You can also activate the SOS feature to notify your emergency contacts.";
}

//====================================================
// GENERAL SAFETY TIPS
//====================================================

if (text.contains("safety tips") ||
text.contains("safety advice") ||
text.contains("how can i stay safe") ||
text.contains("how to stay safe") ||
text.contains("personal safety")) {
return "For better personal safety, stay aware of your surroundings, avoid isolated areas, keep your phone charged, share your plans with someone you trust, check nearby alerts, and use SOS whenever you face an immediate threat.";
}

//====================================================
// PUBLIC PLACE SAFETY
//====================================================

if (text.contains("public place") ||
text.contains("crowded place") ||
text.contains("public safety")) {
return "In public places, stay aware of your surroundings, keep your belongings secure, avoid unnecessary confrontations, and move toward trusted people or security staff if you feel threatened.";
}

//====================================================
// PHONE SAFETY
//====================================================

if (text.contains("phone safety") ||
text.contains("phone charged") ||
text.contains("battery")) {
return "Keep your phone charged and make sure location services are available when you are travelling or entering an unfamiliar area. A charged phone can help you contact trusted people or emergency services.";
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
return "Guardian AI can provide safety guidance based on the information provided about an incident. Its purpose is to help users understand the situation and choose safer actions.";
}

//====================================================
// WHY REPORT INCIDENT
//====================================================

if (text.contains("why report") ||
text.contains("why should i report") ||
text.contains("benefit of reporting")) {
return "Reporting incidents helps create awareness about safety problems in the community. Approved reports can appear as public safety information and help other users make safer decisions.";
}

//====================================================
// WHAT IF I SEE AN INCIDENT
//====================================================

if (text.contains("witness an incident") ||
text.contains("see an incident") ||
text.contains("witness a crime")) {
return "If you witness an incident, keep yourself safe first. Do not put yourself in unnecessary danger. If appropriate, move to a safe place and report the incident through the app or contact the relevant emergency service.";
}

//====================================================
// THANK YOU
//====================================================

if (text.contains("thank")) {
return "You're welcome! Stay safe, and remember that Guardian AI is here to provide safety guidance and explain the features of the Smart Safety Alert System.";
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

return "I'm Guardian AI, your personal safety assistant. I can help you with questions about:\n\n"
"• Personal Safety\n"
"• Emergency Guidance\n"
"• SOS Feature\n"
"• Incident Reporting\n"
"• Safety Map\n"
"• Public Alerts\n"
"• Emergency Contacts\n"
"• Threat Levels\n"
"• Safe Routes\n"
"• Women's Safety\n"
"• Travel Safety\n"
"• Smart Safety Alert System\n\n"
"Please ask me a question related to safety or this application.";
}
}
