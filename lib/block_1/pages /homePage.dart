import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mediora/block_1/tools/advice_card.dart';
import 'package:mediora/block_1/tools/appointement_card.dart';
import 'package:mediora/block_2/pages/appointment_page.dart';
import 'package:mediora/block_3/pages/consult_page.dart';
import 'package:mediora/block_4/pages/posts_page.dart';
import 'package:mediora/block_5/pages/edit_profile_page.dart';
import 'package:mediora/block_5/pages/profile_page.dart';

final List<Map<String, dynamic>> users = [
  {"name": "John Smith"},
];

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final List<Widget> _pages = [
    HomepageBody(),
    AppointmentPage(),
    ConsultPage(),
    PostsPage(),
    ProfilePage(),
  ];
  // ignore: non_constant_identifier_names
  int _current_index = 0;
  //function of greeting using time
  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) {
      return 'Good Morning,';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon,';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening,';
    } else {
      return 'Good Night,';
    }
  }

  @override
  Widget build(BuildContext context) {
    final greeting = getGreeting();
    final userName = users[0]["name"];

    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBody: true,
        //Greeting with the name of the user
        appBar: _current_index == 0
            ? AppBar(
                toolbarHeight: 60.h,
                elevation: 0, // remove default shadow
                flexibleSpace: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 36, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        greeting,
                        style: TextStyle(
                          color: Color.fromARGB(255, 115, 111, 111),
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  // the icon which can move user to the edit profile page
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: GestureDetector(
                      onTap: () => Navigator.push(context, 
                      MaterialPageRoute(builder: (context) => EditProfilePage())),
                      child: CircleAvatar(
                        radius: 22.r,
                        // ignore: deprecated_member_use
                        //backgroundColor: Color(0xFF2463EB).withOpacity(0.2),
                        backgroundImage: AssetImage('assets/default_avatar.png'),
                      ),
                    ),
                  ),
                ],

                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(
                    color: Colors.grey[300], // color of the dividing line
                    height: 1,
                  ),
                ),
              )
            : null,

        body: _pages[_current_index],

        bottomNavigationBar: BottomNavigatorBarNewCustom(
          currentIndex: _current_index,
          onTap: (index) {
            setState(() {
              _current_index = index;
            });
          },
        ),
      ),
    );
  }
}

//bottom navigator bar edetting
class HomepageBody extends StatelessWidget {
  const HomepageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return appointments.isEmpty
        ? const Center(child: Text("Nothing to show"))
        : ListView(
            padding: EdgeInsets.only(top: 8.h),
            children: [
              // Title of booked appointments
              Padding(
                padding: EdgeInsets.only(left: 12.0.w, bottom: 8.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.calendar_month_rounded,
                      color: Color(0xFF2463EB),
                    ),
                    5.horizontalSpace,
                    Text(
                      'Your Booked Appointments',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17.sp,
                      ),
                    ),
                  ],
                ),
              ),

              // All appointment cards
              ...appointments.map(
                (appointment) => AppointementCard(appointment: appointment),
              ),

              // Extra card under appointments
              Padding(
                padding: EdgeInsets.only(left: 20.0.w, top: 12.h),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Health Tips for Today",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 17.sp,
                    ),
                  ),
                ),
              ),

              // Card of health tips advice
              const HealthTips(),
            ],
          );
  }
}

class BottomNavigatorBarNewCustom extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavigatorBarNewCustom({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<BottomNavigatorBarNewCustom> createState() =>
      _BottomNavigatorBarNewCustomState();
}

class _BottomNavigatorBarNewCustomState
    extends State<BottomNavigatorBarNewCustom> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 68,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black45
                : Colors.black26, // 👈 shadow adapts to theme
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(
            padding: EdgeInsets.zero, // 👈 removes internal padding
          ),
          child: SizedBox(
            height: 68,
            child: OverflowBox(
              maxHeight: 68, // 👈 prevents overflow
              child: BottomNavigationBar(
                backgroundColor: isDark
                    ? const Color(0xFF1E1E1E) // 👈 your dark color
                    : Colors.white, // 👈 your light color
                selectedFontSize: 10,
                unselectedFontSize: 10,
                currentIndex: widget.currentIndex,
                //type: BottomNavigationBarType.fixed,
                selectedItemColor: const Color(0xFF2463EB),
                unselectedItemColor: Colors.grey,
                enableFeedback: false,
                onTap: widget.onTap,
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home_rounded, size: 20),
                    label: "Home",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.calendar_month, size: 20),
                    label: "Appointment",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.medical_services, size: 20),
                    label: "Consult",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.post_add, size: 20),
                    label: "Post",
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person, size: 20),
                    label: "Profile",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
