class ContactModel {
  final String id;
  final String name;
  final String phone;
  final String relationship;

  ContactModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.relationship,
  });

  factory ContactModel.fromMap(
      Map<String, dynamic> map,
      String documentId,
      ) {
    return ContactModel(
      id: documentId,
      name: map["name"] ?? "",
      phone: map["phone"] ?? "",
      relationship: map["relationship"] ?? "",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "name": name,
      "phone": phone,
      "relationship": relationship,
    };
  }
}