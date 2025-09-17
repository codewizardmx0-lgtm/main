import 'package:flutter/material.dart';
import 'package:flutter_app/providers/bookings_provider.dart';
import 'package:flutter_app/models/hotel_list_data.dart';
import 'package:flutter_app/models/room_data.dart';
import 'package:flutter_app/utils/text_styles.dart';
import 'package:flutter_app/utils/themes.dart';
import 'package:flutter_app/widgets/common_button.dart';
import 'package:flutter_app/widgets/common_card.dart';
import 'package:provider/provider.dart';

class CompleteBookingScreen extends StatefulWidget {
  final HotelListData hotel;
  final HotelListData roomData;

  const CompleteBookingScreen({
    Key? key,
    required this.hotel,
    required this.roomData,
  }) : super(key: key);

  @override
  _CompleteBookingScreenState createState() => _CompleteBookingScreenState();
}

class _CompleteBookingScreenState extends State<CompleteBookingScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers للنموذج
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _requestsController = TextEditingController();
  
  // التواريخ
  DateTime _checkInDate = DateTime.now().add(Duration(days: 1));
  DateTime _checkOutDate = DateTime.now().add(Duration(days: 3));
  
  int _numberOfGuests = 2;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _requestsController.dispose();
    super.dispose();
  }

  // حساب عدد الليالي والسعر
  int get numberOfNights => _checkOutDate.difference(_checkInDate).inDays;
  double get totalPrice => (widget.roomData.perNight * numberOfNights).toDouble();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildAppBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHotelSummary(),
                    SizedBox(height: 24),
                    _buildDateSelection(),
                    SizedBox(height: 24),
                    _buildGuestInfo(),
                    SizedBox(height: 24),
                    _buildPriceSummary(),
                    SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ),
          _buildBookButton(),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 16,
      ),
      color: AppTheme.primaryColor,
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Text(
              'إكمال الحجز',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: 48), // توازن مع زر الرجوع
        ],
      ),
    );
  }

  Widget _buildHotelSummary() {
    return CommonCard(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تفاصيل الحجز',
              style: TextStyles(context).getBoldStyle().copyWith(fontSize: 18),
            ),
            SizedBox(height: 12),
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    widget.hotel.imagePath,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.hotel.titleTxt,
                        style: TextStyles(context).getBoldStyle(),
                      ),
                      Text(
                        widget.hotel.subTxt,
                        style: TextStyles(context).getDescriptionStyle(),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.roomData.titleTxt,
                        style: TextStyles(context).getRegularStyle().copyWith(
                          color: AppTheme.primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelection() {
    return CommonCard(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'التواريخ',
              style: TextStyles(context).getBoldStyle().copyWith(fontSize: 18),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDateCard('تاريخ الوصول', _checkInDate, (date) {
                    setState(() {
                      _checkInDate = date;
                      if (_checkOutDate.isBefore(date.add(Duration(days: 1)))) {
                        _checkOutDate = date.add(Duration(days: 2));
                      }
                    });
                  }),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildDateCard('تاريخ المغادرة', _checkOutDate, (date) {
                    setState(() => _checkOutDate = date);
                  }),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'عدد الليالي: $numberOfNights ليلة',
              style: TextStyles(context).getRegularStyle().copyWith(
                color: AppTheme.primaryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateCard(String title, DateTime date, Function(DateTime) onDateSelected) {
    return InkWell(
      onTap: () async {
        final selectedDate = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(Duration(days: 365)),
        );
        if (selectedDate != null) {
          onDateSelected(selectedDate);
        }
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyles(context).getDescriptionStyle()),
            SizedBox(height: 4),
            Text(
              '${date.day}/${date.month}/${date.year}',
              style: TextStyles(context).getBoldStyle(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGuestInfo() {
    return CommonCard(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'بيانات النزيل',
              style: TextStyles(context).getBoldStyle().copyWith(fontSize: 18),
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  child: Text(
                    'الاسم الكامل',
                    style: TextStyles(context).getDescriptionStyle(),
                  ),
                ),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'أدخل اسمك الكامل',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'يرجى إدخال الاسم';
                    }
                    return null;
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  child: Text(
                    'البريد الإلكتروني',
                    style: TextStyles(context).getDescriptionStyle(),
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: 'أدخل بريدك الإلكتروني',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'يرجى إدخال البريد الإلكتروني';
                    }
                    if (!value!.contains('@')) {
                      return 'يرجى إدخال بريد إلكتروني صحيح';
                    }
                    return null;
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  child: Text(
                    'رقم الهاتف',
                    style: TextStyles(context).getDescriptionStyle(),
                  ),
                ),
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'أدخل رقم هاتفك',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  validator: (value) {
                    if (value?.trim().isEmpty ?? true) {
                      return 'يرجى إدخال رقم الهاتف';
                    }
                    return null;
                  },
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, bottom: 8),
                  child: Text(
                    'طلبات خاصة (اختياري)',
                    style: TextStyles(context).getDescriptionStyle(),
                  ),
                ),
                TextFormField(
                  controller: _requestsController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: 'أي طلبات خاصة للفندق...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceSummary() {
    return CommonCard(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ملخص الأسعار',
              style: TextStyles(context).getBoldStyle().copyWith(fontSize: 18),
            ),
            SizedBox(height: 16),
            _buildPriceRow('سعر الليلة', '\$${widget.roomData.perNight}'),
            _buildPriceRow('عدد الليالي', '$numberOfNights'),
            Divider(),
            _buildPriceRow(
              'المجموع الإجمالي', 
              '\$${totalPrice.toInt()}',
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String title, String value, {bool isBold = false}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: isBold 
                ? TextStyles(context).getBoldStyle()
                : TextStyles(context).getRegularStyle(),
          ),
          Text(
            value,
            style: isBold 
                ? TextStyles(context).getBoldStyle().copyWith(
                    color: AppTheme.primaryColor
                  )
                : TextStyles(context).getRegularStyle(),
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton() {
    return Container(
      padding: EdgeInsets.all(16),
      child: CommonButton(
        buttonText: _isLoading ? 'جاري الحجز...' : 'تأكيد الحجز',
        onTap: _isLoading ? null : _confirmBooking,
      ),
    );
  }

  Future<void> _confirmBooking() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      final bookingsProvider = context.read<BookingsProvider>();
      
      final error = await bookingsProvider.createBooking(
        hotel: widget.hotel,
        roomData: RoomData(_numberOfGuests, numberOfNights),
        checkInDate: _checkInDate,
        checkOutDate: _checkOutDate,
        guestName: _nameController.text.trim(),
        guestEmail: _emailController.text.trim(),
        guestPhone: _phoneController.text.trim(),
        specialRequests: _requestsController.text.trim().isEmpty 
            ? null 
            : _requestsController.text.trim(),
      );

      if (error != null) {
        // إظهار رسالة خطأ
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: Colors.red,
          ),
        );
      } else {
        // نجح الحجز
        _showSuccessDialog();
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 28),
            SizedBox(width: 8),
            Text('تم الحجز بنجاح!'),
          ],
        ),
        content: Text(
          'تم حفظ حجزك بنجاح. يمكنك مراجعة تفاصيل الحجز في قسم "رحلاتي".',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // إغلاق الحوار
              Navigator.of(context).pop(); // العودة لصفحة الغرفة
              Navigator.of(context).pop(); // العودة لصفحة تفاصيل الفندق
            },
            child: Text('موافق'),
          ),
        ],
      ),
    );
  }
}