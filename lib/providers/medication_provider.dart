import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/medication.dart';
import '../services/firestore_service.dart';

final medicationProvider = StreamProvider<List<Medication>>((ref) {
  return firestoreService.streamMedications();
});
