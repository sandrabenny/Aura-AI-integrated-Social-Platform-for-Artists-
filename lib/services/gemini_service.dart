import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  static const String apiKey = 'AIzaSyBxa4_Ki58EY6opiv6_qPeQMX7eLc3vEbg';
  static const String baseUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent';

  static Future<String> generateResponse(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl?key=$apiKey'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'contents': [{
            'parts': [{
              'text': '''
              You are AURA, an AI art assistant. You help users with art-related questions, 
              provide insights about artworks, and guide them through the art marketplace.
              
              User: $prompt
              
              Please provide a helpful, art-focused response. If the question is not art-related,
              gently guide the conversation back to art topics.
              '''
            }]
          }],
          'generationConfig': {
            'temperature': 0.7,
            'topK': 40,
            'topP': 0.95,
            'maxOutputTokens': 1024,
          },
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && 
            data['candidates'].isNotEmpty && 
            data['candidates'][0]['content'] != null &&
            data['candidates'][0]['content']['parts'] != null &&
            data['candidates'][0]['content']['parts'].isNotEmpty) {
          return data['candidates'][0]['content']['parts'][0]['text'] ?? 
                 'I apologize, but I couldn\'t generate a response. Could you please rephrase your question?';
        } else {
          print('Invalid response format from Gemini API: ${response.body}');
          return 'I apologize, but I\'m having trouble processing your request. Could you please try again?';
        }
      } else {
        print('Error from Gemini API: ${response.statusCode} - ${response.body}');
        return 'I apologize, but I\'m experiencing technical difficulties. Please try again later.';
      }
    } catch (e) {
      print('Error calling Gemini API: $e');
      return 'I apologize, but I\'m having trouble connecting to my services. Please try again in a moment.';
    }
  }

  static Future<String> getArtworkInsights(String artworkDescription) async {
    final prompt = '''
    As an art expert, provide insights about this artwork:
    $artworkDescription
    
    Please analyze:
    1. Potential artistic style and influences
    2. Technical aspects (composition, color, technique)
    3. Possible interpretation or meaning
    4. Market value considerations
    
    Keep the response concise but informative.
    ''';

    return await generateResponse(prompt);
  }

  static Future<String> getBiddingAdvice(String artworkDetails, String currentBid) async {
    final prompt = '''
    As an art market expert, provide bidding advice for this artwork:
    Artwork: $artworkDetails
    Current Bid: $currentBid
    
    Consider:
    1. Fair market value
    2. Investment potential
    3. Bidding strategy
    4. Maximum recommended bid
    
    Provide concise, practical advice.
    ''';

    return await generateResponse(prompt);
  }

  static Future<String> getArtistInsights(String artistProfile) async {
    final prompt = '''
    Analyze this artist's profile and provide insights:
    $artistProfile
    
    Include:
    1. Artistic style and influences
    2. Market position and potential
    3. Notable characteristics
    4. Collection value considerations
    
    Keep the response focused and valuable for collectors.
    ''';

    return await generateResponse(prompt);
  }
} 