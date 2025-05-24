class User {
  final int id;
  final String username;
  final String lastname;
  final String email;
  final String role;

  User({
    required this.id,
    required this.username,
    required this.lastname,
    required this.email,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'lastname': lastname,
      'email': email,
      'role': role,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      lastname: json['lastname'] ?? '',
      email: json['email'],
      role: json['role'],
    );
  }
}

class UserCreate extends User {
  final String password;

  UserCreate({
    required int id,
    required String username,
    required String lastname,
    required String email,
    required String role,
    required this.password,
  }) : super(
         id: id,
         username: username,
         lastname: lastname,
         email: email,
         role: role,
       );

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['password'] = password;
    return data;
  }

  factory UserCreate.fromJson(Map<String, dynamic> json) {
    return UserCreate(
      id: json['id'],
      username: json['username'],
      lastname: json['lastname'],
      email: json['email'],
      role: json['role'],
      password: json['password'],
    );
  }
}

class UserLogin {
  final String email;
  final String password;

  UserLogin({required this.email, required this.password});

  Map<String, dynamic> toJson() {
    return {'email': email, 'password': password};
  }

  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(email: json['email'], password: json['password']);
  }
}
