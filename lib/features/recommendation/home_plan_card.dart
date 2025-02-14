import 'package:dream_home_user/features/recommendation/feature_card.dart';
import 'package:flutter/material.dart';

class HomePlanCard extends StatelessWidget {
  final Function() ontap;
  final bool showListTile;

  const HomePlanCard({
    super.key,
    required this.ontap,
    this.showListTile = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        margin: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                'https://img.freepik.com/free-photo/3d-electric-car-building_23-2148972401.jpg?t=st=1739425386~exp=1739428986~hmac=24232826ac755ed6be79eaf7a2029586a265a5f0c2451bbe97a18830ec3f867c&w=1060',
                fit: BoxFit.cover,
                height: 180,
                width: double.infinity,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "HomePlan Name",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "description",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    showListTile == true ? '\$647 - Paid' : '\$647',
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                ],
              ),
            ),
            if (showListTile)
              ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/men/1.jpg'),
                ),
                title: Text("Architect Name"),
                subtitle: Text("Professional Architect"),
              ),
          ],
        ),
      ),
    );
  }
}
