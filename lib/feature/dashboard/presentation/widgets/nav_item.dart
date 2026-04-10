
class NavItem {
  final String? activeIcon;
  final String? inactiveIcon;
  final String? label;
  final bool isCenter;

  const NavItem({
    this.activeIcon,
    this.inactiveIcon,
    this.label,
    this.isCenter = false,
  });
}
