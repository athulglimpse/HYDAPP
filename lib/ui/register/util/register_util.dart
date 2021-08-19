enum RegisterEnum {
  EMAIL,
  FACEBOOK,
  GOOGLE,
  APPLE,
}

///Return Type Register by Register Enum
String getTypeByEnum(RegisterEnum registerEnum) {
  switch (registerEnum) {
    case RegisterEnum.FACEBOOK:
      return 'facebook';
    case RegisterEnum.GOOGLE:
      return 'google';
    case RegisterEnum.APPLE:
      return 'apple';
    case RegisterEnum.EMAIL:
    default:
      return 'email';
  }
}

///Return SocialId by Register Enum
String getSocialIdByEnum(
    RegisterEnum registerEnum, String socialId, String defaultId) {
  switch (registerEnum) {
    case RegisterEnum.FACEBOOK:
    case RegisterEnum.GOOGLE:
    case RegisterEnum.APPLE:
      return socialId;
    case RegisterEnum.EMAIL:
    default:
      return defaultId;
  }
}
