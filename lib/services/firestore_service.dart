import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/medication.dart';
import '../models/user_profile.dart';
import '../models/activity_log.dart';
import '../models/reminder.dart';
import 'auth_service.dart';
import 'notification_service.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? get _uid => authService.currentUserId;

  // Collection references
  CollectionReference get _usersRef => _db.collection('users');
  DocumentReference get _currentUserDoc {
    if (_uid == null) throw Exception("User not authenticated");
    return _usersRef.doc(_uid);
  }
  
  CollectionReference get _medicationsRef => _currentUserDoc.collection('medications');
  CollectionReference get _logsRef => _currentUserDoc.collection('logs');
  CollectionReference get _remindersRef => _currentUserDoc.collection('reminders');

  // --- User Profile ---
  Future<void> saveUserProfile(UserProfile profile) async {
    await _usersRef.doc(profile.id).set(profile.toMap(), SetOptions(merge: true));
  }

  Stream<UserProfile?> streamUserProfile() {
    if (_uid == null) return Stream.value(null);
    return _usersRef.doc(_uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) return null;
      return UserProfile.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    });
  }

  // --- Medications ---
  Future<void> addMedication(Medication med) async {
    await _medicationsRef.doc(med.id).set(med.toMap());
    await notificationService.scheduleMedicationReminder(med.id, med.name, med.time);
  }

  Future<void> updateMedication(Medication med) async {
    await _medicationsRef.doc(med.id).update(med.toMap());
    await notificationService.scheduleMedicationReminder(med.id, med.name, med.time);
  }

  Future<void> deleteMedication(String id) async {
    await _medicationsRef.doc(id).delete();
    await notificationService.cancelReminder(id);
  }

  Stream<List<Medication>> streamMedications() {
    if (_uid == null) return Stream.value([]);
    return _medicationsRef
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Medication.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // --- Activity Logs ---
  Future<void> addActivityLog(ActivityLog log) async {
    await _logsRef.doc(log.id).set(log.toMap());
  }

  Stream<List<ActivityLog>> streamActivityLogs() {
    if (_uid == null) return Stream.value([]);
    return _logsRef
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ActivityLog.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }

  // --- Reminders ---
  Future<void> addReminder(Reminder reminder) async {
    await _remindersRef.doc(reminder.id).set(reminder.toMap());
  }

  Future<void> updateReminder(Reminder reminder) async {
    await _remindersRef.doc(reminder.id).update(reminder.toMap());
  }

  Future<void> deleteReminder(String id) async {
    await _remindersRef.doc(id).delete();
  }

  Stream<List<Reminder>> streamReminders() {
    if (_uid == null) return Stream.value([]);
    return _remindersRef
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Reminder.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList());
  }
}

final firestoreService = FirestoreService();
