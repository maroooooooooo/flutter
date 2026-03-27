enum FormFieldId {
  fullName,
  email,
  phone,
  password,
  country,
  // ── Add new field IDs here ──────────────────────────────────────────────
  // dateOfBirth,
  // address,
}

enum FieldType { text, email, phone, password, dropdown }

class FormFieldModel {
  final FormFieldId id;
  final String label;
  final String hint;
  final FieldType type;
  final bool isRequired;
  final List<String>? dropdownOptions; // used when type == dropdown

  const FormFieldModel({
    required this.id,
    required this.label,
    required this.hint,
    required this.type,
    this.isRequired = true,
    this.dropdownOptions,
  });
}

// ── Field definitions — add/remove/reorder here to change the form ─────────
const List<FormFieldModel> parentFormFields = [
  FormFieldModel(
    id: FormFieldId.fullName,
    label: 'Full name',
    hint: 'Enter your name',
    type: FieldType.text,
  ),
  FormFieldModel(
    id: FormFieldId.email,
    label: 'Email',
    hint: 'Enter your email',
    type: FieldType.email,
  ),
  FormFieldModel(
    id: FormFieldId.phone,
    label: 'phone',
    hint: 'phone number',
    type: FieldType.phone,
  ),
  FormFieldModel(
    id: FormFieldId.password,
    label: 'Password',
    hint: '••••••••',
    type: FieldType.password,
  ),
  FormFieldModel(
    id: FormFieldId.country,
    label: 'Country',
    hint: 'Select country',
    type: FieldType.dropdown,
    dropdownOptions: [
      'Egypt',
      'United States',
      'United Kingdom',
      'Saudi Arabia',
      'UAE',
      'Canada',
      'Australia',
      'Germany',
      'France',
      'Other',
    ],
  ),
  // ── Paste new FormFieldModel(...) here to add a field ───────────────────
];