import 'package:flutter/material.dart';
import 'package:flutter_app/models/hotel_list_data.dart';
import 'package:flutter_app/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesProvider extends ChangeNotifier {
  List<HotelListData> _favorites = [];
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  String _errorMessage = '';
  
  List<HotelListData> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  
  // التحقق من وجود فندق في المفضلة
  bool isFavorite(String hotelImagePath) {
    return _favorites.any((hotel) => hotel.imagePath == hotelImagePath);
  }
  
  // إضافة فندق للمفضلة (CREATE)
  Future<void> addToFavorites(HotelListData hotel) async {
    if (!isFavorite(hotel.imagePath)) {
      _setLoading(true);
      try {
        // استخدام API لإضافة للمفضلة
        await _apiService.addToFavorites('user123', hotel.imagePath);
        _favorites.add(hotel);
        await _saveFavorites();
        _setLoading(false);
        notifyListeners();
      } catch (e) {
        _setError('فشل في إضافة الفندق للمفضلة: $e');
      }
    }
  }
  
  // حذف فندق من المفضلة (DELETE)
  Future<void> removeFromFavorites(String hotelImagePath) async {
    _setLoading(true);
    try {
      // استخدام API لحذف من المفضلة
      await _apiService.removeFromFavorites('user123', hotelImagePath);
      _favorites.removeWhere((hotel) => hotel.imagePath == hotelImagePath);
      await _saveFavorites();
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('فشل في حذف الفندق من المفضلة: $e');
    }
  }
  
  // تبديل حالة المفضلة (TOGGLE)
  Future<void> toggleFavorite(HotelListData hotel) async {
    if (isFavorite(hotel.imagePath)) {
      await removeFromFavorites(hotel.imagePath);
    } else {
      await addToFavorites(hotel);
    }
  }
  
  // تحديث فندق في المفضلة (UPDATE) - في حال تغيرت تفاصيله
  Future<void> updateFavorite(HotelListData updatedHotel) async {
    int index = _favorites.indexWhere(
      (hotel) => hotel.imagePath == updatedHotel.imagePath
    );
    if (index != -1) {
      _favorites[index] = updatedHotel;
      await _saveFavorites();
      notifyListeners();
    }
  }
  
  // حفظ المفضلة في SharedPreferences
  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoritesJson = _favorites.map((hotel) {
      return jsonEncode({
        'imagePath': hotel.imagePath,
        'titleTxt': hotel.titleTxt,
        'subTxt': hotel.subTxt,
        'rating': hotel.rating,
        'reviews': hotel.reviews,
        'perNight': hotel.perNight,
        'dist': hotel.dist,
      });
    }).toList();
    
    await prefs.setStringList('favorites', favoritesJson);
  }
  
  // استرجاع المفضلة من SharedPreferences (READ)
  Future<void> loadFavorites() async {
    _setLoading(true);
    try {
      // محاولة الحصول على المفضلة من API ثم الرجوع للتخزين المحلي كاحتياطي
      try {
        final favoriteIds = await _apiService.getFavorites('user123');
        print('تم جلب ${favoriteIds.length} مفضلة من API');
        // إذا كان هناك مفضلة، قم بجلب تفاصيل كل فندق
        if (favoriteIds.isNotEmpty) {
          // في المشروع الحقيقي: استخدم الـ IDs لجلب الفنادق
          // هنا: نستخدم القائمة المحلية للتبسيط
        }
      } catch (e) {
        print('فشل جلب المفضلة من API، استخدام التخزين المحلي: $e');
      }
      
      // استخدام التخزين المحلي كاحتياطي
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getStringList('favorites') ?? [];
      
      _favorites = favoritesJson.map((jsonString) {
        final data = jsonDecode(jsonString);
        return HotelListData(
          imagePath: data['imagePath'],
          titleTxt: data['titleTxt'],
          subTxt: data['subTxt'],
          rating: data['rating']?.toDouble() ?? 0.0,
          reviews: data['reviews'] ?? 0,
          perNight: data['perNight'] ?? 0,
          dist: data['dist']?.toDouble() ?? 0.0,
        );
      }).toList();
      
      _setLoading(false);
      notifyListeners();
    } catch (e) {
      _setError('فشل في تحميل المفضلة: $e');
    }
  }
  
  // مسح جميع المفضلة
  Future<void> clearAllFavorites() async {
    _favorites.clear();
    await _saveFavorites();
    notifyListeners();
  }
  
  // الحصول على عدد المفضلة
  int get favoritesCount => _favorites.length;
  
  // دوال مساعدة لإدارة الحالة
  void _setLoading(bool loading) {
    _isLoading = loading;
    if (loading) _errorMessage = '';
    notifyListeners();
  }
  
  void _setError(String error) {
    _errorMessage = error;
    _isLoading = false;
    notifyListeners();
  }
  
  void clearError() {
    _errorMessage = '';
    notifyListeners();
  }
}
