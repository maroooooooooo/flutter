import 'package:flutter/material.dart';
import 'package:projects/models/createaccount_model.dart';


class CreateAccountViewModel extends ChangeNotifier {
  // Dynamically build state maps from field definitions
  final Map<FormFieldId, String> _values = {
    for (final f in parentFormFields) f.id: '',
  };

  final Map<FormFieldId, String?> _errors = {
    for (final f in parentFormFields) f.id: null,
  };

  final Map<FormFieldId, bool> _obscured = {
    for (final f in parentFormFields.where((f) => f.type == FieldType.password))
      f.id: true,
  };

  String getValue(FormFieldId id) => _values[id] ?? '';
  String? getError(FormFieldId id) => _errors[id];
  bool isObscured(FormFieldId id) => _obscured[id] ?? false;

  void updateValue(FormFieldId id, String value) {
    _values[id] = value;
    if (_errors[id] != null) _errors[id] = null; // clear error on edit
    notifyListeners();
  }

  void toggleObscure(FormFieldId id) {
    if (_obscured.containsKey(id)) {
      _obscured[id] = !_obscured[id]!;
      notifyListeners();
    }
  }

  bool _validateAll() {
    bool valid = true;
    for (final field in parentFormFields) {
      if (!field.isRequired) continue;
      final val = _values[field.id]?.trim() ?? '';
      if (val.isEmpty) {
        _errors[field.id] = '${field.label} is required';
        valid = false;
      } else if (field.type == FieldType.email && !val.contains('@')) {
        _errors[field.id] = 'Enter a valid email';
        valid = false;
      } else if (field.type == FieldType.password && val.length < 6) {
        _errors[field.id] = 'Password must be at least 6 characters';
        valid = false;
      } else {
        _errors[field.id] = null;
      }
    }
    notifyListeners();
    return valid;
  }

  void proceed() {
    if (!_validateAll()) return;
    debugPrint('Form submitted: $_values');
    // TODO: navigate to step 2
  }

  // Total steps shown in the step indicator
  static const int totalSteps = 4;
  static const int currentStep = 1;
}