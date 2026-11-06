import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/cache/local_storage.dart';
import '../../../../core/routes/app_router.dart';
import '../pages/dashboard_page.dart';

class AppDrawer extends StatefulWidget {
  final Function(int)? onSelectTab;

  const AppDrawer({super.key, this.onSelectTab});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  String _userName = "Client";
  String _userMobile = "";
  String _siteName = "";
  int _siteId = 0;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    try {
      final localStorage = GetIt.I<LocalStorage>();
      final rawUser = await localStorage.load(key: 'user', boxName: 'auth');
      if (rawUser != null) {
        Map<String, dynamic> user = {};
        if (rawUser is String) {
          user = json.decode(rawUser);
        } else if (rawUser is Map) {
          user = Map<String, dynamic>.from(rawUser);
        }

        final dynamic rawSiteId = user['site_id'] ?? user['siteId'] ?? 0;
        final int parsedSiteId = rawSiteId is int
            ? rawSiteId
            : int.tryParse(rawSiteId.toString()) ?? 0;
        final String siteName = user['site_name']?.toString() ?? "";

        if (mounted) {
          setState(() {
            _userName = user['name']?.toString() ?? "Client";
            _userMobile = user['mobile_no']?.toString() ?? "";
            _siteId = parsedSiteId;
            _siteName = siteName;
          });
        }
      }
    } catch (_) {}
  }

  /// Navigate to a bottom-nav tab (Home=0, Drawings=1, Tickets=2, Profile=3)
  void _goToTab(BuildContext context, int index) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(); // close drawer
    }
    // Switch tab immediately
    DashboardPage.tabNotifier.value = index;
    widget.onSelectTab?.call(index);
  }

  /// Navigate to a named route page (opens on top of shell)
  void _goToPage(BuildContext context, String path) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(); // close drawer
    }
    Future.delayed(const Duration(milliseconds: 120), () {
      appRouter.router.push(path);
    });
  }

  /// Logout
  void _doLogout(BuildContext context) async {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    await Future.delayed(const Duration(milliseconds: 120));
    final localStorage = GetIt.I<LocalStorage>();
    await localStorage.clearAll();
    DashboardPage.tabNotifier.value = 0;
    appRouter.router.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // ── Drawer Header ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 50, 20, 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF002055), Color(0xFF1976D2)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Image.asset(
                    "assets/images/png_images/app_logo.png",
                    width: 40,
                    height: 40,
                    errorBuilder: (_, __, ___) => const Icon(
                      Icons.apartment,
                      size: 34,
                      color: Color(0xFF1976D2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  _userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                if (_userMobile.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    _userMobile,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
                if (_siteId > 0) ...[
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _siteName.isNotEmpty
                          ? "$_siteName (Site #$_siteId)"
                          : "Site #$_siteId",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),

          // ── Menu Items ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                // ── Home ──
                ListTile(
                  leading: const Icon(Icons.home_outlined, color: Color(0xFF002055)),
                  title: const Text(
                    "Home",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () => _goToTab(context, 0),
                ),
                // ── Drawings ──
                ListTile(
                  leading: const Icon(Icons.architecture_outlined, color: Color(0xFF002055)),
                  title: const Text(
                    "Drawings",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () => _goToTab(context, 1),
                ),
                // ── Tickets ──
                ListTile(
                  leading: const Icon(Icons.confirmation_number_outlined, color: Color(0xFF002055)),
                  title: const Text(
                    "Tickets",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () => _goToTab(context, 2),
                ),
                // ── Profile ──
                ListTile(
                  leading: const Icon(Icons.person_outline, color: Color(0xFF002055)),
                  title: const Text(
                    "Profile",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  onTap: () => _goToTab(context, 3),
                ),
                const Divider(height: 1),
                // ── Site Payment History ──
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE3F2FD),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.receipt_long, color: Color(0xFF1976D2)),
                    title: const Text(
                      "View Payments",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1976D2),
                      ),
                    ),
                    trailing: const Icon(Icons.chevron_right, color: Color(0xFF1976D2), size: 20),
                    onTap: () => _goToPage(context, '/site-payment-history'),
                  ),
                ),
                const Divider(height: 1),
                // ── Logout ──
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    "Logout",
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.red),
                  ),
                  onTap: () => _doLogout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
