import 'package:flutter/material.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/screens/add_weekly_menu_page.dart';
import 'package:foodryp/utils/contants.dart';
import 'package:foodryp/utils/responsive.dart';
import 'package:foodryp/utils/theme_provider.dart';
import 'package:foodryp/widgets/CustomWidgets/image_picker_preview_container.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

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
    double cardWidth = MediaQuery.of(context).size.width < 600
        ? MediaQuery.of(context).size.width
        : 300;
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Center(
      child: Card(
        surfaceTintColor: Colors.white,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        child: SizedBox(
          width: cardWidth,
          height: 300,
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.meal.dayOfWeek.length,
                  itemBuilder: (context, index) {
                    final imageUrl =
                        '${Constants.baseUrl}/${widget.meal.dayOfWeek[index].recipeImage}'
                            .replaceAll('\\', '/');
                    return Container(
                      width: cardWidth /
                          widget.meal.dayOfWeek
                              .length, // Dynamic width based on number of images
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(imageUrl),
                        ),
                        borderRadius: index == 0
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(0))
                            : index == widget.meal.dayOfWeek.length - 1
                                ? const BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(0))
                                : BorderRadius.zero,
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Constants.defaultPadding),
                child: Row(
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
                        color: themeProvider.currentTheme == ThemeType.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 5), // Adjust the spacing as needed
                    Text(
                      '•',
                      style: TextStyle(
                        fontSize: Responsive.isDesktop(context)
                            ? Constants.desktopFontSize
                            : Constants.mobileFontSize,
                        color: themeProvider.currentTheme == ThemeType.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    const SizedBox(width: 5),

                    Text(
                      DateFormat('dd MMM yyyy')
                          .format(widget.meal.dateCreated), // Format the date
                      style: TextStyle(
                        fontSize: Responsive.isDesktop(context)
                            ? Constants.desktopFontSize
                            : Constants.mobileFontSize,
                        color: themeProvider.currentTheme == ThemeType.dark
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    !widget.isForAll &&
                            widget.publicUserId == widget.currentUserId
                        ? IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddWeeklyMenuPage(
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(widget.meal.title,
                            style: Theme.of(context).textTheme.headline6),
                      ),
                    ],
                  ),
                ),
              ),
            ],
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
