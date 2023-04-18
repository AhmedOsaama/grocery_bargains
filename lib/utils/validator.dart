// import 'package:easy_localization/easy_localization.dart';

class Validator {
  static String? defaultValidator(String? value) {
    if (value != null && value.trim().isEmpty) {
      // return tr("error_field_required");
      return "error_field_required";
    }
    return null;
  }

  static String? phoneValidator(String? value) {
    if (value != null && (value.trim().isEmpty || value.trim().length < 6)) {
      // return tr("error_field_required");
      return "Invalid phone number";
    }
    return null;
  }

  static String? text(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return "Full name is required";
      } else if (!RegExp('[a-zA-Z]').hasMatch(value)) {
        return "enter_correct_name";
      }
    }
    return null;
  }

  // static String? phone(String? value) {
  //   if (value != null) {
  //     value = value.trim();
  //     if (value.isEmpty) {
  //       return tr("error_field_required");
  //       // } else if (!value.startsWith('+')) {
  //       //   return tr("enter_phone_code");
  //       // }
  //     } else if (!value.startsWith('0')) {
  //       return tr("Invalid phone number");
  //     } else if (value.length != 11) {
  //       return tr("Phone number must be 11 digits");
  //     }
  //   }
  //   return null;
  // }

  static String? defaultEmptyValidator(String? value) {
    return null;
  }

  static String? email(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return "The email is required";
      } else if (!RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value)) {
        return "Please enter a valid email address";
      }
    } else {
      return "Please enter a valid email address";
    }
    return null;
  }

  static String? password(String? value) {
    if (value != null) {
      value = value.trim();
      if (value.isEmpty) {
        return "Password is required";
      }
    } else {
      return "Password is required";
    }
    return null;
  }

  static String? confirmPassword(String? confirmPassword, String? password) {
    if (confirmPassword != null) {
      confirmPassword = confirmPassword.trim();
      if (confirmPassword.isEmpty) {
        return "Confirm password is required";
      } else if (confirmPassword != password) {
        return "Passwords do not match";
      }
    } else {
      return "Confirm password is required";
    }
    return null;
  }
}
