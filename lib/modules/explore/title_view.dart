import 'package:flutter/material.dart';
import 'package:flutter_app/utils/text_styles.dart';
import 'package:flutter_app/utils/themes.dart';

class TitleView extends StatelessWidget {
  final String titleTxt;
  final String subTxt;
  final AnimationController animationController;
  final Animation<double> animation;
  final VoidCallback click;
  final bool isLeftButton;

  const TitleView(
      {Key? key,
      this.titleTxt = "",
      this.subTxt = "",
      required this.animationController,
      required this.animation,
      required this.click,
      this.isLeftButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Animation للحركة من الأسفل للأعلى
    final Animation<Offset> slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));

    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: slideAnimation,
        child: Padding(
          padding: const EdgeInsets.only(left: 24, right: 24),
          child: Row(
            children: <Widget>[
              Text(
                titleTxt,
                textAlign: TextAlign.left,
                style: TextStyles(context).getBoldStyle().copyWith(
                      fontSize: 18,
                    ),
              ),
              Expanded(child: SizedBox()),
              isLeftButton
                  ? Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                        onTap: click,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8, right: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                subTxt,
                                textAlign: TextAlign.left,
                                style: TextStyles(context)
                                    .getBoldStyle()
                                    .copyWith(
                                        fontSize: 16,
                                        color: AppTheme.primaryColor),
                              ),
                              SizedBox(
                                height: 38,
                                width: 26,
                                child: Icon(
                                  Icons.arrow_forward,
                                  size: 18,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  : SizedBox()
            ],
          ),
        ),
      ),
    );
  }
}
