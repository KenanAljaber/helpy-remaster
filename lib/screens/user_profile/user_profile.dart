import 'package:flutter/material.dart';
import 'package:helpy/models/user/user.dart';
import 'package:helpy/styles/theme.dart';
import 'package:helpy/utils/constants/routes_constants.dart';
import 'package:helpy/widgets/profile_picture_selector.dart';

class UserProfile extends StatefulWidget {
  final User user;
  final bool isCurrentUser;
  const UserProfile(
      {super.key, required this.user, this.isCurrentUser = false});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final TextEditingController _requestController = TextEditingController();

  @override
  void dispose() {
    _requestController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).viewInsets.bottom,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  // Header section with profile info
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Column(
                      children: [
                        // Header with back button and optional settings/notifications
                        Row(
                          children: [
                            // Back button (always shown)
                            // IconButton(
                            //   onPressed: () => Navigator.pop(context),
                            //   icon: const Icon(
                            //     Icons.arrow_back,
                            //     color: AppColors.almostBlack,
                            //     size: 24,
                            //   ),
                            // ),
                            const Spacer(),
                            // Settings and notifications (only for current user)
                            if (widget.isCurrentUser) ...[
                              PopupMenuButton<String>(
                                icon: Icon(
                                  Icons.more_vert,
                                  color: Colors.grey[600],
                                  size: 24,
                                ),
                                color: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                itemBuilder: (context) => [
                                  PopupMenuItem<String>(
                                    value: 'settings',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.settings,
                                          color: Colors.grey[600],
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        const Text('Settings'),
                                      ],
                                    ),
                                  ),
                                  PopupMenuItem<String>(
                                    value: 'notifications',
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.notifications_outlined,
                                          color: Colors.grey[600],
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        const Text('Notifications'),
                                      ],
                                    ),
                                  ),
                                  const PopupMenuDivider(),
                                  PopupMenuItem<String>(
                                    value: 'logout',
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.logout,
                                          color: AppColors.secondaryColor,
                                          size: 20,
                                        ),
                                        const SizedBox(width: 12),
                                        const Text(
                                          'Logout',
                                          style: TextStyle(
                                            color: AppColors.secondaryColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                                onSelected: _handleMenuAction,
                              ),
                            ],
                          ],
                        ),
                        // const SizedBox(height: 20),

                        // Profile picture
                        ProfilePictureSelector(
                          initialImageUrl: widget.user.photoLink,
                          size: 100,
                          isEditable: widget.isCurrentUser,
                          onImageSelected: widget.isCurrentUser
                              ? (imagePath) {
                                  // TODO: Update user profile picture
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Profile picture updated!'),
                                      backgroundColor: AppColors.primaryColor,
                                    ),
                                  );
                                }
                              : null,
                          fallbackText: widget.user.name,
                        ),
                        const SizedBox(height: 15),

                        // User name
                        Text(
                          widget.user.name,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),

                        // Help way description
                        Text(
                          widget.user.helpWay,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 25),

                        // Stats row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildStatCard(
                              "${widget.user.timesHelped}",
                              "Helped",
                            ),
                            _buildStatCard(
                              "${widget.user.timesGotHelped}",
                              "Got Helped",
                            ),
                            _buildStatCard(
                              "${widget.user.reputation.positive}",
                              "Reputation",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Conditional content based on user type
                  if (widget.isCurrentUser) ...[
                    // Around me section for current user
                    Container(
                      height: 400, // Fixed height instead of Expanded
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Around me",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Placeholder notification items
                          Expanded(
                            child: ListView.builder(
                              itemCount: 3,
                              itemBuilder: (context, index) {
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundColor: AppColors.primaryColor,
                                        child: Text(
                                          "${index + 1}",
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 15),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Notification ${index + 1}",
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              "This is a placeholder notification for around me section",
                                              style: TextStyle(
                                                color: Colors.grey[600],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    // Request section for other users
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Request Message",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Message text field
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey[300]!,
                                width: 1,
                              ),
                            ),
                            child: TextField(
                              controller: _requestController,
                              maxLines: 4,
                              decoration: const InputDecoration(
                                hintText: "Type your request here...",
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),

                          // Send request button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                _sendRequest();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.secondaryColor,
                                foregroundColor: Colors.white,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Send Request",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  void _sendRequest() {
    if (_requestController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a request message'),
          backgroundColor: AppColors.secondaryColor,
        ),
      );
      return;
    }

    // TODO: Implement actual request sending logic here
    // For now, just show a success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Request sent to ${widget.user.name}!'),
        backgroundColor: AppColors.primaryColor,
      ),
    );

    // Clear the text field
    _requestController.clear();

    // Optionally navigate back
    Navigator.pop(context);
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'settings':
        // TODO: Navigate to settings screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Settings feature coming soon!'),
            backgroundColor: AppColors.primaryColor,
          ),
        );
        break;
      case 'notifications':
        // TODO: Navigate to notifications screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notifications feature coming soon!'),
            backgroundColor: AppColors.primaryColor,
          ),
        );
        break;
      case 'logout':
        _showLogoutConfirmation();
        break;
    }
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Logout',
            style: TextStyle(
              color: AppColors.almostBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(
              color: AppColors.almostBlack,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
                _performLogout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Logout',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _performLogout() {
    // TODO: Clear user session, preferences, etc.

    // Show logout message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully'),
        backgroundColor: AppColors.primaryColor,
      ),
    );

    // Navigate to login screen and clear all previous routes
    Navigator.pushNamedAndRemoveUntil(
      context,
      RoutesConstants.login,
      (route) => false,
    );
  }
}
