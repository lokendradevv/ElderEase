class Reminder {
  final String id;
  final String title;
  final String time; 
  final bool isEnabled;

  Reminder({
    required this.id,
    required this.title,
    required this.time,
    this.isEnabled = true,
  });

  Reminder copyWith({
    String? id,
    String? title,
    String? time,
    bool? isEnabled,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      time: time ?? this.time,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'time': time,
      'isEnabled': isEnabled,
    };
  }

  factory Reminder.fromMap(Map<String, dynamic> map, String documentId) {
    return Reminder(
      id: documentId,
      title: map['title'] ?? '',
      time: map['time'] ?? '',
      isEnabled: map['isEnabled'] ?? true,
    );
  }
}
