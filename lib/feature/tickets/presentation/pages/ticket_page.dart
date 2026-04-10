import 'package:builder_customer/core/cache/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';
// import 'package:/.dart';
import 'package:intl/intl.dart';

import '../bloc/ticket_list_bloc.dart';
import '../bloc/ticket_list_event.dart';
import '../bloc/ticket_list_state.dart';
import 'package:builder_customer/core/cache/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../bloc/ticket_list_bloc.dart';
import '../bloc/ticket_list_event.dart';
import '../bloc/ticket_list_state.dart';

class TicketTabPage extends StatelessWidget {
  const TicketTabPage({super.key});

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
        
        final int siteId = user['site_id'] ?? 0;

      

        return BlocProvider(
          create: (_) =>
              GetIt.I<TicketListBloc>()..add(TicketListLoad(siteId: siteId)),
          child: Scaffold(
            appBar: AppBar(title: const Text('Tickets')),
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
  // convert to local time if needed
  String createdDate = DateFormat("dd/MM/yyyy hh:mm a").format(DateTime.parse(ticket.createdAt).toLocal());
 
  String updateDate = DateFormat("dd/MM/yyyy hh:mm a").format(DateTime.parse(ticket.updatedAt).toLocal());

                    

                      return 
                       
                  Card(
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
          child: Text("Ticket Created date : ${createdDate}"),
        ),
        
         onTap: () {
                          if (GoRouter.of(context).canPop()) {
                            context.push('/ticket/${ticket.id}',
                                extra: ticket);
                          } else {
                            GoRouter.of(context).push('/ticket/${ticket.id}',
                                extra: ticket);
                          }
                        },
      ),
    );

                      
                    },
                  );
                }
                if (state is TicketListError) {
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
