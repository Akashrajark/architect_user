import 'package:dream_home_user/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../util/format_function.dart';
import 'feature_card.dart';

class HomePlanCard extends StatelessWidget {
  final Function() onTap;
  final Map cardData;
  const HomePlanCard({
    super.key,
    required this.cardData,
    required this.onTap,
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
            if (cardData['image_url'] != null)
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  cardData['image_url'],
                  fit: BoxFit.cover,
                  height: 220,
                  width: double.infinity,
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
                          formatValue(cardData['name']),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          formatValue(cardData['description']),
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '₹${formatValue(cardData['price'])}',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.green),
                        ),
                        SizedBox(height: 8),
                        Wrap(
                          runSpacing: 10,
                          spacing: 10,
                          children: [
                            if (cardData['total_bedrooms'] != 0)
                              FeatureCard(
                                text:
                                    '${formatInteger(cardData['total_bedrooms'])} Bed',
                                icon: Icons.bed,
                              ),
                            if (cardData['total_bathrooms'] != 0)
                              FeatureCard(
                                icon: Icons.bathtub,
                                text:
                                    '${formatInteger(cardData['total_bathrooms'])} Bath',
                              ),
                            FeatureCard(
                              icon: Icons.straighten, // represents length
                              text:
                                  "${formatValue(cardData['plot_length'])} m Length",
                            ),
                            FeatureCard(
                              icon: Icons.straighten, // can use same for width
                              text:
                                  "${formatValue(cardData['plot_width'])} m Width",
                            ),
                            FeatureCard(
                              icon: Icons.square_foot,
                              text:
                                  "${formatValue(cardData['plot_area'])} m² Area",
                            ),
                            FeatureCard(
                              icon: Icons.directions, // road facing
                              text:
                                  "${formatValue(cardData['road_facing'])} Facing",
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
}

    //  ListTile(
    //                   leading: CircleAvatar(
    //                     backgroundImage: NetworkImage(
    //                         'https://randomuser.me/api/portraits/men/1.jpg'),
    //                   ),
    //                   title: Text("Architect Name"),
    //                   subtitle: Text("Professional Architect"),
    //                 ),