import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_app/models/booking_data.dart';
import 'package:flutter_app/models/hotel_list_data.dart';
import 'package:flutter_app/models/room_data.dart';
import 'package:flutter_app/services/api_service.dart';

class BookingsProvider extends ChangeNotifier {
  static const String _boxName = 'bookings';
  Box<BookingData>? _bookingsBox;
  List<BookingData> _bookings = [];
  bool _isInitialized = false;
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String _errorMessage = '';

  List<BookingData> get bookings => _bookings;
  bool get isInitialized => _isInitialized;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  // تهيئة قاعدة البيانات
  Future<void> initDatabase() async {
    try {
      if (_bookingsBox == null && !_isInitialized) {
        await Hive.initFlutter();
        
        // تسجيل Type Adapter
        if (!Hive.isAdapterRegistered(0)) {
          Hive.registerAdapter(BookingDataAdapter());
        }
        
        // فتح Box
        _bookingsBox = await Hive.openBox<BookingData>(_boxName);
        
        // تحميل البيانات الموجودة
        await _loadBookings();
        
        _isInitialized = true;
        notifyListeners();
      }
    } catch (e) {
      print('خطأ في تهيئة قاعدة البيانات: $e');
      _isInitialized = false;
    }
  }

  // تحميل الحجوزات من قاعدة البيانات (READ)
  Future<void> _loadBookings() async {
    try {
      if (_bookingsBox != null) {
        final loadedBookings = _bookingsBox!.values.toList();
        _bookings = loadedBookings.cast<BookingData>();
        notifyListeners();
      }
    } catch (e) {
      print('خطأ في تحميل الحجوزات: $e');
      _bookings = []; // قائمة فارغة في حالة الخطأ
      notifyListeners();
    }
  }

  // إضافة حجز جديد (CREATE)
  Future<String?> createBooking({
    required HotelListData hotel,
    required RoomData roomData,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required String guestName,
    required String guestEmail,
    required String guestPhone,
    String? specialRequests,
  }) async {
    try {
      await initDatabase();

      // التحقق من صحة البيانات
      if (guestName.trim().isEmpty) {
        return 'يرجى إدخال اسم النزيل';
      }
      if (guestEmail.trim().isEmpty || !guestEmail.contains('@')) {
        return 'يرجى إدخال بريد إلكتروني صحيح';
      }
      if (guestPhone.trim().isEmpty) {
        return 'يرجى إدخال رقم الهاتف';
      }
      if (checkInDate.isAfter(checkOutDate)) {
        return 'تاريخ المغادرة يجب أن يكون بعد تاريخ الوصول';
      }
      if (checkInDate.isBefore(DateTime.now().subtract(Duration(days: 1)))) {
        return 'لا يمكن الحجز في تاريخ سابق';
      }

      // إنشاء الحجز
      final booking = BookingData.fromHotel(
        hotel: hotel,
        roomData: roomData,
        checkInDate: checkInDate,
        checkOutDate: checkOutDate,
        guestName: guestName,
        guestEmail: guestEmail,
        guestPhone: guestPhone,
        specialRequests: specialRequests,
      );

      // محاولة حفظ في API أولاً
      try {
        final apiBooking = await _apiService.createBooking(booking);
        print('✅ تم حفظ الحجز في API: ${apiBooking.id}');
      } catch (e) {
        print('⚠️ فشل حفظ الحجز في API، استخدام التخزين المحلي: $e');
      }
      
      // حفظ في قاعدة البيانات المحلية
      await _bookingsBox!.add(booking);
      
      // إضافة للقائمة المحلية
      _bookings.add(booking);
      notifyListeners();

      return null; // نجح الحفظ
    } catch (e) {
      return 'حدث خطأ أثناء الحجز: $e';
    }
  }

  // تحديث حجز موجود (UPDATE)
  Future<bool> updateBooking(BookingData booking) async {
    try {
      await initDatabase();
      await booking.save();
      await _loadBookings();
      return true;
    } catch (e) {
      print('خطأ في تحديث الحجز: $e');
      return false;
    }
  }

  // حذف حجز (DELETE)
  Future<bool> deleteBooking(String bookingId) async {
    try {
      await initDatabase();
      
      // البحث عن الحجز
      final booking = _bookings.firstWhere((b) => b.id == bookingId);
      
      // حذف من قاعدة البيانات
      await booking.delete();
      
      // حذف من القائمة المحلية
      _bookings.removeWhere((b) => b.id == bookingId);
      notifyListeners();
      
      return true;
    } catch (e) {
      print('خطأ في حذف الحجز: $e');
      return false;
    }
  }

  // الحصول على حجز بواسطة ID
  BookingData? getBookingById(String id) {
    try {
      return _bookings.firstWhere((booking) => booking.id == id);
    } catch (e) {
      return null;
    }
  }

  // الحصول على الحجوزات القادمة
  List<BookingData> get upcomingBookings {
    return _bookings
        .where((booking) => 
            booking.isUpcoming && 
            (booking.status == 'confirmed' || booking.status == 'pending'))
        .toList()
      ..sort((a, b) => a.checkInDate.compareTo(b.checkInDate));
  }

  // الحصول على الحجوزات المنتهية
  List<BookingData> get completedBookings {
    return _bookings
        .where((booking) => 
            booking.isCompleted || booking.status == 'completed')
        .toList()
      ..sort((a, b) => b.checkOutDate.compareTo(a.checkOutDate));
  }

  // الحصول على الحجوزات الملغية
  List<BookingData> get cancelledBookings {
    return _bookings
        .where((booking) => booking.status == 'cancelled')
        .toList()
      ..sort((a, b) => b.bookingDate.compareTo(a.bookingDate));
  }

  // إلغاء حجز
  Future<bool> cancelBooking(String bookingId) async {
    try {
      final booking = getBookingById(bookingId);
      if (booking != null) {
        booking.updateStatus('cancelled');
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('خطأ في إلغاء الحجز: $e');
      return false;
    }
  }

  // تأكيد حجز
  Future<bool> confirmBooking(String bookingId) async {
    try {
      final booking = getBookingById(bookingId);
      if (booking != null) {
        booking.updateStatus('confirmed');
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      print('خطأ في تأكيد الحجز: $e');
      return false;
    }
  }

  // إحصائيات الحجوزات
  Map<String, int> get bookingStats {
    return {
      'total': _bookings.length,
      'upcoming': upcomingBookings.length,
      'completed': completedBookings.length,
      'cancelled': cancelledBookings.length,
    };
  }

  // إجمالي الأموال المنفقة
  double get totalSpent {
    return completedBookings.fold(0.0, (sum, booking) => sum + booking.totalPrice);
  }

  // إجمالي الأموال المحجوزة (القادمة)
  double get totalUpcoming {
    return upcomingBookings.fold(0.0, (sum, booking) => sum + booking.totalPrice);
  }

  // البحث في الحجوزات
  List<BookingData> searchBookings(String query) {
    if (query.trim().isEmpty) return _bookings;
    
    final lowerQuery = query.toLowerCase();
    return _bookings.where((booking) {
      return booking.hotelTitle.toLowerCase().contains(lowerQuery) ||
             booking.hotelLocation.toLowerCase().contains(lowerQuery) ||
             booking.guestName.toLowerCase().contains(lowerQuery) ||
             booking.id.contains(lowerQuery);
    }).toList();
  }

  // إغلاق قاعدة البيانات
  Future<void> closeDatabase() async {
    await _bookingsBox?.close();
  }
}