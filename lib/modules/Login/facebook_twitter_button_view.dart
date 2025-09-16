import 'package:flutter/material.dart';
import 'package:flutter_app/widgets/common_button.dart';

class FacebookTwitterButtonView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return _fTButtonUI();
  }

  Widget _fTButtonUI() {
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(width: 24),
          Expanded(
            child: CommonButton(
              padding: EdgeInsets.zero,
              backgroundColor: Color(0xFF3C5799), // أزرق غامق لفيسبوك
              buttonTextWidget: _buttonTextUI(),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: CommonButton(
              padding: EdgeInsets.zero,
              backgroundColor: Color(0xFF05A9F0), // أزرق فاتح لتويتر
              buttonTextWidget: _buttonTextUI(isFacebook: false),
            ),
          ),
          SizedBox(width: 24),
        ],
      ),
    );
  }

  Widget _buttonTextUI({bool isFacebook = true}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(
          isFacebook ? Icons.facebook : Icons.chat, // اخترنا chat كتويتر
          size: 20,
          color: Colors.white,
        ),
        SizedBox(width: 4),
        Text(
          isFacebook ? "Facebook" : "Twitter",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
