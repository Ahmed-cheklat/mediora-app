import 'package:flutter/material.dart';
import 'package:health_icons/health_icons.dart';

final List<Map<String, dynamic>> specialties = [
  {"specialty": "general practice", "icon": HealthIcons.stethoscopeFilled},
  {"specialty": "family medicine", "icon": HealthIcons.peopleFilled},
  {"specialty": "internal medicine", "icon": HealthIcons.stomachFilled},
  {"specialty": "pediatrics", "icon": HealthIcons.childCareFilled},
  {"specialty": "emergency medicine", "icon": HealthIcons.ambulanceFilled},
  {"specialty": "cardiology", "icon": HealthIcons.heartCardiogramFilled},
  {"specialty": "dermatology", "icon": HealthIcons.allergiesFilled},
  {"specialty": "neurology", "icon": HealthIcons.neurologyFilled},
  {"specialty": "psychiatry", "icon": HealthIcons.psychologyFilled},
  {"specialty": "general surgery", "icon": HealthIcons.generalSurgeryFilled},
  {"specialty": "orthopedic surgery", "icon": HealthIcons.orthopaedicsFilled},
  {"specialty": "obstetrics and gynecology", "icon": HealthIcons.pregnantFilled},
  {"specialty": "ophthalmology", "icon": HealthIcons.eyeFilled},
  {"specialty": "otolaryngology (ent)", "icon": HealthIcons.earFilled},
  {"specialty": "radiology", "icon": HealthIcons.radiologyFilled},
];

class SpecialityCard extends StatelessWidget {
  final Map<String, dynamic> specialities;
  final VoidCallback function; 

  const SpecialityCard({super.key, required this.specialities,required this.function});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Card(
        child: ListTile(
          leading: Icon(specialities["icon"], color: Color(0xFF2463EB)),
          title: Text(
            specialities['specialty'],
            style: TextStyle(fontSize: 18),
          ),
          trailing: Icon(Icons.arrow_forward_ios, color: Color(0xFF2463EB)),
        ),
      ),
    );
  }
}
