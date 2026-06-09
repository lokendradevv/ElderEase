import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity_log.dart';
import '../services/firestore_service.dart';

final activityLogProvider = StreamProvider<List<ActivityLog>>((ref) {
  return firestoreService.streamActivityLogs();
});
