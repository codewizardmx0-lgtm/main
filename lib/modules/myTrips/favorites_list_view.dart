import 'package:flutter/material.dart';
import 'package:flutter_app/routes/route_names.dart';
import 'package:flutter_app/providers/favorites_provider.dart';
import 'package:flutter_app/modules/explore/hotel_list_view_page.dart';
import 'package:provider/provider.dart';

class FavoritesListView extends StatefulWidget {
  final AnimationController animationController;

  const FavoritesListView({Key? key, required this.animationController})
      : super(key: key);
  @override
  _FavoritesListViewState createState() => _FavoritesListViewState();
}

class _FavoritesListViewState extends State<FavoritesListView> {
  @override
  void initState() {
    widget.animationController.forward();
    // تحميل المفضلة عند بدء الصفحة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<FavoritesProvider>().loadFavorites();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FavoritesProvider>(
      builder: (context, favProvider, child) {
        final favoritesList = favProvider.favorites;
        
        if (favoritesList.isEmpty) {
          // عرض رسالة عندما تكون المفضلة فارغة
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 80,
                  color: Colors.grey[400],
                ),
                SizedBox(height: 16),
                Text(
                  'لا توجد فنادق في المفضلة',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey[600],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'اضغط على ❤️ في صفحة الفندق لإضافته للمفضلة',
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
            itemCount: favoritesList.length,
            padding: EdgeInsets.only(top: 8, bottom: 8),
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              var count = favoritesList.length > 10 ? 10 : favoritesList.length;
              var animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                  parent: widget.animationController,
                  curve: Interval((1 / count) * index, 1.0,
                      curve: Curves.fastOutSlowIn)));
              widget.animationController.forward();
              
              // إضافة خاصية السحب للحذف (Swipe to Delete)
              return Dismissible(
                key: Key(favoritesList[index].imagePath),
                direction: DismissDirection.endToStart,
                onDismissed: (direction) async {
                  final removedHotel = favoritesList[index];
                  await favProvider.removeFromFavorites(removedHotel.imagePath);
                  
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('تم حذف ${removedHotel.titleTxt} من المفضلة'),
                      backgroundColor: Colors.red,
                      action: SnackBarAction(
                        label: 'تراجع',
                        textColor: Colors.white,
                        onPressed: () {
                          favProvider.addToFavorites(removedHotel);
                        },
                      ),
                    ),
                  );
                },
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: EdgeInsets.only(right: 20),
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                child: HotelListViewPage(
                  callback: () {
                    NavigationServices(context)
                        .gotoRoomBookingScreen(favoritesList[index].titleTxt);
                  },
                  hotelData: favoritesList[index],
                  animation: animation,
                  animationController: widget.animationController,
                ),
              );
            },
          ),
        );
      },
    );
  }
}
