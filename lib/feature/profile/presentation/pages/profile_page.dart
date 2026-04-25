import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

import '../../../../core/cache/local_storage.dart';
import '../widgets/profile_sliver_header.dart';
import '../widgets/profile_content_sections.dart';
import '../../domain/repositories/profile_repository.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({super.key});

  @override
  State<ProfileTabPage> createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _contentKey = GlobalKey();
  bool _isUploading = false;

  void _restartAnimations() {
    (_headerKey.currentState as dynamic)?.restartAnimation();
    (_contentKey.currentState as dynamic)?.restartAnimation();
  }

  Future<void> _pickAndUploadImage(int customerId) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (image != null) {
      setState(() {
        _isUploading = true;
      });

      try {
        final profileRepo = GetIt.I<ProfileRepository>();
        await profileRepo.updateProfilePicture(
          customerId: customerId,
          imagePath: image.path,
        );
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile picture updated successfully')),
          );
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isUploading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localStorage = GetIt.I<LocalStorage>();

    return FutureBuilder(
      future: localStorage.load(key: 'user', boxName: 'auth'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting && !_isUploading) {
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

        final int id = user['id'] ?? 0;
        final String name = user['name'] ?? "User";
        final String email = user['email'] ?? "";
        final String? profilePic = user['profile_pic'];

        return Scaffold(
          backgroundColor: Theme.of(context).primaryColor,
          body: Stack(
            children: [
              CustomScrollView(
                slivers: [
                  ProfileSliverHeader(
                    key: _headerKey,
                    name: name,
                    email: email,
                    profilePic: profilePic,
                    onPickImage: () => _pickAndUploadImage(id),
                    onEditProfile: () async {
                      final result = await context.push('/edit-profile', extra: user);
                      if (result == true) {
                        setState(() {}); // Refresh the FutureBuilder
                      }
                    },
                  ),
                  SliverToBoxAdapter(
                    child: ProfileContentSections(key: _contentKey),
                  ),
                ],
              ),
              if (_isUploading)
                Container(
                  color: Colors.black45,
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: _restartAnimations,
            tooltip: 'Restart Animations',
            child: const Icon(Icons.refresh),
          ),
        );
      },
    );
  }
}
