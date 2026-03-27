import 'package:flutter/material.dart';

// ════════════════════════════════════════════════════════════════════════════
// VIEW-MODEL
// ════════════════════════════════════════════════════════════════════════════

class TermsViewModel extends ChangeNotifier {
  final List<bool> _switches = [false, false, false];

  bool switchAt(int i) => _switches[i];
  bool get allAccepted => _switches.every((s) => s);

  void toggle(int index) {
    _switches[index] = !_switches[index];
    notifyListeners();
  }

  void acceptTerms() {
    if (!allAccepted) return;
    debugPrint('Terms accepted!');
    // TODO: navigate to next screen
  }
}
