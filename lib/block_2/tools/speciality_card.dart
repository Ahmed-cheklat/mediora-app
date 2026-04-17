import 'package:flutter/material.dart';


final List<Map<String, dynamic>> specialties = [
  {"specialty": "Cardiology", "icon": Icons.favorite},
  {"specialty": "Neurology", "icon": Icons.psychology},
  {"specialty": "Dermatology", "icon": Icons.spa},
  {"specialty": "Pediatrics", "icon": Icons.child_care},
  {"specialty": "Orthopedics", "icon": Icons.accessibility_new},
  {"specialty": "Ophthalmology", "icon": Icons.remove_red_eye},
  {"specialty": "Gynecology", "icon": Icons.pregnant_woman},
  {"specialty": "Urology", "icon": Icons.water_drop},
  {"specialty": "Psychiatry", "icon": Icons.self_improvement},
  {"specialty": "Oncology", "icon": Icons.healing},
  {"specialty": "Radiology", "icon": Icons.medical_services},
  {"specialty": "General Surgery", "icon": Icons.local_hospital},
  {"specialty": "Endocrinology", "icon": Icons.biotech},
  {"specialty": "Gastroenterology", "icon": Icons.lunch_dining},
  {"specialty": "Pulmonology", "icon": Icons.air},
];



class SpecialityCard extends StatelessWidget {
  final Map<String, dynamic> specialities; 


  const SpecialityCard({super.key, required this.specialities});

  @override
  Widget build(BuildContext context) {
    return Card(
      
      child: ListTile(
        leading: Icon(specialities["icon"],color: specialities["color"],),
        title: Text(specialities['specialty'],style: TextStyle(
          fontSize: 18,
        ),) ,
        trailing: Icon(Icons.arrow_forward_ios,color: Color(0xFF2463EB),),
      ),
    );
  }
}
