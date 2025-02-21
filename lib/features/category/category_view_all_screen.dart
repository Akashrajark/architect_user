import 'package:dream_home_user/theme/app_theme.dart';
import 'package:flutter/material.dart';

import '../home_plan/homeplans.dart';

class CategoryViewAllScreen extends StatelessWidget {
  final List<Map<String, dynamic>> categories;
  const CategoryViewAllScreen({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Categories"),
        centerTitle: true,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        itemCount: categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 1.8,
        ),
        itemBuilder: (context, index) {
          return CategoryCard(
            image: categories[index]['image_url']!,
            title: categories[index]['name']!,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Homeplans(
                    categoryId: categories[index]['id'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String image, title;
  final Function() onTap;
  final bool isActive;

  const CategoryCard({
    super.key,
    required this.image,
    required this.title,
    required this.onTap,
    this.isActive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: isActive
            ? BorderSide(width: 2, color: Colors.white)
            : BorderSide.none,
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 200,
          width: 200,
          child: Stack(
            alignment: AlignmentDirectional.bottomStart,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  image,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      color: onprimaryColor, fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
