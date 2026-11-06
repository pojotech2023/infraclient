import 'package:builder_customer/core/localization/context_ext.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../tickets/presentation/pages/ticket_page.dart';
import '../../../profile/presentation/pages/profile_page.dart';
import '../../../drawing/presentation/pages/drawing_page.dart';
import 'layouts.dart';

class DashboardPage extends StatefulWidget {
  final Widget child;
  static final ValueNotifier<int> tabNotifier = ValueNotifier<int>(0);

  const DashboardPage({super.key, required this.child});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomeTabPage(onSelectTab: _onTabChanged),
      DrawingTabPage(onSelectTab: _onTabChanged),
      TicketTabPage(onSelectTab: _onTabChanged),
      const ProfileTabPage(),
    ];
    DashboardPage.tabNotifier.addListener(_onTabNotifierChange);
  }

  @override
  void dispose() {
    DashboardPage.tabNotifier.removeListener(_onTabNotifierChange);
    super.dispose();
  }

  void _onTabNotifierChange() {
    if (mounted) {
      final newIndex = DashboardPage.tabNotifier.value;
      if (_currentIndex != newIndex) {
        setState(() => _currentIndex = newIndex);
      }
    }
  }

  void _onTabChanged(int index) {
    if (_currentIndex != index) {
      setState(() => _currentIndex = index);
    }
    if (DashboardPage.tabNotifier.value != index) {
      DashboardPage.tabNotifier.value = index;
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    // Only treat it as a child shell route if we're NOT on /dashboard
    final isShellRoute = location != '/dashboard';

    return DashboardMobile(
      selectedIndex: _currentIndex,
      pages: _pages,
      isShellRoute: isShellRoute,
      child: widget.child,
      onTabChanged: (i) {
        _onTabChanged(i);
        // If we're in a sub-shell-route, pop back to dashboard
        if (isShellRoute) context.go('/dashboard');
      },
    );
  }
}
