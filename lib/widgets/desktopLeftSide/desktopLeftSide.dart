import 'package:flutter/material.dart';
import 'package:foodryp/data/demo_data.dart';
import 'package:foodryp/utils/responsive.dart';

import '../../utils/contants.dart';

class DesktopLeftSide extends StatelessWidget {
  const DesktopLeftSide({super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            // Friend List Title
            Container(
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                'Team List',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ),
            // ListView for Friends
            Expanded(
              child: ListView.separated(
                itemCount: DemoData.creatorTeams.length,
                itemBuilder: (context, index) {
                  final creatorTeam = DemoData.creatorTeams[index];
                  return InkWell(
                    onTap: () {},
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                              screenSize.width <=1300 ? Container():  Expanded(
                                  flex: 1,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                        Constants.defaultPadding),
                                    child: Image.network(
                                      creatorTeam['image'],
                                     
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    children: [
                                      Text(
                                        creatorTeam['name'],
                                        style: TextStyle(
                                            fontSize:
                                               screenSize.width <=1500 ? 12 : Constants.desktopFontSize,
                                            fontWeight: FontWeight.bold),
                                      ),
        
                                      Text(
                              'Owned By : ${creatorTeam['owner']}',
                              style: TextStyle(
                                fontSize: screenSize.width <=1500 ? 12 : Constants.desktopFontSize,
                              ),
                            ),
                            Text(
                              'Status: ${creatorTeam['status']}',
                              style: TextStyle(
                                fontSize: screenSize.width <=1500 ? 12 : Constants.desktopFontSize,
                              ),
                            ),
                            Text(
                              'Total Recipes : ${creatorTeam['totalRecipes']}',
                              style: TextStyle(
                                fontSize: screenSize.width <=1500 ? 12 : Constants.desktopFontSize,
                              ),
                            ),
        
                            Text(
                              'Specialized in : ${creatorTeam['specializedIn']}',
                              style: TextStyle(
                                fontSize:screenSize.width <=1500 ? 12 : Constants.desktopFontSize,
                              ),
                            ),
                                    ],
                                  ),
                                ),
                              ],
                            )
                            // Add more widgets for actions, details, etc.
                          ],
                        ),
                      ),
                    ),
                  );
                }, separatorBuilder: (BuildContext context, int index) { 
                  return const SizedBox(height: 15,);
                 },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
