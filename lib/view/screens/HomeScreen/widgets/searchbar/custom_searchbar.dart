import 'package:flinto_driver/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class SearchBarr extends StatelessWidget {
  final String hint;
  final bool showQRCode;
  
  const SearchBarr({
    Key? key,
    required this.hint,
    this.showQRCode = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            
            // margin: const EdgeInsets.symmetric(horizontal: 3,),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: 
                  TextField(
                    decoration: InputDecoration(
                      hintText: hint,
                      hintStyle: TextStyle(color: Colors.grey[400],fontSize: 14),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    ),
                  ),
                ),
        ),SizedBox(width: 10,),
        if (showQRCode)
            Container(
              margin: const EdgeInsets.only(right: 8),
              decoration: const BoxDecoration(
                color: AppColors.darkGrey,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.qr_code_scanner, color: Colors.white, size: 22),
                onPressed: () {},
              ),
            ),
      ],
    );
  }
}
