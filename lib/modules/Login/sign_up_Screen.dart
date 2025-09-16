import 'package:flutter/material.dart';
import 'package:flutter_app/utils/text_styles.dart';
import 'package:flutter_app/utils/themes.dart';
import 'package:flutter_app/modules/Login/facebook_twitter_button_view.dart';
import 'package:flutter_app/utils/validator.dart';
import 'package:flutter_app/widgets/common_appbar_view.dart';
import 'package:flutter_app/widgets/common_button.dart';
import 'package:flutter_app/widgets/common_text_field_view.dart';
import 'package:flutter_app/widgets/remove_focuse.dart';
import 'package:flutter_app/routes/route_names.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  String _errorEmail = '';
  TextEditingController _emailController = TextEditingController();
  String _errorPassword = '';
  TextEditingController _passwordController = TextEditingController();
  String _errorFName = '';
  TextEditingController _fnameController = TextEditingController();
  String _errorLName = '';
  TextEditingController _lnameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        body: RemoveFocuse(
          onClick: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _appBar(),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 32),
                        child: FacebookTwitterButtonView(),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "أو سجّل باستخدام البريد الإلكتروني", // نص ثابت
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ),
                      CommonTextFieldView(
                        controller: _fnameController,
                        errorText: _errorFName,
                        padding: const EdgeInsets.only(
                            bottom: 16, left: 24, right: 24),
                        titleText: "الاسم الأول", // نص ثابت
                        hintText: "أدخل اسمك الأول", // نص ثابت
                        keyboardType: TextInputType.name,
                        onChanged: (String txt) {},
                      ),
                      CommonTextFieldView(
                        controller: _lnameController,
                        errorText: _errorLName,
                        padding: const EdgeInsets.only(
                            bottom: 16, left: 24, right: 24),
                        titleText: "الاسم الأخير", // نص ثابت
                        hintText: "أدخل اسمك الأخير", // نص ثابت
                        keyboardType: TextInputType.name,
                        onChanged: (String txt) {},
                      ),
                      CommonTextFieldView(
                        controller: _emailController,
                        errorText: _errorEmail,
                        titleText: "البريد الإلكتروني", // نص ثابت
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, bottom: 16),
                        hintText: "أدخل بريدك الإلكتروني", // نص ثابت
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (String txt) {},
                      ),
                      CommonTextFieldView(
                        titleText: "كلمة المرور", // نص ثابت
                        padding: const EdgeInsets.only(
                            left: 24, right: 24, bottom: 24),
                        hintText: "أدخل كلمة المرور", // نص ثابت
                        isObscureText: true,
                        onChanged: (String txt) {},
                        errorText: _errorPassword,
                        controller: _passwordController,
                      ),
                      CommonButton(
                        padding:
                            EdgeInsets.only(left: 24, right: 24, bottom: 8),
                        buttonText: "تسجيل حساب جديد", // نص ثابت
                        onTap: () {
                          if (_allValidation()) {
                            // هنا تقدر تنقل المستخدم للصفحة التالية بعد النجاح
                             NavigationServices(context).gotoTabScreen();
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          "بالتسجيل أنت توافق على الشروط والأحكام", // نص ثابت
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).disabledColor,
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "لديك حساب بالفعل؟", // نص ثابت
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).disabledColor,
                            ),
                          ),
                          InkWell(
                            borderRadius: BorderRadius.all(Radius.circular(8)),
                            onTap: () {
                               NavigationServices(context).gotoLoginScreen();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "تسجيل الدخول", // نص ثابت
                                style: TextStyles(context)
                                    .getRegularStyle()
                                    .copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppTheme.primaryTextColor,
                                    ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).padding.bottom + 24,
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return CommonAppbarView(
      iconData: Icons.arrow_back,
      titleText: "إنشاء حساب جديد", // نص ثابت
      onBackClick: () {
        Navigator.pop(context);
      },
    );
  }

  bool _allValidation() {
    bool isValid = true;

    if (_fnameController.text.trim().isEmpty) {
      _errorFName = "الاسم الأول لا يمكن أن يكون فارغًا"; // نص ثابت
      isValid = false;
    } else {
      _errorFName = '';
    }

    if (_lnameController.text.trim().isEmpty) {
      _errorLName = "الاسم الأخير لا يمكن أن يكون فارغًا"; // نص ثابت
      isValid = false;
    } else {
      _errorLName = '';
    }

    if (_emailController.text.trim().isEmpty) {
      _errorEmail = "البريد الإلكتروني لا يمكن أن يكون فارغًا"; // نص ثابت
      isValid = false;
    } else if (!Validator.validateEmail(_emailController.text.trim())) {
      _errorEmail = "الرجاء إدخال بريد إلكتروني صحيح"; // نص ثابت
      isValid = false;
    } else {
      _errorEmail = '';
    }

    if (_passwordController.text.trim().isEmpty) {
      _errorPassword = "كلمة المرور لا يمكن أن تكون فارغة"; // نص ثابت
      isValid = false;
    } else if (_passwordController.text.trim().length < 6) {
      _errorPassword = "كلمة المرور يجب أن تكون 6 أحرف على الأقل"; // نص ثابت
      isValid = false;
    } else {
      _errorPassword = '';
    }
    setState(() {});
    return isValid;
  }
}
