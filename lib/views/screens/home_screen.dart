import 'package:flutter/material.dart';
import 'package:projects/viewmodels/home_viewmodel.dart';
import 'package:projects/views/screens/assessment_screen.dart';
import 'package:projects/views/screens/child_menu_screen.dart';
import 'package:projects/views/screens/settings_screen.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onNavTap(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => const AssessmentScreen(),
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
        ),
      );
      return;
    }
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      extendBody: true,
      body: SafeArea(
        child: Consumer<HomeViewModel>(
          builder: (context, viewModel, child) {
            if (!viewModel.hasChild) {
              return _buildEmptyState(context);
            }

            return RefreshIndicator(
              onRefresh: viewModel.refreshData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(context, viewModel),
                      const SizedBox(height: 24),
                      _buildChildProgressCard(viewModel),
                      const SizedBox(height: 20),
                      _buildAssessmentInfoCard(),
                      const SizedBox(height: 24),
                      _buildAssessmentProgressSection(viewModel),
                      const SizedBox(height: 24),
                      _buildQuickActionsSection(context),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(context),
    );
  }

  // ── HEADER ──────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, HomeViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChildMenuScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                child: const Text('😊', style: TextStyle(fontSize: 24)),
              ),
            ),
          ),
        ),
        const Text(
          'Hi Menna !',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(25),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                child: const Icon(
                  Icons.settings_outlined,
                  size: 24,
                  color: Color(0xFF4A5568),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── CHILD PROGRESS CARD ─────────────────────────────────────────────────────

  Widget _buildChildProgressCard(HomeViewModel viewModel) {
    final child = viewModel.currentChild!;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9A8B), Color(0xFFFF6A88)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6A88).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text('👦', style: TextStyle(fontSize: 32)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Child: ${child.name}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF2D3748),
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Overall progress',
                      style: TextStyle(fontSize: 13, color: Color(0xFF718096)),
                    ),
                  ],
                ),
              ),
              Text(
                '${child.overallProgress}%',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF2D3748),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: const Color(0xFFE2E8F0),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: child.overallProgress / 100,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                    ),
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF667EEA).withOpacity(0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Last test: ${child.lastTestName}',
              style: const TextStyle(fontSize: 12, color: Color(0xFF718096)),
            ),
          ),
        ],
      ),
    );
  }

  // ── ASSESSMENT INFO CARD ────────────────────────────────────────────────────

  Widget _buildAssessmentInfoCard() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F9FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFBAE6FD), width: 1),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('📋', style: TextStyle(fontSize: 28)),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  'Understanding assessments',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0C4A6E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Learn about developmental assessments and how they help track your child\'s progress and identify areas that need attention to support their growth.',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF075985),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF0284C7),
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Learn more',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_forward, size: 16),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── ASSESSMENT PROGRESS SECTION ─────────────────────────────────────────────

  Widget _buildAssessmentProgressSection(HomeViewModel viewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Assessments progress',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 16),
        ...viewModel.currentChild!.assessmentSteps.map((step) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _buildAssessmentStepCard(step),
          );
        }).toList(),
      ],
    );
  }

  Widget _buildAssessmentStepCard(step) {
    Color iconColor;
    Color bgColor;
    Color statusBgColor;
    Color statusTextColor;
    String statusText;
    IconData iconData;

    if (step.isComplete) {
      iconColor = const Color(0xFFF59E0B);
      bgColor = const Color(0xFFFEF3C7);
      statusBgColor = const Color(0xFFE5E7EB);
      statusTextColor = const Color(0xFF4B5563);
      statusText = 'Complete';
      iconData = Icons.check_circle;
    } else if (step.isLocked) {
      iconColor = const Color(0xFFEF4444);
      bgColor = const Color(0xFFFEE2E2);
      statusBgColor = const Color(0xFFE5E7EB);
      statusTextColor = const Color(0xFF6B7280);
      statusText = 'Locked';
      iconData = Icons.lock;
    } else {
      iconColor = const Color(0xFF3B82F6);
      bgColor = const Color(0xFFDBEAFE);
      statusBgColor = const Color(0xFFDBEAFE);
      statusTextColor = const Color(0xFF1E40AF);
      statusText = 'In Progress';
      iconData = Icons.play_circle_outline;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: step.isLocked ? null : () {},
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: bgColor,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(iconData, color: iconColor, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Step ${step.stepNumber}: ${step.name}',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2D3748),
                        ),
                      ),
                      if (step.subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          step.subtitle!,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF718096),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: statusBgColor,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    statusText,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── QUICK ACTIONS ───────────────────────────────────────────────────────────

  Widget _buildQuickActionsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Quick actions',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ChildMenuScreen()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text('👶', style: TextStyle(fontSize: 28)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Add new child',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ── ANIMATED BOTTOM NAV ─────────────────────────────────────────────────────

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: SizedBox(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home_rounded, 'Home', 0),
              _buildNavItem(Icons.assignment_rounded, 'Assessments', 1),
              _buildNavItem(Icons.person_rounded, 'Profile', 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isActive = _selectedIndex == index;

    return GestureDetector(
      onTap: () => _onNavTap(index),
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 90,
        height: 70,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Floating blue bubble
            AnimatedPositioned(
              duration: const Duration(milliseconds: 400),
              curve: Curves.elasticOut,
              top: isActive ? -22 : 8,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeOutBack,
                width: isActive ? 52 : 0,
                height: isActive ? 52 : 0,
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6),
                  shape: BoxShape.circle,
                  boxShadow: isActive
                      ? [
                          BoxShadow(
                            color: const Color(0xFF3B82F6).withOpacity(0.4),
                            blurRadius: 12,
                            offset: const Offset(0, 6),
                          ),
                        ]
                      : [],
                ),
                child: isActive
                    ? Icon(icon, color: Colors.white, size: 24)
                    : const SizedBox.shrink(),
              ),
            ),

            // Inactive icon
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: isActive ? 0.0 : 1.0,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Icon(
                  icon,
                  color: const Color(0xFF9CA3AF),
                  size: 24,
                ),
              ),
            ),

            // Label
            Positioned(
              bottom: 6,
              child: AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 250),
                style: TextStyle(
                  fontSize: 11,
                  color: isActive
                      ? const Color(0xFF3B82F6)
                      : const Color(0xFF9CA3AF),
                  fontWeight:
                      isActive ? FontWeight.w700 : FontWeight.w400,
                ),
                child: Text(label),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── EMPTY STATE ─────────────────────────────────────────────────────────────

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('👶', style: TextStyle(fontSize: 80)),
          const SizedBox(height: 24),
          const Text(
            'No child added yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ChildMenuScreen()),
              );
            },
            child: const Text('Add a child'),
          ),
        ],
      ),
    );
  }
}