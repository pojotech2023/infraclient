import 'package:http/http.dart' as http;
import 'dart:convert';
void main() async {
  try {
    var response = await http.post(Uri.parse('https://ssbuildcraft.in/admin/public/api/login-customer'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'mobile_no': '8015915169'})
    );
    print('Status: ${response.statusCode}');
    print('Body: ${response.body}');
  } catch (e) {
    print('Error: $e');
  }
}
