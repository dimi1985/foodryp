import 'package:flutter/material.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/screens/add_weekly_menu_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';

class CustomWeeklyMenuCard extends StatefulWidget {
  final WeeklyMenu meal;
  final String currentPage;
  final bool isForAll;
  final String publicUserId;
  final String currentUserId;
  const CustomWeeklyMenuCard(
      {super.key,
      required this.meal,
      required this.currentPage,
      required this.isForAll,
      required this.publicUserId,
      required this.currentUserId});

  @override
  State<CustomWeeklyMenuCard> createState() => _CustomWeeklyMenuCardState();
}

class _CustomWeeklyMenuCardState extends State<CustomWeeklyMenuCard> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(Constants.defaultPadding),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: SizedBox(
          width: 300,
          height: 300,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(Constants.defaultPadding),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top section: Image and recipe details
                Expanded(
                  child: ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: widget.meal.dayOfWeek.length,
                    itemBuilder: (context, index) {
                      final dayOfWeek = widget.meal.dayOfWeek[index];
                      final recipeImage =
                          ('${Constants.baseUrl}/${dayOfWeek.recipeImage}')
                              .replaceAll('\\', '/');
                      return SizedBox(
                        width: widget.currentPage == 'WeeklyMenuPage' ? 75 : 43,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(2),
                          child: Image.network(
                            recipeImage,
                            fit: BoxFit.cover,
                            filterQuality: FilterQuality.none,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(Constants.defaultPadding),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(Constants.defaultPadding),
                        bottomRight: Radius.circular(Constants.defaultPadding),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            ImagePickerPreviewContainer(
                              containerSize: 10,
                              onImageSelected: (file, list) {},
                              gender: '',
                              isFor: '',
                              initialImagePath: widget.meal.userProfileImage,
                              isForEdit: false,
                              allowSelection: false,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              widget.meal.username,
                              style: TextStyle(
                                fontSize: Responsive.isDesktop(context)
                                    ? Constants.desktopFontSize
                                    : Constants.mobileFontSize,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(
                                width: 5), // Adjust the spacing as needed
                            Text(
                              '•',
                              style: TextStyle(
                                fontSize: Responsive.isDesktop(context)
                                    ? Constants.desktopFontSize
                                    : Constants.mobileFontSize,
                                color: Colors.black,
                              ),
                            ),
                            const SizedBox(width: 5),

                            // Text(
                            //   DateFormat('dd MMM yyyy')
                            //       .format(recipe.date), // Format the date
                            //   style: TextStyle(
                            //     fontSize: Responsive.isDesktop(context)
                            //         ? Constants.desktopFontSize
                            //         : Constants.mobileFontSize,
                            //     color: Colors.black,
                            //   ),
                            // ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        Expanded(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: Text(
                                  widget.meal.title.toUpperCase(),
                                ),
                              ),
                              const Spacer(),
                              !widget.isForAll &&
                                      widget.publicUserId ==
                                          widget.currentUserId
                                  ? IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  AddWeeklyMenuPage(
                                                    meal: widget.meal,
                                                    isForEdit: true,
                                                  )),
                                        );
                                      },
                                      icon: const Icon(Icons.edit))
                                  : Container()
                            ],
                          ),
                        ),
                        // You can add more widgets here if needed
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getWeekdayName(int index) {
    switch (index) {
      case 0:
        return const Text('Monday');
      case 1:
        return const Text('Tuesday');
      case 2:
        return const Text('Wednesday');
      case 3:
        return const Text('Thursday');
      case 4:
        return const Text('Friday');
      case 5:
        return const Text('Saturday');
      case 6:
        return const Text('Sunday');
      default:
        return Container();
    }
  }
}
