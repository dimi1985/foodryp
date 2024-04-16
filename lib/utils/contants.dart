import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Constants {


static const primaryColor = Color.fromARGB(255, 0, 0, 0);
static const secondaryColor = Color(0xFFFFFFFF);
static const backgroundColor = Color(0xFFF2F5FD);
static const headerColor = Color.fromARGB(255, 18, 45, 119);
static const leftSideColor = Color.fromARGB(255, 5, 214, 68);
static const middleSideColor = Color.fromARGB(255, 201, 10, 191);
static const rightSideColor = Color.fromARGB(255, 218, 10, 107);
static const defaultPadding = 16.0;
static const mobileFontSize = 12.0;
static const tabletFontSize = 14.0;
static const desktopFontSize = 15.0;
static const mobileHeadingTitleSize = 18.0;
static const tabletHeadingTitleSize = 22.0;
static const desktopHeadingTitleSize = 24.0;
static const topThreeTitleSize = 30.0;

static const imageURL = kIsWeb ? 'http://localhost:3000' : 'http://192.168.12.229:3000';

static const baseUrl =
      kIsWeb ? 'http://localhost:3000' : 'http://192.168.12.229:3000';

}
