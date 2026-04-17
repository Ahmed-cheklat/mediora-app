
import 'package:flutter/material.dart';

final List<Map<String, dynamic>> appointments = [
  {
    "doctor_name": "Dr. Emily Carter",
    "doctor_image": Icons.person,
    "speciality": "Cardiology",
    "day_name": "Mon",
    "day_number": "24",
    "time": "10:30 AM",
  },
  {
    "doctor_name": "Dr. Michael Brown",
    "doctor_image": Icons.person,
    "speciality": "Neurology",
    "day_name": "Thu",
    "day_number": "27",
    "time": "02:00 PM",
  },
];

class AppointementCard extends StatelessWidget {
  final Map<String, dynamic> appointment;

  const AppointementCard({super.key, required this.appointment});

  @override
  Widget build(BuildContext context) {
          return SizedBox(
            
          );
        }
  
}











































  // Container(
  //                   height: 5,
  //                   child: Padding(
  //                   padding: const EdgeInsets.only(left: 8.0),
  //                   child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.start,
  //                       children: [
  //                         SizedBox(
                            
  //                           width: 160,
  //                           height: 50,
  //                           child: Card(
  //                             color: Colors.blue,
  //                             child: Center(child: Text('Date')),)),
  //                         SizedBox(
  //                           width: 160,
  //                           height: 50,
  //                           child: Card(
  //                             color: Colors.blue,
  //                             child: Center(child: Text('View')),)),
  //                       ],
  //                   ),
  //                 )),
  //                 Container(
  //                   height: 60,
  //                   child: Padding(
  //                   padding: const EdgeInsets.all(8.0),
  //                   child: Card(
  //                     color: Colors.blue,
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.center,
  //                       children: [
  //                         Icon(Icons.message,color: Colors.white,),
  //                         SizedBox(width: 10,),
  //                         Text('Chat with Doctor'),
  //                       ],
  //                     ),
  //                   ),
  //                 ))