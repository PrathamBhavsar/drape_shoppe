class AsigneeModel {
  final String name;
  final String email;
  final String profilePhotoUrl;

  AsigneeModel({
    required this.name,
    required this.email,
    required this.profilePhotoUrl
  });

  // json to User object
  factory AsigneeModel.fromJson(Map<String, dynamic> json) {
    return AsigneeModel(
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