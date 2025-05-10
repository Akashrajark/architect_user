import 'package:dream_home_user/features/image_generation/image_genration.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import '../../common_widgets.dart/feature_card.dart';
import '../../theme/app_theme.dart';
import '../../util/format_function.dart';

class GeneratedHomeplanCard extends StatelessWidget {
  final Function() onTap;
  final Map cardData;
  final bool useNetworkImage;
  const GeneratedHomeplanCard({
    super.key,
    required this.cardData,
    required this.onTap,
    this.useNetworkImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      shadowColor: shadowColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            if (useNetworkImage)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  cardData['image'],
                  fit: BoxFit.cover,
                  height: 220,
                  width: double.infinity,
                ),
              )
            else if (cardData['image_file'] != null)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.memory(
                  cardData['image_file'],
                  fit: BoxFit.cover,
                  height: 220,
                  width: double.infinity,
                ),
              )
            else
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: ImageGenration(
                  prompt: cardData['overall_image_prompt'],
                  onImageGenerated: (data) {
                    output['image_file'] = data;
                    Logger().w('output2: $output');
                  },
                ),
              ),
            Padding(
              padding: const EdgeInsets.only(top: 207),
              child: SizedBox(
                width: double.infinity,
                child: Material(
                  borderRadius: BorderRadius.circular(16),
                  child: Padding(
                    padding: EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatValue(cardData['title']),
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          formatValue(cardData['description']),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 3,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          runSpacing: 10,
                          spacing: 10,
                          children: [
                            if (cardData['total_bedrooms'] != 0)
                              FeatureCard(
                                text: '${formatInteger(getTotalBedrooms(cardData['floors']))} Bed',
                                icon: Icons.bed,
                              ),
                            if (cardData['total_bathrooms'] != 0)
                              FeatureCard(
                                icon: Icons.bathtub,
                                text: '${formatInteger(getTotalBathroom(cardData['floors']))} Bath',
                              ),
                            FeatureCard(
                              icon: Icons.straighten, // represents length
                              text: "${formatValue(cardData['plot_length'])} Length",
                            ),
                            FeatureCard(
                              icon: Icons.straighten, // can use same for width
                              text: "${formatValue(cardData['plot_width'])} Width",
                            ),
                            FeatureCard(
                              icon: Icons.square_foot,
                              text: "${formatValue(cardData['plot_area'])} Area",
                            ),
                            FeatureCard(
                              icon: Icons.directions, // road facing
                              text: "${formatValue(cardData['road_facing'])} Facing",
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  int getTotalBedrooms(List? properties) {
    if (properties == null || properties.isEmpty) {
      return 0; // Return 0 if the list is null or empty
    }

    return properties.fold(0, (sum, property) {
      int bedrooms = property['bedroom_count'] ?? 0; // Default to 0 if 'bedrooms' is missing
      return sum + bedrooms;
    });
  }

  int getTotalBathroom(List? properties) {
    if (properties == null || properties.isEmpty) {
      return 0; // Return 0 if the list is null or empty
    }

    return properties.fold(0, (sum, property) {
      int bedrooms = property['bathroom_count'] ?? 0; // Default to 0 if 'bedrooms' is missing
      return sum + bedrooms;
    });
  }
}
