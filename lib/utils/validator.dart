// import 'package:easy_localization/easy_localization.dart';
//
// class Validator {
//   static String? defaultValidator(String? value) {
//     if (value != null && value.trim().isEmpty) {
//       return tr("error_field_required");
//     }
//     return null;
//   }
//
//   static String? name(String? value) {
//     if (value != null) {
//       value = value.trim();
//       if (value.isEmpty) {
//         return tr("error_field_required");
//       } else if (!RegExp('[a-zA-Z]').hasMatch(value)) {
//         return tr("enter_correct_name");
//       }
//     }
//     return null;
//   }
//
//   static String? phone(String? value) {
//     if (value != null) {
//       value = value.trim();
//       if (value.isEmpty) {
//         return tr("error_field_required");
//         // } else if (!value.startsWith('+')) {
//         //   return tr("enter_phone_code");
//         // }
//       } else if (!value.startsWith('0')) {
//         return tr("Invalid phone number");
//       } else if (value.length != 11) {
//         return tr("Phone number must be 11 digits");
//       }
//     }
//     return null;
//   }
//
//   static String? text(String? value) {
//     if (value != null) {
//       value = value.trim();
//       if (value.isEmpty) {
//         return tr("error_field_required");
//       } else if (!RegExp('[a-zA-Z]').hasMatch(value)) {
//         return tr("enter_correct_name");
//       }
//     }
//     return null;
//   }
//
//   static String? defaultEmptyValidator(String? value) {
//     return null;
//   }
//
//   static String? email(String? value) {
//     if (value != null) {
//       value = value.trim();
//       if (value.isEmpty) {
//         return tr("error_field_required");
//       } else if (!RegExp(
//               r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//           .hasMatch(value)) {
//         return tr("error_email_regex");
//       }
//     } else {
//       return tr("error_field_required");
//     }
//     return null;
//   }
//
//   static String? password(String? value) {
//     if (value != null) {
//       value = value.trim();
//       if (value.isEmpty) {
//         return tr("error_field_required");
//       }
//       // else if (!RegExp(r"^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$").hasMatch(value)) {
//       //   return tr("error_password_validation");
//       // }
//     } else {
//       return tr("error_field_required");
//     }
//     return null;
//   }
//
//   static String? confirmPassword(String? confirmPassword, String? password) {
//     if (confirmPassword != null) {
//       confirmPassword = confirmPassword.trim();
//       if (confirmPassword.isEmpty) {
//         return tr("error_field_required");
//       } else if (confirmPassword != password) {
//         return tr("error_wrong_password_confirm");
//       }
//     } else {
//       return tr("error_field_required");
//     }
//     return null;
//   }
//
//   static String? numbers(String? value) {
//     if (value != null) {
//       value = value.trim();
//       if (value.isEmpty) {
//         return tr("error_field_required");
//       }
//       final number = int.tryParse(value);
//       if (number == null) {
//         return tr("error_wrong_input");
//       }
//     } else {
//       return tr("error_field_required");
//     }
//     return null;
//   }
//
//   static String? prices(String? value) {
//     if (value != null) {
//       value = value.trim();
//       if (value.isEmpty) {
//         return tr("error_field_required");
//       }
//       final number = double.tryParse(value);
//       if (number == null) {
//         return tr("error_wrong_input");
//       }
//     } else {
//       return tr("error_field_required");
//     }
//     return null;
//   }
// }
