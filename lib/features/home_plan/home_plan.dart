import 'package:flutter/material.dart';
import 'package:dream_home_user/features/recommendation/feature_card.dart';
import 'package:dream_home_user/theme/app_theme.dart';

class HomePlan extends StatefulWidget {
  const HomePlan({super.key});

  @override
  State<HomePlan> createState() => _HomePlanState();
}

class _HomePlanState extends State<HomePlan> {
  late int currentIndex = 0;

  final List<dynamic> images = [
    'https://images.pexels.com/photos/30689450/pexels-photo-30689450/free-photo-of-black-and-white-cat-lounging-on-red-roof-tiles.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/30458589/pexels-photo-30458589/free-photo-of-charming-urban-street-with-vibrant-architecture.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/30666571/pexels-photo-30666571/free-photo-of-elegant-mansion-facade-with-lush-foliage.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
    'https://images.pexels.com/photos/30641190/pexels-photo-30641190/free-photo-of-rural-courtyard-with-traditional-charpai.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryColor,
      body: Column(
        children: [
          SizedBox(
            height: 400,
            child: Stack(
              children: [
                PageView.builder(
                  onPageChanged: (int index) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Image.network(
                      images[index],
                      fit: BoxFit.cover,
                      width: double.infinity,
                    );
                  },
                ),
                Positioned(
                  top: 35,
                  left: 10,
                  child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: CircleAvatar(
                      backgroundColor: secondaryColor,
                      radius: 15,
                      child: Icon(
                        Icons.chevron_left,
                        color: primaryColor,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  bottom: 10,
                  child: Material(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blueGrey[900],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      child: Text(
                        "${currentIndex + 1}/${images.length}",
                        style: TextStyle(color: secondaryColor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
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
                  Text(
                    'About',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Text(
                        'This is a long text that will take as much space as it needs. '
                        'It will expand to fill the available space in the container. '
                        'You can add as much text as you want here, and it will scroll '
                        'if the content exceeds the available space. '
                        'This approach does not require any external packages. '
                        'Flutter provides all the necessary widgets to achieve this. '
                        'You can also customize the text style, alignment, and other '
                        'properties as needed.',
                        style: TextStyle(fontSize: 14.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        decoration: BoxDecoration(
          color: Colors.grey[300],
        ),
        padding: EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$99.99',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
              ),
              child: Text('Buy Now'),
            ),
          ],
        ),
      ),
    );
  }
}
