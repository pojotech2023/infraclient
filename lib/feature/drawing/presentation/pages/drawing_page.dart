import 'dart:convert';
import 'package:builder_customer/core/cache/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../dashboard/presentation/widgets/app_drawer.dart';
import '../bloc/drawing_bloc.dart';
import '../bloc/drawing_event.dart';
import '../bloc/drawing_state.dart';
import '../widgets/drawing_list.dart';

class DrawingTabPage extends StatelessWidget {
  final Function(int)? onSelectTab;

  const DrawingTabPage({super.key, this.onSelectTab});

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

        final dynamic rawSiteId = user['site_id'] ?? user['siteId'] ?? 0;
        final int siteId = rawSiteId is int
            ? rawSiteId
            : int.tryParse(rawSiteId.toString()) ?? 0;

        return BlocProvider(
          create: (_) => GetIt.I<DrawingBloc>()..add(DrawingLoad(siteId: siteId)),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Drawings'),
              leading: Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
              ),
            ),
            drawer: AppDrawer(onSelectTab: onSelectTab),
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
                    child: DrawingList(data: state.data),
                  );
                }
                if (state is DrawingError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.error_outline, size: 48, color: Colors.orange),
                          const SizedBox(height: 12),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(fontSize: 15, color: Colors.black87),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () => context.read<DrawingBloc>().add(DrawingLoad(siteId: siteId)),
                            icon: const Icon(Icons.refresh),
                            label: const Text("Retry"),
                          ),
                        ],
                      ),
                    ),
                  );
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
