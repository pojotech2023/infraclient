import 'dart:convert';
import 'package:builder_customer/core/cache/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../dashboard/presentation/widgets/app_drawer.dart';
import '../bloc/ticket_list_bloc.dart';
import '../bloc/ticket_list_event.dart';
import '../bloc/ticket_list_state.dart';

class TicketTabPage extends StatelessWidget {
  final Function(int)? onSelectTab;

  const TicketTabPage({super.key, this.onSelectTab});

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
          create: (_) =>
              GetIt.I<TicketListBloc>()..add(TicketListLoad(siteId: siteId)),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Tickets'),
              leading: Builder(
                builder: (ctx) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(ctx).openDrawer(),
                ),
              ),
            ),
            drawer: AppDrawer(onSelectTab: onSelectTab),
            floatingActionButton: Builder(
              builder: (ctx) => FloatingActionButton(
                onPressed: () async {
                  final created =
                      await GoRouter.of(ctx).push<bool>('/ticket-create');
                  if (created == true) {
                    ctx.read<TicketListBloc>().add(TicketListLoad(siteId: siteId));
                    if (ScaffoldMessenger.maybeOf(ctx) != null) {
                      ScaffoldMessenger.of(ctx).showSnackBar(
                          const SnackBar(content: Text('Ticket created')));
                    }
                  }
                },
                child: const Icon(Icons.add),
              ),
            ),
            body: BlocBuilder<TicketListBloc, TicketListState>(
              builder: (context, state) {
                if (state is TicketListLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is TicketListLoaded) {
                  return ListView.builder(
                    itemCount: state.tickets.length,
                    itemBuilder: (_, index) {
                      final ticket = state.tickets[index];
                      String createdDate = DateFormat("dd/MM/yyyy hh:mm a")
                          .format(DateTime.parse(ticket.createdAt).toLocal());
                     
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 8,
                            backgroundColor: Theme.of(context).primaryColor,
                          ),
                          title: Text(
                            ticket.ticket,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text("Ticket Created date : $createdDate"),
                          ),
                          onTap: () {
                            if (GoRouter.of(context).canPop()) {
                              context.push('/ticket/${ticket.id}', extra: ticket);
                            } else {
                              GoRouter.of(context).push('/ticket/${ticket.id}', extra: ticket);
                            }
                          },
                        ),
                      );
                    },
                  );
                }
                if (state is TicketListError) {
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
                            onPressed: () => context.read<TicketListBloc>().add(TicketListLoad(siteId: siteId)),
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
