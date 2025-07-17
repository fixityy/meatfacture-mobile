class GetTokenbyPhoneModel {
  String token;
  GetTokenbyPhoneModel({required this.token});

  String get getToken => token;

  factory GetTokenbyPhoneModel.fromJson(Map<String, dynamic> json) {
    return GetTokenbyPhoneModel(token: json['token'].toString());
  }
}
