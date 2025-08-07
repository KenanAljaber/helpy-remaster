import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:helpy/styles/theme.dart';

class ProfilePictureSelector extends StatefulWidget {
  final String? initialImagePath;
  final String? initialImageUrl;
  final double size;
  final bool isEditable;
  final Function(String?)? onImageSelected;
  final String? fallbackText;

  const ProfilePictureSelector({
    super.key,
    this.initialImagePath,
    this.initialImageUrl,
    this.size = 120,
    this.isEditable = true,
    this.onImageSelected,
    this.fallbackText,
  });

  @override
  State<ProfilePictureSelector> createState() => _ProfilePictureSelectorState();
}

class _ProfilePictureSelectorState extends State<ProfilePictureSelector> {
  final ImagePicker _picker = ImagePicker();
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _selectedImagePath = widget.initialImagePath;
  }

  void _selectProfileImage() {
    if (!widget.isEditable) return;

    // For web, directly open file picker
    if (kIsWeb) {
      _openFilePicker();
      return;
    }

    // For mobile platforms, show camera/gallery options
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Choose Profile Picture',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.almostBlack,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildImageOption(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  onTap: () {
                    Navigator.pop(context);
                    _openCamera();
                  },
                ),
                _buildImageOption(
                  icon: Icons.photo_library,
                  label: 'Gallery',
                  onTap: () {
                    Navigator.pop(context);
                    _openGallery();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: BoxDecoration(
          color: AppColors.primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.primaryColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 32,
              color: AppColors.primaryColor,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.almostBlack,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // WEB FILE PICKER - DIRECT IMAGE SELECTION
  Future<void> _openFilePicker() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery, // On web, this opens file picker
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
        _showMessage('Photo selected!');
        widget.onImageSelected?.call(_selectedImagePath);
      }
    } on PlatformException catch (e) {
      if (e.code == 'file_picker_cancelled') {
        // User cancelled, do nothing
      } else {
        _showMessage('Error selecting file: ${e.message ?? e.code}');
      }
    } catch (e) {
      _showMessage('Error: ${e.toString()}');
    }
  }

  // INSTANT CAMERA/GALLERY ACCESS - NO PERMISSION DIALOGS
  Future<void> _openCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
        preferredCameraDevice: CameraDevice.rear,
      );

      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
        _showMessage('Photo captured!');
        widget.onImageSelected?.call(_selectedImagePath);
      }
    } on PlatformException catch (e) {
      String message = 'Camera error occurred';
      if (e.code == 'camera_access_denied') {
        message =
            'Camera access denied. Please enable camera permission in settings.';
      } else if (e.code == 'channel-error') {
        message = 'Camera service error. Please try again.';
      }
      _showMessage(message);
    } catch (e) {
      _showMessage('Error: ${e.toString()}');
    }
  }

  Future<void> _openGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
        _showMessage('Photo selected!');
        widget.onImageSelected?.call(_selectedImagePath);
      }
    } on PlatformException catch (e) {
      String message = 'Gallery error occurred';
      if (e.code == 'photo_access_denied') {
        message =
            'Photo access denied. Please enable gallery permission in settings.';
      } else if (e.code == 'channel-error') {
        message = 'Gallery service error. Please try again.';
      }
      _showMessage(message);
    } catch (e) {
      _showMessage('Error: ${e.toString()}');
    }
  }

  void _showMessage(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: AppColors.primaryColor,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      );
    }
  }

  Widget _buildProfileImage() {
    final radius = widget.size / 2;

    // Show selected image (local file)
    if (_selectedImagePath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: kIsWeb
            ? Image.network(
                _selectedImagePath!,
                width: widget.size,
                height: widget.size,
                fit: BoxFit.cover,
              )
            : Image.file(
                File(_selectedImagePath!),
                width: widget.size,
                height: widget.size,
                fit: BoxFit.cover,
              ),
      );
    }

    // Show initial URL image
    if (widget.initialImageUrl != null && widget.initialImageUrl!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.network(
          widget.initialImageUrl!,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildFallbackAvatar(radius);
          },
        ),
      );
    }

    // Show fallback avatar
    return _buildFallbackAvatar(radius);
  }

  Widget _buildFallbackAvatar(double radius) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryColor,
      child: widget.fallbackText != null && widget.fallbackText!.isNotEmpty
          ? Text(
              widget.fallbackText!.substring(0, 2).toUpperCase(),
              style: TextStyle(
                color: Colors.white,
                fontSize: widget.size * 0.3,
                fontWeight: FontWeight.bold,
              ),
            )
          : Icon(
              Icons.person,
              size: widget.size * 0.5,
              color: Colors.white,
            ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.isEditable ? _selectProfileImage : null,
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            _buildProfileImage(),
            if (widget.isEditable)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: widget.size * 0.15,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
