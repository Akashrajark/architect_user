import 'package:dream_home_user/util/format_function.dart';
import 'package:flutter/material.dart';

class ArchitectViewCard extends StatelessWidget {
  final Function() ontap;
  final Map architectDetails;
  const ArchitectViewCard({
    super.key,
    required this.ontap,
    required this.architectDetails,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(64),
      child: InkWell(
        onTap: ontap,
        borderRadius: BorderRadius.circular(64),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: Colors.green,
                backgroundImage: architectDetails['photo'] != null
                    ? NetworkImage(architectDetails['photo'])
                    : null,
                child: architectDetails['photo'] == null
                    ? Icon(Icons.person)
                    : null,
              ),
              SizedBox(
                width: 15,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(formatValue(architectDetails['name']),
                        style: Theme.of(context).textTheme.titleLarge),
                    Text(formatValue(architectDetails['email']),
                        style: Theme.of(context).textTheme.bodyLarge),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios)
            ],
          ),
        ),
      ),
    );
  }
}
