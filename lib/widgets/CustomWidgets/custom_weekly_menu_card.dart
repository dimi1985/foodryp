import 'package:flutter/material.dart';
import 'package:foodryp/models/weeklyMenu.dart';
import 'package:foodryp/screens/add_weekly_menu_page.dart';
import 'package:foodryp/screens/weekly_menu_deletion_confirmation_screen.dart';
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
  final bool isForDiet;

  const CustomWeeklyMenuCard({
    super.key,
    required this.meal,
    required this.currentPage,
    required this.isForAll,
    required this.publicUserId,
    required this.currentUserId,
    required this.isForDiet,
  });

  @override
  State<CustomWeeklyMenuCard> createState() => _CustomWeeklyMenuCardState();
}

class _CustomWeeklyMenuCardState extends State<CustomWeeklyMenuCard> {
  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double cardWidth = screenSize.width < 600 ? screenSize.width : 300;
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
                    return Container(
                      width: cardWidth / widget.meal.dayOfWeek.length,
                      margin: const EdgeInsets.symmetric(horizontal: 1),
                      decoration: BoxDecoration(
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
                      child: ClipRRect(
                        borderRadius: index == 0
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(15),
                                bottomLeft: Radius.circular(0))
                            : index == widget.meal.dayOfWeek.length - 1
                                ? const BorderRadius.only(
                                    topRight: Radius.circular(15),
                                    bottomRight: Radius.circular(0))
                                : BorderRadius.zero,
                        child: Image.network(
                          widget.meal.dayOfWeek[index].recipeImage ??
                              Constants.emptyField,
                               loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child; // image fully loaded, return the image widget
                      } else {
                        return Center(
                          child: CircularProgressIndicator(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null, // This will show a determinate progress indicator if size is known, otherwise indeterminate
                          ),
                        );
                      }},
                          fit: BoxFit.cover,
                          filterQuality: FilterQuality.none,
                        ),
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
                    const SizedBox(width: 5),
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
                      DateFormat('dd MMM yyyy').format(widget.meal.dateCreated),
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
                                          isForDiet: widget.isForDiet,
                                        )),
                              );
                            },
                            icon: const Icon(Icons.edit))
                        : Container(),
                   !widget.isForAll &&
                            widget.publicUserId == widget.currentUserId
                        ? IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              WeeklyMenuDeletionConfirmationScreen(
                            weeklyMenu: widget.meal,
                          ),
                        ));
                      },
                      icon: const Icon(Icons.delete),
                    ):Container(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Align(
                  alignment: Alignment.topLeft, // Align to the start (top-left)
                  child: Text(
                    widget.meal.title,
                    style: Theme.of(context).textTheme.titleLarge,
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
