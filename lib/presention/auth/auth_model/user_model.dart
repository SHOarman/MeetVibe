class UserModel {
  final String? username;
  final String? email;
  final String? fullName;
  final String? id;
  final String? createdAt;
  final String? updatedAt;
  final int? age;
  final String? dateOfBirth;
  final String? gender;
  final String? occupation;
  final String? fitnessGoal;
  final String? bio;
  final String? profileImage;
  final String? referenceImage;
  final bool? useReferenceImage;
  final String? role;
  final bool? isEmailVerified;
  final bool? isActive;

  UserModel({
    this.username,
    this.email,
    this.fullName,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.age,
    this.dateOfBirth,
    this.gender,
    this.occupation,
    this.fitnessGoal,
    this.bio,
    this.profileImage,
    this.referenceImage,
    this.useReferenceImage,
    this.role,
    this.isEmailVerified,
    this.isActive,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      username: json['username'] as String?,
      email: json['email'] as String?,
      fullName: json['full_name'] as String?,
      id: json['id'] as String?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
      age: json['age'] as int?,
      dateOfBirth: json['date_of_birth'] as String?,
      gender: json['gender'] as String?,
      occupation: json['occupation'] as String?,
      fitnessGoal: json['fitness_goal'] as String?,
      bio: json['bio'] as String?,
      profileImage: json['profile_image'] as String?,
      referenceImage: json['reference_image'] as String?,
      useReferenceImage: json['use_reference_image'] as bool?,
      role: json['role'] as String?,
      isEmailVerified: json['is_email_verified'] as bool?,
      isActive: json['is_active'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'full_name': fullName,
      'id': id,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'age': age,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'occupation': occupation,
      'fitness_goal': fitnessGoal,
      'bio': bio,
      'profile_image': profileImage,
      'reference_image': referenceImage,
      'use_reference_image': useReferenceImage,
      'role': role,
      'is_email_verified': isEmailVerified,
      'is_active': isActive,
    };
  }
}
