import'dart:convert';
import 'package:builder_customer/core/cache/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'package:builder_customer/core/cache/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../bloc/drawing_bloc.dart';
import '../bloc/drawing_event.dart';
import '../bloc/drawing_state.dart';
import '../widgets/drawing_list.dart';



class DrawingTabPage extends StatelessWidget {
  const DrawingTabPage({super.key});

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

        // final user = snapshot.data ?? {};
        // final int siteId = user['siteId'] ?? 0;
final rawUser = snapshot.data;

Map<String, dynamic> user = {};

if (rawUser is String) {
  user = json.decode(rawUser);
} else if (rawUser is Map) {
  user = Map<String, dynamic>.from(rawUser);
}

final int siteId = user['site_id'] ?? 0;
      

        return BlocProvider(
          create: (_) =>
            GetIt.I<DrawingBloc>()..add(DrawingLoad(siteId: siteId)),
          child: Scaffold(
            appBar: AppBar(title: const Text('Drawings')),
      
            body: BlocBuilder<DrawingBloc, DrawingState>(
              builder: (context, state) {
                if (state is DrawingLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is DrawingLoaded) {
                 return RefreshIndicator(
                   onRefresh: () async {
                     context.read<DrawingBloc>().add(DrawingLoad(siteId: siteId));
                   },
                   child: DrawingList(data:state.data),
                 );
                }
                if (state is DrawingError) {
                  return Center(child: Text(state.message));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        );
      },
    );
  }
}
