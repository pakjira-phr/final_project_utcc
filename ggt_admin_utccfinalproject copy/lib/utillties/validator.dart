import 'package:form_field_validator/form_field_validator.dart';

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'password is required'),
  MinLengthValidator(6, errorText: 'password must be at least 6 digits'),
]);
final emailValidator = MultiValidator([
  RequiredValidator(errorText: 'email is required'),
  EmailValidator(errorText: 'enter a valid email address')
]);
final userNameValidator = MultiValidator([
  RequiredValidator(errorText: 'user name is required'),
  MaxLengthValidator(10, errorText: 'user name must less than 10 characters'),
  MinLengthValidator(3, errorText: 'user name must more than 3 characters')
]);
final thaiIDCardValidator = MultiValidator([
  RequiredValidator(errorText: 'ID is required'),
  MinLengthValidator(13, errorText: 'ID must be 13 digits'),
  MaxLengthValidator(13, errorText: 'ID must be 13 digits'),
]);
final licenseIDValidator = MultiValidator([
  RequiredValidator(errorText: 'ID is required'),
  MinLengthValidator(7, errorText: 'ID must be  7 digits'),
  MaxLengthValidator(7, errorText: 'ID must be 7 digits'),
]);
final phoneNumValidator = MultiValidator([
  RequiredValidator(errorText: 'Phone Number is required'),
  MinLengthValidator(7, errorText: 'ID must be  10 digits'),
  MaxLengthValidator(7, errorText: 'ID must be 10 digits'),
]);

// String? Function(String?)? confirmPassword(
//     TextEditingController passwordController) {
//   devtools
//       .log('passwordController.text in validator : ${passwordController.text}');
//   MultiValidator con = MultiValidator(
//     [
//       RequiredValidator(errorText: 'password is required'),
//       TwoFieldsMatchValidator(
//         checkField: passwordController.text,
//         errorText: "password not match",
//       ),
//     ],
//   );
//   return con;
// }

// class TwoFieldsMatchValidator extends TextFieldValidator {
//   String? checkField;
//   TwoFieldsMatchValidator({required this.checkField, required String errorText})
//       : super(errorText);

//   @override
//   bool get ignoreEmptyValues => true;

//   @override
//   bool isValid(String? value) {
//     devtools.log('value : $value');
//     devtools.log('checkField : $checkField');
//     if (checkField == '' || checkField == null) {
//       checkField = value;
//     }
//     return checkField == value;
//   }
// }
