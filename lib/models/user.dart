class UserModel {
  final String name;
  final String email;
  final String profilePhotoUrl;



  UserModel({
    required this.name,
    required this.email,
    required this.profilePhotoUrl
  });

  // json to User object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
        profilePhotoUrl: json['profile_photo_url']
    );
  }

  // User object to json
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'profile_photo_url': profilePhotoUrl,
    };
  }
}