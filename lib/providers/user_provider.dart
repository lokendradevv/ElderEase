import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile.dart';
import '../services/firestore_service.dart';

final userProvider = StreamProvider<UserProfile?>((ref) {
  return firestoreService.streamUserProfile();
});
