import 'package:helpy/models/user/reputation.dart';

class User {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String helpWay;
  final String photoLink;
  final Reputation reputation;

  User(
      {this.id = '',
      required this.name,
      required this.email,
      this.phone = "",
      this.photoLink = "",
      required this.helpWay,
      required this.reputation});
  User.empty()
      : this(
            id: '',
            name: '',
            email: '',
            helpWay: "",
            reputation: Reputation.empty());

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
            : Reputation.fromJson(json['reputation']));
  }

  toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'helpWay': helpWay,
      'photoLink': photoLink,
      "positiveRate":reputation.positive,
      "negativeRate":reputation.negative
    };
  }
}
