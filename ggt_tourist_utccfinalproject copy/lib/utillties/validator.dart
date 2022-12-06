import 'package:form_field_validator/form_field_validator.dart';

final passwordValidator = MultiValidator([
  RequiredValidator(errorText: 'password is required'),
  MinLengthValidator(6, errorText: 'password must be at least 6 digits long'),
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
  MinLengthValidator(13, errorText: 'ID must be 13 digits long'),
  MaxLengthValidator(13, errorText: 'ID must be 13 digits long'),
]);
final phoneValidator = MultiValidator([
  RequiredValidator(errorText: 'Phone Number is required'),
  MinLengthValidator(10, errorText: 'Phone Number must be 10 digits long'),
  MaxLengthValidator(10, errorText: 'Phone Number must be 10 digits long'),
]);

final swiftCodeValidator = MultiValidator([
  RequiredValidator(errorText: 'SWIFT Code is required'),
  MinLengthValidator(8, errorText: 'SWIFT Code must be 8-11 digits long'),
  MaxLengthValidator(11, errorText: 'SWIFT Code must be 8-11 digits long'),
]);

final promptPayInternationalValidator = MultiValidator([
  RequiredValidator(errorText: 'PayNowID is required'),
  MinLengthValidator(10, errorText: 'PayNowID must more than 10 digits long'),
  // MaxLengthValidator(10, errorText: 'PayNowID must be 10 digits long'),
]);
final promptPayValidator = MultiValidator([
  RequiredValidator(errorText: 'Prompt Pay is required'),
  MinLengthValidator(10, errorText: 'Prompt Pay must be 10 or 13 digits long'),
  MaxLengthValidator(13, errorText: 'Prompt Pay must be 10 or 13 digits long'),
]);

final postCodeValidator = MultiValidator([
  RequiredValidator(errorText: 'Post Code is required'),
  MinLengthValidator(5, errorText: 'Post Code must be 5 digits long'),
  MaxLengthValidator(5, errorText: 'Post Code must be 5 digits long'),
]);

final nullValidator = MultiValidator([]);
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
