import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

class AiAnalysisService {
  // TODO: Replace this with your API key from Google AI Studio (https://makersuite.google.com/app/apikey)
  static const String _apiKey = 'AIzaSyA0zH5UrviziqXdXAJ9XwoEwn9i0_4KH-8';
  
  static Future<String> analyzeArtwork(String imageUrl) async {
    try {
      // Download the image
      final response = await http.get(Uri.parse(imageUrl));
      final bytes = response.bodyBytes;

      // Initialize the model
      final model = GenerativeModel(
        model: 'gemini-1.5-flash-002',
        apiKey: _apiKey,
        generationConfig: GenerationConfig(
          temperature: 0.7,
          maxOutputTokens: 2048,
        ),
      );

      // Create the prompt
      const prompt = '''
Analyze this artwork and provide a 5-line description covering:
1. Style and technique
2. Color palette and mood
3. Subject matter or theme
4. Artistic influences or period
5. Overall emotional impact
Keep each line concise and insightful.
''';

      // Create content
      final content = [
        Content.multi([
          TextPart(prompt),
          DataPart('image/jpeg', bytes),
        ]),
      ];
      
      // Generate content
      final result = await model.generateContent(content);
      return result.text ?? 'Unable to analyze artwork.';
    } catch (e) {
      print('Error analyzing artwork: $e');
      return 'Unable to analyze artwork at this time. Please try again later.';
    }
  }
} 