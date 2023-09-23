class User {
  int? id;
  final String UserName;
  final String Password;

  User({this.id, required this.UserName, required this.Password});


  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': UserName,
      'password': Password,
    };
  }
}
