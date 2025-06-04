class User {
  final String email;
  final String fullName;
  final bool isActive;
  final DateTime? createdAt;
  final DateTime? updatedAt;


  User({
    required this.email,
    required this.fullName,
    required this.isActive,
    this.createdAt,
    this.updatedAt,

  });

  // Converte User para Map (útil para armazenar em shared_preferences)
  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'fullName': fullName,
      'isActive': isActive,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  // Cria User a partir de um Map (útil para ler de shared_preferences)
  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      email: map['email'] ?? '',
      fullName: map['fullName'] ?? '',
      isActive: map['isActive'] ?? false,
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : null,
      updatedAt: map['updatedAt'] != null ? DateTime.parse(map['updatedAt']) : null,
    );
  }

  // Cria User a partir de um JSON (resposta da API)
  factory User.fromJson(Map<String, dynamic> json, String token) {
    return User(
      email: json['email'] as String,
      fullName: json['full_name'] as String? ?? '', // note o underscore, pois em backend está full_name
      isActive: json['is_active'] as bool? ?? false,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null,
    );
  }
}
