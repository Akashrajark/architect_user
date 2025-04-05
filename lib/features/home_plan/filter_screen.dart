import 'package:dream_home_user/common_widgets.dart/custom_button.dart';
import 'package:dream_home_user/features/home_plan/homeplans.dart';
import 'package:flutter/material.dart';

import '../../common_widgets.dart/custom_dropdownmenu.dart';
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
  final TextEditingController _plotLengthController = TextEditingController();
  final TextEditingController _plotWidthController = TextEditingController();
  final TextEditingController _plotAreaController = TextEditingController();

  List _categories = [];
  String? _selectedRoadFacing;
  final List roadFacingOptions = [
    {'name': 'North'},
    {'name': 'South'},
    {'name': 'East'},
    {'name': 'West'},
    {'name': 'Northeast'},
    {'name': 'Northwest'},
    {'name': 'Southeast'},
    {'name': 'Southwest'},
  ];

  int? selectedIndex;

  void _applyFilters() {
    int? bedrooms = _bedroomController.text.isNotEmpty
        ? int.tryParse(_bedroomController.text)
        : null;
    int? bathrooms = _bathroomController.text.isNotEmpty
        ? int.tryParse(_bathroomController.text)
        : null;
    int? plotLength = _plotLengthController.text.isNotEmpty
        ? int.tryParse(_plotLengthController.text)
        : null;
    int? plotWidth = _plotWidthController.text.isNotEmpty
        ? int.tryParse(_plotWidthController.text)
        : null;
    int? plotArea = _plotAreaController.text.isNotEmpty
        ? int.tryParse(_plotAreaController.text)
        : null;

    if (bedrooms == null &&
        bathrooms == null &&
        selectedIndex == null &&
        plotLength == null &&
        plotWidth == null &&
        plotArea == null &&
        _selectedRoadFacing == null) {
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
          categoryId:
              selectedIndex != null ? _categories[selectedIndex!]['id'] : null,
          plotLength: plotLength,
          plotWidth: plotWidth,
          plotArea: plotArea,
          roadFacing: _selectedRoadFacing,
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
          SizedBox(height: 15),
          Text(
            "Ploat Length",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 5),
          TextField(
            controller: _plotLengthController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Ploat Length"),
          ),
          SizedBox(height: 15),
          Text(
            "Ploat Width",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 5),
          TextField(
            controller: _plotWidthController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Ploat Width"),
          ),
          SizedBox(height: 15),
          Text(
            "Ploat Area",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          SizedBox(height: 5),
          TextField(
            controller: _plotAreaController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Ploat Area"),
          ),
          SizedBox(height: 15),
          CustomDropDownMenu(
            iconData: Icons.explore,
            isExpanded: true,
            isRequired: true,
            selectedValue: _selectedRoadFacing,
            title: 'Road Facing',
            hintText: "Select Road Facing",
            onSelected: (selected) {
              _selectedRoadFacing = selected;
            },
            dropdownMenuItems: List.generate(
              roadFacingOptions.length,
              (index) => DropdownMenuItem(
                value: roadFacingOptions[index]['name'],
                child: Text(roadFacingOptions[index]['name']),
              ),
            ),
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
