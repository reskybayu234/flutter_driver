class Driver {
  final String id;
  String name;
  final String driverID;
  String status;
  String email;
  String phone;

  Driver({
    required this.id,
    required this.name,
    required this.driverID,
    this.status = '',
    this.email = '',
    this.phone = '',
  });

  factory Driver.fromJson(Map<String, dynamic> json) {
    return Driver(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      driverID: json['driverID'] ?? '',
      status: json['status'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'driverID': driverID,
      'status': status,
      'email': email,
      'phone': phone,
    };
  }
}