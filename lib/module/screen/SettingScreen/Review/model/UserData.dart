class UserData{
  String address;
  String email;
  String fcmToken;
  String firstName;
  String lastName;
  String phoneNumber;
  String profileImage;
  String uId;

  UserData(
      {required this.address,
        required this.email,
        required this.fcmToken,
        required this.firstName,
        required this.lastName,
        required this.phoneNumber,
        required this.profileImage,
        required this.uId});

  Map<String, dynamic> toJson() {
    return {
      "address": this.address,
      "email": this.email,
      "fcmToken": this.fcmToken,
      "firstName": this.firstName,
      "lastName": this.lastName,
      "phoneNumber": this.phoneNumber,
      "profileImage": this.profileImage,
      "uId": this.uId,
    };
  }

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      address: json["address"],
      email: json["email"],
      fcmToken: json["fcmToken"],
      firstName: json["firstName"],
      lastName: json["lastName"],
      phoneNumber: json["phoneNumber"],
      profileImage: json["profileImage"],
      uId: json["uId"],
    );
  }
//
}