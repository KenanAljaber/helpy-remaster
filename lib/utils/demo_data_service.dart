import 'dart:math';
import 'package:latlong2/latlong.dart';
import 'package:helpy/models/user/user.dart';
import 'package:helpy/models/user/reputation.dart';

class DemoDataService {
  static final Random _random = Random();

  // Sample names for demo users
  static const List<String> _firstNames = [
    'Emma',
    'Liam',
    'Olivia',
    'Noah',
    'Ava',
    'Ethan',
    'Isabella',
    'Lucas',
    'Sophia',
    'Mason',
    'Mia',
    'Oliver',
    'Charlotte',
    'Elijah',
    'Amelia',
    'James',
    'Harper',
    'Benjamin',
    'Evelyn',
    'Sebastian',
    'Abigail',
    'Michael',
    'Emily',
    'Daniel',
    'Elizabeth',
    'Henry',
    'Sofia',
    'Jackson',
    'Avery',
    'Samuel',
    'Ella',
    'David',
    'Madison',
    'Joseph',
    'Scarlett',
    'Carter',
    'Victoria',
    'Owen',
    'Luna',
    'Wyatt',
    'Grace',
    'John',
    'Chloe',
    'Jack',
    'Penelope',
    'Luke',
    'Layla',
    'Jayden',
    'Riley',
    'Dylan',
    'Zoey',
    'Grayson',
    'Nora'
  ];

  static const List<String> _lastNames = [
    'Smith',
    'Johnson',
    'Williams',
    'Brown',
    'Jones',
    'Garcia',
    'Miller',
    'Davis',
    'Rodriguez',
    'Martinez',
    'Hernandez',
    'Lopez',
    'Gonzalez',
    'Wilson',
    'Anderson',
    'Thomas',
    'Taylor',
    'Moore',
    'Jackson',
    'Martin',
    'Lee',
    'Perez',
    'Thompson',
    'White',
    'Harris',
    'Sanchez',
    'Clark',
    'Ramirez',
    'Lewis',
    'Robinson',
    'Walker',
    'Young',
    'Allen',
    'King',
    'Wright',
    'Scott',
    'Torres',
    'Nguyen',
    'Hill',
    'Flores',
    'Green',
    'Adams',
    'Nelson',
    'Baker',
    'Hall',
    'Rivera',
    'Campbell',
    'Mitchell',
    'Carter',
    'Roberts',
    'Gomez',
    'Phillips',
    'Evans',
    'Turner',
    'Diaz'
  ];

  // Sample help categories and descriptions
  static const List<Map<String, String>> _helpCategories = [
    {
      'category': 'Translation',
      'description': 'Help translating documents from English to Spanish',
      'icon': '🌐'
    },
    {
      'category': 'Shopping',
      'description': 'Assist with grocery shopping and errands',
      'icon': '🛒'
    },
    {
      'category': 'Technology',
      'description': 'Help with computer and smartphone issues',
      'icon': '💻'
    },
    {
      'category': 'Transportation',
      'description': 'Provide rides to appointments or shopping',
      'icon': '🚗'
    },
    {
      'category': 'Home Help',
      'description': 'Assist with household chores and maintenance',
      'icon': '🏠'
    },
    {
      'category': 'Tutoring',
      'description': 'Help with homework and academic subjects',
      'icon': '📚'
    },
    {
      'category': 'Pet Care',
      'description': 'Walk dogs or care for pets while away',
      'icon': '🐕'
    },
    {
      'category': 'Gardening',
      'description': 'Help with garden maintenance and planting',
      'icon': '🌱'
    },
    {
      'category': 'Cooking',
      'description': 'Teach cooking skills and meal preparation',
      'icon': '👨‍🍳'
    },
    {
      'category': 'Fitness',
      'description': 'Exercise buddy and fitness motivation',
      'icon': '💪'
    }
  ];

  /// Generate demo users around a given location
  static List<User> generateDemoUsers(LatLng userLocation, {int count = 8}) {
    List<User> demoUsers = [];

    for (int i = 0; i < count; i++) {
      // Generate random position within 2km radius
      LatLng randomLocation =
          _generateRandomLocation(userLocation, maxDistance: 2000);

      // Generate random user data
      String firstName = _firstNames[_random.nextInt(_firstNames.length)];
      String lastName = _lastNames[_random.nextInt(_lastNames.length)];
      String fullName = '$firstName $lastName';
      String email =
          '${firstName.toLowerCase()}.${lastName.toLowerCase()}@example.com';

      // Generate random help category
      Map<String, String> helpCategory =
          _helpCategories[_random.nextInt(_helpCategories.length)];
      String helpDescription = helpCategory['description']!;

      // Generate random reputation (mostly positive)
      int positiveReviews = _random.nextInt(50) + 5; // 5-54 positive reviews
      int negativeReviews = _random.nextInt(5); // 0-4 negative reviews
      int totalReviews = positiveReviews + negativeReviews;

      // Generate random help counts
      int timesHelped = _random.nextInt(30) + 5; // 5-34 times helped
      int timesGotHelped = _random.nextInt(15) + 1; // 1-15 times got helped

      // Generate avatar URL using DiceBear
      String avatarUrl = _generateAvatarUrl(firstName, lastName);

      User demoUser = User(
        name: fullName,
        email: email,
        helpWay: helpDescription,
        reputation: Reputation(
          positive: positiveReviews,
          negative: negativeReviews,
          total: totalReviews,
        ),
        photoLink: avatarUrl,
        timesHelped: timesHelped,
        timesGotHelped: timesGotHelped,
        location: randomLocation, // Add location to user model
      );

      demoUsers.add(demoUser);
    }

    return demoUsers;
  }

  /// Generate a random location within a specified radius
  static LatLng _generateRandomLocation(LatLng center,
      {required double maxDistance}) {
    // Convert maxDistance from meters to degrees (approximate)
    double maxDistanceDegrees = maxDistance / 111000; // 1 degree ≈ 111km

    // Generate random angle and distance
    double angle = _random.nextDouble() * 2 * pi;
    double distance = _random.nextDouble() * maxDistanceDegrees;

    // Calculate new coordinates
    double lat = center.latitude + (distance * cos(angle));
    double lng = center.longitude +
        (distance * sin(angle) / cos(center.latitude * pi / 180));

    return LatLng(lat, lng);
  }

  /// Generate avatar URL using DiceBear
  static String _generateAvatarUrl(String firstName, String lastName) {
    // Create a seed from the name for consistent avatars
    String seed = '${firstName.toLowerCase()}_${lastName.toLowerCase()}';

    // Generate different avatar styles for variety
    List<String> styles = [
      'adventurer',
      'avataaars',
      'big-ears',
      'bottts',
      'croodles',
      'fun-emoji'
    ];
    String style = styles[_random.nextInt(styles.length)];

    return 'https://api.dicebear.com/7.x/$style/svg?seed=$seed&backgroundColor=b6e3f4,c0aede,d1d4f9,ffd5dc,ffdfbf';
  }

  /// Calculate distance between two points in meters
  static double calculateDistance(LatLng point1, LatLng point2) {
    const double earthRadius = 6371000; // Earth's radius in meters

    double lat1Rad = point1.latitude * pi / 180;
    double lat2Rad = point2.latitude * pi / 180;
    double deltaLat = (point2.latitude - point1.latitude) * pi / 180;
    double deltaLng = (point2.longitude - point1.longitude) * pi / 180;

    double a = sin(deltaLat / 2) * sin(deltaLat / 2) +
        cos(lat1Rad) * cos(lat2Rad) * sin(deltaLng / 2) * sin(deltaLng / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));

    return earthRadius * c;
  }

  /// Format distance for display
  static String formatDistance(double distanceInMeters) {
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.round()}m';
    } else {
      double distanceInKm = distanceInMeters / 1000;
      return '${distanceInKm.toStringAsFixed(1)}km';
    }
  }
}
