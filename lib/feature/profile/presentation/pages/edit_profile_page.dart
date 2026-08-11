import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:custom_ui/custom_ui.dart';
import 'package:builder_customer/core/localization/context_ext.dart';
import 'dart:convert';
import '../../../../core/cache/local_storage.dart';
import '../../domain/repositories/profile_repository.dart';

class EditProfilePage extends StatefulWidget {
  final Map<String, dynamic> userData;

  const EditProfilePage({super.key, required this.userData});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController dobController;
  late TextEditingController addressController;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.userData['name']);
    emailController = TextEditingController(text: widget.userData['email']);
    dobController = TextEditingController(text: widget.userData['dob']);
    addressController = TextEditingController(text: widget.userData['address']);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    dobController.dispose();
    addressController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final profileRepo = GetIt.I<ProfileRepository>();
      
      final Map<String, dynamic> data = {};
      if (nameController.text != widget.userData['name']) {
        data['name'] = nameController.text;
      }
      if (emailController.text != widget.userData['email']) {
        data['email'] = emailController.text;
      }
      if (dobController.text != widget.userData['dob']) {
        data['dob'] = dobController.text;
      }
      if (addressController.text != widget.userData['address']) {
        data['address'] = addressController.text;
      }

      if (data.isNotEmpty) {
        await profileRepo.updateProfileDetails(data);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n?.edit ?? 'Edit Profile'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  CustomTextField(
                    hint: 'Name',
                    controller: nameController,
                    style: TextFieldStyle.outlined,
                    prefixIcon: const Icon(Icons.person),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hint: context.l10n?.email ?? 'Email',
                    controller: emailController,
                    style: TextFieldStyle.outlined,
                    prefixIcon: const Icon(Icons.email),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        dobController.text = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
                      }
                    },
                    child: AbsorbPointer(
                      child: CustomTextField(
                        hint: context.l10n?.dateofBirth ?? 'Date of Birth',
                        controller: dobController,
                        style: TextFieldStyle.outlined,
                        prefixIcon: const Icon(Icons.calendar_today),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CustomTextField(
                    hint: context.l10n?.address ?? 'Address',
                    controller: addressController,
                    style: TextFieldStyle.outlined,
                    prefixIcon: const Icon(Icons.location_on),
                    maxLines: 3,
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: context.l10n?.save ?? 'Save Changes',
                    type: ButtonType.elevated,
                    onPressed: () {
                      if (!_isLoading) {
                        _saveProfile();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black45,
              child: const Center(
                child: CircularProgressIndicator(color: Colors.white),
              ),
            ),
        ],
      ),
    );
  }
}
