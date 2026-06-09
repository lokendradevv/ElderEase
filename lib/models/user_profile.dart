class UserProfile {
  final String id;
  final String name;
  final String role; // 'elder' or 'caregiver'
  final String? caregiverId; // If elder, link to caregiver
  final String? age;
  final String? bloodGroup;
  final String? caregiverName;
  final String? caregiverLineUserId;

  UserProfile({
    required this.id,
    required this.name,
    required this.role,
    this.caregiverId,
    this.age,
    this.bloodGroup,
    this.caregiverName,
    this.caregiverLineUserId,
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? role,
    String? caregiverId,
    String? age,
    String? bloodGroup,
    String? caregiverName,
    String? caregiverLineUserId,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      role: role ?? this.role,
      caregiverId: caregiverId ?? this.caregiverId,
      age: age ?? this.age,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      caregiverName: caregiverName ?? this.caregiverName,
      caregiverLineUserId: caregiverLineUserId ?? this.caregiverLineUserId,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'caregiverId': caregiverId,
      'age': age,
      'bloodGroup': bloodGroup,
      'caregiverName': caregiverName,
      'caregiverLineUserId': caregiverLineUserId,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map, String documentId) {
    return UserProfile(
      id: documentId,
      name: map['name'] ?? '',
      role: map['role'] ?? 'elder',
      caregiverId: map['caregiverId'],
      age: map['age'],
      bloodGroup: map['bloodGroup'],
      caregiverName: map['caregiverName'],
      caregiverLineUserId: map['caregiverLineUserId'],
    );
  }
}
