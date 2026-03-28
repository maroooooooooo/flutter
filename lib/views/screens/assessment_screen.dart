import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodels/assessment_viewmodel.dart';
import '../../models/assessment_model.dart';

class AssessmentScreen extends StatefulWidget {
  const AssessmentScreen({Key? key}) : super(key: key);

  @override
  State<AssessmentScreen> createState() => _AssessmentScreenState();
}

class _AssessmentScreenState extends State<AssessmentScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _listController;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _listController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _headerFade = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOut,
    );
    _headerSlide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    ));

    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 200), () {
      _listController.forward();
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AssessmentViewModel(),
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F7FA),
        body: Consumer<AssessmentViewModel>(
          builder: (context, vm, _) {
            return RefreshIndicator(
              onRefresh: vm.refreshAssessments,
              color: const Color(0xFF3B82F6),
              child: CustomScrollView(
                slivers: [
                  _buildSliverHeader(context, vm),
                  _buildFilterBar(vm),
                  if (vm.isLoading)
                    const SliverFillRemaining(
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF3B82F6),
                        ),
                      ),
                    )
                  else
                    _buildAssessmentList(vm),
                  const SliverPadding(padding: EdgeInsets.only(bottom: 100)),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ── SLIVER APP BAR ──────────────────────────────────────────────────────────

  Widget _buildSliverHeader(BuildContext context, AssessmentViewModel vm) {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 18,
            color: Color(0xFF2D3748),
          ),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.parallax,
        background: _buildHeaderBackground(vm),
        titlePadding: EdgeInsets.zero,
        title: Container(
          alignment: Alignment.center,
          child: const Text(
            'Assessments',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3748),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderBackground(AssessmentViewModel vm) {
    return FadeTransition(
      opacity: _headerFade,
      child: SlideTransition(
        position: _headerSlide,
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
          ),
          padding: const EdgeInsets.fromLTRB(20, 80, 20, 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Assessments',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF1A202C),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              _buildProgressSummary(vm),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSummary(AssessmentViewModel vm) {
    return Row(
      children: [
        // Progress pill
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF3B82F6), Color(0xFF6366F1)],
            ),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF3B82F6).withOpacity(0.35),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.bolt_rounded, color: Colors.white, size: 16),
              const SizedBox(width: 6),
              Text(
                '${vm.completedCount}/${vm.totalCount} Complete',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        // Mini progress bar
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${(vm.overallProgress * 100).toInt()}% overall progress',
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFF718096),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 6),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: LinearProgressIndicator(
                  value: vm.overallProgress,
                  backgroundColor: const Color(0xFFE2E8F0),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF3B82F6),
                  ),
                  minHeight: 6,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ── FILTER BAR ──────────────────────────────────────────────────────────────

  Widget _buildFilterBar(AssessmentViewModel vm) {
    return SliverToBoxAdapter(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: AssessmentFilter.values.map((filter) {
              final isActive = vm.activeFilter == filter;
              final label = _filterLabel(filter);
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: GestureDetector(
                  onTap: () => vm.setFilter(filter),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF3B82F6)
                          : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: isActive
                          ? [
                              BoxShadow(
                                color:
                                    const Color(0xFF3B82F6).withOpacity(0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isActive
                            ? Colors.white
                            : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  String _filterLabel(AssessmentFilter f) {
    switch (f) {
      case AssessmentFilter.all:
        return 'All';
      case AssessmentFilter.inProgress:
        return 'In Progress';
      case AssessmentFilter.completed:
        return 'Completed';
      case AssessmentFilter.locked:
        return 'Locked';
    }
  }

  // ── ASSESSMENT LIST ─────────────────────────────────────────────────────────

  Widget _buildAssessmentList(AssessmentViewModel vm) {
    final items = vm.assessments;

    if (items.isEmpty) {
      return SliverFillRemaining(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('🔍', style: TextStyle(fontSize: 48)),
              const SizedBox(height: 16),
              Text(
                'No assessments found',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey.shade500,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return _AnimatedAssessmentCard(
              assessment: items[index],
              index: index,
              listController: _listController,
              onTap: () {
                if (!items[index].isLocked) {
                  vm.startAssessment(items[index].id);
                }
              },
            );
          },
          childCount: items.length,
        ),
      ),
    );
  }
}

// ── ANIMATED CARD ────────────────────────────────────────────────────────────

class _AnimatedAssessmentCard extends StatelessWidget {
  final Assessment assessment;
  final int index;
  final AnimationController listController;
  final VoidCallback onTap;

  const _AnimatedAssessmentCard({
    required this.assessment,
    required this.index,
    required this.listController,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final delay = (index * 0.1).clamp(0.0, 0.6);
    final animation = CurvedAnimation(
      parent: listController,
      curve: Interval(delay, (delay + 0.5).clamp(0.0, 1.0),
          curve: Curves.easeOutCubic),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _AssessmentCard(assessment: assessment, onTap: onTap),
      ),
    );
  }
}

class _AssessmentCard extends StatefulWidget {
  final Assessment assessment;
  final VoidCallback onTap;

  const _AssessmentCard({
    required this.assessment,
    required this.onTap,
  });

  @override
  State<_AssessmentCard> createState() => _AssessmentCardState();
}

class _AssessmentCardState extends State<_AssessmentCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
      lowerBound: 0.97,
      upperBound: 1.0,
      value: 1.0,
    );
    _scaleAnimation = _pressController;
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  // ── Status helpers ──────────────────────────────────────────────────────────

  Color get _accentColor {
    switch (widget.assessment.status) {
      case AssessmentStatus.inProgress:
        return const Color(0xFF3B82F6);
      case AssessmentStatus.complete:
        return const Color(0xFF10B981);
      case AssessmentStatus.available:
        return const Color(0xFF8B5CF6);
      case AssessmentStatus.locked:
        return const Color(0xFF94A3B8);
    }
  }

  Color get _bgColor {
    switch (widget.assessment.status) {
      case AssessmentStatus.inProgress:
        return const Color(0xFFEFF6FF);
      case AssessmentStatus.complete:
        return const Color(0xFFF0FDF4);
      case AssessmentStatus.available:
        return const Color(0xFFF5F3FF);
      case AssessmentStatus.locked:
        return const Color(0xFFF8FAFC);
    }
  }

  String get _statusLabel {
    switch (widget.assessment.status) {
      case AssessmentStatus.inProgress:
        return 'In Progress';
      case AssessmentStatus.complete:
        return 'Complete';
      case AssessmentStatus.available:
        return 'Available';
      case AssessmentStatus.locked:
        return 'Locked';
    }
  }

  IconData get _statusIcon {
    switch (widget.assessment.status) {
      case AssessmentStatus.inProgress:
        return Icons.play_circle_rounded;
      case AssessmentStatus.complete:
        return Icons.check_circle_rounded;
      case AssessmentStatus.available:
        return Icons.radio_button_unchecked_rounded;
      case AssessmentStatus.locked:
        return Icons.lock_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final a = widget.assessment;
    final isLocked = a.isLocked;

    return GestureDetector(
      onTapDown: isLocked ? null : (_) => _pressController.reverse(),
      onTapUp: isLocked ? null : (_) {
        _pressController.forward();
        widget.onTap();
      },
      onTapCancel: isLocked ? null : () => _pressController.forward(),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isLocked
                  ? const Color(0xFFE2E8F0)
                  : _accentColor.withOpacity(0.25),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: isLocked
                    ? Colors.black.withOpacity(0.03)
                    : _accentColor.withOpacity(0.08),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Emoji avatar
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: isLocked
                            ? const Color(0xFFF1F5F9)
                            : _bgColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isLocked
                              ? const Color(0xFFE2E8F0)
                              : _accentColor.withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          a.imagePath,
                          style: TextStyle(
                            fontSize: 26,
                            color: isLocked ? null : null,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            a.name,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: isLocked
                                  ? const Color(0xFF94A3B8)
                                  : const Color(0xFF1A202C),
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            a.description,
                            style: TextStyle(
                              fontSize: 13,
                              color: isLocked
                                  ? const Color(0xFFCBD5E1)
                                  : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Status badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: isLocked
                            ? const Color(0xFFF1F5F9)
                            : _accentColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            _statusIcon,
                            size: 13,
                            color: isLocked
                                ? const Color(0xFF94A3B8)
                                : _accentColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _statusLabel,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: isLocked
                                  ? const Color(0xFF94A3B8)
                                  : _accentColor,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // Progress bar for in-progress
                if (a.isInProgress && a.progressValue != null) ...[
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(6),
                          child: LinearProgressIndicator(
                            value: a.progressValue,
                            backgroundColor: const Color(0xFFE2E8F0),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              _accentColor,
                            ),
                            minHeight: 6,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '${((a.progressValue ?? 0) * 100).toInt()}%',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: _accentColor,
                        ),
                      ),
                    ],
                  ),
                  if (a.lastTestDate != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      'Last test: ${a.lastTestDate}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF94A3B8),
                      ),
                    ),
                  ],
                ],

                // Lock info
                if (isLocked &&
                    (a.requirementText != null ||
                        a.availabilityText != null)) ...[
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: const Color(0xFFE2E8F0),
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.info_outline_rounded,
                          size: 14,
                          color: Color(0xFF94A3B8),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          a.requirementText ?? a.availabilityText ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF64748B),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],

                // CTA button for available/in-progress
                if (!isLocked) ...[
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: widget.onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accentColor,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        a.isInProgress ? 'Continue' : 'Start',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
