import 'package:flutter/material.dart';
import 'package:helpy/styles/theme.dart';
import 'package:helpy/utils/constants/routes_constants.dart';
import 'package:helpy/utils/config.dart';
import 'package:helpy/widgets/profile_picture_selector.dart';
import 'package:helpy/widgets/location_picker.dart';

class UserDetailsScreen extends StatefulWidget {
  final String phoneNumber;

  const UserDetailsScreen({super.key, required this.phoneNumber});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _customHelpController = TextEditingController();

  String? _selectedHelpWay;
  bool _isLoading = false;
  String? _profileImagePath;
  double? _selectedLatitude;
  double? _selectedLongitude;

  final List<String> _helpOptions = [
    'Tutoring and Academic Support',
    'Language Translation',
    'Pet Care and Walking',
    'Grocery Shopping and Errands',
    'Home Maintenance and Repairs',
    'Technology Help and Support',
    'Cooking and Meal Preparation',
    'Transportation and Rides',
    'Childcare and Babysitting',
    'Event Planning and Organization',
    'Garden and Plant Care',
    'Fitness and Personal Training',
    'Art and Creative Services',
    'Music Lessons and Performance',
    'Career Counseling and Mentoring',
    'Other (Specify below)',
  ];

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _customHelpController.dispose();
    super.dispose();
  }

  void _completeSignup() async {
    // Validate form
    if (_firstNameController.text.trim().isEmpty ||
        _lastNameController.text.trim().isEmpty ||
        _emailController.text.trim().isEmpty ||
        _selectedHelpWay == null ||
        (_selectedHelpWay == 'Other (Specify below)' &&
            _customHelpController.text.trim().isEmpty) ||
        _selectedLatitude == null ||
        _selectedLongitude == null) {
      _showMessage('Please fill in all required fields and set your location');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // Here you would typically send the data to your backend
    // including the location coordinates: _selectedLatitude, _selectedLongitude
    print('User location: $_selectedLatitude, $_selectedLongitude');
    print('API Base URL: ${Config.apiBaseUrl}');
    print('Environment: ${Config.environment}');

    // Example of how to use the Config class for API calls:
    // final response = await http.post(
    //   Uri.parse(Config.usersEndpoint),
    //   body: jsonEncode({
    //     'firstName': _firstNameController.text.trim(),
    //     'lastName': _lastNameController.text.trim(),
    //     'email': _emailController.text.trim(),
    //     'phoneNumber': widget.phoneNumber,
    //     'helpWay': _selectedHelpWay,
    //     'customHelp': _customHelpController.text.trim(),
    //     'latitude': _selectedLatitude,
    //     'longitude': _selectedLongitude,
    //     'profileImage': _profileImagePath,
    //   }),
    //   headers: {'Content-Type': 'application/json'},
    // );

    _showMessage('Account created successfully!');

    // Navigate to map screen
    if (mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        RoutesConstants.map,
        (route) => false,
      );
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primaryColor,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.almostBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tell us about you',
          style: TextStyle(
              color: AppColors.almostBlack, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            // Profile picture section
            ProfilePictureSelector(
              initialImagePath: _profileImagePath,
              size: 120,
              isEditable: true,
              onImageSelected: (imagePath) {
                setState(() {
                  _profileImagePath = imagePath;
                });
              },
              fallbackText: 'U',
            ),
            const SizedBox(height: 40),

            // Form fields
            _buildTextField(
              controller: _firstNameController,
              hint: 'First Name',
            ),
            const SizedBox(height: 20),

            _buildTextField(
              controller: _lastNameController,
              hint: 'Last Name',
            ),
            const SizedBox(height: 20),

            _buildTextField(
              controller: _emailController,
              hint: 'Email',
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            // Help options dropdown
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonFormField<String>(
                value: _selectedHelpWay,
                hint: Text('How would you like to help?',
                    style: TextStyle(color: Colors.grey[400])),
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.all(16),
                ),
                items: _helpOptions.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedHelpWay = newValue;
                  });
                },
              ),
            ),

            if (_selectedHelpWay == 'Other (Specify below)') ...[
              const SizedBox(height: 20),
              _buildTextField(
                controller: _customHelpController,
                hint: 'Please specify how you would like to help',
                maxLines: 3,
              ),
            ],

            const SizedBox(height: 20),

            // Location picker section
            const Text(
              'Set your location',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.almostBlack,
              ),
            ),
            const SizedBox(height: 12),
            LocationPicker(
              height: 200,
              onLocationSelected: (latitude, longitude) {
                setState(() {
                  _selectedLatitude = latitude;
                  _selectedLongitude = longitude;
                });
              },
            ),
            // if (_selectedLatitude != null && _selectedLongitude != null) ...[
            //   const SizedBox(height: 12),
            //   Container(
            //     padding: const EdgeInsets.all(12),
            //     decoration: BoxDecoration(
            //       color: AppColors.primaryColor.withValues(alpha: 0.1),
            //       borderRadius: BorderRadius.circular(8),
            //       border: Border.all(
            //         color: AppColors.primaryColor.withValues(alpha: 0.3),
            //       ),
            //     ),
            //     child: Row(
            //       children: [
            //         Icon(
            //           Icons.location_on,
            //           color: AppColors.primaryColor,
            //           size: 16,
            //         ),
            //         const SizedBox(width: 8),
            //         Expanded(
            //           child: Text(
            //             'Location set: ${_selectedLatitude!.toStringAsFixed(6)}, ${_selectedLongitude!.toStringAsFixed(6)}',
            //             style: TextStyle(
            //               fontSize: 12,
            //               color: AppColors.primaryColor,
            //               fontWeight: FontWeight.w500,
            //             ),
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ],

            const SizedBox(height: 40),

            // Complete signup button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _completeSignup,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Complete Signup',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
