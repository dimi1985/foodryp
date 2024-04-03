import 'package:flutter/material.dart';
import 'package:foodryp/data/demo_data.dart';
import 'package:foodryp/screens/auth_screen/auth_screen.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';

class MenuWebItems extends StatefulWidget {
  const MenuWebItems({super.key});

  @override
  State<MenuWebItems> createState() => _MenuWebItemsState();
}

class _MenuWebItemsState extends State<MenuWebItems> {


  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      children: DemoData.menuItems
          .map(
            (item) => _buildMenuItem(item),
          )
          .toList(),
    );
  }

  Widget _buildMenuItem(String item) {
    return Padding(
      padding:  EdgeInsets.all(Responsive.isMobile(context) ? 0 : Constants.defaultPadding),
      child: TextButton(
        onPressed: () {
          // Handle menu item tap (e.g., navigate to a different screen)
        switch (item) {
            case 'Login/Register':
              // Navigate to Screen 1
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AuthScreen()),
              );
              break;
           
            // Add more cases for other menu items
            default:
              // Handle default case (optional)
              break;
          }
        },
        child: Text(
          item,
          style:  TextStyle(
            color:Responsive.isMobile(context) || Responsive.isTablet(context)? Colors.white :Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: Responsive.isMobile(context) ? Constants.mobileFontSize : Constants.desktopFontSize
          ),
        ),
      ),
    );
  }
}
