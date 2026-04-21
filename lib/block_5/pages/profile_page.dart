import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mediora/Network/networkServices.dart';
import 'package:mediora/block_0/pages/signin_with_hellopage/policies.dart';
import 'package:mediora/block_0/pages/signin_with_hellopage/sign_in.dart';
import 'package:mediora/block_5/pages/FAQ_page.dart';
import 'package:mediora/block_5/pages/change_password_page.dart';
import 'package:mediora/block_5/pages/delete_account_page.dart';
import 'package:mediora/block_5/pages/edit_profile_page.dart';
import 'package:mediora/block_5/pages/notification_modes_page.dart';
import 'package:mediora/block_5/tools/themeProvider.dart';
import 'package:provider/provider.dart';

//an example of user information


class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  String _firstName = '';
  String _lastName = '';
  String _email = '';


   @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    // Read each field individually from secure storage
    final firstName = await _secureStorage.read(key: 'first_name') ?? '';
    final lastName  = await _secureStorage.read(key: 'last_name')  ?? '';
    final email     = await _secureStorage.read(key: 'email')      ?? '';

    if (mounted) {
      setState(() {
        _firstName = firstName;
        _lastName = lastName;
        _email = email;
      });
    }
  }
  














@override
  Widget build(BuildContext context) {
    // at the top of build method
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Padding(
      padding: EdgeInsets.all(8.0.r),
      child: ListView(
        children: [
          30.verticalSpace,
          // a sizebox which contain picture,fullname,gmail and button to push to edit profile page
          SizedBox(
            height: 200.h,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ProfilePictureCustom(),
                10.verticalSpace,

                //User's fullname
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _firstName ,

                      //userInfo["first_name"],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                    5.horizontalSpace,
                    Text(
                      _lastName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15.sp,
                      ),
                    ),
                  ],
                ),

                //user's email
                Text(
                  _email,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12.sp,
                  ),
                ),
                5.verticalSpace,

                //edit profile button to push to edit profile page
              ],
            ),
          ),

          Divider(
            thickness: 1,
            color: Colors.grey.withOpacity(0.3),
            indent: 16.w,
            endIndent: 16.w,
          ),

          Padding(
            padding: EdgeInsets.all(8.0.r),
            child: Text(
              'PREFERENCES',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
          Column(
            children: [
              //Dark mode button
              Card(
                //color: Colors.white,
                shadowColor: const Color(0xFF2463EB),
                child: ListTile(
                  leading: Icon(
                    Icons.dark_mode,
                    color: const Color(0xFF2463EB),
                  ),
                  title: Text(
                    'Dark Mode',
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontFamily: 'LineSeedJP',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  trailing: Switch(
                    value: themeProvider
                        .isDark, // 👈 will be replaced with themeProvider later
                    onChanged: (_) => themeProvider.toggleTheme(),
                    activeColor: const Color(0xFF2463EB),

                    // 👈 will be replaced with themeProvider.toggleTheme() later
                  ),
                ),
              ),
              //list of preferences
              ...List.generate(
                preferencesActions.length,
                (index) => ActionsCardCustom(
                  title: preferencesActions[index]["title"],
                  icon: preferencesActions[index]["icon"],
                  function: () {
                    switch (index) {
                      case 0:
                        NavigateTo.pushTo(context, ChangePasswordPage());
                        break;
                      case 1:
                        NavigateTo.pushTo(context, NotificationModesPage());
                        break;
                      case 2:
                        NavigateTo.pushTo(context, FaqPage());
                        break;
                      case 3:
                        NavigateTo.pushTo(context, Policies());
                        break;
                    }
                    // handle each action
                  },
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.all(8.0.r),
            child: Text(
              'ACCOUNT ',
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 12.sp,
              ),
            ),
          ),
          Column(
            children: [
              ...List.generate(
                accountActions.length,
                (index) => ActionsCardForAccountCustom(
                  title: accountActions[index]["title"],
                  icon: accountActions[index]["icon"],
                  function: () {
                    switch (index) {
                      case 0:
                        ConfirmDialog.show(
                          context,
                          title: 'Are you sure to Log out?',
                          confirmText: 'Log Out',
                          onConfirm: () async {
                            final result = await AuthService().signOut();
                            if (result.success) {
                              print('Logged out');
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SignIn(),
                                ),
                                (route) => false,
                              );
                            }
                            if (!result.success) {
                              CustomSnackBarForSignIn.show(
                                context,
                                message: result.message,
                                icon: Icons.error,
                                backgroundColor: Colors.red,
                              );
                            }
                          },
                        );
                        break;
                      case 1:
                        NavigateTo.pushTo(context, DeleteAccountPage());
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ProfilePictureCustom extends StatelessWidget {
  const ProfilePictureCustom({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // profile picture
        CircleAvatar(
          radius: 45.r,
          backgroundImage: AssetImage('assets/default_avatar.png'),
        ),

        // pencil icon at bottom right
        Positioned(
          bottom: 0.h,
          right: 0.w,
          child: Container(
            width: 28.r,
            height: 28.r,
            decoration: BoxDecoration(
              color: Color(0xFF2463EB),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.w),
            ),
            child: GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EditProfilePage()),
              ),
              child: Icon(Icons.edit, color: Colors.white, size: 14.r),
            ),
          ),
        ),
      ],
    );
  }
}

// a custom class for the actions inside profile page
// it contains all from change password action to delete account action excepting to dark and light action
class ActionsCardCustom extends StatelessWidget {
  final Function function;
  final IconData icon;
  final String title;

  const ActionsCardCustom({
    super.key,
    required this.icon,
    required this.title,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => function(),
      child: Card(
        //color: Colors.white,
        shadowColor: const Color(0xFF2463EB),
        child: ListTile(
          leading: Icon(
            icon, // 👈 directly use icon
            color: const Color(0xFF2463EB),
          ),
          title: Text(
            title,
            style: TextStyle(fontSize: 13.sp),
          ), // 👈 directly use title
          trailing: Icon(Icons.chevron_right),
        ),
      ),
    );
  }
}

//list of actions (names and icons)
final List<Map<String, dynamic>> preferencesActions = [
  {"title": "Change Password", "icon": Icons.lock},
  {"title": "Notifications", "icon": Icons.notifications},
  {"title": "FAQ", "icon": Icons.help},
  {"title": "Privacy Policy", "icon": Icons.shield},
];

// log out and delete account actions
final List<Map<String, dynamic>> accountActions = [
  {"title": "Log Out", "icon": Icons.logout},
  {"title": "Delete Account", "icon": Icons.delete},
];

//button of account (log out and delete account)
class ActionsCardForAccountCustom extends StatelessWidget {
  final Function function;
  final IconData icon;
  final String title;

  const ActionsCardForAccountCustom({
    super.key,
    required this.icon,
    required this.title,
    required this.function,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => function(),
      child: SizedBox(
        height: 60.h,
        child: Card(
          //color: const Color(0xFFFFF0F0),
          shadowColor: Colors.red,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.red),
              5.horizontalSpace,
              Text(
                title,
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//a class to avoid repetetion at the switch
class NavigateTo {
  static void pushTo(BuildContext context, Widget destination) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => destination));
  }
}

class ConfirmDialog {
  static void show(
    BuildContext context, {
    required String title,
    required String confirmText,
    required Function() onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title, style: TextStyle(fontSize: 15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onConfirm(); // 👈 call the function
            },
            child: Text(confirmText, style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
