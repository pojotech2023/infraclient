import 'package:builder_customer/feature/dashboard/presentation/widgets/app_drawer.dart';
import 'dart:convert'; 
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:hive/hive.dart';
import '../../../../core/cache/local_storage.dart';
import '../bloc/checklist_bloc.dart';
import '../bloc/checklist_event.dart';
import '../bloc/checklist_state.dart';
import '../widgets/check_listview.dart';

class HomeTabPage extends StatelessWidget {
  final Function(int)? onSelectTab;

  const HomeTabPage({super.key, this.onSelectTab});

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

        return BlocProvider<ChecklistBloc>(
          create: (_) => GetIt.I<ChecklistBloc>()..add(FetchChecklistEvent(siteId)),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Checklist'),
              leading: Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
              ),
            ),
            drawer: AppDrawer(onSelectTab: onSelectTab),
            body: BlocBuilder<ChecklistBloc, ChecklistState>(
              builder: (context, state) {
                if (state is ChecklistLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ChecklistError) {
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
                            onPressed: () => context.read<ChecklistBloc>().add(FetchChecklistEvent(siteId)),
                            icon: const Icon(Icons.refresh),
                            label: const Text("Retry"),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (state is ChecklistLoaded) {
                  return RefreshIndicator(
                    onRefresh: () async {
                      context.read<ChecklistBloc>().add(FetchChecklistEvent(siteId));
                      await Future.delayed(const Duration(milliseconds: 500));
                    },
                    child: ChecklistListView(checklist: state.checklist),
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
