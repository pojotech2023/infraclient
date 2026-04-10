import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../core/config/flavor_config.dart';
import '../../domain/entities/ticket_message_entity.dart';


class MessageBubble extends StatelessWidget {
  final TicketMessageEntity msg;

  const MessageBubble({super.key, required this.msg});

  @override
  Widget build(BuildContext context) {
    DateTime dateTime = DateTime.parse(msg.createdAt).toLocal();
    String formattedDate = DateFormat("dd/MM/yyyy hh:mm a").format(dateTime);

    final isAdmin = msg.senderType.toLowerCase() == 'admin' ||
        msg.senderType.toLowerCase() == 'supervisor';

    final cardColor = isAdmin
        ? Colors.green[100]
        : msg.senderType.toLowerCase() == 'supervisor'
            ? Colors.blueAccent[100]
            : Theme.of(context).colorScheme.surface;

    return Align(
      alignment: isAdmin ? Alignment.centerLeft : Alignment.centerRight,
      child: Card(
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (msg.message?.isNotEmpty ?? false)
                Text(msg.message!, style: const TextStyle(fontSize: 14)),
              if (msg.attachment != null)
                Container(
                  width: 100,
                  height: 100,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        '${FlavorConfig.appConfig.imageUrl}/${msg.attachment!}',
                      ),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                ),
              Text(
                "${msg.senderType} | $formattedDate",
                style: const TextStyle(fontSize: 10),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
