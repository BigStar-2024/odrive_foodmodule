double toDouble(String str) {
  double ret = 0;
  try {
    ret = double.parse(str);
  } catch (_) {}
  return ret;
}

int toInt(String str) {
  int ret = 0;
  try {
    ret = int.parse(str);
  } catch (_) {}
  return ret;
}

bool toBool(String str) {
  return (str == "true") ? true : false;
}

bool validateEmail(String value) {
  String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  if (!regex.hasMatch(value))
    return false;
  else
    return true;
}

String sliceString(String input, int length) {
  if (input.length > length) {
    return input.substring(0, length) + "..";
  } else {
    return input;
  }
}

String shortenLocationName(String locationName, int maxLength) {
  if (locationName.length <= maxLength) {
    return locationName;
  } else {
    return locationName.substring(0, maxLength - 3) + '...';
  }
}

String maskHiddenString(String input) {
  if (input.length <= 4) {
    return input;
  }
  String masked = '*' * (input.length - 4);
  masked += input.substring(input.length - 4);
  return masked;
}
