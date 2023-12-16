import 'package:alumni_connect/api/apis.dart';
import 'package:alumni_connect/constant/gloabalvariable.dart';
import 'package:alumni_connect/models/chat_user.dart';
import 'package:alumni_connect/screens/friends.dart';
import 'package:alumni_connect/screens/home_page.dart';
import 'package:alumni_connect/screens/message_screen.dart';
import 'package:alumni_connect/screens/profile_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.w600);
  static final List<Widget> _widgetOptions = <Widget>[
    const HomePageScreen(),
    const MessageScreen(),
    const FriendsScreen(),
    const ProfileScreen(), // Replace 'User()' with your actual user object
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.secondaryColor,
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: GlobalVariables.secondaryColor,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              rippleColor: Colors.grey[300]!,
              hoverColor: Colors.grey[100]!,
              gap: 8,

              activeColor: GlobalVariables.mainColor,
              tabBorderRadius: 22,
              tabActiveBorder: Border.all(
                  color: GlobalVariables.mainColor,
                  width: 1), // tab button border

              curve: Curves.easeOutExpo, // tab animation curves
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: Colors.grey[100]!,
              color: GlobalVariables.mainColor,
              tabs: const [
                GButton(
                  icon: CupertinoIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: CupertinoIcons.chat_bubble_2,
                  text: 'Message',
                ),
                GButton(
                  icon: Icons.chat,
                  text: 'Chat',
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                ),
              ],
              selectedIndex: _selectedIndex,
              onTabChange: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
          ),
        ),
      ),
    );
  }
}
