import 'package:email_validator/email_validator.dart';

class Validators {
  String? validateEmail({String? value}) {
    if (value!.length == 0)
      return "Please enter your email";
    else if (!EmailValidator.validate(value))
      return "Please enter valid email";
    else
      return null;
  }

  String? validatePassword({String? value}) {
    if (value!.isEmpty) {
      return 'Password is required';
    } else if (value.length < 6) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  String? validateName({String? value}) {
    if (value!.isEmpty) {
      return 'Please write your name';
    }
    return null;
  }
  String? validateUsername({String? value}) {
    if (value!.isEmpty) {
      return 'Please write your username';
    }
    return null;
  }
  String? validateVehicleID({String? value}) {
    if (value!.isEmpty) {
      return 'Please write your VehicleID';
    }
    return null;
  }
  String? phoneVehicleID({String? value}) {
    if (value!.isEmpty) {
      return 'Please write your phone';
    }
    return null;
  }

  String? validateAccidentName({String? value}) {
    if (value!.isEmpty) {
      return 'Please write accident name';
    }
    return null;
  }

  String? validateAccidentDescription({String? value}) {
    if (value!.isEmpty) {
      return 'Please write some notes';
    }
    return null;
  }
}
