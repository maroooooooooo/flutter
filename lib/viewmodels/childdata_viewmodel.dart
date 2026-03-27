import 'package:flutter/material.dart';
import 'package:projects/models/childdata_model.dart';

class ChildDataViewModel extends ChangeNotifier {
  // Auto-build state maps from field list — adding a field above auto-registers it
  final Map<ChildFieldId, String> _values = {
    for (final f in childFormFields) f.id: '',
  };

  final Map<ChildFieldId, String?> _errors = {
    for (final f in childFormFields) f.id: null,
  };

  // yesNo fields tracked separately as bool?
  final Map<ChildFieldId, bool?> _yesNoValues = {
    for (final f in childFormFields.where((f) => f.type == ChildFieldType.yesNo))
      f.id: null,
  };

  String getValue(ChildFieldId id) => _values[id] ?? '';
  String? getError(ChildFieldId id) => _errors[id];
  bool? getYesNo(ChildFieldId id) => _yesNoValues[id];

  void updateValue(ChildFieldId id, String value) {
    _values[id] = value;
    if (_errors[id] != null) _errors[id] = null;
    notifyListeners();
  }

  void updateYesNo(ChildFieldId id, bool value) {
    _yesNoValues[id] = value;
    if (_errors[id] != null) _errors[id] = null;
    notifyListeners();
  }

  bool _validateAll() {
    bool valid = true;
    for (final field in childFormFields) {
      if (!field.isRequired) continue;

      if (field.type == ChildFieldType.yesNo) continue;

      final val = _values[field.id]?.trim() ?? '';
      if (val.isEmpty) {
        _errors[field.id] = '${field.hint.isNotEmpty ? field.hint : field.label} is required';
        valid = false;
      } else {
        _errors[field.id] = null;
      }
    }
    notifyListeners();
    return valid;
  }

  void proceed(BuildContext context) {
    if (!_validateAll()) return;
    debugPrint('✅ Child data submitted:');
    debugPrint('   Name     : ${_values[ChildFieldId.childName]}');
    debugPrint('   Language : ${_values[ChildFieldId.language]}');
    debugPrint('   DOB      : ${_values[ChildFieldId.dateOfBirth]}');
    debugPrint('   Gender   : ${_values[ChildFieldId.gender]}');
    debugPrint('   Diagnosed: ${_yesNoValues[ChildFieldId.previousDiagnosis]}');
    // TODO: navigate to next screen
  }

  static const int totalSteps = 4;
  static const int currentStep = 4;
}