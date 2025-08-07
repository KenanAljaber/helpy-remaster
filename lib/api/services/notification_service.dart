import 'package:helpy/api/api_client.dart';
import 'package:helpy/models/request.dart';

class NotificationService {
  final ApiClient _apiClient = ApiClient();

  // Mock data for development
  List<Request> _mockSentRequests = [
    Request(
      id: '1',
      message:
          'I need help with math homework - calculus is really challenging for me',
      status: RequestStatus.pending,
      requesterId: 'current_user',
      requesterName: 'You',
      helperId: 'user2',
      helperName: 'John Smith',
      helperPhotoLink: null,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      estimatedDuration: 120,
      tags: ['math', 'calculus', 'homework'],
    ),
    Request(
      id: '2',
      message:
          'Can you help me with grocery shopping? I have a broken leg and can\'t drive',
      status: RequestStatus.accepted,
      requesterId: 'current_user',
      requesterName: 'You',
      helperId: 'user3',
      helperName: 'Sarah Johnson',
      helperPhotoLink: null,
      acceptedAt: DateTime.now().subtract(const Duration(hours: 1)),
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
      estimatedDuration: 60,
      tags: ['shopping', 'transportation'],
    ),
    Request(
      id: '3',
      message: 'Need assistance with computer setup and software installation',
      status: RequestStatus.rejected,
      requesterId: 'current_user',
      requesterName: 'You',
      helperId: 'user4',
      helperName: 'Mike Wilson',
      helperPhotoLink: null,
      rejectionReason: 'I\'m not available this week due to work commitments',
      rejectedAt: DateTime.now().subtract(const Duration(minutes: 30)),
      createdAt: DateTime.now().subtract(const Duration(hours: 4)),
      estimatedDuration: 180,
      tags: ['technology', 'computer'],
    ),
    Request(
      id: '4',
      message: 'Looking for help with English conversation practice',
      status: RequestStatus.completed,
      requesterId: 'current_user',
      requesterName: 'You',
      helperId: 'user5',
      helperName: 'Emma Davis',
      helperPhotoLink: null,
      acceptedAt: DateTime.now().subtract(const Duration(days: 2)),
      completedAt: DateTime.now().subtract(const Duration(hours: 6)),
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      estimatedDuration: 90,
      tags: ['language', 'english'],
    ),
  ];

  List<Request> _mockReceivedRequests = [
    Request(
      id: '5',
      message: 'I need help moving furniture this weekend. Can you assist me?',
      status: RequestStatus.pending,
      requesterId: 'user6',
      requesterName: 'Alex Brown',
      requesterPhotoLink: null,
      helperId: 'current_user',
      helperName: 'You',
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
      estimatedDuration: 240,
      tags: ['moving', 'furniture'],
    ),
    Request(
      id: '6',
      message:
          'Can you tutor me in English? I\'m preparing for an important exam',
      status: RequestStatus.pending,
      requesterId: 'user7',
      requesterName: 'Maria Garcia',
      requesterPhotoLink: null,
      helperId: 'current_user',
      helperName: 'You',
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      estimatedDuration: 120,
      tags: ['tutoring', 'english', 'exam'],
    ),
    Request(
      id: '7',
      message: 'I need help with my garden - planting and maintenance',
      status: RequestStatus.accepted,
      requesterId: 'user8',
      requesterName: 'David Lee',
      requesterPhotoLink: null,
      helperId: 'current_user',
      helperName: 'You',
      acceptedAt: DateTime.now().subtract(const Duration(hours: 3)),
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      estimatedDuration: 180,
      tags: ['gardening', 'outdoor'],
    ),
    Request(
      id: '8',
      message:
          'Help needed with cooking lessons - I want to learn Italian cuisine',
      status: RequestStatus.rejected,
      requesterId: 'user9',
      requesterName: 'Lisa Chen',
      requesterPhotoLink: null,
      helperId: 'current_user',
      helperName: 'You',
      rejectionReason: 'I don\'t have experience with Italian cooking',
      rejectedAt: DateTime.now().subtract(const Duration(days: 1)),
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      estimatedDuration: 150,
      tags: ['cooking', 'italian'],
    ),
  ];

  /// Get sent requests for the current user
  Future<List<Request>> getSentRequests(String userId) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockSentRequests);
  }

  /// Get received requests for the current user
  Future<List<Request>> getReceivedRequests(String userId) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockReceivedRequests);
  }

  /// Accept a help request
  Future<bool> acceptRequest(String requestId) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Update mock data
    final index = _mockReceivedRequests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      _mockReceivedRequests[index] =
          _mockReceivedRequests[index].updateStatus(RequestStatus.accepted);
    }

    return true;
  }

  /// Reject a help request
  Future<bool> rejectRequest(String requestId, String reason) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Update mock data
    final index = _mockReceivedRequests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      _mockReceivedRequests[index] = _mockReceivedRequests[index].updateStatus(
        RequestStatus.rejected,
        rejectionReason: reason,
      );
    }

    return true;
  }

  /// Cancel a sent request
  Future<bool> cancelRequest(String requestId) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Update mock data
    final index = _mockSentRequests.indexWhere((r) => r.id == requestId);
    if (index != -1) {
      _mockSentRequests[index] =
          _mockSentRequests[index].updateStatus(RequestStatus.cancelled);
    }

    return true;
  }

  /// Complete a request
  Future<bool> completeRequest(String requestId) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Update mock data
    final sentIndex = _mockSentRequests.indexWhere((r) => r.id == requestId);
    if (sentIndex != -1) {
      _mockSentRequests[sentIndex] =
          _mockSentRequests[sentIndex].updateStatus(RequestStatus.completed);
    }

    final receivedIndex =
        _mockReceivedRequests.indexWhere((r) => r.id == requestId);
    if (receivedIndex != -1) {
      _mockReceivedRequests[receivedIndex] =
          _mockReceivedRequests[receivedIndex]
              .updateStatus(RequestStatus.completed);
    }

    return true;
  }

  /// Get request by ID
  Future<Request?> getRequestById(String requestId) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 200));

    // Search in both sent and received requests
    final sentRequest =
        _mockSentRequests.where((r) => r.id == requestId).firstOrNull;
    if (sentRequest != null) return sentRequest;

    final receivedRequest =
        _mockReceivedRequests.where((r) => r.id == requestId).firstOrNull;
    return receivedRequest;
  }

  /// Get unread notifications count
  Future<int> getUnreadNotificationsCount(String userId) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 200));

    // Count pending received requests
    return _mockReceivedRequests
        .where((r) => r.status == RequestStatus.pending)
        .length;
  }

  /// Mark notifications as read
  Future<bool> markNotificationsAsRead(String userId) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 200));

    // In a real implementation, this would mark notifications as read
    // For now, just return success
    return true;
  }

  /// Create a new help request
  Future<Request?> createRequest(Request request) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));

    // Add to mock sent requests
    final newRequest = request.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      createdAt: DateTime.now(),
    );
    _mockSentRequests.insert(0, newRequest);

    return newRequest;
  }

  /// Get requests by status
  Future<List<Request>> getRequestsByStatus(
    String userId, {
    required RequestStatus status,
    bool isRequester = false,
  }) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));

    if (isRequester) {
      return _mockSentRequests.where((r) => r.status == status).toList();
    } else {
      return _mockReceivedRequests.where((r) => r.status == status).toList();
    }
  }

  /// Get pending requests count for a user
  Future<Map<String, int>> getRequestCounts(String userId) async {
    // TODO: Replace with actual API call when backend is ready
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 200));

    return {
      'sent': _mockSentRequests.length,
      'received': _mockReceivedRequests.length,
      'pending': _mockReceivedRequests
          .where((r) => r.status == RequestStatus.pending)
          .length,
      'accepted': _mockReceivedRequests
          .where((r) => r.status == RequestStatus.accepted)
          .length,
      'completed': _mockReceivedRequests
          .where((r) => r.status == RequestStatus.completed)
          .length,
    };
  }
}
