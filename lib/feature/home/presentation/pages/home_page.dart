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

  const HomeTabPage({super.key,});

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
      print("RAW USER: $rawUser");
print("DECODED USER: $user");
print("SITE ID: $siteId");
    print("TYPE: ${rawUser.runtimeType}");
print("RAW USER: $rawUser");
print("SITE ID: $siteId");
    return BlocProvider<ChecklistBloc>(
      create: (_) => GetIt.I<ChecklistBloc>()..add(FetchChecklistEvent(siteId)),
      child: Scaffold(
        appBar: AppBar(title: const Text('Checklist')),
        body: BlocBuilder<ChecklistBloc, ChecklistState>(
          builder: (context, state) {
            if (state is ChecklistLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is ChecklistError) {
              return Center(child: Text(state.message));
            }
            if (state is ChecklistLoaded) {


            return RefreshIndicator(
              onRefresh: () async {
                context.read<ChecklistBloc>().add(FetchChecklistEvent(siteId));
                // Wait briefly so the indicator shows while the bloc state transitions
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
       }); }
}
