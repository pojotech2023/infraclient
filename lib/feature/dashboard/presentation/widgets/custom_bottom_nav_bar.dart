import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'nav_item.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;
  final List<NavItem> items;
  final Color? backgroundColor;
  final Color? selectedColor;
  final Color? unselectedColor;
  final double borderRadius;
  final Widget? centerIcon;
  final VoidCallback? onCenterTap;

  const CustomBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    required this.items,
    this.backgroundColor,
    this.selectedColor,
    this.unselectedColor,
    this.borderRadius = 0,
    this.centerIcon,
    this.onCenterTap,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: items.asMap().entries.map((entry) {
            int index = entry.key;
            NavItem item = entry.value;

            if (item.isCenter && centerIcon != null) {
              return _buildCenterButton();
            }

            // Adjust index for center button
            int actualIndex = index;
            if (items.any((item) => item.isCenter)) {
              if (index > items.indexWhere((item) => item.isCenter)) {
                actualIndex = index - 1;
              }
            }

            // Compute the original index (including center) for selection comparison
            final int centerPos = items.indexWhere((it) => it.isCenter);
            int originalIndexForThisItem = index;
            // original index equals its position in items list
            // which includes the center button where applicable

            return _buildNavItem(
              context,
              item,
              actualIndex,
              originalIndexForThisItem,
              centerPos,
            );
          }).toList(),
        ),
      ),
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    NavItem item,
    int index,
    int originalIndexForThisItem,
    int centerPos,
  ) {
    // selectedIndex refers to original indices including the center button
    // originalIndexForThisItem is the index in the full list (with center)
    final isSelected = selectedIndex == originalIndexForThisItem;
    final color = isSelected 
        ? (selectedColor ?? Theme.of(context).primaryColor)
        : (unselectedColor ?? Colors.grey);
    
    // Choose the appropriate icon based on selection state
    final iconPath = isSelected ? item.activeIcon : item.inactiveIcon;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (iconPath != null)
                SvgPicture.asset(
                  iconPath,
                  colorFilter: ColorFilter.mode(
                    color,
                    BlendMode.srcIn,
                  ),
                  width: 24,
                  height: 24,
                ),
              if (item.label != null) ...[
                const SizedBox(height: 4),
                Text(
                  item.label!,
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCenterButton() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: FloatingActionButton(
        onPressed: onCenterTap,
        backgroundColor: selectedColor ?? Colors.blue,
        elevation: 2,
        child: centerIcon ?? const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
