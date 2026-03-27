/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ════════════════════════════════════════════════════════════════════════════
// MODEL
// ════════════════════════════════════════════════════════════════════════════

class ChildNumberModel {
  final int minValue;
  final int maxValue;

  const ChildNumberModel({
    this.minValue = 1,
    this.maxValue = 10, // ← change this to add more numbers
  });

  List<int> get values =>
      List.generate(maxValue - minValue + 1, (i) => minValue + i);
}

// ════════════════════════════════════════════════════════════════════════════
// VIEW-MODEL
// ════════════════════════════════════════════════════════════════════════════

class ChildNumberViewModel extends ChangeNotifier {
  ChildNumberViewModel({ChildNumberModel? model})
      : model = model ?? const ChildNumberModel() {
    // Start with middle item selected
    _selectedIndex = (this.model.values.length ~/ 2);
    scrollController = FixedExtentScrollController(
      initialItem: _selectedIndex,
    );
  }

  final ChildNumberModel model;
  late final FixedExtentScrollController scrollController;

  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;
  int get selectedValue => model.values[_selectedIndex];
  bool get canProceed => true; // always valid — a number is always selected

  void onItemChanged(int index) {
    _selectedIndex = index;
    notifyListeners();
  }

  void proceed(BuildContext context) {
    // ── Print selected value to console ────────────────────────────────────
    debugPrint('✅ Selected child number: $selectedValue');

    // ── Navigate to WhatAreYouScreen (reusing a screen from the project) ───
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const _ConfirmationScreen()),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  static const int totalSteps = 4;
  static const int currentStep = 3;
}

// ════════════════════════════════════════════════════════════════════════════
// VIEW
// ════════════════════════════════════════════════════════════════════════════

class ChildNumberScreen extends StatelessWidget {
  const ChildNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChildNumberViewModel(),
      child: const _ChildNumberView(),
    );
  }
}

// ── Root scaffold ─────────────────────────────────────────────────────────

class _ChildNumberView extends StatelessWidget {
  const _ChildNumberView();

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
                icon: const Icon(Icons.chevron_left,
                    size: 32, color: Colors.black87),
                onPressed: () => Navigator.maybePop(context),
              ),
            ),

            // Step indicator
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: _StepIndicator(),
            ),

            const SizedBox(height: 32),

            // Header
            const Center(child: _Header()),

            const SizedBox(height: 32),

            // Picker
            const Expanded(child: _NumberPicker()),

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
    const total = ChildNumberViewModel.totalSteps;
    const current = ChildNumberViewModel.currentStep;

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
          'Enter child number',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'Please enter the number you need.',
          style: TextStyle(fontSize: 13, color: Color(0xFF999999)),
        ),
      ],
    );
  }
}

// ── Number picker ─────────────────────────────────────────────────────────

class _NumberPicker extends StatelessWidget {
  const _NumberPicker();

  static const double _itemExtent = 56.0;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ChildNumberViewModel>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Center(
        child: Container(
          width: double.infinity,
          height: 230,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE5E5E5), width: 1.2),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // ── Selection highlight band ──────────────────────────────
              Positioned(
                child: Container(
                  height: _itemExtent,
                  margin: const EdgeInsets.symmetric(horizontal: 0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),

              // ── Scrollable list ───────────────────────────────────────
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ListWheelScrollView.useDelegate(
                  controller: vm.scrollController,
                  itemExtent: _itemExtent,
                  perspective: 0.003,
                  diameterRatio: 2.8,
                  physics: const FixedExtentScrollPhysics(),
                  onSelectedItemChanged: vm.onItemChanged,
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: vm.model.values.length,
                    builder: (context, index) {
                      final value = vm.model.values[index];
                      final isSelected = index == vm.selectedIndex;
                      return _PickerItem(
                        value: value,
                        isSelected: isSelected,
                      );
                    },
                  ),
                ),
              ),

              // ── Top & bottom fade masks ───────────────────────────────
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Container(
                    height: 70,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.white, Colors.transparent],
                      ),
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(16)),
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Container(
                    height: 70,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.white, Colors.transparent],
                      ),
                      borderRadius:
                          BorderRadius.vertical(bottom: Radius.circular(16)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PickerItem extends StatelessWidget {
  final int value;
  final bool isSelected;

  const _PickerItem({required this.value, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 180),
        style: TextStyle(
          fontSize: isSelected ? 26 : 22,
          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
          color: isSelected ? Colors.black : const Color(0xFFBBBBBB),
        ),
        child: Text('$value'),
      ),
    );
  }
}

// ── Next button ───────────────────────────────────────────────────────────

class _NextButton extends StatelessWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context) {
    final vm = context.read<ChildNumberViewModel>();
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      child: SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: () => vm.proceed(context),
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
}

// ════════════════════════════════════════════════════════════════════════════
// CONFIRMATION SCREEN  (simple destination to prove navigation + value works)
// ════════════════════════════════════════════════════════════════════════════

class _ConfirmationScreen extends StatelessWidget {
  const _ConfirmationScreen();

  @override
  Widget build(BuildContext context) {
    // Value is passed via Navigator arguments for a real app;
    // here we read it from the route arguments if available.
    final int? number =
        ModalRoute.of(context)?.settings.arguments as int?;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: IconButton(
                icon: const Icon(Icons.chevron_left,
                    size: 32, color: Colors.black87),
                onPressed: () => Navigator.maybePop(context),
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFF007AFF).withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.check_circle_outline,
                          size: 44, color: Color(0xFF007AFF)),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'All set!',
                      style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      number != null
                          ? 'You selected $number child${number == 1 ? '' : 'ren'}.'
                          : 'Selection received.',
                      style: const TextStyle(
                          fontSize: 15, color: Color(0xFF888888)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/