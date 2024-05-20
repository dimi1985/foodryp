import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:foodryp/models/celebration_day.dart';
import 'package:foodryp/models/user.dart';
import 'package:foodryp/models/wikifood.dart';
import 'package:foodryp/utils/app_localizations.dart';

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

  static User defaultUser = User(
    id: '',
    username: '',
    email: '',
    profileImage: '',
    memberSince: DateTime.now(),
    role: '',
    recipes: [],
    likedRecipes: [],
    followers: [],
    following: [],
    followRequestsSent: [],
    followRequestsReceived: [],
    followRequestsCanceled: [], 
    commentId: [],
  );


  static Wikifood defaultWikifood = Wikifood(id: '', title: '', text: '', source: ''
   
  );
  static String emptyField = '';
  static bool defaultBoolValue = false;
  static List<User> defaultEmptyList = [];
  static List<CelebrationDay> defaultCelebEmptyList = [];
   static TextStyle globalTextStyle = const TextStyle(color: Colors.black);
  static const imageURL =
      kIsWeb ? 'http://localhost:3000' : 'http://192.168.84.229:3000';

  static const baseUrl =
      kIsWeb ? 'http://localhost:3000' : 'http://192.168.84.229:3000';

  static    bool checiIfAndroid(BuildContext context){
        bool isAndroid = Theme.of(context).platform == TargetPlatform.android;
        return isAndroid;
      }

  static String calculateMembershipDuration(
      BuildContext context, DateTime? memberSince) {
    final now = DateTime.now();
    final difference = now.difference(memberSince!);

    if (difference.inDays >= 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${AppLocalizations.of(context).translate(years == 1 ? 'year' : 'years')} ${AppLocalizations.of(context).translate('ago')}';
    } else if (difference.inDays >= 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${AppLocalizations.of(context).translate(months == 1 ? 'month' : 'months')} ${AppLocalizations.of(context).translate('ago')}';
    } else if (difference.inDays >= 7) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks ${AppLocalizations.of(context).translate(weeks == 1 ? 'week' : 'weeks')} ${AppLocalizations.of(context).translate('ago')}';
    } else if (difference.inDays >= 1) {
      return '${difference.inDays} ${AppLocalizations.of(context).translate(difference.inDays == 1 ? 'day' : 'days')} ${AppLocalizations.of(context).translate('ago')}';
    } else {
      return AppLocalizations.of(context).translate('today');
    }
  }

  static TextStyle dynamicStyle = const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              );

               static TextStyle staticStyle = const TextStyle(
               fontSize: 12,
                fontWeight: FontWeight.normal,
                color: Colors.grey,
              );

  static bool checkIfAndroid() {
return defaultTargetPlatform == TargetPlatform.android;
  }
}
