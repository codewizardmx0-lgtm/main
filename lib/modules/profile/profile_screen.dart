import 'package:flutter/material.dart';
import 'package:flutter_app/providers/theme_provider.dart';
import 'package:flutter_app/routes/route_names.dart';
import 'package:flutter_app/utils/localfiles.dart';
import 'package:flutter_app/utils/text_styles.dart';
import 'package:flutter_app/utils/themes.dart';
import 'package:flutter_app/widgets/bottom_top_move_animation_view.dart';
import 'package:provider/provider.dart';
import '../../models/setting_list_data.dart';

class ProfileScreen extends StatefulWidget {
  final AnimationController animationController;

  const ProfileScreen({Key? key, required this.animationController})
      : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  List<SettingsListData> userSettingsList = SettingsListData.userSettingsList;

  @override
  void initState() {
    widget.animationController.forward();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BottomTopMoveAnimationView(
        animationController: widget.animationController,
        child: Consumer<ThemeProvider>(
          builder: (context, provider, child) => Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: Container(child: appBar()),
              ),
              Expanded(
                child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  padding: EdgeInsets.all(0.0),
                  itemCount: userSettingsList.length,
                  itemBuilder: (context, index) {
                    // الحصول على النص مباشرة
                      final String title = userSettingsList[index].titleTxt.toString();
                    return InkWell(
                      onTap: () async {
                        // Navigate to the correct screen
                        if (index == 5) {
                          NavigationServices(context).gotoSettingsScreen();
                        } else if (index == 3) {
                          NavigationServices(context).gotoHeplCenterScreen();
                        } else if (index == 0) {
                          NavigationServices(context).gotoChangepasswordScreen();
                        } else if (index == 1) {
                          NavigationServices(context).gotoInviteFriend();
                        }
                      },
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(left: 8, right: 16),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Text(
                                      title,
                                      style: TextStyles(context)
                                          .getRegularStyle()
                                          .copyWith(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 16),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Container(
                                    child: Icon(
                                        userSettingsList[index].iconData,
                                        color: AppTheme.secondaryTextColor
                                            .withOpacity(0.7)),
                                  ),
                                )
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: Divider(height: 1),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ));
  }

  Widget appBar() {
    return InkWell(
      onTap: () {
        NavigationServices(context).gotoEditProfile();
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Raaj", // استبدل النص بالثابت
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "View/Edit Profile", // استبدال النص المباشر
                    style: TextStyle(
                      fontSize: 18,
                      color: Theme.of(context).disabledColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.only(right: 24, top: 16, bottom: 16, left: 24),
            child: Container(
              width: 70,
              height: 70,
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(40.0)),
                child: Image.asset(Localfiles.userImage),
              ),
            ),
          )
        ],
      ),
    );
  }
}
