import 'dart:io';
import 'package:custom_ui/custom_ui.dart';
import 'package:flutter/material.dart';
import '../../../../core/utils/file_picker_helper.dart';

class MessageInputBox extends StatefulWidget {
  final Function(String message, File? attachment) onSend;

  const MessageInputBox({super.key, required this.onSend});

  @override
  State<MessageInputBox> createState() => _MessageInputBoxState();
}

class _MessageInputBoxState extends State<MessageInputBox> {
  final TextEditingController _controller = TextEditingController();
  File? _attachment;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_attachment != null) _attachmentPreview(),
           CustomTextField(
                         hint: 'Send a Message',
                        style: TextFieldStyle.outlined,
                  controller: _controller,
                  prefixIcon: IconButton(
                icon: const Icon(Icons.attach_file),
                onPressed: _showAttachmentOptions,
              ) ,
              suffixIcon:  IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (_controller.text.trim().isEmpty && _attachment == null) return;
                  widget.onSend(_controller.text.trim(), _attachment);
                  _controller.clear();
                  setState(() => _attachment = null);
                },
              ),
                 
                ),
             SizedBox(height: 8,)
        ],
      ),
    );
  }

  Widget _attachmentPreview() {
    final isImage = _attachment!.path.endsWith('.jpg') ||
        _attachment!.path.endsWith('.jpeg') ||
        _attachment!.path.endsWith('.png');

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: isImage
              ? Image.file(_attachment!, height: 90, width: 90, fit: BoxFit.cover)
              : const Icon(Icons.insert_drive_file, size: 50),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => setState(() => _attachment = null),
            child: const CircleAvatar(
              radius: 10,
              backgroundColor: Colors.black54,
              child: Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  void _showAttachmentOptions() async {
    showModalBottomSheet(
      context: context,
      builder: (_) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Pick Image'),
            onTap: () async {
              Navigator.pop(context);
              final file = await FilePickerHelper.pickImage();
              if (file != null) setState(() => _attachment = file);
            },
          ),
                ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Capture Photo'),
                onTap: () async {
                  Navigator.pop(context);
                  final file = await FilePickerHelper.pickImage(fromCamera: true);
                  if (file != null) setState(() => _attachment = file);
                },
              ),
        ],
      ),
    );
  }
}
