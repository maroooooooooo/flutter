import 'package:flutter/material.dart';
import 'package:projects/models/childnumber_model.dart';

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
}