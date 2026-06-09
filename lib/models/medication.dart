class Medication {
  final String id;
  final String name;
  final String dosage;
  final String time;
  final bool isCompleted;
  final DateTime? startDate;
  final DateTime? endDate;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    this.isCompleted = false,
    this.startDate,
    this.endDate,
  });

  Medication copyWith({
    String? id,
    String? name,
    String? dosage,
    String? time,
    bool? isCompleted,
    DateTime? startDate,
    DateTime? endDate,
  }) {
    return Medication(
      id: id ?? this.id,
      name: name ?? this.name,
      dosage: dosage ?? this.dosage,
      time: time ?? this.time,
      isCompleted: isCompleted ?? this.isCompleted,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dosage': dosage,
      'time': time,
      'isCompleted': isCompleted,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
    };
  }

  factory Medication.fromMap(Map<String, dynamic> map, String documentId) {
    return Medication(
      id: documentId,
      name: map['name'] ?? '',
      dosage: map['dosage'] ?? '',
      time: map['time'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      startDate: map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
    );
  }
}
