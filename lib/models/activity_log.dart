class ActivityLog {
  final String id;
  final String title;
  final String description;
  final DateTime timestamp;
  final String type; // e.g., 'medication_taken', 'medication_missed', 'emergency'

  ActivityLog({
    required this.id,
    required this.title,
    required this.description,
    required this.timestamp,
    required this.type,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'timestamp': timestamp.toIso8601String(),
      'type': type,
    };
  }

  factory ActivityLog.fromMap(Map<String, dynamic> map, String documentId) {
    return ActivityLog(
      id: documentId,
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      timestamp: map['timestamp'] != null ? DateTime.parse(map['timestamp']) : DateTime.now(),
      type: map['type'] ?? 'general',
    );
  }
}
