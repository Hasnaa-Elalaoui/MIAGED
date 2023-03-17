class User {
  final String login;
  final String password;
  final int postal_code;
  final String address;
  final String city;
  final DateTime birthdate;

  User({required this.login, required this.password, required this.postal_code, required this.address, required this.city, required this.birthdate});

  Map<String, dynamic> toMap() {
    return {
      'login': login,
      'password': password,
      'postal_code': postal_code,
      'address': address,
      'city': city,
      'birthdate': birthdate,
    };
  }

  User.fromMap(Map<String, dynamic>? userMap)
      : login = userMap?['login'],
        password = userMap?['password'],
        postal_code = userMap?['postal_code'],
        address = userMap?['address'],
        city = userMap?['city'],
        birthdate = userMap?['birthdate'].toDate();

}