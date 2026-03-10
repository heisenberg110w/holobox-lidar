import 'dart:async';
import 'dart:io';

import 'package:uuid/uuid.dart';

import '../models/admin_stats.dart';
import '../models/pending_product.dart';
import 'admin_repository.dart';

class DemoAdminRepository implements AdminRepository {
  final _uuid = const Uuid();
  final _pending = <PendingProduct>[];
  final _pendingStream = StreamController<List<PendingProduct>>.broadcast();

  int _approvedProducts = 0;
  int _scans = 0;

  DemoAdminRepository() {
    // Seed a couple items so you can see UI immediately.
    _pending.addAll([
      PendingProduct(
        id: _uuid.v4(),
        name: 'Demo Jacket',
        notes: 'Sample pending product',
        gender: 'Unisex',
        ethnicity: 'Asian',
        ageGroup: '18-24',
        submittedAt: DateTime.now().subtract(const Duration(hours: 2)),
        imageUrl: null,
      ),
      PendingProduct(
        id: _uuid.v4(),
        name: 'Demo Sneakers',
        notes: '',
        gender: 'Male',
        ethnicity: 'White',
        ageGroup: '25-34',
        submittedAt: DateTime.now().subtract(const Duration(hours: 5)),
        imageUrl: null,
      ),
    ]);
    _emit();
  }

  void _emit() {
    _pending.sort((a, b) => b.submittedAt.compareTo(a.submittedAt));
    _pendingStream.add(List.unmodifiable(_pending));
  }

  @override
  Stream<List<PendingProduct>> watchPendingProducts() => _pendingStream.stream;

  @override
  Future<void> submitPendingProduct({
    required String createdBy,
    required String name,
    required String notes,
    required String gender,
    required String ethnicity,
    required String ageGroup,
    required File imageFile,
    String? scanObjPath,
  }) async {
    // Simulate network delay.
    await Future.delayed(const Duration(milliseconds: 600));
    _pending.add(
      PendingProduct(
        id: _uuid.v4(),
        name: name,
        notes: notes,
        gender: gender,
        ethnicity: ethnicity,
        ageGroup: ageGroup,
        submittedAt: DateTime.now(),
        imageUrl: null,
        scanUrl: scanObjPath != null ? 'demo://scan.obj' : null,
      ),
    );
    _emit();
  }

  @override
  Future<void> approvePendingProduct({required String id, required String approvedBy}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _pending.removeWhere((p) => p.id == id);
    _approvedProducts++;
    _emit();
  }

  @override
  Future<void> rejectPendingProduct({required String id, required String rejectedBy}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _pending.removeWhere((p) => p.id == id);
    _emit();
  }

  @override
  Future<AdminStats> getStats() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return AdminStats(
      totalProducts: _approvedProducts,
      pendingApprovals: _pending.length,
      totalScans: _scans,
    );
  }

  @override
  Future<void> saveScanObj({required String createdBy, required String localObjPath}) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _scans++;
  }

  void dispose() {
    _pendingStream.close();
  }
}

