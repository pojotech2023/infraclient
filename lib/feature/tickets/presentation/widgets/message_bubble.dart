import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/config/flavor_config.dart';
import '../../domain/entities/ticket_message_entity.dart';

class MessageBubble extends StatelessWidget {
  final TicketMessageEntity msg;

  const MessageBubble({super.key, required this.msg});

  void _openAttachment(BuildContext context, String url, bool isImage, bool isPdf) async {
    if (isImage || isPdf) {
      Map<String, dynamic> params = {
        "url": url,
        "title": isPdf ? 'PDF Document' : 'Image Attachment',
      };
      GoRouter.of(context).push('/drawingDetail', extra: params);
    } else {
      final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    }
  }

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

    final String typeFormatted = msg.senderType.isNotEmpty 
        ? '${msg.senderType[0].toUpperCase()}${msg.senderType.substring(1).toLowerCase()}' 
        : 'Unknown';

    final String senderName = msg.senderName ?? typeFormatted;
    
    String displayTitle;
    if (senderName.toLowerCase() == typeFormatted.toLowerCase()) {
      displayTitle = typeFormatted;
    } else {
      if (typeFormatted.toLowerCase() == 'client') {
        displayTitle = senderName; // Hide "(Client)" role for clients
      } else {
        displayTitle = '$senderName ($typeFormatted)';
      }
    }

    Widget? attachmentWidget;
    if (msg.attachmentUrl != null || msg.attachment != null) {
      final String fullUrl = msg.attachmentUrl ?? '${FlavorConfig.appConfig.imageUrl}/${msg.attachment!}';
      final String path = (msg.attachmentUrl ?? msg.attachment!).toLowerCase();
      final isImage = path.endsWith('.jpg') || path.endsWith('.jpeg') || path.endsWith('.png');
      final isVideo = path.endsWith('.mp4') || path.endsWith('.mov') || path.endsWith('.mkv');
      final isPdf = path.endsWith('.pdf');
      final isExcel = path.endsWith('.xls') || path.endsWith('.xlsx');

      if (isImage) {
        attachmentWidget = Container(
          width: 100, height: 100,
          margin: const EdgeInsets.only(top: 4, bottom: 4),
          decoration: BoxDecoration(
            image: DecorationImage(image: NetworkImage(fullUrl), fit: BoxFit.cover),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade100),
          ),
        );
      } else if (isVideo) {
        attachmentWidget = Container(
          width: 100, height: 100, margin: const EdgeInsets.only(top: 4, bottom: 4),
          decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(8)),
          child: const Center(child: Icon(Icons.play_circle_outline, color: Colors.white, size: 40)),
        );
      } else if (isPdf) {
        attachmentWidget = Container(
          width: 100, height: 100, margin: const EdgeInsets.only(top: 4, bottom: 4),
          decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.red.shade200)),
          child: const Center(child: Icon(Icons.picture_as_pdf, color: Colors.red, size: 40)),
        );
      } else if (isExcel) {
        attachmentWidget = Container(
          width: 100, height: 100, margin: const EdgeInsets.only(top: 4, bottom: 4),
          decoration: BoxDecoration(color: Colors.green.shade50, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green.shade200)),
          child: const Center(child: Icon(Icons.table_chart, color: Colors.green, size: 40)),
        );
      } else {
        attachmentWidget = Container(
          width: 100, height: 100, margin: const EdgeInsets.only(top: 4, bottom: 4),
          decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(8)),
          child: const Center(child: Icon(Icons.insert_drive_file, size: 40)),
        );
      }

      attachmentWidget = GestureDetector(
        onTap: () => _openAttachment(context, fullUrl, isImage, isPdf),
        child: attachmentWidget,
      );
    }

    return Align(
      alignment: isAdmin ? Alignment.centerLeft : Alignment.centerRight,
      child: Card(
        color: cardColor,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                displayTitle,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              ),
              const SizedBox(height: 4),
              if (msg.message?.isNotEmpty ?? false)
                Text(msg.message!, style: const TextStyle(fontSize: 14)),
              if (attachmentWidget != null) attachmentWidget,
              const SizedBox(height: 2),
              Text(
                formattedDate,
                style: const TextStyle(fontSize: 10, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
