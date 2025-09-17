import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/common_appbar_view.dart';
import 'package:flutter_app/widgets/common_button.dart';
import 'package:flutter_app/widgets/common_text_field_view.dart';
import 'package:flutter_app/widgets/remove_focuse.dart';

class ChangepasswordScreen extends StatefulWidget {
  @override
  _ChangepasswordScreenState createState() => _ChangepasswordScreenState();
}

class _ChangepasswordScreenState extends State<ChangepasswordScreen> {
  String _errorNewPassword = '';
  String _errorConfirmPassword = '';
  TextEditingController _newController = TextEditingController();
  TextEditingController _confirmController = TextEditingController();

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
              titleText: "تغيير كلمة المرور", // نص ثابت
              onBackClick: () {
                Navigator.pop(context);
              },
            ),
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
                              "أدخل كلمة المرور الجديدة", // نص ثابت
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
                      controller: _newController,
                      titleText: "كلمة المرور الجديدة", // نص ثابت
                      padding:
                          EdgeInsets.only(left: 24, right: 24, bottom: 16),
                      hintText: "أدخل كلمة المرور الجديدة", // نص ثابت
                      keyboardType: TextInputType.visiblePassword,
                      isObscureText: true,
                      onChanged: (String txt) {},
                      errorText: _errorNewPassword,
                    ),
                    CommonTextFieldView(
                      controller: _confirmController,
                      titleText: "تأكيد كلمة المرور", // نص ثابت
                      padding:
                          EdgeInsets.only(left: 24, right: 24, bottom: 24),
                      hintText: "أدخل كلمة المرور مرة أخرى", // نص ثابت
                      keyboardType: TextInputType.visiblePassword,
                      isObscureText: true,
                      onChanged: (String txt) {},
                      errorText: _errorConfirmPassword,
                    ),
                    CommonButton(
                      padding: EdgeInsets.only(left: 24, right: 24, bottom: 16),
                      buttonText: "تطبيق", // نص ثابت
                      onTap: () {
                        if (_allValidation()) {
                          Navigator.pop(context);
                        }
                      },
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool _allValidation() {
    bool isValid = true;

    if (_newController.text.trim().isEmpty) {
      _errorNewPassword = 'كلمة المرور لا يمكن أن تكون فارغة'; // نص ثابت
      isValid = false;
    } else if (_newController.text.trim().length < 6) {
      _errorNewPassword = 'يجب أن تكون كلمة المرور 6 أحرف على الأقل'; // نص ثابت
      isValid = false;
    } else {
      _errorNewPassword = '';
    }

    if (_confirmController.text.trim().isEmpty) {
      _errorConfirmPassword = 'تأكيد كلمة المرور لا يمكن أن يكون فارغًا'; // نص ثابت
      isValid = false;
    } else if (_newController.text.trim() != _confirmController.text.trim()) {
      _errorConfirmPassword = 'كلمة المرور غير متطابقة'; // نص ثابت
      isValid = false;
    } else {
      _errorConfirmPassword = '';
    }

    setState(() {});
    return isValid;
  }
}
