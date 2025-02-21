import 'package:dream_home_user/common_widgets.dart/custom_button.dart';
import 'package:dream_home_user/features/home_plan/homeplans.dart';
import 'package:flutter/material.dart';

import '../category/category_view_all_screen.dart';

class FilterScreen extends StatefulWidget {
  final List categories;
  const FilterScreen({super.key, required this.categories});

  @override
  State<FilterScreen> createState() => _FilterScreenState();
}

class _FilterScreenState extends State<FilterScreen> {
  final TextEditingController _bedroomController = TextEditingController();
  final TextEditingController _bathroomController = TextEditingController();

  List _categories = [];

  int? selectedIndex;

  void _applyFilters() {
    int? bedrooms = _bedroomController.text.isNotEmpty
        ? int.tryParse(_bedroomController.text)
        : null;
    int? bathrooms = _bathroomController.text.isNotEmpty
        ? int.tryParse(_bathroomController.text)
        : null;

    if (bedrooms == null && bathrooms == null && selectedIndex == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please select at least one filter")),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Homeplans(
          bedrooms: bedrooms,
          bathrooms: bathrooms,
          categoryId: _categories[selectedIndex!]['id'],
        ),
      ),
    );
  }

  @override
  void initState() {
    _categories = widget.categories;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Filter Properties")),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            "Bedroom",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 5),
          TextField(
            controller: _bedroomController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Bedroom Count"),
          ),
          SizedBox(height: 15),
          Text(
            "Bathroom",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 5),
          TextField(
            controller: _bathroomController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Bathroom Count"),
          ),
          SizedBox(height: 12),
          Text(
            "Select Category",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 5),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: _categories.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1.8,
            ),
            itemBuilder: (context, index) {
              return CategoryCard(
                isActive: selectedIndex == index,
                image: _categories[index]['image_url']!,
                title: _categories[index]['name']!,
                onTap: () {
                  setState(() {});
                  selectedIndex = index;
                },
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: CustomButton(
          inverse: true,
          onPressed: _applyFilters,
          label: "Apply Filters",
        ),
      ),
    );
  }
}
