import 'package:flutter/material.dart';
import 'package:builder_customer/core/localization/context_ext.dart';
import '../../../../core/network/network.dart';
import '../widgets/widgets.dart';


class DashboardMobile extends StatelessWidget {
  final int selectedIndex;
  final List<Widget> pages;
  final bool isShellRoute;
  final Widget child;
  final ValueChanged<int> onTabChanged;

  const DashboardMobile({
    super.key,
    required this.selectedIndex,
    required this.pages,
    required this.isShellRoute,
    required this.child,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(child: ConnectionStatusWidget(
        child: isShellRoute
            ? child
            : IndexedStack(
          index: selectedIndex,
          children: pages,
        ),
      ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        selectedIndex: selectedIndex,
        onTap: (index) {
         onTabChanged(index);
          
        },

    
        
        items:  [
          NavItem(
            activeIcon: "assets/images/svg_images/home.svg",
            inactiveIcon: "assets/images/svg_images/home_unselector.svg",
            label:  context.l10n?.home ?? 'Home',
          ),
             NavItem(
            activeIcon: "assets/images/svg_images/drawing.svg",
            inactiveIcon: "assets/images/svg_images/drawing_unselector.svg",
            label: 'Drawings',
          ),
          NavItem(
            activeIcon: "assets/images/svg_images/messages.svg",
            inactiveIcon: "assets/images/svg_images/messages_unselector.svg",
            label:context.l10n?.ticket ?? 'Tickets',
          ),
        
          NavItem(
            activeIcon: "assets/images/svg_images/profile.svg",
            inactiveIcon: "assets/images/svg_images/profile_unselector.svg",
            label:context.l10n?.profile ??'Profile',
          ),
        ],
        backgroundColor: Theme.of(context).colorScheme.surface,
        selectedColor: Theme.of(context).colorScheme.primary,
        unselectedColor: Colors.grey,
        borderRadius: 16,
      ),
      
    );
  }
}
