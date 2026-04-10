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

  const DashboardPage({super.key, required this.child});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = <Widget>[
    const HomeTabPage(),
     const DrawingTabPage(),
    const TicketTabPage(),
    const ProfileTabPage(),
      
  ];

  String _titleForIndex(int index) {
    switch (index) {
      case 0:
        return context.l10n?.home ?? 'Home';
      case 1:
        return 'Drawings';
      case 2:
        return context.l10n?.ticket ?? 'Tickets';
      case 3:
        return context.l10n?.profile ?? 'Profile';
      default:
        return context.l10n?.dashboard ?? 'Dashboard';
    }
  }


  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final isShellRoute = location != '/dashboard';

    return  DashboardMobile(
        selectedIndex: _currentIndex,
        pages: _pages,
        isShellRoute: isShellRoute,
        child: widget.child,
        onTabChanged: (i) {
          setState(() => _currentIndex = i);
          if (isShellRoute) context.go('/dashboard');
        },
      
    );
  }

  
}

