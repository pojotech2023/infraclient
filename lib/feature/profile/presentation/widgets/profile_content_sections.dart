import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../core/cache/local_storage.dart';
import '../../../../core/theme/bloc/theme_bloc.dart';
import '../../../../core/theme/bloc/theme_event.dart';
import '../../../../core/theme/bloc/theme_state.dart';
import 'menu_item.dart';
import 'package:builder_customer/core/localization/context_ext.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

class ProfileContentSections extends StatefulWidget {
  const ProfileContentSections({super.key});

  @override
  State<ProfileContentSections> createState() => _ProfileContentSectionsState();
}

class _ProfileContentSectionsState extends State<ProfileContentSections>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _staggerController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    
    // Bottom to top animation for the entire card
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 1.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.1, 1.0, curve: Curves.easeOut),
    ));

    // Staggered animation for menu items
    _staggerController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Start animations with a more visible delay
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        print('Starting content slide animation');
        _slideController.forward();
      }
    });
    
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        print('Starting menu items animation');
        _staggerController.forward();
      }
    });
  }

  @override
  void dispose() {
    _slideController.dispose();
    _staggerController.dispose();
    super.dispose();
  }

  void restartAnimation() {
    _slideController.reset();
    _staggerController.reset();
    
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _slideController.forward();
      }
    });
    
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) {
        _staggerController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
 

 final localStorage = GetIt.I<LocalStorage>();

    return FutureBuilder(
      future: localStorage.load(key: 'user', boxName: 'auth'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return Scaffold(
            body: Center(child: Text('Error: ${snapshot.error}')),
          );
        }

        final rawUser = snapshot.data;
        Map<String, dynamic> user = {};
        if (rawUser is String) {
          user = json.decode(rawUser);
        } else if (rawUser is Map) {
          user = Map<String, dynamic>.from(rawUser);
        }
        final String name = user['name'] ?? "";
        final String email = user['email'] ?? "";
         final String dob = user['dob'] ?? "N/A";
        final String mobile = user['mobile_no'] ?? "N/A";
        final String address = user['address'] ?? "N/A";
        final String city = user['city'] ?? "";
        final String state = user['state'] ?? "";
        final String zip = user['zip'] ?? "";



    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
           
                _AnimatedMenuSection(
              title:   context.l10n?.personalInformation ?? 'Personal Information',
              items: [
                MenuItem(
                  icon: Icons.phone,
                  title: context.l10n?.mobileNumber ?? 'Mobile Number',
                  subtitle: mobile,
                ),
                MenuItem(
                  icon: Icons.calendar_month,
                  title: context.l10n?.dateofBirth ?? 'Date of Birth',
                  subtitle: dob,
                 
                ),
                MenuItem(
                  icon: Icons.my_location_outlined,
                  title:context.l10n?.address ?? 'Address',
                 subtitle: address,
                ),
              
              ],
                  animationController: _staggerController,
                  startDelay: 0.0,
            ),
            const SizedBox(height: 30),
                _AnimatedMenuSection(
              title:  context.l10n?.supportInformation ??'Support & Information',
              items: [
                MenuItem(
                  icon: Icons.privacy_tip_outlined,
                  title: context.l10n?.privacyPolicy ?? 'Privacy Policy',
                  onTap: () => _showSnackBar(context,  context.l10n?.privacyPolicy ??'Privacy Policy'),
                ),
                MenuItem(
                  icon: Icons.description_outlined,
                  title:  context.l10n?.termsConditions ??'Terms & Conditions',
                  onTap: () => _showSnackBar(context,  context.l10n?.termsConditions ??'Terms & Conditions'),
                ),
                MenuItem(
                  icon: Icons.help_outline,
                  title:context.l10n?.faqs ?? 'FAQs',
                  onTap: () => _showSnackBar(context,  context.l10n?.faqs ?? 'FAQs'),
                ),
              ],
                  animationController: _staggerController,
                  startDelay: 0.3,
            ),
            const SizedBox(height: 30),
            BlocBuilder<ThemeBloc, ThemeState>(
              builder: (context, state) {
                    return _AnimatedMenuSection(
                  title:  context.l10n?.accountManagement ??  'Account Management',
                  items: [
                    // MenuItem(
                    //   icon: Icons.lock_outline,
                    //   title: 'Change Password',
                    //   onTap: () => _showSnackBar(context, 'Change Password'),
                    // ),

                    MenuItem(
                      icon: state.themeMode == ThemeMode.dark ? Icons.dark_mode : Icons.light_mode,
                      title: context.l10n?.theme ?? 'Theme',
                      trailing: Switch(
                        value: state.themeMode == ThemeMode.dark,
                        onChanged: (value) {
                          context.read<ThemeBloc>().add(
                            ThemeModeChanged(value ? ThemeMode.dark : ThemeMode.light),
                          );
                        },
                        activeColor: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    MenuItem(
                      icon: Icons.palette,
                      title:    context.l10n?.colorScheme?? 'Color scheme',
                      onTap: () => context.push('/theme'),
                    ),
                    MenuItem(
                      icon: Icons.translate,
                      title:  context.l10n?.language?? 'Language',
                      onTap: () => context.push('/language'),
                    ),

                                        MenuItem(
                      icon: Icons.logout,
                      title:     context.l10n?.logout?? 'Logout',
                      onTap: () async {
                        await localStorage.clearAll();
  if (!mounted) return;
  WidgetsBinding.instance.addPostFrameCallback((_) {

    context.go('/login');
  });
                      },
                    ),
              
                  ],
                      animationController: _staggerController,
                      startDelay: 0.6,
                );
              },
            ),
          ],
            ),
          ),
        ),
      ),
    );
  });
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$message tapped'),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

class _AnimatedMenuSection extends StatelessWidget {
  final String title;
  final List<MenuItem> items;
  final AnimationController animationController;
  final double startDelay;

  const _AnimatedMenuSection({
    required this.title,
    required this.items,
    required this.animationController,
    required this.startDelay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(-1.0, 0.0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animationController,
            curve: Interval(startDelay.clamp(0.0, 1.0), (startDelay + 0.3).clamp(0.0, 1.0), curve: Curves.easeOutCubic),
          )),
          child: FadeTransition(
            opacity: Tween<double>(
              begin: 0.0,
              end: 1.0,
            ).animate(CurvedAnimation(
              parent: animationController,
              curve: Interval(startDelay.clamp(0.0, 1.0), (startDelay + 0.3).clamp(0.0, 1.0), curve: Curves.easeOut),
            )),
            child: Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall
              
              
         
            ),
          ),
        ),
        const SizedBox(height: 15),
        ...items.asMap().entries.map((entry) {
          int index = entry.key;
          MenuItem item = entry.value;
          double itemDelay = startDelay + 0.1 + (index * 0.1);
          double endDelay = (itemDelay + 0.4).clamp(0.0, 1.0);
          
          return SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.0, 0.8),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animationController,
              curve: Interval(
                itemDelay.clamp(0.0, 1.0),
                endDelay,
                curve: Curves.easeOutCubic,
              ),
            )),
            child: FadeTransition(
              opacity: Tween<double>(
                begin: 0.0,
                end: 1.0,
              ).animate(CurvedAnimation(
                parent: animationController,
                curve: Interval(
                  itemDelay.clamp(0.0, 1.0),
                  endDelay,
                  curve: Curves.easeOut,
                ),
              )),
              child: item,
            ),
          );
        }),
      ],
    );
  }
}