import 'package:data_model/data_model.dart';

class User implements Model<UserId> {
  UserId id;

  String name;
  String password;

  String realName;
  String realSurname;
  String email;

  User({
    this.id,
    this.name,
    this.password,
    String realName,
    String realSurname,
    String email
  }) :
    realName = realName ?? '',
    email = email ?? '',
    realSurname = realSurname ?? '';

  factory User.fromJson(Map<String, dynamic> json) {
    if (json == null) return null;
    return User(
        id: UserId(json['id']),
        name: json['name'],
        password: json['password'],
        realName: json['realName'],
        realSurname: json['realSurname'],
        email: json['email']
    );
  }

  Map<String, dynamic> get json => {
        'id': id?.json,
        'name': name,
        'password': password,
        'realName': realName,
        'realSurname': realSurname,
        'email': email
      }..removeWhere((key, value) => value == null);
}

class UserId extends ObjectId {
  UserId._(id) : super(id);
  factory UserId(id) {
    if (id == null) return null;
    return UserId._(id);
  }
}
