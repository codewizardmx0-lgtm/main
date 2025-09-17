import 'package:flutter/material.dart';
import 'package:flutter_app/models/room_data.dart';
import 'package:flutter_app/motel_app.dart';
import 'package:flutter_app/providers/theme_provider.dart';
import 'package:flutter_app/utils/enum.dart';
import 'package:flutter_app/utils/themes.dart';
import 'package:flutter_app/widgets/custom_dialog.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Helper {
  // نص الغرف والأشخاص
  static String getRoomText(RoomData roomData) {
    return "${roomData.numberRoom} room(s) ${roomData.people} people";
  }

  // نص التاريخ
  static String getDateText(DateText dateText) {
    LanguageType _languageType = applicationcontext == null
        ? LanguageType.en
        : applicationcontext!.read<ThemeProvider>().languageType;

    return "0${dateText.startDate} ${DateFormat('MMM', _languageType.toString().split(".")[1]).format(DateTime.now())} - 0${dateText.endDate} ${DateFormat('MMM', _languageType.toString().split(".")[1]).format(DateTime.now().add(Duration(days: 2)))}";
  }

  static String getLastSearchDate(DateText dateText) {
    LanguageType _languageType = applicationcontext == null
        ? LanguageType.en
        : applicationcontext!.read<ThemeProvider>().languageType;

    return "${dateText.startDate} - ${dateText.endDate} ${DateFormat('MMM', _languageType.toString().split(".")[1]).format(DateTime.now().add(Duration(days: 2)))}";
  }

  // نص الأشخاص والأطفال
  static String getPeopleandChildren(RoomData roomData) {
    return "Sleeps ${roomData.numberRoom} people + ${roomData.numberRoom} children";
  }

  // نجوم التقييم
  static Widget ratingStar({double rating = 4.5}) {
    return RatingBarIndicator(
      rating: rating,
      itemBuilder: (context, index) => Icon(
        Icons.star,
        color: AppTheme.primaryColor,
      ),
      itemCount: 5,
      unratedColor: AppTheme.secondaryTextColor,
      itemSize: 18.0,
      direction: Axis.horizontal,
    );
  }

  // نافذة حوارية عامة
  Future<bool> showCommonPopup(
      String title, String descriptionText, BuildContext context,
      {bool isYesOrNoPopup = false, bool barrierDismissible = true}) async {
    bool isOkClick = false;
    return await showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (BuildContext context) => CustomDialog(
        title: title,
        description: descriptionText,
        onCloseClick: () {
          Navigator.of(context).pop();
        },
        actionButtonList: isYesOrNoPopup
            ? <Widget>[
                CustomDialogActionButton(
                  buttonText: "NO",
                  color: Colors.green,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                CustomDialogActionButton(
                  buttonText: "YES",
                  color: Colors.red,
                  onPressed: () {
                    isOkClick = true;
                    Navigator.of(context).pop();
                  },
                )
              ]
            : <Widget>[
                CustomDialogActionButton(
                  buttonText: "OK",
                  color: Colors.green,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
      ),
    ).then((_) {
      return isOkClick;
    });
  }
}
