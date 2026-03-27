import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projects/models/createaccount_model.dart';
import 'package:projects/viewmodels/createaccount_viewmodel.dart';
import 'package:provider/provider.dart';


class CreateAccountScreen extends StatelessWidget {
  const CreateAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CreateAccountViewModel(),
      child: const _CreateAccountView(),
    );
  }
}

// ── Root scaffold ─────────────────────────────────────────────────────────

class _CreateAccountView extends StatelessWidget {
  const _CreateAccountView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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

            const SizedBox(height: 20),

            // Title
            const Center(
              child: Text(
                'Create an account',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
              ),
            ),

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
    const total = CreateAccountViewModel.totalSteps;
    const current = CreateAccountViewModel.currentStep;

    return Row(
      children: List.generate(total * 2 - 1, (i) {
        if (i.isOdd) {
          // Connector line
          final leftStep = (i ~/ 2) + 1;
          final isCompleted = leftStep < current;
          return Expanded(
            child: Container(
              height: 1.5,
              color: isCompleted ? const Color(0xFF007AFF) : const Color(0xFFDDDDDD),
            ),
          );
        }
        // Step circle
        final step = i ~/ 2 + 1;
        final isActive = step == current;
        final isCompleted = step < current;

        return Container(
          width: 30,
          height: 30,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isActive || isCompleted ? Colors.white : Colors.white,
            border: Border.all(
              color: isActive || isCompleted
                  ? const Color(0xFF007AFF)
                  : const Color(0xFFCCCCCC),
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              '$step',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive || isCompleted
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

// ── Form body ─────────────────────────────────────────────────────────────

class _FormBody extends StatelessWidget {
  const _FormBody();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Dynamically render each field from the model list
          ...parentFormFields.map((field) => Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: _buildField(field),
              )),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildField(FormFieldModel field) {
    switch (field.type) {
      case FieldType.phone:
        return _PhoneField(field: field);
      case FieldType.password:
        return _PasswordField(field: field);
      case FieldType.dropdown:
        return _DropdownField(field: field);
      default:
        return _TextField(field: field);
    }
  }
}

// ── Shared field label ────────────────────────────────────────────────────

class _FieldLabel extends StatelessWidget {
  final String label;
  const _FieldLabel(this.label);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6, top: 14),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: Colors.black87,
        ),
      ),
    );
  }
}

// ── Shared input decoration ───────────────────────────────────────────────

InputDecoration _inputDecoration({
  required String hint,
  Widget? suffix,
  Widget? prefix,
  String? errorText,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14),
    errorText: errorText,
    suffixIcon: suffix,
    prefixIcon: prefix,
    filled: true,
    fillColor: const Color(0xFFF7F7F7),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Color(0xFF007AFF), width: 1.5),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
    ),
  );
}

// ── Plain text / email field ──────────────────────────────────────────────

class _TextField extends StatelessWidget {
  final FormFieldModel field;
  const _TextField({required this.field});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateAccountViewModel>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(field.label),
        TextFormField(
          keyboardType: field.type == FieldType.email
              ? TextInputType.emailAddress
              : TextInputType.text,
          onChanged: (v) => context.read<CreateAccountViewModel>().updateValue(field.id, v),
          decoration: _inputDecoration(
            hint: field.hint,
            errorText: vm.getError(field.id),
          ),
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}

// ── Password field ────────────────────────────────────────────────────────

class _PasswordField extends StatelessWidget {
  final FormFieldModel field;
  const _PasswordField({required this.field});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateAccountViewModel>();
    final obscured = vm.isObscured(field.id);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(field.label),
        TextFormField(
          obscureText: obscured,
          onChanged: (v) => context.read<CreateAccountViewModel>().updateValue(field.id, v),
          decoration: _inputDecoration(
            hint: field.hint,
            errorText: vm.getError(field.id),
            suffix: IconButton(
              icon: Icon(
                obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                color: const Color(0xFFAAAAAA),
                size: 20,
              ),
              onPressed: () => context.read<CreateAccountViewModel>().toggleObscure(field.id),
            ),
          ),
          style: const TextStyle(fontSize: 14, color: Colors.black87),
        ),
      ],
    );
  }
}

// ── Phone field ───────────────────────────────────────────────────────────
// Built as a custom Row to avoid Flutter's prefixIcon width constraints.

class _PhoneField extends StatelessWidget {
  final FormFieldModel field;
  const _PhoneField({required this.field});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateAccountViewModel>();
    final error = vm.getError(field.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(field.label),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF7F7F7),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: error != null ? Colors.redAccent : const Color(0xFFE5E5E5),
              width: error != null ? 1.5 : 1.0,
            ),
          ),
          child: Row(
            children: [
              // ── Dial-code prefix ──────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'icons/flags/png/eg.png',
                      package: 'country_icons',
                      height: 18,
                      width: 24,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.keyboard_arrow_down,
                      size: 16,
                      color: Color(0xFF888888),
                    ),
                    const SizedBox(width: 6),
                    const Text(
                      '+20',
                      style: TextStyle(fontSize: 14, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              // Divider
              Container(width: 1, height: 24, color: const Color(0xFFDDDDDD)),
              // ── Number input ──────────────────────────────────────────
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  onChanged: (v) =>
                      context.read<CreateAccountViewModel>().updateValue(field.id, v),
                  style: const TextStyle(fontSize: 14, color: Colors.black87),
                  decoration: InputDecoration(
                    hintText: field.hint,
                    hintStyle: const TextStyle(
                        color: Color(0xFFAAAAAA), fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 15),
                  ),
                ),
              ),
            ],
          ),
        ),
        if (error != null)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(error,
                style: const TextStyle(
                    color: Colors.redAccent, fontSize: 12)),
          ),
      ],
    );
  }
}

// ── Dropdown field ────────────────────────────────────────────────────────

class _DropdownField extends StatelessWidget {
  final FormFieldModel field;
  const _DropdownField({required this.field});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CreateAccountViewModel>();
    final value = vm.getValue(field.id);
    final error = vm.getError(field.id);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _FieldLabel(field.label),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          hint: Text(field.hint,
              style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 14)),
          icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF888888)),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF7F7F7),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            errorText: error,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E5E5)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF007AFF), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Colors.redAccent),
            ),
          ),
          items: (field.dropdownOptions ?? [])
              .map((opt) => DropdownMenuItem(
                    value: opt,
                    child: Text(opt,
                        style: const TextStyle(fontSize: 14, color: Colors.black87)),
                  ))
              .toList(),
          onChanged: (v) {
            if (v != null) {
              context.read<CreateAccountViewModel>().updateValue(field.id, v);
            }
          },
        ),
      ],
    );
  }
}

// ── Next button ───────────────────────────────────────────────────────────

class _NextButton extends StatelessWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<CreateAccountViewModel>();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: vm.proceed,
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
              Text('→', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}