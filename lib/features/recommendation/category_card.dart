import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: 120,
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Shadow color
                  blurRadius: 8, // Softness of the shadow
                  spreadRadius: 2, // Extent of the shadow
                  offset: Offset(2, 4), // Position of the shadow
                ),
              ],
              image: const DecorationImage(
                image: NetworkImage(
                  'https://1.bp.blogspot.com/-La0cpfzCplQ/Xvb2LbCaRpI/AAAAAAABXWk/YshtXUjdCqwcFAfY8J-3iB0P7ru6G8TiQCNcBGAsYHQ/s1920/kerala-traditional-finished-house.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Traditional',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
