import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/common_appbar_view.dart';
import 'package:flutter_app/widgets/common_button.dart';
import 'package:flutter_app/widgets/common_text_field_view.dart';
import 'package:flutter_app/widgets/remove_focuse.dart';
import 'package:flutter_app/utils/validator.dart';
import 'package:flutter_app/routes/route_names.dart';
import 'package:flutter_app/providers/auth_provider.dart';
import 'package:provider/provider.dart';


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
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return CommonButton(
                          padding: EdgeInsets.only(left: 24, right: 24, bottom: 16),
                          buttonText: authProvider.isLoading ? "جاري تسجيل الدخول..." : "تسجيل الدخول",
                          onTap: authProvider.isLoading ? null : () async {
                            if (_allValidation()) {
                              await _handleLogin(authProvider);
                            }
                          },
                        );
                      },
                    ),
                    
                    // عرض رسائل الخطأ
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        if (authProvider.errorMessage.isNotEmpty) {
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Container(
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.red.shade50,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.red.shade200),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.error_outline, color: Colors.red, size: 20),
                                  SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      authProvider.errorMessage,
                                      style: TextStyle(
                                        color: Colors.red.shade700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.close, size: 18, color: Colors.red),
                                    onPressed: () => authProvider.clearError(),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }
                        return SizedBox.shrink();
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

  /// معالجة تسجيل الدخول
  Future<void> _handleLogin(AuthProvider authProvider) async {
    // مسح الأخطاء السابقة
    authProvider.clearError();
    
    try {
      // محاولة تسجيل الدخول
      bool success = await authProvider.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (success) {
        // نجح تسجيل الدخول - انتقال للشاشة الرئيسية
        print('✅ نجح تسجيل الدخول - انتقال للشاشة الرئيسية');
        NavigationServices(context).gotoTabScreen();
        
        // عرض رسالة نجاح
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('مرحباً بك في تطبيق حجز الفنادق! 🎉'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // سيتم عرض الخطأ عبر AuthProvider الذي يتم عرضه في Consumer
      print('❌ فشل تسجيل الدخول: $e');
    }
  }

  bool _allValidation() {
    bool isValid = true;
    if (_emailController.text.trim().isEmpty) {
      _errorEmail = 'البريد الإلكتروني لا يمكن أن يكون فارغاً';
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
