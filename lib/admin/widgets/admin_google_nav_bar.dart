import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class AdminGoogleNavBar extends StatefulWidget {
  final Function(int)? onTabChange;
  final int selectedIndex;

  AdminGoogleNavBar({
    super.key,
    required this.onTabChange,
    required this.selectedIndex
  });

  @override
  State<AdminGoogleNavBar> createState() => _AdminGoogleNavBarState();
}

class _AdminGoogleNavBarState extends State<AdminGoogleNavBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GNav(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //rippleColor: Colors.grey.shade800, // tab button ripple color when pressed
          //hoverColor: Colors.grey.shade700, // tab button hover color
          haptic: true, // haptic feedback
          tabBorderRadius: 15,
          tabActiveBorder: Border.all(color: Colors.white, width: 1), // tab button border
          tabBorder: Border.all(color: Colors.grey, width: 1), // tab button border
          tabShadow: [BoxShadow(color: Colors.grey.withOpacity(0.5), blurRadius: 8)], // tab button shadow
          curve: Curves.easeOutExpo, // tab animation curves
          duration: Duration(milliseconds: 900), // tab animation duration
          gap: 8, // the tab button gap between icon and text
          color: Colors.grey[800], // unselected icon color
          activeColor: Colors.deepPurpleAccent, // selected icon and text color
          iconSize: 24, // tab button icon size
          tabBackgroundColor: Colors.white, // selected tab background color
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5), // navigation bar padding
          onTabChange: widget.onTabChange,
          selectedIndex: widget.selectedIndex,
          tabs: [
            GButton(
              icon: Icons.home,
              text: 'Acceuil',
            ),
            GButton(
              icon: Icons.category_sharp,
              text: 'Catégories',
            ),
            GButton(
              icon: Icons.paste_rounded,
              text: 'Produits',
            ),
            GButton(
              icon: Icons.keyboard_command_key_sharp,
              text: 'Bilan',
            ),
          ]
      ),
    );
  }
}
