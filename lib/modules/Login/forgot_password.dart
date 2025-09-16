import 'package:flutter/material.dart';
import 'package:flutter_app/utils/validator.dart';
import 'package:flutter_app/widgets/common_appbar_view.dart';
import 'package:flutter_app/widgets/common_button.dart';
import 'package:flutter_app/widgets/common_text_field_view.dart';
import 'package:flutter_app/widgets/remove_focuse.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  String _errorEmail = '';
  TextEditingController _emailController = TextEditingController();

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
            appBar(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16.0, bottom: 16.0, left: 24, right: 24),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              "أرسل رابط إعادة تعيين كلمة المرور", // نص ثابت
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Theme.of(context).disabledColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    CommonTextFieldView(
                      controller: _emailController,
                      titleText: "البريد الإلكتروني", // نص ثابت
                      errorText: _errorEmail,
                      padding:
                          EdgeInsets.only(left: 24, right: 24, bottom: 24),
                      hintText: "أدخل بريدك الإلكتروني", // نص ثابت
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (String txt) {},
                    ),
                    CommonButton(
                      padding:
                          EdgeInsets.only(left: 24, right: 24, bottom: 16),
                      buttonText: "إرسال", // نص ثابت
                      onTap: () {
                        if (_allValidation()) Navigator.pop(context);
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

  Widget appBar() {
    return CommonAppbarView(
      iconData: Icons.arrow_back,
      titleText: "نسيت كلمة المرور؟", // نص ثابت
      onBackClick: () {
        Navigator.pop(context);
      },
    );
  }

  bool _allValidation() {
    bool isValid = true;
    if (_emailController.text.trim().isEmpty) {
      _errorEmail = 'البريد الإلكتروني لا يمكن أن يكون فارغًا'; // نص ثابت
      isValid = false;
    } else if (!Validator.validateEmail(_emailController.text.trim())) {
      _errorEmail = 'يرجى إدخال بريد إلكتروني صالح'; // نص ثابت
      isValid = false;
    } else {
      _errorEmail = '';
    }
    setState(() {});
    return isValid;
  }
}
