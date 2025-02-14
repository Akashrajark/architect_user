import 'package:flutter/material.dart';

class ArchitectViewCard extends StatelessWidget {
  final Function() ontap;
  const ArchitectViewCard({
    super.key,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Row(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundColor: Colors.green,
          ),
          SizedBox(
            width: 15,
          ),
          Text(
            'ajf ac',
            style: TextStyle(
              fontSize: 18,
            ),
          ),
          Spacer(),
          Icon(Icons.chevron_right)
        ],
      ),
    );
  }
}
