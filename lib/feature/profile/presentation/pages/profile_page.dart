import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:convert';

import '../../../../core/cache/local_storage.dart';
import '../widgets/profile_sliver_header.dart';
import '../widgets/profile_content_sections.dart';
import '../../domain/repositories/profile_repository.dart';
import '../bloc/profile_bloc.dart';
import '../bloc/profile_event.dart';
import '../bloc/profile_state.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({super.key});

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _contentKey = GlobalKey();

  void _restartAnimations() {
    (_headerKey.currentState as dynamic)?.restartAnimation();
    (_contentKey.currentState as dynamic)?.restartAnimation();
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      final localStorage = GetIt.I<LocalStorage>();
      final rawUser = await localStorage.load(key: 'user', boxName: 'auth');
      if (rawUser != null) {
        Map<String, dynamic> user = {};
        if (rawUser is String) {
          user = json.decode(rawUser);
        } else if (rawUser is Map) {
          user = Map<String, dynamic>.from(rawUser);
        }
        
        user['local_profile_pic'] = image.path;
        
        await localStorage.save(
          key: 'user',
          value: json.encode(user),
          boxName: 'auth',
        );
        
        // Refresh the profile to show the new picture
        if (context.mounted) {
          context.read<ProfileBloc>().add(LoadProfile());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<ProfileBloc>()..add(LoadProfile()),
      child: BlocConsumer<ProfileBloc, ProfileState>(
        listener: (context, state) {
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          } else if (state is ProfileLoaded) {
            // You could show a success message if needed
          }
        },
        builder: (context, state) {
          if (state is ProfileInitial || state is ProfileLoading) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (state is ProfileError) {
            print('ProfileError: ${state.message}');
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Failed to load profile.'),
                      const SizedBox(height: 8),
                      Text(
                        state.message, 
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => context.read<ProfileBloc>().add(LoadProfile()),
                        child: Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (state is ProfileLoaded) {
            final profile = state.profile;

            return Scaffold(
              backgroundColor: Theme.of(context).primaryColor,
              body: CustomScrollView(
                slivers: [
                  ProfileSliverHeader(
                    key: _headerKey,
                    name: profile.name,
                    email: profile.email,
                    profilePic: profile.profilePic,
                    onPickImage: () => _pickAndUploadImage(context),
                    onEditProfile: () async {
                      // Pass the CustomerEntity converted to a Map (or just pass the entity)
                      final Map<String, dynamic> extraData = {
                        'id': profile.id,
                        'name': profile.name,
                        'email': profile.email,
                        'dob': profile.dob,
                        'address': profile.address,
                        'marriage_date': profile.marriageDate,
                        'mobile_no': profile.mobileNo,
                      };
                      final result = await context.push('/edit-profile', extra: extraData);
                      if (result == true) {
                        context.read<ProfileBloc>().add(LoadProfile());
                      }
                    },
                  ),
                  SliverToBoxAdapter(
                    child: ProfileContentSections(key: _contentKey),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: _restartAnimations,
                tooltip: 'Restart Animations',
                child: const Icon(Icons.refresh),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

