import 'package:flutter/material.dart';
import 'package:flutter_app/modules/myTrips/hotel_list_view.dart';
import 'package:flutter_app/providers/bookings_provider.dart';
import 'package:provider/provider.dart';

class UpcomingListView extends StatefulWidget {
  final AnimationController animationController;

  const UpcomingListView({Key? key, required this.animationController})
      : super(key: key);
  @override
  _UpcomingListViewState createState() => _UpcomingListViewState();
}

class _UpcomingListViewState extends State<UpcomingListView> {
  @override
  void initState() {
    widget.animationController.forward();
    // تحميل الحجوزات عند بدء الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<BookingsProvider>().initDatabase();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<BookingsProvider>(
      builder: (context, bookingsProvider, child) {
        // حماية من عدم التهيئة
        if (!bookingsProvider.isInitialized) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(
                  'جاري تحميل الحجوزات...',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ],
            ),
          );
        }
        
        final upcomingBookings = bookingsProvider.upcomingBookings;
        
        if (upcomingBookings.isEmpty) {
          // عرض رسالة عندما لا توجد حجوزات قادمة
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.event_available,
                  size: 80,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'لا توجد حجوزات قادمة',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'احجز فندقاً لمشاهدة حجزك هنا!',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[500],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }
        
        return Container(
          child: ListView.builder(
            itemCount: upcomingBookings.length,
            padding: EdgeInsets.only(top: 8, bottom: 16),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              // حماية من تجاوز الفهرس
              if (index >= upcomingBookings.length) {
                return SizedBox.shrink();
              }
              
              final booking = upcomingBookings[index];
              
              final hotelData = booking.asHotelData; // تحويل الحجز لبيانات فندق
              
              var count = upcomingBookings.length > 10 ? 10 : upcomingBookings.length;
              var animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: widget.animationController,
                  curve: Interval((1 / count) * index, 1.0,
                      curve: Curves.fastOutSlowIn)));
              widget.animationController.forward();
              
              // إضافة خاصية السحب لإلغاء الحجز
              return Dismissible(
                key: Key(booking.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  // تأكيد الإلغاء
                  return await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('إلغاء الحجز'),
                      content: Text('هل أنت متأكد من إلغاء هذا الحجز؟'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(false),
                          child: Text('لا'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(true),
                          child: Text('نعم'),
                        ),
                      ],
                    ),
                  ) ?? false;
                },
                onDismissed: (direction) async {
                  await bookingsProvider.cancelBooking(booking.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم إلغاء حجز ${booking.hotelTitle}'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.cancel,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                child: HotelListView(
                  callback: () {
                    // عرض تفاصيل الحجز
                    _showBookingDetails(context, booking);
                  },
                  hotelData: hotelData,
                  animation: animation,
                  animationController: widget.animationController,
                  isShowDate: true,
                ),
              );
            },
          ),
        );
      },
    );
  }
  
  // عرض تفاصيل الحجز
  void _showBookingDetails(BuildContext context, booking) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('تفاصيل الحجز'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('الفندق: ${booking.hotelTitle}'),
              Text('الموقع: ${booking.hotelLocation}'),
              Text('تاريخ الوصول: ${booking.checkInDate.day}/${booking.checkInDate.month}/${booking.checkInDate.year}'),
              Text('تاريخ المغادرة: ${booking.checkOutDate.day}/${booking.checkOutDate.month}/${booking.checkOutDate.year}'),
              Text('عدد الليالي: ${booking.numberOfNights}'),
              Text('السعر الإجمالي: \$${booking.totalPrice.toInt()}'),
              Text('الحالة: ${booking.statusArabic}'),
              if (booking.specialRequests != null && booking.specialRequests!.isNotEmpty) 
                Text('طلبات خاصة: ${booking.specialRequests}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('إغلاق'),
          ),
        ],
      ),
    );
  }
}
