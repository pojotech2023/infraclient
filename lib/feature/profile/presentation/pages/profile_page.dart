/*
import 'package:flutter/material.dart';
import '../widgets/profile_header.dart';
import '../widgets/profile_content_card.dart';

class ProfileTabPage extends StatelessWidget {
  const ProfileTabPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: const Column(
        children: [
          ProfileHeader(),
          Expanded(
            child: ProfileContentCard(),
          ),
        ],
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'dart:convert';

import '../../../../core/cache/local_storage.dart';
import '../widgets/profile_sliver_header.dart';
import '../widgets/profile_content_sections.dart';

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
        final String name = user['name'] ?? "Durai";
        final String email = user['email'] ?? "durai@gmail.com";
         final String dob = user['dob'] ?? "durai@gmail.com";
        final String mobile = user['mobile'] ?? "9876543210";
        final String address = user['address'] ?? "123, Main Street, Anytown, USA";
        final String city = user['city'] ?? "Anytown";
        final String state = user['state'] ?? "CA";
        final String zip = user['zip'] ?? "12345";



    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: CustomScrollView(
        slivers: [
          ProfileSliverHeader(key: _headerKey,name: name,email: email,),
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
       }); }
}
