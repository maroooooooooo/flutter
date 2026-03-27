import 'package:flutter/material.dart';
import 'package:projects/models/terms_model.dart';
import 'package:projects/viewmodels/terms_viewmodel.dart';
import 'package:projects/views/screens/whatareyou_screen.dart';
import 'package:projects/widgets/common_widgets.dart';
import 'package:provider/provider.dart';

// ════════════════════════════════════════════════════════════════════════════
// TERMS SCREEN (entry point)
// ════════════════════════════════════════════════════════════════════════════

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TermsViewModel(),
      child: const _TermsView(),
    );
  }
}

// ════════════════════════════════════════════════════════════════════════════
// TERMS VIEW
// ════════════════════════════════════════════════════════════════════════════

class _TermsView extends StatelessWidget {
  const _TermsView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Back chevron
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.chevron_left, size: 32, color: Colors.black87),
                onPressed: () => Navigator.maybePop(context),
              ),
            ),

            // Scrollable body
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    SizedBox(height: 10),
                    Center(child: StanfordLogo()),
                    SizedBox(height: 36),
                    _ConsentSwitches(),
                    SizedBox(height: 24),
                    _TermsBody(),
                    SizedBox(height: 110),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const _AcceptButton(),
    );
  }
}

// ── Consent switches ──────────────────────────────────────────────────────

class _ConsentSwitches extends StatelessWidget {
  const _ConsentSwitches();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TermsViewModel>();
    return Column(
      children: List.generate(
        consentLabels.length,
        (i) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Transform.scale(
                scale: 0.85,
                child: Switch.adaptive(
                  value: vm.switchAt(i),
                  onChanged: (_) => context.read<TermsViewModel>().toggle(i),
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF34C759),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFFE5E5EA),
                  trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  consentLabels[i],
                  style: const TextStyle(
                    fontSize: 13.5,
                    color: Color(0xFF333333),
                    height: 1.4,
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

// ── Terms body text ───────────────────────────────────────────────────────

class _TermsBody extends StatelessWidget {
  const _TermsBody();

  @override
  Widget build(BuildContext context) {
    return Text(
      termsContent.body,
      style: const TextStyle(
        fontSize: 13.5,
        color: Color(0xFF333333),
        height: 1.55,
      ),
    );
  }
}

// ── Accept button ─────────────────────────────────────────────────────────

class _AcceptButton extends StatelessWidget {
  const _AcceptButton();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<TermsViewModel>();
    final enabled = vm.allAccepted;

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
      child: AnimatedOpacity(
        opacity: enabled ? 1.0 : 0.4,
        duration: const Duration(milliseconds: 300),
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: enabled
                ? () {
                    final vm = context.read<TermsViewModel>();
                    vm.acceptTerms();

                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (_, __, ___) => const WhatAreYouScreen(),
                        transitionsBuilder: (_, animation, __, child) {
                          return SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(1, 0),
                              end: Offset.zero,
                            ).animate(
                              CurvedAnimation(
                                parent: animation,
                                curve: Curves.easeInOut,
                              ),
                            ),
                            child: child,
                          );
                        },
                      ),
                    );
                  }
                : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF007AFF),
              disabledBackgroundColor: const Color(0xFF007AFF),
              foregroundColor: Colors.white,
              disabledForegroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'I Accept',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
