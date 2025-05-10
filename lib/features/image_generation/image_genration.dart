import 'dart:typed_data';
import 'dart:convert';
import 'package:dream_home_user/features/image_generation/generated_homeplan_card.dart';
import 'package:dream_home_user/features/image_generation/generated_homeplan_details.dart';
import 'package:dream_home_user/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;

const String _apiKey = "AIzaSyBVk6BMKoPabvSEAvIKoSl2ZiF-7-5wDrk";

Map output = {};

class HousePlanChatScreen extends StatefulWidget {
  const HousePlanChatScreen({super.key});

  @override
  State<HousePlanChatScreen> createState() => _HousePlanChatScreenState();
}

class _HousePlanChatScreenState extends State<HousePlanChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // To scroll results
  bool _isLoading = false;
  Map<String, dynamic>? _housePlanData; // To store the parsed JSON
  String? _errorMessage; // To store any errors
  String? _rawApiResponse; // To store the raw response for debugging

  // Dispose controllers when the widget is removed
  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  // --- Function to call Gemini API ---
  Future<void> _generatePlan() async {
    if (_apiKey == "YOUR_API_KEY_HERE" || _apiKey.isEmpty) {
      setState(() {
        _errorMessage = "API Key Missing! Please paste your Gemini API key into the _apiKey variable in the code.";
        _isLoading = false;
        _housePlanData = null;
        _rawApiResponse = null;
      });
      return;
    }

    if (_textController.text.isEmpty) {
      setState(() {
        _errorMessage = "Please enter a description for the house.";
        _isLoading = false;
        _housePlanData = null;
        _rawApiResponse = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null; // Clear previous errors
      _housePlanData = null; // Clear previous data
      _rawApiResponse = null;
    });

    final userInput = _textController.text;

    // --- The specific prompt structure you provided ---
    // --- Updated prompt structure with floor description and consistency instruction ---
    final prompt = """
You are a specialized AI assistant for generating conceptual house plan details and image prompts based on user descriptions.

Your task is to carefully analyze the user's conceptual house description, provided within the "$userInput" placeholder, and generate a structured response detailing the conceptual plan.

The output MUST be a JSON object, enclosed strictly within ```json ... ``` tags. Include ONLY the JSON block in your final response.

The JSON object must follow this exact structure:
{
  "title": "A suitable, descriptive title for the house plan (e.g., 'Modern 3-Bedroom Family Home' or 'Compact Urban Dwelling')",
  "description": "A brief description summarizing the key features and style of the entire house concept based on the user input. Use Markdown for basic formatting if appropriate (like bullet points or lists).",
  "plot_area": "Estimate the total plot area in square feet or meters (e.g., '1500 sqft' or '140 sqm') based on the description or plausible assumptions. If the description gives no clues and estimation is highly uncertain, set to null.",
  "plot_length": "Estimate the plot length (e.g., '30 ft' or '9 m'). Estimate or set to null if highly uncertain.",
  "plot_width": "Estimate the plot width (e.g., '50 ft' or '15 m'). Ensure plot_length and plot_width are reasonably consistent with plot_area if all are estimated. Estimate or set to null if highly uncertain.",
  "road_facing": "Determine or reasonably assume the primary direction the main road faces relative to the house (e.g., 'North', 'South-East', 'West'). Estimate or set to null if unspecified and cannot be reasonably assumed.",
  "overall_image_prompt": "Generate a DETAILED, concise prompt (around 20-50 words) specifically for an AI image generator (like Stable Diffusion) to create a visual representation of the EXTERIOR of this house. Describe the architectural style, main materials, key visual features (e.g., large windows, pitched roof), time of day, and overall setting (e.g., suburban street, rural landscape). Avoid overly complex sentences or jargon.",
  "floors": [
    {
      "name": "Clearly identify the floor (e.g., 'Ground Floor', 'First Floor', 'Basement', 'Second Floor')",
      "description": "Provide a brief, clear description of the layout and key functional areas/rooms located on *this specific floor*, based on the user description or plausible design principles.",
      "bedroom_count": "Count the exact number of bedrooms on this floor based on the user description or the layout described for this floor. Use an integer (0, 1, 2, etc.) or null if the floor has no bedrooms or if the count is completely unknown/not applicable. It should match the image prompt of this floor",
      "bathroom_count": "Count the exact number of bathrooms and/or toilets (full or half baths) on this floor based on the user description or the layout described for this floor. Use an integer (0, 1, 2, etc.) or null if the floor has no bathrooms or if the count is completely unknown/not applicable. It should match the image prompt of this floor",
      "image_prompt": "Generate a DETAILED, concise prompt (around 20-40 words) specifically for an AI image generator to create a visual representation of the FLOOR PLAN LAYOUT for *this specific floor*. Describe the view (e.g., top-down, bird's eye), style (e.g., blueprint, minimalist rendering, schematic), and the main room placements and flow (e.g., 'open living area flowing into kitchen', 'bedrooms arranged around central hall'). Avoid overly complex sentences."
    }
    // Include multiple floor objects if the user's description implies more than one floor. Ensure the number of floor objects matches the implied number of stories/levels.
  ]
}

Strict Consistency Mandate: You MUST ensure absolute consistency between the numerical `bedroom_count` and `bathroom_count` values for each floor object and the number of bedrooms and bathrooms mentioned or clearly implied within the `description` and `image_prompt` fields of *that same floor object*. These counts must accurately reflect the textual description of the floor's layout.

Interpret the user's request thoughtfully. Where details are missing, make creative but plausible assumptions consistent with the overall style and purpose implied by the user. Prioritize generating clear, specific, and effective image prompts for both the exterior and floor plans.

Output ONLY the final JSON object enclosed in ```json ... ```. Do not add any introductory text, explanations, or concluding remarks outside the JSON block.
""";

    // --- Initialize the Generative Model ---
    // Use gemini-1.5-flash or gemini-pro depending on availability and needs
    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: _apiKey);
    // For stricter safety settings (optional):
    // final safetySettings = [
    //   SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
    //   SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
    // ];
    // final model = GenerativeModel(
    //     model: 'gemini-1.5-flash',
    //     apiKey: _apiKey,
    //     safetySettings: safetySettings);

    final content = [Content.text(prompt)];

    try {
      // --- Send the request to Gemini ---
      final response = await model.generateContent(content);
      _rawApiResponse = response.text; // Store raw response
      Logger().w(_rawApiResponse);
      // --- Extract and Parse the JSON ---
      String? jsonString;
      if (_rawApiResponse != null) {
        // Find the start and end of the JSON block
        final jsonStartIndex = _rawApiResponse!.indexOf('```json');
        final jsonEndIndex = _rawApiResponse!.lastIndexOf('```');

        if (jsonStartIndex != -1 && jsonEndIndex != -1 && jsonEndIndex > jsonStartIndex) {
          // Extract the string between ```json and ```
          jsonString = _rawApiResponse!
              .substring(jsonStartIndex + 7, jsonEndIndex) // +7 to skip ```json\n
              .trim();
        } else {
          // Fallback: Assume the whole response might be the JSON if markers aren't found
          // This is less reliable but might work if the model *only* outputs JSON.
          jsonString = _rawApiResponse!.trim();
        }
      }

      if (jsonString != null && jsonString.isNotEmpty) {
        // Attempt to decode the extracted JSON string
        final decodedJson = jsonDecode(jsonString);
        if (decodedJson is Map<String, dynamic>) {
          setState(() {
            _housePlanData = decodedJson;
            _errorMessage = null; // Clear error on success
          });
          // Scroll to the bottom to show results
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        } else {
          throw const FormatException("Decoded JSON is not a Map.");
        }
      } else {
        throw FormatException(
            "Could not find or extract JSON block from the response. Raw response:\n$_rawApiResponse");
      }
    } catch (e) {
      // --- Handle Errors ---
      setState(() {
        _errorMessage = "Error generating plan: ${e.toString()}\n\nRaw Response:\n$_rawApiResponse";
        _housePlanData = null; // Clear data on error
      });
      debugPrint("Error: $e"); // Log the error for debugging
      debugPrint("Raw Response: $_rawApiResponse");
    } finally {
      // --- Stop Loading Indicator ---
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Gemini House Planner'),
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController, // Use scroll controller
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      // --- Display Error Message ---
                      if (_errorMessage != null)
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: Colors.redAccent.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.redAccent)),
                          child: SelectableText(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.redAccent),
                          ),
                        ),

                      // --- Display House Plan Data ---
                      if (_housePlanData != null) _buildResultView(_housePlanData!),

                      // --- Optional: Display Raw Response for Debugging ---
                      // if (_rawApiResponse != null && _housePlanData == null && _errorMessage == null) // Show if no data and no error
                      //    Padding(
                      //      padding: const EdgeInsets.only(top: 15.0),
                      //      child: SelectableText("Raw Response (JSON not parsed):\n$_rawApiResponse"),
                      //    ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: InputDecoration(
                      hintText:
                          'Describe your dream house (e.g., "A 2-story modern house with 3 bedrooms, large windows, south facing")...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      // fillColor: Colors.grey[800], // Darker input field
                    ),
                    maxLines: 3, // Allow multi-line input
                    onSubmitted: (_) => _generatePlan(), // Allow submitting with Enter key
                  ),
                ),
                const SizedBox(width: 8),
                // --- Send Button ---

                IconButton(
                  icon: _isLoading
                      ? const SizedBox(
                          // Show progress indicator inside button
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 3))
                      : const Icon(Icons.send),
                  onPressed: _isLoading ? null : _generatePlan, // Disable while loading
                  tooltip: 'Generate Plan',
                  style: IconButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- Helper Widget to Build the Results View ---
  Widget _buildResultView(Map<String, dynamic> data) {
    output = data;
    // final textTheme = Theme.of(context).textTheme;
    // final titleStyle = textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold);
    // final headingStyle = textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold);
    // final bodyStyle = textTheme.bodyLarge;

    // Safely access data, providing defaults or 'N/A'
    // String getField(String key, [String defaultValue = 'N/A']) {
    //   return data[key]?.toString() ?? defaultValue;
    // }

    // Extract floor data safely
    // List<Map<String, dynamic>> floors = [];
    // if (data['floors'] is List) {
    //   floors = List<Map<String, dynamic>>.from((data['floors'] as List).whereType<Map<String, dynamic>>());
    // }

    return Padding(
      padding: const EdgeInsets.only(left: 0, right: 0, top: 16, bottom: 140),
      child: GeneratedHomeplanCard(
        cardData: data,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => GeneratedHomeplanDetails(
                homeplan: output,
              ),
            ),
          );
        },
      ),
    );
  }

  // Helper widget for displaying plot detail items consistently
  // Widget _buildDetailItem(String label, String value) {
  //   final textTheme = Theme.of(context).textTheme;
  //   return Flexible(
  //     // Use Flexible to prevent overflow in Row
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(label, style: textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
  //         const SizedBox(height: 2),
  //         SelectableText(value, style: textTheme.bodyLarge),
  //       ],
  //     ),
  //   );
  // }
}

class ImageGenration extends StatefulWidget {
  final String prompt;
  final Function(Uint8List) onImageGenerated;
  const ImageGenration({super.key, required this.prompt, required this.onImageGenerated});

  @override
  State<ImageGenration> createState() => _ImageGenrationState();
}

class _ImageGenrationState extends State<ImageGenration> {
  Future<Uint8List?> generate() async {
    final apiKey = 'sk-IeNoLRkUsBdBV9SmOPqAliXleZxetAn9OF2RmKqQA2ZSzk2f'; // Replace with your Stability AI API key
    final url = Uri.parse('https://api.stability.ai/v2beta/stable-image/generate/ultra');
    final request = http.MultipartRequest('POST', url)
      ..headers['Authorization'] = 'Bearer $apiKey'
      ..fields['prompt'] = widget.prompt;
    // Add more fields if needed

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final contentType = response.headers['content-type'] ?? '';
      if (contentType.contains('image/')) {
        // It's an image, return the bytes directly
        final imageBytes = response.bodyBytes;
        widget.onImageGenerated(imageBytes); // Call the callback with the image bytes
        return response.bodyBytes;
      } else if (contentType.contains('application/json')) {
        final data = jsonDecode(response.body);
        throw Exception('Unexpected JSON response: $data');
      } else {
        throw Exception('Unknown response type: $contentType');
      }
    } else {
      throw Exception('Error: \\${response.statusCode} \\${response.body}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Uint8List?>(
      future: generate(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(child: const CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          return Text('Error: \\${snapshot.error}', style: const TextStyle(color: Colors.redAccent));
        } else if (snapshot.hasData && snapshot.data != null) {
          return Image.memory(snapshot.data!, fit: BoxFit.cover);
        } else {
          return Container();
        }
      },
    );
  }
}

//  Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // --- Title ---
//           Text(getField('title', 'Untitled Plan'), style: titleStyle),
//           const SizedBox(height: 10),

//           // --- Description ---
//           if (data['description'] != null) ...[
//             Text('Description:', style: headingStyle),
//             SelectableText(getField('description'), style: bodyStyle),
//             const SizedBox(height: 15),
//           ],

//           // --- Plot Details ---
//           Row(
//             // Use Row for better layout of plot details
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildDetailItem('Plot Area:', getField('plot_area')),
//               _buildDetailItem('Plot Length:', getField('plot_length')),
//             ],
//           ),
//           const SizedBox(height: 8),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _buildDetailItem('Plot Width:', getField('plot_width')),
//               _buildDetailItem('Road Facing:', getField('road_facing')),
//             ],
//           ),
//           const SizedBox(height: 15),

//           // --- Overall Image Prompt ---
//           Text('Exterior Image Prompt:', style: headingStyle),
//           ImageGenration(prompt: data['overall_image_prompt']),
//           const SizedBox(height: 20),

//           // --- Floors ---
//           Text('Floor Details:', style: headingStyle),
//           if (floors.isEmpty)
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0),
//               child: Text('No floor details provided.', style: bodyStyle),
//             )
//           else
//             ListView.separated(
//               physics: const NeverScrollableScrollPhysics(), // Disable scrolling
//               shrinkWrap: true,
//               itemBuilder: (context, index) => Card(
//                 margin: const EdgeInsets.symmetric(vertical: 5),
//                 child: Padding(
//                   padding: const EdgeInsets.all(12.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Floor Name: ${floors[index]['name']}', style: headingStyle),
//                       const SizedBox(height: 5),
//                       Text('Bedroom: ${floors[index]['bedroom_count']}', style: headingStyle),
//                       const SizedBox(height: 5),
//                       Text('Bathroom: ${floors[index]['bathroom_count']}', style: headingStyle),
//                       const SizedBox(height: 5),
//                       Text('Description: ${floors[index]['description']}', style: headingStyle),
//                       const SizedBox(height: 5),
//                       ImageGenration(prompt: floors[index]['image_prompt']),
//                     ],
//                   ),
//                 ),
//               ),
//               separatorBuilder: (context, index) => SizedBox(
//                 height: 5,
//               ),
//               itemCount: floors.length,
//             ),
//         ],
//       ),
