import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart' as AppUser;

class FirebaseAuthService {
  static final FirebaseAuthService _instance = FirebaseAuthService._internal();
  factory FirebaseAuthService() => _instance;
  FirebaseAuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// الحصول على المستخدم الحالي
  User? get currentUser => _auth.currentUser;

  /// تدفق حالة المصادقة
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  /// التسجيل بالبريد الإلكتروني وكلمة المرور
  Future<UserCredential> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      print('🔐 محاولة إنشاء حساب جديد: $email');
      
      UserCredential result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // تحديث اسم المستخدم
      if (result.user != null) {
        await result.user!.updateDisplayName(name);
        await result.user!.reload();
        print('✅ تم إنشاء الحساب بنجاح');
      }

      return result;
    } on FirebaseAuthException catch (e) {
      print('❌ خطأ في إنشاء الحساب: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ خطأ غير متوقع في إنشاء الحساب: $e');
      throw 'حدث خطأ غير متوقع أثناء إنشاء الحساب';
    }
  }

  /// تسجيل الدخول بالبريد الإلكتروني وكلمة المرور
  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      print('🔐 محاولة تسجيل الدخول: $email');
      
      UserCredential result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      print('✅ تم تسجيل الدخول بنجاح');
      return result;
    } on FirebaseAuthException catch (e) {
      print('❌ خطأ في تسجيل الدخول: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ خطأ غير متوقع في تسجيل الدخول: $e');
      throw 'حدث خطأ غير متوقع أثناء تسجيل الدخول';
    }
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    try {
      print('🚪 محاولة تسجيل الخروج');
      await _auth.signOut();
      print('✅ تم تسجيل الخروج بنجاح');
    } catch (e) {
      print('❌ خطأ في تسجيل الخروج: $e');
      throw 'فشل في تسجيل الخروج';
    }
  }

  /// إرسال رابط إعادة تعيين كلمة المرور
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      print('📧 إرسال رابط إعادة تعيين كلمة المرور إلى: $email');
      await _auth.sendPasswordResetEmail(email: email);
      print('✅ تم إرسال رابط إعادة تعيين كلمة المرور');
    } on FirebaseAuthException catch (e) {
      print('❌ خطأ في إرسال رابط إعادة التعيين: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ خطأ غير متوقع في إرسال رابط إعادة التعيين: $e');
      throw 'حدث خطأ غير متوقع أثناء إرسال رابط إعادة التعيين';
    }
  }

  /// تحديث كلمة المرور
  Future<void> updatePassword(String newPassword) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw 'المستخدم غير مسجل دخول';
      }

      print('🔒 تحديث كلمة المرور للمستخدم: ${user.email}');
      await user.updatePassword(newPassword);
      print('✅ تم تحديث كلمة المرور بنجاح');
    } on FirebaseAuthException catch (e) {
      print('❌ خطأ في تحديث كلمة المرور: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ خطأ غير متوقع في تحديث كلمة المرور: $e');
      throw 'حدث خطأ غير متوقع أثناء تحديث كلمة المرور';
    }
  }

  /// تحديث الملف الشخصي
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw 'المستخدم غير مسجل دخول';
      }

      print('👤 تحديث الملف الشخصي للمستخدم: ${user.email}');
      await user.updateDisplayName(displayName);
      if (photoURL != null) {
        await user.updatePhotoURL(photoURL);
      }
      await user.reload();
      print('✅ تم تحديث الملف الشخصي بنجاح');
    } catch (e) {
      print('❌ خطأ في تحديث الملف الشخصي: $e');
      throw 'حدث خطأ أثناء تحديث الملف الشخصي';
    }
  }

  /// حذف الحساب
  Future<void> deleteAccount() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw 'المستخدم غير مسجل دخول';
      }

      print('🗑️ حذف حساب المستخدم: ${user.email}');
      await user.delete();
      print('✅ تم حذف الحساب بنجاح');
    } on FirebaseAuthException catch (e) {
      print('❌ خطأ في حذف الحساب: ${e.code} - ${e.message}');
      throw _handleAuthException(e);
    } catch (e) {
      print('❌ خطأ غير متوقع في حذف الحساب: $e');
      throw 'حدث خطأ غير متوقع أثناء حذف الحساب';
    }
  }

  /// التحقق من البريد الإلكتروني
  Future<void> sendEmailVerification() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw 'المستخدم غير مسجل دخول';
      }

      print('📧 إرسال رابط التحقق إلى: ${user.email}');
      await user.sendEmailVerification();
      print('✅ تم إرسال رابط التحقق بنجاح');
    } catch (e) {
      print('❌ خطأ في إرسال رابط التحقق: $e');
      throw 'حدث خطأ أثناء إرسال رابط التحقق';
    }
  }

  /// الحصول على بيانات المستخدم كـ AppUser
  AppUser.User? getCurrentAppUser() {
    User? firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;

    // تقسيم الاسم الكامل إلى اسم أول وأخير
    String displayName = firebaseUser.displayName ?? 'مستخدم جديد';
    List<String> nameParts = displayName.split(' ');
    String firstName = nameParts.isNotEmpty ? nameParts[0] : 'مستخدم';
    String lastName = nameParts.length > 1 ? nameParts.sublist(1).join(' ') : 'جديد';

    return AppUser.User(
      firstName: firstName,
      lastName: lastName,
      email: firebaseUser.email ?? '',
      password: '', // لا نحفظ كلمة المرور لأسباب أمنية
      createdAt: firebaseUser.metadata.creationTime ?? DateTime.now(),
    );
  }

  /// معالجة أخطاء Firebase Auth وتحويلها لرسائل عربية
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'البريد الإلكتروني غير مسجل';
      case 'wrong-password':
        return 'كلمة المرور غير صحيحة';
      case 'email-already-in-use':
        return 'البريد الإلكتروني مستخدم بالفعل';
      case 'weak-password':
        return 'كلمة المرور ضعيفة جداً';
      case 'invalid-email':
        return 'البريد الإلكتروني غير صالح';
      case 'user-disabled':
        return 'تم تعطيل هذا الحساب';
      case 'too-many-requests':
        return 'تم تجاوز عدد المحاولات المسموح. حاول لاحقاً';
      case 'operation-not-allowed':
        return 'هذه العملية غير مسموحة';
      case 'requires-recent-login':
        return 'يتطلب تسجيل دخول حديث';
      default:
        return 'حدث خطأ في المصادقة: ${e.message ?? 'خطأ غير معروف'}';
    }
  }
}