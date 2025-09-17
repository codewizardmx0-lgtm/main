import 'package:dio/dio.dart';
import '../models/hotel_list_data.dart';
import '../models/booking_data.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  late final Dio _dio;
  
  // يمكن تغيير هذا الرابط لاحقاً للـ JSON Server أو أي API آخر
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  void initialize() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // إضافة Interceptors للتسجيل والتصحيح
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) => print('🌐 API Log: $obj'),
    ));
  }

  // ===============================
  // طلبات الفنادق (Hotels API)
  // ===============================

  /// الحصول على قائمة الفنادق
  Future<List<HotelListData>> getHotels() async {
    try {
      // مؤقتاً نستخدم بيانات وهمية حتى نعد JSON Server
      // يمكن تغييرها لاحقاً إلى: final response = await _dio.get('/hotels');
      
      await Future.delayed(const Duration(seconds: 1)); // محاكاة تأخير الشبكة
      
      return HotelListData.hotelList; // البيانات الموجودة حالياً
    } catch (e) {
      print('❌ خطأ في جلب الفنادق: $e');
      throw ApiException('فشل في جلب قائمة الفنادق', e);
    }
  }

  /// البحث عن فنادق
  Future<List<HotelListData>> searchHotels(String query) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      final allHotels = HotelListData.hotelList;
      final searchResults = allHotels.where((hotel) =>
        hotel.titleTxt.toLowerCase().contains(query.toLowerCase()) ||
        hotel.subTxt.toLowerCase().contains(query.toLowerCase())
      ).toList();
      
      return searchResults;
    } catch (e) {
      print('❌ خطأ في البحث: $e');
      throw ApiException('فشل في البحث عن الفنادق', e);
    }
  }

  // ===============================
  // طلبات الحجوزات (Bookings API)  
  // ===============================

  /// الحصول على الحجوزات
  Future<List<BookingData>> getBookings(String userId) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      // مؤقتاً نرجع بيانات وهمية
      return [
        BookingData(
          id: 'BK001',
          hotelTitle: 'Grand Rosy Hotel',
          hotelLocation: 'الدوحة، قطر',
          hotelImagePath: 'assets/images/hotel_1.jpg',
          hotelRating: 4.5,
          hotelPricePerNight: 850,
          numberOfPeople: 2,
          checkInDate: DateTime.now().add(const Duration(days: 5)),
          checkOutDate: DateTime.now().add(const Duration(days: 8)),
          numberOfGuests: 2,
          totalPrice: 2550.0,
          guestName: 'محمد أحمد',
          guestEmail: 'mohamed@example.com',
          guestPhone: '+974 5555 1234',
          bookingDate: DateTime.now(),
          status: 'confirmed',
        ),
      ];
    } catch (e) {
      print('❌ خطأ في جلب الحجوزات: $e');
      throw ApiException('فشل في جلب الحجوزات', e);
    }
  }

  /// إضافة حجز جديد
  Future<BookingData> createBooking(BookingData booking) async {
    try {
      // مؤقتاً نحاكي إنشاء الحجز
      await Future.delayed(const Duration(seconds: 2));
      
      final newBooking = BookingData(
        id: 'BK${DateTime.now().millisecondsSinceEpoch}',
        hotelTitle: booking.hotelTitle,
        hotelLocation: booking.hotelLocation,
        hotelImagePath: booking.hotelImagePath,
        hotelRating: booking.hotelRating,
        hotelPricePerNight: booking.hotelPricePerNight,
        numberOfPeople: booking.numberOfPeople,
        checkInDate: booking.checkInDate,
        checkOutDate: booking.checkOutDate,
        numberOfGuests: booking.numberOfGuests,
        totalPrice: booking.totalPrice,
        guestName: booking.guestName,
        guestEmail: booking.guestEmail,
        guestPhone: booking.guestPhone,
        bookingDate: DateTime.now(),
        status: 'confirmed',
      );
      
      print('✅ تم إنشاء حجز جديد: ${newBooking.id}');
      return newBooking;
      
    } catch (e) {
      print('❌ خطأ في إنشاء الحجز: $e');
      throw ApiException('فشل في إنشاء الحجز', e);
    }
  }

  /// تحديث حجز
  Future<BookingData> updateBooking(BookingData booking) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      print('✅ تم تحديث الحجز: ${booking.id}');
      return booking;
      
    } catch (e) {
      print('❌ خطأ في تحديث الحجز: $e');
      throw ApiException('فشل في تحديث الحجز', e);
    }
  }

  /// حذف حجز
  Future<void> deleteBooking(String bookingId) async {
    try {
      await Future.delayed(const Duration(seconds: 1));
      
      print('✅ تم حذف الحجز: $bookingId');
      
    } catch (e) {
      print('❌ خطأ في حذف الحجز: $e');
      throw ApiException('فشل في حذف الحجز', e);
    }
  }

  // ===============================
  // طلبات المفضلة (Favorites API)
  // ===============================

  /// الحصول على المفضلة
  Future<List<String>> getFavorites(String userId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      // مؤقتاً نرجع قائمة فارغة
      return [];
    } catch (e) {
      print('❌ خطأ في جلب المفضلة: $e');
      throw ApiException('فشل في جلب المفضلة', e);
    }
  }

  /// إضافة إلى المفضلة
  Future<void> addToFavorites(String userId, String hotelId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      print('✅ تمت إضافة الفندق للمفضلة: $hotelId');
    } catch (e) {
      print('❌ خطأ في إضافة المفضلة: $e');
      throw ApiException('فشل في إضافة المفضلة', e);
    }
  }

  /// حذف من المفضلة
  Future<void> removeFromFavorites(String userId, String hotelId) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));
      
      print('✅ تم حذف الفندق من المفضلة: $hotelId');
    } catch (e) {
      print('❌ خطأ في حذف المفضلة: $e');
      throw ApiException('فشل في حذف المفضلة', e);
    }
  }
}

// ===============================
// فئة الأخطاء المخصصة
// ===============================

class ApiException implements Exception {
  final String message;
  final dynamic originalError;

  ApiException(this.message, [this.originalError]);

  @override
  String toString() => 'ApiException: $message';
}