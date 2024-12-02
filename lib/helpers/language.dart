String getLanguageCode(String code) {
  switch (code) {
    case "th":
      return "tm";
    case "en":
      return 'en';
    case "ru":
      return "ru";
    case "tr":
      return "tr";
    default:
      return "tm";
  }
}
