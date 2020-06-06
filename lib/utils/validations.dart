import '../utils/app_localizations.dart';

class Validations {
  String validateEmail(String value, context) {
    if (value.isEmpty)
      return AppLocalizations.of(context).translate("email_empty");
    final RegExp nameExp = new RegExp(
        r'^([A-Za-z0-9+_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,63})$');
    if (!nameExp.hasMatch(value))
      return AppLocalizations.of(context).translate("email_invalid");
    return null;
  }

  String validateName(String value, context, [String whichName]) {
    if (value.isEmpty)
      return whichName == "first"
          ? AppLocalizations.of(context).translate("first_name_empty")
          : AppLocalizations.of(context).translate("last_name_empty");
    final RegExp nameExp = new RegExp(r'[a-z0-9]');
    if (!nameExp.hasMatch(value))
      return whichName == "first"
          ? AppLocalizations.of(context).translate("first_name_invalid")
          : AppLocalizations.of(context).translate("last_name_invalid");
    return null;
  }

  String validateUserName(String value, context) {
    if (value.isEmpty)
      return AppLocalizations.of(context).translate("user_name_empty");
    final RegExp nameExp = new RegExp(r'[a-z0-9]');
    if (!nameExp.hasMatch(value))
      return AppLocalizations.of(context).translate("user_name_not_valid");
    return null;
  }

  String validatePassword(String value, String s, context) {
    if (value.isEmpty)
      return AppLocalizations.of(context).translate("password_empty");
    final RegExp nameExp = new RegExp(r'[A-Za-z0-9]');
    if (!nameExp.hasMatch(value))
      return s == 'new'
          ? AppLocalizations.of(context).translate("new_password_invalid")
          : AppLocalizations.of(context).translate("password_invalid");
    return null;
  }

  String validatePhone(String value, context) {
    if (value.isEmpty)
      return AppLocalizations.of(context).translate("phone_empty");
    return null;
  }
}
