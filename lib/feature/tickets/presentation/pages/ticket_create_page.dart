import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';

import '../../../../core/cache/local_storage.dart';
import '../../domain/usecases/get_tickets.dart';

class TicketCreatePage extends StatefulWidget {
  const TicketCreatePage({super.key});

  @override
  State<TicketCreatePage> createState() => _TicketCreatePageState();
}

class _TicketCreatePageState extends State<TicketCreatePage> {
  final TextEditingController _controller = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  XFile? _picked;
  bool _submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pick() async {
    final file = await _picker.pickImage(source: ImageSource.gallery);
    if (!mounted) return;
    setState(() => _picked = file);
  }

 void submit({required int siteId, required int customerId,  required Map user}) async {
    if (_controller.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter ticket name')));
      return;
    }
    setState(() => _submitting = true);

    final addTicket = GetIt.I<AddTicket>();
    // final result = await addTicket(
    //   siteId: siteId,
    //   customerId: customerId,
    //   ticket: _controller.text.trim(),
    //   attachmentPath: _picked?.path,
    // );
    print("USER FROM STORAGE: $user");
     final result = await addTicket(
      siteId: siteId,
      customerId: customerId,
      ticket: _controller.text.trim(),
      attachmentPath: _picked?.path,
    );
    if (!mounted) return;
    result.fold(
      (l) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(l.message)));
      },
      (r) {
        Navigator.of(context).pop(true);
      },
    );
    if (mounted) setState(() => _submitting = false);
  }

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
        final int customerId= user['id'] ?? 0;
       

   
    return Scaffold(
      appBar: AppBar(title: const Text('New Ticket')),
      body:SafeArea(child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Ticket Name'),
            const SizedBox(height: 8),
            TextField(
              controller: _controller,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'e.g. TV not working'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                ElevatedButton.icon(onPressed: _pick, icon: const Icon(Icons.attach_file), label: const Text('Attachment')),
                const SizedBox(width: 12),
                Expanded(child: Text(_picked == null ? 'No file selected' : File(_picked!.path).path.split('/').last, overflow: TextOverflow.ellipsis)),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: ()=> submit(siteId: siteId,customerId: customerId,user:user),
                child: _submitting ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Submit'),
              ),
            )
          ],
        ),
      ),
      )
    );});
  }
}


