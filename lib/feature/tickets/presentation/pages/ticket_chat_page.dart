import 'dart:io';

import 'package:builder_customer/core/config/flavor_config.dart';
import 'package:custom_ui/custom_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:custom_ui/custom_ui.dart';
import 'package:intl/intl.dart';

import '../../../../core/utils/file_picker_helper.dart';
import '../bloc/ticket_messaging/ticket_message_bloc.dart';
import '../bloc/ticket_messaging/ticket_message_event.dart';
import '../bloc/ticket_messaging/ticket_message_state.dart';
import 'package:get_it/get_it.dart';

import '../widgets/message_bubble.dart';
import '../widgets/message_input_box.dart';

class TicketChatPage extends StatelessWidget {
  final int ticketId;
  final int siteId;
  final String ticketName;

   TicketChatPage({super.key, required this.siteId,required this.ticketId, required this.ticketName});

  final TextEditingController messageController = TextEditingController();
  File? attachment;
    final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (_) => GetIt.I<TicketMessageBloc>()..add(LoadTicketMessages(ticketId: ticketId)),
      child: Scaffold(
        appBar: AppBar(title: Text(ticketName)),
        body: BlocBuilder<TicketMessageBloc, TicketMessageState>(
          builder: (context, state) {
            if (state is TicketMessageLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is TicketMessageLoaded) {
              final messages = state.messages;
              return Column(
                children: [



                  Expanded(
                    child: ListView.builder(
                      itemCount: messages.length,
                      itemBuilder: (_, i) => MessageBubble(msg: messages[i]),
                    ),
                  ),
                  if (state.isSending)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: CircularProgressIndicator(),
                    ),
                  SafeArea(
                    child: MessageInputBox(
                      onSend: (message, attachment) {
                        context.read<TicketMessageBloc>().add(
                              SendMessage(
                                siteId: siteId.toString(),
                                senderType: "client",
                                ticketId: ticketId.toString(),
                                message: message,
                                attachment: attachment,
                              ),
                            );
                      },
                    ),
                  ),


//                   Expanded(child: ListView.builder(
//                 itemCount: messages.length,
//                 itemBuilder: (_, index) {
//                   final msg = messages[index];


//   DateTime dateTime = DateTime.parse(msg.createdAt).toLocal(); // convert to local time if needed
//   String formattedDate = DateFormat("dd/MM/yyyy hh:mm a").format(dateTime);
 
// final cardColor = msg.senderType.toLowerCase() == 'admin' ? Colors.green[100] : msg.senderType.toLowerCase() == 'supervisor' ? Colors.blueAccent[100] : Colors.grey[100];
//                   final isAdmin = msg.senderType == 'admin' || msg.senderType == 'supervisor';
//                   return Align(
//                     alignment: isAdmin ? Alignment.centerLeft : Alignment.centerRight,
//                     child: Card(
//                       color: cardColor,
//                       child: Padding(
//                         padding: const EdgeInsets.all(8.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             if (msg.message != null) Text(msg.message!),
//                             if (msg.attachment != null)
//                       Container(
//                         width: 100,
//                         height: 100,
//                         margin: EdgeInsets.only(top: 4),
//                         decoration: BoxDecoration(
//                           image: DecorationImage(
//                             image: NetworkImage('${FlavorConfig.appConfig.imageUrl}/${msg.attachment!}'),
//                             fit: BoxFit.cover,
//                             onError: (exception, stackTrace) {
//                               debugPrint('Image load failed: $exception');
//                             },
//                           ),borderRadius:BorderRadius.circular(8),
//                           border: Border.all(color: Colors.grey.shade100, width: 1,),
//                         ),
//                       ),

//                             Text( " ${msg.senderType}  | $formattedDate", style: const TextStyle(fontSize: 10)),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               )
           
//            ),

//            messageBox(context),
               
//               Padding(padding: EdgeInsets.all(16),child:  CustomTextField(
//   hint: 'Send a Message',
//   style: TextFieldStyle.outlined,
//   controller: messageController,
//   suffixIcon: Padding(
//     padding: EdgeInsets.all(8),
//     child:CustomButton(
//       radius: 8,
    
//   text: "Circular",
//   icon: Icon(Icons.send,color: Colors.white,),
//   type: ButtonType.circular,
//   onPressed: () {

//      if (messageController.text.trim().isNotEmpty) {
//     context.read<TicketMessageBloc>().add(
//       SendMessage(
//         siteId:siteId.toString(),
//         senderType:"client",
//         ticketId: ticketId.toString(),
//         message: messageController.text.trim(),
//       ),
//     );

//     messageController.clear();
//   }
//   },
// )
//   )

  
 
// ),
//               ) 
                ],
              );
           
            } else if (state is TicketMessageError) {
              return Center(child: Text(state.message));
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }


  //  /// Message input + attachment box
  // Widget messageBox(BuildContext context) {
  //   return Padding(
  //     padding: const EdgeInsets.all(10),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         if (attachment != null) _attachmentPreview(),
  //         const SizedBox(height: 10),
  //        CustomTextField(
  // hint: 'Send a Message',
  // style: TextFieldStyle.outlined,
  //           controller: messageController,
  //             suffixIcon: IconButton(
  //                 onPressed: () {
  //                   // if (chatEditingController.text.isNotEmpty || attachment != null) {
  //                   //   controller.sendMessage(
  //                   //     message: chatEditingController.text,
  //                   //     file: attachment,
  //                   //   );
  //                   //   chatEditingController.clear();
  //                   //   setState(() => attachment = null);
  //                   // }

                    
  //    if (messageController.text.trim().isNotEmpty) {
  //   context.read<TicketMessageBloc>().add(
  //     SendMessage(
  //       siteId:siteId.toString(),
  //       senderType:"client",
  //       ticketId: ticketId.toString(),
  //       message: messageController.text.trim(),
  //     ),
  //   );

  //   messageController.clear();
  // }
  //                 },
  //                 icon: const Icon(Icons.send),
  //               ),
  //             prefixIcon: IconButton(
  //               onPressed: () => _showAttachmentOptions(context),
  //               icon: const Icon(Icons.attach_file),
  //             ),
           
  //         ),
  //       ],
  //     ),
  //   );
  // }


  //   /// Attachment preview
  // Widget _attachmentPreview() {
  //   final isImage = attachment!.path.endsWith('.jpg') ||
  //       attachment!.path.endsWith('.jpeg') ||
  //       attachment!.path.endsWith('.png');

  //   return SizedBox(
  //     height: 90,
  //     child: Stack(
  //       children: [
  //         ClipRRect(
  //           borderRadius: BorderRadius.circular(8),
  //           child: isImage
  //               ? Image.file(attachment!, fit: BoxFit.cover, width: 90, height: 90)
  //               : Container(
  //             width: 90,
  //             color: Colors.grey[200],
  //             child: const Center(child: Icon(Icons.videocam)),
  //           ),
  //         ),
  //         Positioned(
  //           top: 4,
  //           right: 4,
  //           child: InkWell(
  //             onTap: () => setState(() => attachment = null),
  //             child: Container(
  //               decoration: const BoxDecoration(
  //                 color: Colors.black54,
  //                 shape: BoxShape.circle,
  //               ),
  //               padding: const EdgeInsets.all(2),
  //               child: const Icon(Icons.close, color: Colors.white, size: 16),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // /// Attachment bottom sheet
  // void _showAttachmentOptions(BuildContext context) {
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (_) {
  //       return SafeArea(
  //         child: Wrap(
  //           children: [
  //             ListTile(
  //               leading: const Icon(Icons.image),
  //               title: const Text('Pick Image'),
  //               onTap: () async {
  //                 Navigator.pop(context);
  //                 final file = await FilePickerHelper.pickImage();
  //                 if (file != null) setState(() => attachment = file);
  //               },
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.videocam),
  //               title: const Text('Pick Video'),
  //               onTap: () async {
  //                 Navigator.pop(context);
  //                 final file = await FilePickerHelper.pickVideo();
  //                 if (file != null) setState(() => attachment = file);
  //               },
  //             ),
  //             ListTile(
  //               leading: const Icon(Icons.camera_alt),
  //               title: const Text('Capture Photo'),
  //               onTap: () async {
  //                 Navigator.pop(context);
  //                 final file = await FilePickerHelper.pickImage(fromCamera: true);
  //                 if (file != null) setState(() => attachment = file);
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }
}
