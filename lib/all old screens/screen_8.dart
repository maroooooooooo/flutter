/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ════════════════════════════════════════════════════════════════════════════
// MODEL
// ════════════════════════════════════════════════════════════════════════════

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

// ════════════════════════════════════════════════════════════════════════════
// VIEW-MODEL
// ════════════════════════════════════════════════════════════════════════════

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

// ════════════════════════════════════════════════════════════════════════════
// VIEW
// ════════════════════════════════════════════════════════════════════════════

class ChildDataScreen extends StatelessWidget {
  const ChildDataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChildDataViewModel(),
      child: const _ChildDataView(),
    );
  }
}

// ── Root scaffold ─────────────────────────────────────────────────────────

class _ChildDataView extends StatelessWidget {
  const _ChildDataView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: IconButton(
                icon: const Icon(Icons.chevron_left, size: 32, color: Colors.black87),
                onPressed: () => Navigator.maybePop(context),
              ),
            ),

            // Step indicator
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: _StepIndicator(),
            ),

            const SizedBox(height: 24),

            // Title
            const Center(child: _Header()),

            const SizedBox(height: 20),

            // Scrollable form
            const Expanded(child: _FormBody()),

            // Next button
            const _NextButton(),
          ],
        ),
      ),
    );
  }
}

// ── Step indicator ────────────────────────────────────────────────────────

class _StepIndicator extends StatelessWidget {
  const _StepIndicator();

  @override
  Widget build(BuildContext context) {
    const total = ChildDataViewModel.totalSteps;
    const current = ChildDataViewModel.currentStep;

    return Row(
      children: List.generate(total * 2 - 1, (i) {
        if (i.isOdd) {
          final leftStep = (i ~/ 2) + 1;
          final isCompleted = leftStep < current;
          return Expanded(
            child: Container(
              height: 1.5,
              color: isCompleted
                  ? const Color(0xFF007AFF)
                  : const Color(0xFFDDDDDD),
            ),
          );
        }
        final step = i ~/ 2 + 1;
        final isActive = step == current;
        final isCompleted = step < current;

        return Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? const Color(0xFF007AFF) : Colors.white,
            border: Border.all(
              color: isActive || isCompleted
                  ? const Color(0xFF007AFF)
                  : const Color(0xFFCCCCCC),
              width: 1.5,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, size: 14, color: Colors.white)
                : Text(
                    '$step',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isActive
                          ? const Color(0xFF007AFF)
                          : const Color(0xFFAAAAAA),
                    ),
                  ),
          ),
        );
      }),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        Text(
          'Enter child data',
          style: TextStyle(
              fontSize: 22, fontWeight: FontWeight.w800, color: Colors.black),
        ),
        SizedBox(height: 6),
        Text(
          'Please enter the number you need.',
          style: TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)),
        ),
      ],
    );
  }
}

// ── Form body — loops the field list and dispatches to the right widget ────

class _FormBody extends StatelessWidget {
  const _FormBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...childFormFields.map((field) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _buildField(field),
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildField(ChildFieldModel field) {
    switch (field.type) {
      case ChildFieldType.text:
        return _ChildTextField(field: field);
      case ChildFieldType.dropdown:
        return _ChildDropdownField(field: field);
      case ChildFieldType.date:
        return _ChildDateField(field: field);
      case ChildFieldType.yesNo:
        return _ChildYesNoField(field: field);
    }
  }
}

// ── Shared card decoration ────────────────────────────────────────────────

BoxDecoration _cardDecoration({bool hasError = false, bool focused = false}) {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    border: Border.all(
      color: hasError
          ? Colors.redAccent
          : focused
              ? const Color(0xFF007AFF)
              : const Color(0xFFE8E8E8),
      width: focused || hasError ? 1.5 : 1.0,
    ),
  );
}

// ── Text field ────────────────────────────────────────────────────────────

class _ChildTextField extends StatefulWidget {
  final ChildFieldModel field;
  const _ChildTextField({required this.field});

  @override
  State<_ChildTextField> createState() => _ChildTextFieldState();
}

class _ChildTextFieldState extends State<_ChildTextField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ChildDataViewModel>();
    final error = vm.getError(widget.field.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Focus(
          onFocusChange: (f) => setState(() => _focused = f),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: _cardDecoration(
                hasError: error != null, focused: _focused),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            child: TextField(
              onChanged: (v) => context
                  .read<ChildDataViewModel>()
                  .updateValue(widget.field.id, v),
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              decoration: InputDecoration(
                hintText: widget.field.hint,
                hintStyle:
                    const TextStyle(color: Color(0xFFBBBBBB), fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
        ),
        if (error != null) _ErrorLabel(error),
      ],
    );
  }
}

// ── Dropdown field ────────────────────────────────────────────────────────

class _ChildDropdownField extends StatelessWidget {
  final ChildFieldModel field;
  const _ChildDropdownField({required this.field});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ChildDataViewModel>();
    final value = vm.getValue(field.id);
    final error = vm.getError(field.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: _cardDecoration(hasError: error != null),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value.isEmpty ? null : value,
              isExpanded: true,
              hint: Text(
                field.hint,
                style: const TextStyle(color: Color(0xFFBBBBBB), fontSize: 14),
              ),
              icon: const Icon(Icons.keyboard_arrow_down,
                  color: Color(0xFF888888), size: 20),
              style: const TextStyle(fontSize: 14, color: Colors.black87),
              items: (field.dropdownOptions ?? [])
                  .map((opt) => DropdownMenuItem(
                        value: opt,
                        child: Text(opt),
                      ))
                  .toList(),
              onChanged: (v) {
                if (v != null) {
                  context
                      .read<ChildDataViewModel>()
                      .updateValue(field.id, v);
                }
              },
            ),
          ),
        ),
        if (error != null) _ErrorLabel(error),
      ],
    );
  }
}

// ── Date field ────────────────────────────────────────────────────────────

class _ChildDateField extends StatefulWidget {
  final ChildFieldModel field;
  const _ChildDateField({required this.field});

  @override
  State<_ChildDateField> createState() => _ChildDateFieldState();
}

class _ChildDateFieldState extends State<_ChildDateField> {
  String _displayDate = '';

  Future<void> _pickDate(BuildContext context) async {
    final vm = context.read<ChildDataViewModel>();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 5)),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF007AFF),
            onPrimary: Colors.white,
            surface: Colors.white,
          ),
        ),
        child: child!,
      ),
    );

    if (picked != null) {
      final formatted =
          '${picked.day.toString().padLeft(2, '0')} / ${picked.month.toString().padLeft(2, '0')} / ${picked.year}';
      setState(() => _displayDate = formatted);
      vm.updateValue(widget.field.id, formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ChildDataViewModel>();
    final error = vm.getError(widget.field.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => _pickDate(context),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            decoration: _cardDecoration(hasError: error != null),
            padding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    _displayDate.isEmpty ? widget.field.hint : _displayDate,
                    style: TextStyle(
                      fontSize: 14,
                      color: _displayDate.isEmpty
                          ? const Color(0xFFBBBBBB)
                          : Colors.black87,
                    ),
                  ),
                ),
                const Icon(Icons.calendar_today_outlined,
                    size: 18, color: Color(0xFF888888)),
              ],
            ),
          ),
        ),
        if (error != null) _ErrorLabel(error),
      ],
    );
  }
}

// ── Yes / No field ────────────────────────────────────────────────────────

class _ChildYesNoField extends StatelessWidget {
  final ChildFieldModel field;
  const _ChildYesNoField({required this.field});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ChildDataViewModel>();
    final current = vm.getYesNo(field.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Question label
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Text(
            field.label,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87),
          ),
        ),

        // Yes / No toggle buttons
        Row(
          children: [
            _YesNoButton(
              label: 'Yes',
              isSelected: current == true,
              onTap: () => context
                  .read<ChildDataViewModel>()
                  .updateYesNo(field.id, true),
            ),
            const SizedBox(width: 12),
            _YesNoButton(
              label: 'No',
              isSelected: current == false,
              onTap: () => context
                  .read<ChildDataViewModel>()
                  .updateYesNo(field.id, false),
            ),
          ],
        ),
      ],
    );
  }
}

class _YesNoButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _YesNoButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 90,
        height: 42,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF007AFF) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF007AFF)
                : const Color(0xFFDDDDDD),
            width: 1.2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected ? Colors.white : const Color(0xFF888888),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Shared error label ────────────────────────────────────────────────────

class _ErrorLabel extends StatelessWidget {
  final String message;
  const _ErrorLabel(this.message);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 5, left: 4),
      child: Text(
        message,
        style:
            const TextStyle(color: Colors.redAccent, fontSize: 12),
      ),
    );
  }
}

// ── Next button ───────────────────────────────────────────────────────────

class _NextButton extends StatelessWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: () => context.read<ChildDataViewModel>().proceed(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF007AFF),
            foregroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Next ',
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.2)),
              Text('→',
                  style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}*/