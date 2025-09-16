import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/common_appbar_view.dart';
import 'package:flutter_app/widgets/common_button.dart';
import 'package:flutter_app/widgets/common_text_field_view.dart';
import 'package:flutter_app/widgets/remove_focuse.dart';
import 'package:flutter_app/utils/validator.dart';
import 'package:flutter_app/routes/route_names.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _errorEmail = '';
  TextEditingController _emailController = TextEditingController();
  String _errorPassword = '';
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RemoveFocuse(
        onClick: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CommonAppbarView(
              iconData: Icons.arrow_back,
              titleText: "تسجيل الدخول", // نص ثابت
              onBackClick: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 32),
                      child: Text(
                        "تسجيل الدخول عبر فيسبوك أو تويتر", // بدلاً من FacebookTwitterButtonView
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        "أو تسجيل الدخول باستخدام البريد الإلكتروني", // نص ثابت
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).disabledColor,
                        ),
                      ),
                    ),
                    CommonTextFieldView(
                      controller: _emailController,
                      errorText: _errorEmail,
                      titleText: "البريد الإلكتروني",
                      padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
                      hintText: "أدخل البريد الإلكتروني",
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (String txt) {},
                    ),
                    CommonTextFieldView(
                      titleText: "كلمة المرور",
                      padding: const EdgeInsets.only(left: 24, right: 24),
                      hintText: "أدخل كلمة المرور",
                      isObscureText: true,
                      onChanged: (String txt) {},
                      errorText: _errorPassword,
                      controller: _passwordController,
                    ),
                    _forgotYourPasswordUI(),
                    CommonButton(
                      padding: EdgeInsets.only(left: 24, right: 24, bottom: 16),
                      buttonText: "تسجيل الدخول",
                      onTap: () {
                        if (_allValidation()) {
                           NavigationServices(context).gotoTabScreen();
                        }
                      },
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _forgotYourPasswordUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8, right: 16, bottom: 8, left: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            onTap: () {
              NavigationServices(context).gotoForgotPassword();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "نسيت كلمة المرور؟",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).disabledColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  bool _allValidation() {
    bool isValid = true;
    if (_emailController.text.trim().isEmpty) {
      _errorEmail = 'البريد الإلكتروني لا يمكن أن يكون فارغًا';
      isValid = false;
    } else if (!Validator.validateEmail(_emailController.text.trim())) {
      _errorEmail = 'يرجى إدخال بريد إلكتروني صالح';
      isValid = false;
    } else {
      _errorEmail = '';
    }

    if (_passwordController.text.trim().isEmpty) {
      _errorPassword = 'كلمة المرور لا يمكن أن تكون فارغة';
      isValid = false;
    } else if (_passwordController.text.trim().length < 6) {
      _errorPassword = 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
      isValid = false;
    } else {
      _errorPassword = '';
    }

    setState(() {});
    return isValid;
  }
}
