import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import '../../../../core/config/env_service.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controller = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    final mobile = _controller.text.trim();
    if (mobile.length != 10 || int.tryParse(mobile) == null) {
      setState(() => _error = 'Enter a valid 10-digit mobile number');
      return;
    }
    setState(() { _loading = true; _error = null; });

    try {
      final baseUrl = EnvService.getString('BASE_URL', defaultValue: 'https://api.example.com');
      final uri = Uri.parse('$baseUrl/login-customer');
      print('--- API REQUEST: Login (auth page) ---');
      print('URL: $uri');
      print('BODY: ${json.encode({'mobile_no': mobile})}');

      final res = await http.post(
        uri,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'mobile_no': mobile}),
      );

      print('--- API RESPONSE: Login (auth page) ---');
      print('STATUS: ${res.statusCode}');
      print('BODY: ${res.body}');

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final jsonBody = json.decode(res.body) as Map<String, dynamic>;
        final ok = jsonBody['status'] == true;
        if (ok) {
          final data = jsonBody['data'] as Map<String, dynamic>?;

if (data != null && data['customer'] != null) {
  final customer = Map<String, dynamic>.from(data['customer']);

  print("REAL CUSTOMER: $customer");

  final userData = {
  "id": customer['id'] ?? 0,
  "site_id": customer['site_id'] ?? 0,
  "name": customer['name'] ?? '',
  "mobile_no": customer['mobile_no'] ?? '',
};

  print("SAVING USER: $userData");
  print("FINAL SAVED USER: $userData");
final localStorage = GetIt.I<LocalStorage>();
await localStorage.remove(key: 'user', boxName: 'auth');
await localStorage.save(
  key: 'user',
  value: json.encode(userData), // IMPORTANT
  boxName: 'auth',
);
final saved = await localStorage.load(key: 'user', boxName: 'auth');
print("AFTER SAVE: $saved");
            if (mounted) context.go('/dashboard');
            return;
          }
        }
        setState(() => _error = (jsonBody['message'] as String?) ?? 'Login failed');
      } else {
        setState(() => _error = 'Server error: ${res.statusCode}');
      }
    } catch (e) {
      setState(() => _error = 'Network error: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _controller,
              keyboardType: TextInputType.number,
              maxLength: 10,
              decoration: const InputDecoration(
                labelText: 'Mobile Number',
                hintText: 'Enter 10-digit number',
                counterText: '',
              ),
            ),
            const SizedBox(height: 12),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loading ? null : _login,
              child: _loading
                  ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}


