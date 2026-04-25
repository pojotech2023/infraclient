import 'package:builder_customer/feature/startup/presentation/pages/splash_page.dart';
import 'package:builder_customer/feature/tickets/domain/entities/ticket_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../feature/dashboard/presentation/pages/dashboard_page.dart';
import '../../feature/drawing/presentation/pages/drawing_detail_page.dart';
import '../../feature/profile/presentation/pages/profile_page.dart';
import '../../feature/profile/presentation/pages/edit_profile_page.dart';
import '../../feature/tickets/presentation/pages/ticket_chat_page.dart';
import '../../feature/tickets/presentation/pages/ticket_create_page.dart';
import '../../feature/theme/presentation/pages/theme_page.dart';
import '../../feature/localization/presentation/pages/language_page.dart';
import '../../feature/login/presentation/page/login_page.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter({String? initialLocation}) : router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: initialLocation ?? '/splash',
    routes: <RouteBase>[

       GoRoute(
            path: '/splash',
            name: 'splash',
            builder: (BuildContext context, GoRouterState state) => const SplashPage(),
          ),
      ShellRoute(
        navigatorKey: _rootNavigatorKey,
        builder: (context, state, child) => DashboardPage(child: child),
        routes: [
          // Main dashboard route - shows the tab content
          GoRoute(
            path: '/dashboard',
            name: 'dashboard',
            builder: (BuildContext context, GoRouterState state) {
              // Return empty container as the tab content is handled by DashboardPage
              return const SizedBox.shrink();
            },
          ),
          // Theme settings overlay
        
          // Language settings overlay
         
        ],
      ),
  GoRoute(
            path: '/theme',
            name: 'theme',
            builder: (BuildContext context, GoRouterState state) => const ThemePage(),
          ),
       GoRoute(
            path: '/language',
            name: 'language',
            builder: (BuildContext context, GoRouterState state) => const LanguagePage(),
          ),
      // Movie routes (outside the shell)
     GoRoute(
  path: '/drawingDetail',
  builder: (context, state) {
    final params = state.extra as Map<String, dynamic>;

    final url = params['url'] as String;
    final title = params['title'] as String;

    return DrawingDetailPage(url: url, title: title);
  },
),
      GoRoute(
        path: '/ticket-create',
        builder: (context, state) => const TicketCreatePage(),
      ),


         GoRoute(
        path: '/ticket/:ticketId',
        builder: (context, state) {
          final ticketId = int.parse(state.pathParameters['ticketId']!);
         final ticket = state.extra as TicketEntity; // use correct type here

    // Extract siteId and ticketName from the ticket entity
    final siteId = ticket.siteId;
    final ticketName = ticket.ticket;
          return TicketChatPage(siteId: siteId,ticketId: ticketId, ticketName: ticketName);
        },
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileTabPage(),
      ),
      GoRoute(
        path: '/edit-profile',
        builder: (context, state) {
          final userData = state.extra as Map<String, dynamic>;
          return EditProfilePage(userData: userData);
        },
      ),
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginPage(),
      ),
      
    
    ],
  );

  final GoRouter router;
}


