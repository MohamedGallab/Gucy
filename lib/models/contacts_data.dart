

class Contacts {
  String? id;
  String name;
  String phoneNumber;

  Contacts({this.id, required this.name, required this.phoneNumber });

  Map<String, dynamic> toJson() => {'id': id, 'name': name, 'phoneNumber': phoneNumber};

  static Contacts fromJson(Map<String, dynamic> json) =>
      Contacts(id: json['id'], name: json['name'], phoneNumber: json['phoneNumber'] );
}