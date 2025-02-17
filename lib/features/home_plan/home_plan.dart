import 'package:flutter/material.dart';
import 'package:dream_home_user/features/recommendation/feature_card.dart';
import 'package:dream_home_user/theme/app_theme.dart';

class HomePlan extends StatefulWidget {
  final bool isPaid; // Required parameter for the bottom sheet visibility

  const HomePlan(
      {super.key, required this.isPaid}); // Constructor with required parameter

  @override
  State<HomePlan> createState() => _HomePlanState();
}

class _HomePlanState extends State<HomePlan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 400,
                  child: Image.network(
                    'https://g.foolcdn.com/editorial/images/574911/new-home.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                    top: 40,
                    left: 10,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: CircleAvatar(
                        radius: 15,
                        child: Icon(Icons.chevron_left),
                      ),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The Four Corner',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      FeatureCard(
                        text: "4 Beds",
                        icon: Icons.bed,
                      ),
                      FeatureCard(
                        icon: Icons.bathtub,
                        text: "2 Bath",
                      ),
                      FeatureCard(
                        icon: Icons.directions_car,
                        text: "1 Parking",
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://cdn.pixabay.com/photo/2023/05/27/08/04/ai-generated-8021008_1280.jpg'),
                    ),
                    title: Text("Architect Name"),
                    subtitle: Text("Professional Architect"),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Details',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '''Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.''',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Ground Floor',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '''Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.''',
                    style: TextStyle(fontSize: 14.0),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Detailed Image',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Image.network(
                    'https://gillaniarchitects.weebly.com/uploads/1/2/7/4/12747279/8845232_orig.jpg',
                    fit: BoxFit.cover,
                  ),
                  widget.isPaid == true
                      ? SizedBox(
                          height: 100,
                        )
                      : SizedBox(
                          height: 10,
                        )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: widget.isPaid // Use the isPaid value passed to the widget
          ? Container(
              decoration: BoxDecoration(
                color: Colors.grey[300],
              ),
              padding: EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$99.99',
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    child: Text('Buy Now'),
                  ),
                ],
              ),
            )
          : SizedBox.shrink(), // If not paid, the bottom sheet won't show
    );
  }
}
