import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediora/block_1/pages%20/homePage.dart';
import 'package:mediora/block_2/tools/specialites.dart';
import 'package:mediora/block_2/tools/speciality_card.dart' hide specialties;
class AppointmentPage extends StatelessWidget {
  const AppointmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Homepage()),
              (route) => false,
            );
          },
          icon: Icon(Icons.arrow_back_ios, color: Color(0xFF2463EB)),
        ),
        title: Text(
          'Specialities',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SearchForDoctorField(),
          ),
          10.verticalSpace, 
          ...specialties.map((specialty) => SpecialityCard(specialities: specialty)),
        ],
      ),
    );
  }
}

class SearchForDoctorField extends StatelessWidget {
  const SearchForDoctorField({super.key});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      cursorColor: const Color(0xFF2463EB),
      decoration: InputDecoration(
        hintText: "Search for a doctor",
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),

        prefixIcon: const Icon(
          Icons.search,
          color: Color(0xFF2463EB),
        ),

        filled: true,
        fillColor: const Color.fromARGB(255, 243, 244, 246),

        contentPadding: const EdgeInsets.symmetric(
          vertical: 18,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: Color(0xFF2463EB),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}
