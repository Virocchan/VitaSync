// lib/services/api_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart'; // Relative path to your model

class ApiService {
  // IMPORTANT: CONFIGURE THIS URL
  // For Android Emulator: "http://10.0.2.2:5000"
  // For Physical Device (connected to same Wi-Fi as your computer running the Python server):
  //   Find your computer's local IP (e.g., 192.168.1.XX) and use "http://YOUR_COMPUTER_IP:5000"
  //   Ensure your Python server is started with host='0.0.0.0'
  static const String _baseUrl = "http://10.0.2.2:5000"; // Default for Android Emulator

  Future<String?> sendMessageToGemini({
    required String message,
    required List<ChatMessage> history, // Pass the conversation history
  }) async {
    try {
      final url = Uri.parse('$_baseUrl/chat');

      // Convert ChatMessage list to the format expected by the backend
      List<Map<String, dynamic>> historyPayload = history
          .map((msg) => msg.toJsonForHistory())
          .toList();

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'message': message,
          'history': historyPayload, // Send the current conversation history
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['reply'] as String?;
      } else {
        print('Error from server: ${response.statusCode}');
        print('Error body: ${response.body}');
        // Try to parse the error message from the backend
        String errorMessage = 'Unknown server error (${response.statusCode})';
        try {
          final errorData = jsonDecode(response.body);
          if (errorData['error'] != null) {
            errorMessage = errorData['error'];
          }
        } catch (e) {
          // If parsing errorData fails, use the raw body or default message
          errorMessage = response.body.isNotEmpty ? response.body : errorMessage;
        }
        return "Error: $errorMessage"; // Return the error message to display in chat
      }
    } catch (e) {
      print('Error sending message: $e');
      return "Error: Could not connect to the server. $e"; // Network or other client-side error
    }
  }
}
