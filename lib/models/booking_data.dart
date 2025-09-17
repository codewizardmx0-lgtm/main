import 'package:hive/hive.dart';
import 'package:flutter_app/models/hotel_list_data.dart';
import 'package:flutter_app/models/room_data.dart';

part 'booking_data.g.dart'; // سيتم إنشاؤه تلقائياً

@HiveType(typeId: 0)
class BookingData extends HiveObject {
  @HiveField(0)
  late String id; // معرف فريد للحجز

  @HiveField(1)
  late String hotelTitle; // اسم الفندق

  @HiveField(2)
  late String hotelLocation; // موقع الفندق

  @HiveField(3)
  late String hotelImagePath; // مسار صورة الفندق

  @HiveField(4)
  late double hotelRating; // تقييم الفندق

  @HiveField(5)
  late int hotelPricePerNight; // سعر الليلة

  @HiveField(6)
  late int numberOfPeople; // عدد الأشخاص

  @HiveField(7)
  late DateTime checkInDate; // تاريخ الوصول

  @HiveField(8)
  late DateTime checkOutDate; // تاريخ المغادرة

  @HiveField(9)
  late int numberOfGuests; // عدد الضيوف

  @HiveField(10)
  late double totalPrice; // السعر الإجمالي

  @HiveField(11)
  late String guestName; // اسم النزيل

  @HiveField(12)
  late String guestEmail; // بريد النزيل

  @HiveField(13)
  late String guestPhone; // هاتف النزيل

  @HiveField(14)
  late DateTime bookingDate; // تاريخ الحجز

  @HiveField(15)
  late String status; // حالة الحجز

  @HiveField(16)
  String? specialRequests; // طلبات خاصة

  // Constructor
  BookingData({
    required this.id,
    required this.hotelTitle,
    required this.hotelLocation,
    required this.hotelImagePath,
    required this.hotelRating,
    required this.hotelPricePerNight,
    required this.numberOfPeople,
    required this.checkInDate,
    required this.checkOutDate,
    required this.numberOfGuests,
    required this.totalPrice,
    required this.guestName,
    required this.guestEmail,
    required this.guestPhone,
    required this.bookingDate,
    this.status = 'confirmed',
    this.specialRequests,
  });

  // إنشاء من بيانات الفندق
  factory BookingData.fromHotel({
    required HotelListData hotel,
    required RoomData roomData,
    required DateTime checkInDate,
    required DateTime checkOutDate,
    required String guestName,
    required String guestEmail,
    required String guestPhone,
    String? specialRequests,
  }) {
    final numberOfNights = checkOutDate.difference(checkInDate).inDays;
    final totalPrice = (hotel.perNight * numberOfNights).toDouble();
    
    return BookingData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      hotelTitle: hotel.titleTxt,
      hotelLocation: hotel.subTxt,
      hotelImagePath: hotel.imagePath,
      hotelRating: hotel.rating,
      hotelPricePerNight: hotel.perNight,
      numberOfPeople: roomData.people,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
      numberOfGuests: roomData.people,
      totalPrice: totalPrice,
      guestName: guestName,
      guestEmail: guestEmail,
      guestPhone: guestPhone,
      bookingDate: DateTime.now(),
      status: 'confirmed',
      specialRequests: specialRequests,
    );
  }

  // حساب عدد الليالي
  int get numberOfNights {
    return checkOutDate.difference(checkInDate).inDays;
  }

  // تحويل حالة الحجز إلى نص عربي
  String get statusArabic {
    switch (status) {
      case 'confirmed':
        return 'مؤكد';
      case 'pending':
        return 'في الانتظار';
      case 'cancelled':
        return 'ملغي';
      case 'completed':
        return 'مكتمل';
      default:
        return 'غير معروف';
    }
  }

  // تحديث حالة الحجز
  void updateStatus(String newStatus) {
    status = newStatus;
    save(); // حفظ التغيير في قاعدة البيانات
  }

  // إضافة طلبات خاصة
  void addSpecialRequests(String requests) {
    specialRequests = requests;
    save(); // حفظ التغيير في قاعدة البيانات
  }

  // التحقق من انتهاء الرحلة
  bool get isCompleted {
    return DateTime.now().isAfter(checkOutDate);
  }

  // التحقق من قرب موعد الرحلة
  bool get isUpcoming {
    return DateTime.now().isBefore(checkInDate);
  }

  // الحصول على HotelListData من الحجز
  HotelListData get asHotelData {
    return HotelListData(
      imagePath: hotelImagePath,
      titleTxt: hotelTitle,
      subTxt: hotelLocation,
      rating: hotelRating,
      reviews: 0, // يمكن إضافة هذا لاحقاً
      perNight: hotelPricePerNight,
      dist: 0.0, // يمكن إضافة هذا لاحقاً
      // إضافة التواريخ وبيانات الغرفة
      date: DateText(checkInDate.day, checkOutDate.day),
      roomData: RoomData(numberOfPeople, numberOfGuests),
    );
  }
}