import 'dart:io';

import '../models/admin_stats.dart';
import '../models/pending_product.dart';

abstract class AdminRepository {
  Stream<List<PendingProduct>> watchPendingProducts();
  Future<void> submitPendingProduct({
    required String createdBy,
    required String name,
    required String notes,
    required String gender,
    required String ethnicity,
    required String ageGroup,
    required File imageFile,
    String? scanObjPath, // Optional: local path to OBJ file from LiDAR scan
  });

  Future<void> approvePendingProduct({required String id, required String approvedBy});
  Future<void> rejectPendingProduct({required String id, required String rejectedBy});

  Future<AdminStats> getStats();

  /// Called after LiDAR scan returns a local OBJ path.
  Future<void> saveScanObj({required String createdBy, required String localObjPath});
}

