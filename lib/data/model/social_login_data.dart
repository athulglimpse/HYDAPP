class SocialLoginData {
  String _name;
  String _firstName;
  String _lastName;
  String _email;
  String _id;

  SocialLoginData({
    String name,
    String firstName,
    String lastName,
    String email,
    String id,
  }) {
    _name = name;
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    _id = id;
  }

  String get name => _name;
  set name(String name) => _name = name;
  String get firstName => _firstName;
  set firstName(String firstName) => _firstName = firstName;
  String get lastName => _lastName;
  set lastName(String lastName) => _lastName = lastName;
  String get email => _email;
  set email(String email) => _email = email;
  String get id => _id;
  set id(String id) => _id = id;

  //Convert facebook Login data to SocialLoginData
  SocialLoginData.copyWithFacebookData(Map<String, dynamic> facebookJson) {
    _name = facebookJson['name'];
    _firstName = facebookJson['first_name'];
    _lastName = facebookJson['last_name'];
    _email = facebookJson['email'];
    _id = facebookJson['id'];
  }

  //Convert google Login data to SocialLoginData
  SocialLoginData.copyWithGoogleData(
      {String email, String id, String displayName}) {
    _name = displayName;
    _email = email;
    _id = id;
  }

  //Convert apple Login data to SocialLoginData
  SocialLoginData.copyWithAppleData(
      {String email, String id, String displayName}) {
    _name = displayName;
    _email = email;
    _id = id;
  }

  //Convert UserCredential Login data to SocialLoginData
  SocialLoginData.copyWith({String email, String id, String displayName}) {
    _name = displayName;
    _email = email;
    _id = id;
  }

  SocialLoginData.fromJson(Map<String, dynamic> json) {
    _name = json['name'];
    _firstName = json['first_name'];
    _lastName = json['last_name'];
    _email = json['email'];
    _id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['name'] = _name;
    data['first_name'] = _firstName;
    data['last_name'] = _lastName;
    data['email'] = _email;
    data['id'] = _id;
    return data;
  }
}
