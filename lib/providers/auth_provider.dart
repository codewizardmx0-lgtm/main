import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_auth_service.dart';
import '../models/user.dart' as AppUser;

enum AuthStatus {
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider extends ChangeNotifier {
  final FirebaseAuthService _authService = FirebaseAuthService();
  
  AuthStatus _status = AuthStatus.loading;
  AppUser.User? _currentUser;
  String _errorMessage = '';
  bool _isLoading = false;

  // Getters
  AuthStatus get status => _status;
  AppUser.User? get currentUser => _currentUser;
  String get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated;

  AuthProvider() {
    _init();
  }

  /// تهيئة Provider ومراقبة تغييرات حالة المصادقة
  void _init() {
    _authService.authStateChanges.listen((User? firebaseUser) {
      if (firebaseUser != null) {
        _currentUser = _authService.getCurrentAppUser();
        _status = AuthStatus.authenticated;
        print('✅ المستخدم مسجل دخول: ${firebaseUser.email}');
      } else {
        _currentUser = null;
        _status = AuthStatus.unauthenticated;
        print('❌ المستخدم غير مسجل دخول');
      }
      notifyListeners();
    });
  }

  /// تسجيل الدخول
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      print('🔐 محاولة تسجيل الدخول...');
      await _authService.signInWithEmail(
        email: email,
        password: password,
      );

      _setLoading(false);
      print('✅ تم تسجيل الدخول بنجاح');
      return true;

    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      print('❌ فشل تسجيل الدخول: $e');
      return false;
    }
  }

  /// تسجيل حساب جديد
  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      print('🔐 محاولة إنشاء حساب جديد...');
      await _authService.signUpWithEmail(
        email: email,
        password: password,
        name: name,
      );

      _setLoading(false);
      print('✅ تم إنشاء الحساب بنجاح');
      return true;

    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      print('❌ فشل إنشاء الحساب: $e');
      return false;
    }
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    try {
      _setLoading(true);
      await _authService.signOut();
      _setLoading(false);
      print('✅ تم تسجيل الخروج بنجاح');
    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      print('❌ فشل تسجيل الخروج: $e');
    }
  }

  /// إرسال رابط إعادة تعيين كلمة المرور
  Future<bool> sendPasswordResetEmail(String email) async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.sendPasswordResetEmail(email);
      _setLoading(false);
      return true;

    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      return false;
    }
  }

  /// تحديث كلمة المرور
  Future<bool> updatePassword(String newPassword) async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.updatePassword(newPassword);
      _setLoading(false);
      return true;

    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      return false;
    }
  }

  /// تحديث الملف الشخصي
  Future<bool> updateProfile({
    String? displayName,
    String? photoURL,
  }) async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.updateProfile(
        displayName: displayName,
        photoURL: photoURL,
      );

      // تحديث البيانات المحلية
      _currentUser = _authService.getCurrentAppUser();
      
      _setLoading(false);
      return true;

    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      return false;
    }
  }

  /// إرسال رابط التحقق من البريد الإلكتروني
  Future<bool> sendEmailVerification() async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.sendEmailVerification();
      _setLoading(false);
      return true;

    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      return false;
    }
  }

  /// حذف الحساب
  Future<bool> deleteAccount() async {
    try {
      _setLoading(true);
      _clearError();

      await _authService.deleteAccount();
      _setLoading(false);
      return true;

    } catch (e) {
      _setLoading(false);
      _setError(e.toString());
      return false;
    }
  }

  /// تحديث حالة التحميل
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  /// تعيين رسالة خطأ
  void _setError(String error) {
    _errorMessage = error;
    _status = AuthStatus.error;
    notifyListeners();
  }

  /// مسح رسالة الخطأ
  void _clearError() {
    _errorMessage = '';
    if (_status == AuthStatus.error) {
      _status = _currentUser != null 
          ? AuthStatus.authenticated 
          : AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  /// إعادة تعيين حالة الخطأ
  void clearError() {
    _clearError();
  }

  /// التحقق من صحة البريد الإلكتروني
  bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  /// التحقق من قوة كلمة المرور
  bool isStrongPassword(String password) {
    // على الأقل 6 أحرف، تحتوي على رقم وحرف
    return password.length >= 6 && 
           password.contains(RegExp(r'[0-9]')) && 
           password.contains(RegExp(r'[a-zA-Z]'));
  }

  /// الحصول على رسالة وصفية لقوة كلمة المرور
  String getPasswordStrengthMessage(String password) {
    if (password.length < 6) {
      return 'كلمة المرور يجب أن تحتوي على 6 أحرف على الأقل';
    }
    if (!password.contains(RegExp(r'[0-9]'))) {
      return 'كلمة المرور يجب أن تحتوي على رقم واحد على الأقل';
    }
    if (!password.contains(RegExp(r'[a-zA-Z]'))) {
      return 'كلمة المرور يجب أن تحتوي على حرف واحد على الأقل';
    }
    return 'كلمة المرور قوية';
  }
}