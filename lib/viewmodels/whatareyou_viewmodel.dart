import 'package:flutter/material.dart';
import 'package:projects/models/whatareyou_model.dart';
import 'package:projects/views/screens/childnumber_screen.dart';
import 'package:projects/views/screens/opt_screen.dart';


class WhatAreYouViewModel extends ChangeNotifier {
  UserRole? _selectedRole;

  UserRole? get selectedRole => _selectedRole;
  bool get canProceed => _selectedRole != null;

  void selectRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  void proceed(BuildContext context) {
    if (!canProceed) return;

    debugPrint('Selected role: ${_selectedRole!.label}');

    if (_selectedRole == UserRole.parent) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) =>
              const OtpScreen(phoneNumber: '+201001234567'),
          transitionsBuilder: (_, animation, __, child) {
            const begin = Offset(1.0, 0.0); // from right
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    } else if (_selectedRole == UserRole.caregiverOrganization) {
      Navigator.of(context).push(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const ChildNumberScreen(),
          transitionsBuilder: (_, animation, __, child) {
            const begin = Offset(1.0, 0.0); // from right
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

            return SlideTransition(
              position: animation.drive(tween),
              child: child,
            );
          },
        ),
      );
    }
  }
}