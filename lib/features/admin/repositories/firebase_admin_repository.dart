import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

import '../models/admin_stats.dart';
import '../models/pending_product.dart';
import 'admin_repository.dart';

class FirebaseAdminRepository implements AdminRepository {
  final _uuid = const Uuid();

  @override
  Stream<List<PendingProduct>> watchPendingProducts() {
    return FirebaseFirestore.instance
        .collection('pending_products')
        .where('status', isEqualTo: 'pending')
        .orderBy('submittedAt', descending: true)
        .snapshots()
        .map((snap) {
      return snap.docs.map((d) {
        final data = d.data();
        return PendingProduct(
          id: d.id,
          name: (data['name'] ?? '').toString(),
          notes: data['notes']?.toString(),
          gender: (data['gender'] ?? '').toString(),
          ethnicity: (data['ethnicity'] ?? '').toString(),
          ageGroup: (data['ageGroup'] ?? '').toString(),
          imageUrl: data['imageUrl']?.toString(),
          scanUrl: data['scanUrl']?.toString(),
          submittedAt: (data['submittedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
    });
  }

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
    final productId = _uuid.v4();

    // Upload product image
    final imagePath = 'pending_products/$productId.jpg';
    final imageRef = FirebaseStorage.instance.ref(imagePath);
    final imageUploadTask = await imageRef.putFile(
      imageFile,
      SettableMetadata(contentType: 'image/jpeg'),
    );
    final imageUrl = await imageUploadTask.ref.getDownloadURL();

    // Upload 3D scan OBJ file if provided
    String? scanUrl;
    String? scanStoragePath;
    if (scanObjPath != null && scanObjPath.isNotEmpty) {
      scanStoragePath = 'pending_products/$productId.obj';
      final scanRef = FirebaseStorage.instance.ref(scanStoragePath);
      final scanUploadTask = await scanRef.putFile(
        File(scanObjPath),
        SettableMetadata(contentType: 'text/plain'),
      );
      scanUrl = await scanUploadTask.ref.getDownloadURL();
    }

    // Create Firestore document
    final productData = {
      'name': name,
      'notes': notes,
      'gender': gender,
      'ethnicity': ethnicity,
      'ageGroup': ageGroup,
      'imageUrl': imageUrl,
      'imageStoragePath': imagePath,
      'status': 'pending',
      'submittedAt': FieldValue.serverTimestamp(),
      'submittedBy': createdBy,
    };

    // Add scan data if available
    if (scanUrl != null && scanStoragePath != null) {
      productData['scanUrl'] = scanUrl;
      productData['scanStoragePath'] = scanStoragePath;
    }

    await FirebaseFirestore.instance.collection('pending_products').doc(productId).set(productData);
  }

  @override
  Future<void> approvePendingProduct({required String id, required String approvedBy}) async {
    final pendingRef = FirebaseFirestore.instance.collection('pending_products').doc(id);
    final snap = await pendingRef.get();
    final data = snap.data();
    if (!snap.exists || data == null) return;

    await FirebaseFirestore.instance.collection('products').doc(id).set({
      ...data,
      'status': 'approved',
      'approvedAt': FieldValue.serverTimestamp(),
      'approvedBy': approvedBy,
    });
    await pendingRef.delete();
  }

  @override
  Future<void> rejectPendingProduct({required String id, required String rejectedBy}) async {
    await FirebaseFirestore.instance.collection('pending_products').doc(id).delete();
  }

  @override
  Future<AdminStats> getStats() async {
    final db = FirebaseFirestore.instance;
    final productsAgg = await db.collection('products').count().get();
    final pendingAgg =
        await db.collection('pending_products').where('status', isEqualTo: 'pending').count().get();
    final scansAgg = await db.collection('scans').count().get();

    return AdminStats(
      totalProducts: productsAgg.count ?? 0,
      pendingApprovals: pendingAgg.count ?? 0,
      totalScans: scansAgg.count ?? 0,
    );
  }

  @override
  Future<void> saveScanObj({required String createdBy, required String localObjPath}) async {
    final scanId = _uuid.v4();
    final storagePath = 'scans/$createdBy/$scanId.obj';
    final ref = FirebaseStorage.instance.ref(storagePath);

    final task = await ref.putFile(
      File(localObjPath),
      SettableMetadata(contentType: 'text/plain'),
    );
    final downloadUrl = await task.ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('scans').doc(scanId).set({
      'createdAt': FieldValue.serverTimestamp(),
      'createdBy': createdBy,
      'storagePath': storagePath,
      'downloadUrl': downloadUrl,
      'format': 'obj',
    });
  }
}

