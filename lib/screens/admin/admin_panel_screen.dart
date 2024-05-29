import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/screens/admin/components/admin_category_page.dart';
import 'package:foodryp/screens/admin/components/admin_food_wiki_page.dart';
import 'package:foodryp/screens/admin/components/admin_recipe_page.dart';
import 'package:foodryp/screens/admin/components/admin_running_event_Page.dart';
import 'package:foodryp/screens/admin/components/admin_teams_page.dart';
import 'package:foodryp/screens/admin/components/admin_user_page.dart';
import 'package:foodryp/utils/app_localizations.dart';
import 'package:foodryp/utils/responsive.dart';

import 'components/widgets/custom_admin_card.dart';

class AdminPanelScreen extends StatelessWidget {
  final User user;
  const AdminPanelScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('Admin Panel')),
      ),
      body: GridView.count(
        crossAxisCount:
            isDesktop ? 5 : 2, // Adjust the number of columns as needed
        padding: const EdgeInsets.all(16.0),
        crossAxisSpacing: 16.0,
        mainAxisSpacing: 16.0,
        children: [
          CustomAdminCard(
            title: AppLocalizations.of(context).translate('Users'),
            icon: Icons.person,
            onTap: () {
              // Navigate to Users screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminUserPage(userRole: user.role)),
              );
            },
          ),
          CustomAdminCard(
            title: AppLocalizations.of(context).translate('Recipes'),
            icon: Icons.restaurant_menu,
            onTap: () {
              // Navigate to Recipes screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminRecipePage(
                          user: user,
                        )),
              );
            },
          ),
          CustomAdminCard(
            title: AppLocalizations.of(context).translate('Categories'),
            icon: Icons.category,
            onTap: () {
              // Navigate to Categories screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminCategoryPage(user: user)),
              );
            },
          ),
          CustomAdminCard(
            title: AppLocalizations.of(context).translate('Teams'),
            icon: Icons.multiline_chart_sharp,
            onTap: () {
              // Navigate to Teams screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => AdminTeamsPage(userRole: user.role)),
              );
            },
          ),

          CustomAdminCard(
            title: AppLocalizations.of(context).translate('Running Events'),
            icon: Icons.restaurant_menu,
            onTap: () {
              // Navigate to Running Events screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AdminRunningEventPage(userRole: user.role)),
              );
            },
          ),
          CustomAdminCard(
            title: AppLocalizations.of(context).translate('Food Wiki'),
            icon: Icons.person,
            onTap: () {
              // Navigate to Users screen
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        AdminFoodWikiPage(userRole: user.role)),
              );
            },
          ),
          // Add more CategoryCard widgets for other categories
        ],
      ),
    );
  }
}
