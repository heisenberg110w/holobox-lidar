import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../providers/admin_auth_provider.dart';
import '../repositories/admin_repository.dart';
import '../services/lidar_scan_service.dart';

class ProductSubmissionScreen extends StatefulWidget {
  const ProductSubmissionScreen({super.key});

  @override
  State<ProductSubmissionScreen> createState() => _ProductSubmissionScreenState();
}

class _ProductSubmissionScreenState extends State<ProductSubmissionScreen> {
  final ImagePicker _picker = ImagePicker();
  final LidarScanService _lidarService = LidarScanService();
  
  File? _selectedImage;
  File? _lidarScanFile;
  String? _selectedGender;
  String? _selectedEthnicity;
  String? _selectedAgeGroup;
  bool _isSubmitting = false;
  bool _isLidarSupported = false;
  bool _isScanning = false;

  final _nameController = TextEditingController();
  final _notesController = TextEditingController();

  final List<String> _genders = ['Male', 'Female', 'Unisex'];
  final List<String> _ethnicities = [
    'Asian',
    'Black',
    'Hispanic',
    'White',
    'Middle Eastern',
    'Mixed',
    'Other'
  ];
  final List<String> _ageGroups = [
    '13-17',
    '18-24',
    '25-34',
    '35-44',
    '45-54',
    '55-64',
    '65+'
  ];

  @override
  void initState() {
    super.initState();
    _checkLidarSupport();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _checkLidarSupport() async {
    final supported = await _lidarService.isSupported();
    if (mounted) {
      setState(() => _isLidarSupported = supported);
    }
  }

  Future<void> _startLidarScan() async {
    if (_isScanning) return;
    
    setState(() => _isScanning = true);
    
    try {
      final objPath = await _lidarService.startScan();
      if (objPath != null && mounted) {
        setState(() {
          _lidarScanFile = File(objPath);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('3D scan captured successfully!'),
            backgroundColor: AppColors.success,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Scan failed: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isScanning = false);
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error picking image: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _submitProduct() async {
    final name = _nameController.text.trim();
    final notes = _notesController.text.trim();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a product name'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select an image'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (_selectedGender == null ||
        _selectedEthnicity == null ||
        _selectedAgeGroup == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final auth = context.read<ClientAuthProvider>();
      final uid = auth.uid;
      if (uid == null) {
        throw StateError('Not signed in.');
      }
      await context.read<AdminRepository>().submitPendingProduct(
            createdBy: uid,
            name: name,
            notes: notes,
            gender: _selectedGender!,
            ethnicity: _selectedEthnicity!,
            ageGroup: _selectedAgeGroup!,
            imageFile: _selectedImage!,
            scanObjPath: _lidarScanFile?.path,
          );

      if (!mounted) return;
      setState(() {
        _isSubmitting = false;
        _selectedImage = null;
        _lidarScanFile = null;
        _selectedGender = null;
        _selectedEthnicity = null;
        _selectedAgeGroup = null;
        _nameController.clear();
        _notesController.clear();
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Submission failed: $e'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ad submitted successfully! Pending review.'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldBackground,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Post New Ad',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Submit your ad for review',
              style: TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 24),

            _buildSectionTitle('Ad Title'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _nameController,
              hint: 'e.g. Summer Collection',
              icon: CupertinoIcons.tag,
            ),
            const SizedBox(height: 24),

            // Image Picker
            _buildImagePicker(),
            const SizedBox(height: 24),

            // LiDAR Scan Section (iOS only)
            if (_isLidarSupported) ...[
              _buildSectionTitle('3D Scan (Optional)'),
              const SizedBox(height: 12),
              _buildLidarScanSection(),
              const SizedBox(height: 24),
            ],

            // Gender Selector
            _buildSectionTitle('Target Gender'),
            const SizedBox(height: 12),
            _buildGenderSelector(),
            const SizedBox(height: 24),

            // Ethnicity Selector
            _buildSectionTitle('Target Ethnicity'),
            const SizedBox(height: 12),
            _buildDropdown(
              value: _selectedEthnicity,
              items: _ethnicities,
              hint: 'Select Ethnicity',
              onChanged: (value) => setState(() => _selectedEthnicity = value),
            ),
            const SizedBox(height: 24),

            // Age Group Selector
            _buildSectionTitle('Target Age Group'),
            const SizedBox(height: 12),
            _buildDropdown(
              value: _selectedAgeGroup,
              items: _ageGroups,
              hint: 'Select Age Group',
              onChanged: (value) => setState(() => _selectedAgeGroup = value),
            ),
            const SizedBox(height: 32),

            _buildSectionTitle('Notes (optional)'),
            const SizedBox(height: 12),
            _buildTextField(
              controller: _notesController,
              hint: 'Extra info for reviewers',
              icon: CupertinoIcons.doc_text,
              maxLines: 3,
            ),
            const SizedBox(height: 24),

            // Submit Button
            GestureDetector(
              onTap: _isSubmitting ? null : _submitProduct,
              child: Container(
                width: double.infinity,
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.primaryPurple, AppColors.lightBlue],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: _isSubmitting
                      ? const CupertinoActivityIndicator(color: AppColors.white)
                      : const Text(
                          'Submit Ad',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.white,
                          ),
                        ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.textDark,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: AppColors.textSecondary.withValues(alpha: 0.6),
            fontSize: 15,
          ),
          prefixIcon: Icon(
            icon,
            color: AppColors.textSecondary.withValues(alpha: 0.7),
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }

  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: double.infinity,
        height: 200,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.border,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: _selectedImage == null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryPurple, AppColors.lightBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      CupertinoIcons.photo,
                      color: AppColors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tap to upload image',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'JPG, PNG (Max 5MB)',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              )
            : Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _selectedImage!,
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedImage = null),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                            ),
                          ],
                        ),
                        child: const Icon(
                          CupertinoIcons.xmark,
                          color: AppColors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildLidarScanSection() {
    return GestureDetector(
      onTap: _isScanning ? null : _startLidarScan,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _lidarScanFile != null ? AppColors.success : AppColors.border,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: _lidarScanFile == null
            ? Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.primaryPurple, AppColors.lightBlue],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: _isScanning
                        ? const CupertinoActivityIndicator(color: AppColors.white)
                        : const Icon(
                            CupertinoIcons.cube_box,
                            color: AppColors.white,
                            size: 28,
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _isScanning ? 'Scanning...' : 'Tap to start LiDAR scan',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Capture a 3D model of your product',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppColors.success.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      CupertinoIcons.checkmark_circle_fill,
                      color: AppColors.success,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          '3D Scan Captured',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          _lidarScanFile!.path.split('/').last,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => setState(() => _lidarScanFile = null),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        CupertinoIcons.xmark,
                        color: AppColors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: _genders.map((gender) {
        bool isSelected = _selectedGender == gender;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => _selectedGender = gender),
            child: Container(
              margin: EdgeInsets.only(
                right: gender != _genders.last ? 12 : 0,
              ),
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryPurple : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? AppColors.primaryPurple : AppColors.border,
                  width: 2,
                ),
              ),
              child: Center(
                child: Text(
                  gender,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.white : AppColors.textDark,
                  ),
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDropdown({
    required String? value,
    required List<String> items,
    required String hint,
    required Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.border,
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          hint: Text(
            hint,
            style: TextStyle(
              color: AppColors.textSecondary.withValues(alpha: 0.6),
              fontSize: 15,
            ),
          ),
          icon: const Icon(
            CupertinoIcons.chevron_down,
            color: AppColors.textSecondary,
            size: 20,
          ),
          style: const TextStyle(
            fontSize: 15,
            color: AppColors.textDark,
            fontWeight: FontWeight.w500,
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
