class User {
  final String id;
  final String name;
  final String email;
  final String department;
  final String role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.department,
    required this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      department: json['department'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'department': department,
      'role': role,
    };
  }
}
