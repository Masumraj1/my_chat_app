import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomText extends StatelessWidget {
  const CustomText({
    super.key,
    required this.text,
    this.maxLines,
    this.textAlign = TextAlign.center,
    this.left = 0,
    this.right = 0,
    this.top = 0,
    this.bottom = 0,
    this.fontSize = 12,
    this.fontWeight = FontWeight.w300,
    this.color = Colors.green,
    this.overflow = TextOverflow.ellipsis,
    this.decoration,
    this.fontFamily,
  });

  final double left;
  final double right;
  final double top;
  final double bottom;
  final double fontSize;
  final FontWeight fontWeight;
  final Color color;
  final String text;
  final TextAlign textAlign;
  final int? maxLines;
  final TextOverflow overflow;
  final TextDecoration? decoration;
  final String? fontFamily;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: left, right: right, top: top, bottom: bottom),
      child: Text(
        text,
        maxLines: maxLines,
        overflow: overflow,
        textAlign: textAlign,
        style: _getTextStyle(),
      ),
    );
  }

  TextStyle _getTextStyle() {
    if (fontFamily != null && fontFamily!.isNotEmpty) {
      return GoogleFonts.getFont(
        fontFamily!,
        fontSize: fontSize.w,
        fontWeight: fontWeight,
        color: color,
        decoration: decoration,
      );
    }


    return GoogleFonts.poppins(
      fontSize: fontSize.w,
      fontWeight: fontWeight,
      color: color,
      decoration: decoration,
    );
  }
}