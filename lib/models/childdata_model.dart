enum ChildFieldId {
  childName,
  language,
  dateOfBirth,
  gender,
  previousDiagnosis,
  // ── Add new field IDs here ───────────────────────────────────────────────
  // nationality,
  // medicalHistory,
  // schoolName,
}

enum ChildFieldType {
  text,
  dropdown,
  date,
  yesNo,
  // ── Add new types here if needed ─────────────────────────────────────────
}

class ChildFieldModel {
  final ChildFieldId id;
  final String label;
  final String hint;
  final ChildFieldType type;
  final bool isRequired;
  final List<String>? dropdownOptions;

  const ChildFieldModel({
    required this.id,
    required this.label,
    required this.hint,
    required this.type,
    this.isRequired = true,
    this.dropdownOptions,
  });
}

// ── Field definitions — add/remove/reorder here to change the form ──────────
const List<ChildFieldModel> childFormFields = [
  ChildFieldModel(
    id: ChildFieldId.childName,
    label: '',
    hint: 'Enter child name',
    type: ChildFieldType.text,
  ),
  ChildFieldModel(
    id: ChildFieldId.language,
    label: '',
    hint: 'Language',
    type: ChildFieldType.dropdown,
    dropdownOptions: [
      'Arabic',
      'English',
      'French',
      'Spanish',
      'German',
      'Other',
    ],
  ),
  ChildFieldModel(
    id: ChildFieldId.dateOfBirth,
    label: '',
    hint: 'Date of birth',
    type: ChildFieldType.date,
  ),
  ChildFieldModel(
    id: ChildFieldId.gender,
    label: '',
    hint: 'Gender',
    type: ChildFieldType.dropdown,
    dropdownOptions: ['Male', 'Female'],
  ),
  ChildFieldModel(
    id: ChildFieldId.previousDiagnosis,
    label: 'Had a child recived any diagnoses before ?',
    hint: '',
    type: ChildFieldType.yesNo,
    isRequired: false,
  ),
  // ── Paste new ChildFieldModel(...) here to add a field ───────────────────
];