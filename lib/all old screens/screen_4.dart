/*import 'package:flutter/material.dart';
import 'package:projects/screen_6.dart';
import 'package:projects/screen_7.dart';
import 'package:provider/provider.dart';

// ════════════════════════════════════════════════════════════════════════════
// MODEL
// ════════════════════════════════════════════════════════════════════════════

enum UserRole { parent, caregiverOrganization }

extension UserRoleLabel on UserRole {
  String get label {
    switch (this) {
      case UserRole.parent:
        return 'parent';
      case UserRole.caregiverOrganization:
        return 'Caregiver / Organization';
    }
  }
}

// ════════════════════════════════════════════════════════════════════════════
// VIEW-MODEL
// ════════════════════════════════════════════════════════════════════════════

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

// ════════════════════════════════════════════════════════════════════════════
// VIEW
// ════════════════════════════════════════════════════════════════════════════

class WhatAreYouScreen extends StatelessWidget {
  const WhatAreYouScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WhatAreYouViewModel(),
      child: const _WhatAreYouView(),
    );
  }
}

// ── Root scaffold ─────────────────────────────────────────────────────────

class _WhatAreYouView extends StatelessWidget {
  const _WhatAreYouView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back chevron
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 4.0),
              child: IconButton(
                icon: const Icon(Icons.chevron_left, size: 32, color: Colors.black87),
                onPressed: () => Navigator.maybePop(context),
              ),
            ),

            // Main content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    SizedBox(height: 48),
                    _Header(),
                    SizedBox(height: 40),
                    _RoleOptions(),
                  ],
                ),
              ),
            ),

            // Next button
            const _NextButton(),
          ],
        ),
      ),
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
          'What are you ?',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: Colors.black,
            height: 1.2,
          ),
        ),
        SizedBox(height: 8),
        Text(
          'please select an option',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 13.5,
            color: Color(0xFFAAAAAA),
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }
}

// ── Role option cards ─────────────────────────────────────────────────────

class _RoleOptions extends StatelessWidget {
  const _RoleOptions();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: UserRole.values
          .map((role) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: _RoleCard(role: role),
              ))
          .toList(),
    );
  }
}

class _RoleCard extends StatelessWidget {
  final UserRole role;
  const _RoleCard({required this.role});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WhatAreYouViewModel>();
    final isSelected = vm.selectedRole == role;

    return GestureDetector(
      onTap: () => context.read<WhatAreYouViewModel>().selectRole(role),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        width: double.infinity,
        height: 58,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? const Color(0xFF007AFF) : const Color(0xFFE0E0E0),
            width: isSelected ? 2.0 : 1.2,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: const Color(0xFF007AFF).withOpacity(0.12),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            role.label,
            style: TextStyle(
              fontSize: 15,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected ? const Color(0xFF007AFF) : const Color(0xFF555555),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Next button ───────────────────────────────────────────────────────────

class _NextButton extends StatelessWidget {
  const _NextButton();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<WhatAreYouViewModel>();
    final enabled = vm.canProceed;

    return Container(
      color: const Color(0xFFF5F5F5),
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.4,
        duration: const Duration(milliseconds: 300),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: enabled ? () => vm.proceed(context) : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              disabledBackgroundColor: const Color(0xFF007AFF),
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Next ',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
                Text(
                  '→',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}*/