

class Contacts {
  String? id;
  String name;
  String phoneNumber;
  bool  isEmergency;

  Contacts({this.id, required this.name, required this.phoneNumber ,required this.isEmergency});

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'phoneNumber': phoneNumber , 'isEmergency':isEmergency};

  static Contacts fromJson(Map<String, dynamic> json) =>
      Contacts(id: json['id'], name: json['name'], phoneNumber: json['phoneNumber'] , isEmergency: json['isEmergency']);
}