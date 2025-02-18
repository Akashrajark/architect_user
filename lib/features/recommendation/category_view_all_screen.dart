import 'package:flutter/material.dart';

class CategoryViewAllScreen extends StatelessWidget {
  final List<Map<String, String>> properties = [
    {"title": "Premium House", "image": "assets/images/home1.jpg"},
    {"title": "House Description", "image": "assets/images/home3.jpg"},
    {"title": "Ijen Sakamto Villa", "image": "assets/images/home2.jpg"},
    {"title": "Park Residence Villa", "image": "assets/images/home4.jpg"},
  ];
  CategoryViewAllScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          itemCount: properties.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.8,
          ),
          itemBuilder: (context, index) {
            return PropertyCard(property: properties[index]);
          },
        ),
      ),
    );
  }
}

class PropertyCard extends StatelessWidget {
  final Map<String, String> property;

  PropertyCard({required this.property});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.asset(
              property["image"]!,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  property["title"]!,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
