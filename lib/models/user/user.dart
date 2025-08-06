import 'package:helpy/models/user/reputation.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String helpWay;
  final String photoLink;
  final Reputation reputation;
  final int timesHelped;
  final int timesGotHelped;

  User(
      {this.id = '',
      required this.name,
      required this.email,
      this.phone = "",
      this.photoLink = "",
      required this.helpWay,
      required this.reputation,
      this.timesHelped = 0,
      this.timesGotHelped = 0});
  User.empty()
      : this(
            id: '',
            name: '',
            email: '',
            helpWay: "",
            reputation: Reputation.empty(),
            timesHelped: 0,
            timesGotHelped: 0);

  fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        phone: json['phone'],
        helpWay: json['helpWay'],
        photoLink: json['photoLink'],
        reputation: json['reputation'] == null
            ? Reputation.empty()
            : Reputation.fromJson(json['reputation']),
        timesHelped: json['timesHelped'] ?? 0,
        timesGotHelped: json['timesGotHelped'] ?? 0);
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'helpWay': helpWay,
      'photoLink': photoLink,
      'timesHelped': timesHelped,
      'timesGotHelped': timesGotHelped,
      "positiveRate":reputation.positive,
      "negativeRate":reputation.negative
    };
  }
}
