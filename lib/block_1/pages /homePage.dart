import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mediora/Network/networkServices.dart';
import 'package:mediora/block_1/tools/advice_card.dart';
import 'package:mediora/block_1/tools/appointement_card.dart';
import 'package:mediora/block_2/pages/specialites_page.dart';
import 'package:mediora/block_3/pages/consult_page.dart';
import 'package:mediora/block_4/pages/posts_page.dart';
import 'package:mediora/block_5/pages/edit_profile_page.dart';
import 'package:mediora/block_5/pages/profile_page.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  String _userName = '...';
  String? _pictureUrl;

  final List<Widget> _pages = [
    const HomepageBody(),
    const AppointmentPage(),
    const ConsultPage(),
    const PostsPage(),
    const ProfilePage(),
  ];

  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _initUser();
  }


Future<void> _refreshUser() async {
  final data = await UserServices().getUser();
  if (data != null) {
    await _saveUser(data);
  }
  await _readUser();
}
  // Step 1: fetch from API, save to secure storage, then read and display
  Future<void> _initUser() async {
    final data = await UserServices().getUser();
    if (data != null) {
      await _saveUser(data);
    }
    await _readUser();
  }

  Future<void> _saveUser(Map<String, dynamic> data) async {
    await _secureStorage.write(
      key: 'first_name',
      value: data['first_name']?.toString() ?? '',
    );
    await _secureStorage.write(
      key: 'last_name',
      value: data['last_name']?.toString() ?? '',
    );
    await _secureStorage.write(
      key: 'picture',
      value: data['picture']?.toString() ?? '',
    );
    await _secureStorage.write(
      key: 'username',
      value: data['username']?.toString() ?? '',
    );
    await _secureStorage.write(
      key: 'email',
      value: data['email']?.toString() ?? '',
    );
    await _secureStorage.write(
      key: 'gender',
      value: data['gender']?.toString() ?? '',
    );
    await _secureStorage.write(
      key: 'phone_number',
      value: data['phone_number']?.toString() ?? '',
    );
  }

  Future<void> _readUser() async {
    final firstName = await _secureStorage.read(key: 'first_name') ?? '';
    final lastName = await _secureStorage.read(key: 'last_name') ?? '';
    final picture = await _secureStorage.read(key: 'picture');

    if (mounted) {
      setState(() {
        _userName = '$firstName $lastName'.trim();
        _pictureUrl =
            (picture != null &&
                picture.startsWith('http') &&
                picture != 'string')
            ? picture
            : null;
      });
    }
  }

  String getGreeting() {
    final hour = DateTime.now().hour;
    if (hour >= 5 && hour < 12) return 'Good Morning,';
    if (hour >= 12 && hour < 17) return 'Good Afternoon,';
    if (hour >= 17 && hour < 21) return 'Good Evening,';
    return 'Good Night,';
  }

  @override
  Widget build(BuildContext context) {
    final greeting = getGreeting();

    return PopScope(
      canPop: false,
      child: Scaffold(
        extendBody: true,
        appBar: _currentIndex == 0
            ? AppBar(
                toolbarHeight: 60.h,
                elevation: 0,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 36, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        greeting,
                        style: TextStyle(
                          color: const Color.fromARGB(255, 115, 111, 111),
                          fontSize: 15.sp,
                        ),
                      ),
                      Text(
                        _userName,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Padding(
                    padding: EdgeInsets.only(right: 16.w),
                    child: GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EditProfilePage()),
                      ),
                      child: CircleAvatar(
                        radius: 22.r,
                        backgroundImage: _pictureUrl != null
                            ? NetworkImage(_pictureUrl!) as ImageProvider
                            : const AssetImage('assets/default_avatar.png'),
                      ),
                    ),
                  ),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(1),
                  child: Container(color: Colors.grey[300], height: 1),
                ),
              )
            : null,
        body: _pages[_currentIndex],
        bottomNavigationBar: BottomNavigatorBarNewCustom(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
        ),
      ),
    );
  }
}

// ── HomepageBody ──────────────────────────────────────────────────────────────

class HomepageBody extends StatelessWidget {
  const HomepageBody({super.key});

  @override
  Widget build(BuildContext context) {
    return appointments.isEmpty
        ? const Center(child: Text("Nothing to show"))
        : Container();
  }
}

// ── BottomNavigationBar ───────────────────────────────────────────────────────

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
            color: isDark ? Colors.black45 : Colors.black26,
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: MediaQuery(
          data: MediaQuery.of(context).copyWith(padding: EdgeInsets.zero),
          child: SizedBox(
            height: 68,
            child: OverflowBox(
              maxHeight: 68,
              child: BottomNavigationBar(
                backgroundColor: isDark
                    ? const Color(0xFF1E1E1E)
                    : Colors.white,
                selectedFontSize: 10,
                unselectedFontSize: 10,
                currentIndex: widget.currentIndex,
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
