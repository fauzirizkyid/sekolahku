import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LayoutStyled {
  static const paddingAllSide = EdgeInsets.all(16);
}

class ColorStyled {
  static const Color myPrimaryColor = Color(0xFFD32F2F);
  static const Color myPrimaryBody = Color(0xFF212121);
  static const Color myTertiaryBody = Color(0xFF999999);
  static const Color myFirstAlternativeColor = Color(0xFFE0E0E0);
  static const Color mySecondAlternativeColor = Color(0xFFEEEEEE);
  static const Color myInvalid = Color(0xFFBF360C);
}

class TextStyled {
  static final headLine = GoogleFonts.roboto(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: ColorStyled.myPrimaryBody);

  static final body = GoogleFonts.roboto(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: ColorStyled.myPrimaryBody);

  static final normalBody = GoogleFonts.roboto(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: ColorStyled.myPrimaryBody);

  static final redBody = GoogleFonts.roboto(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: ColorStyled.myPrimaryColor);

  static final whiteBody = GoogleFonts.roboto(
      fontSize: 12, fontWeight: FontWeight.w500, color: Colors.white);

  static final bodyItalic = GoogleFonts.roboto(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      fontStyle: FontStyle.italic,
      color: ColorStyled.myPrimaryBody);

  static final bodyBold = GoogleFonts.roboto(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: ColorStyled.myPrimaryBody);

  static final TextStyle lightText = GoogleFonts.roboto(
      fontSize: 14,
      fontWeight: FontWeight.w300,
      color: ColorStyled.myTertiaryBody);
}

class Components {
  static inputDecoration({@required enabled, @required icon, @required hint}) =>
      InputDecoration(
        enabled: enabled,
        suffixIconConstraints: BoxConstraints(
          minWidth: 2,
          minHeight: 2,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(end: 10),
          child: Icon(icon, size: 14), // myIcon is a 48px-wide widget.
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: ColorStyled.myFirstAlternativeColor,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: ColorStyled.myPrimaryBody,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: ColorStyled.myFirstAlternativeColor,
            width: 1.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: ColorStyled.mySecondAlternativeColor,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: ColorStyled.myInvalid,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: ColorStyled.myInvalid,
            width: 1.0,
          ),
        ),
        // contentPadding: EdgeInsets.all(15),
        isDense: true,
        hintText: hint,
        hintStyle: TextStyled.lightText,
      );

  static textForm({
    required TextEditingController inputController,
    String hint = '',
    String title = '',
    bool mandatory = false,
    bool decoration = false,
    bool enabled = true,
    TextAlign align = TextAlign.left,
    TextInputType inputType = TextInputType.text,
    IconData? icon,
    int maxLines = 1,
    int? maxLength,
    dynamic onTap,
    dynamic onChanged,
  }) {
    Widget textForm() => Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: align == TextAlign.left
                  ? CrossAxisAlignment.start
                  : CrossAxisAlignment.center,
              children: [
                Visibility(
                    visible: title != '' ? true : false,
                    child: RichText(
                      text: TextSpan(
                        text: title,
                        style: TextStyled.bodyBold,
                        children: <TextSpan>[
                          mandatory == true
                              ? TextSpan(text: ' *', style: TextStyled.redBody)
                              : TextSpan(text: '')
                        ],
                      ),
                    )),
                Container(
                  padding: EdgeInsets.only(top: 5, bottom: 10),
                  child: TextFormField(
                    controller: inputController,
                    style: TextStyled.normalBody,
                    textAlign: align,
                    maxLines: maxLines,
                    maxLength: maxLength,
                    keyboardType: inputType,
                    onTap: onTap,
                    onChanged: onChanged,
                    decoration: Components.inputDecoration(
                        enabled: enabled, hint: hint, icon: icon),
                    validator: (value) {
                      print(value);
                      if (mandatory) {
                        if (value == null || value.isEmpty || value == 'null') {
                          return 'Mohon mengisi ' + title;
                        }
                      }
                      return null;
                    },
                  ),
                )
              ]),
        );

    return textForm();
  }

  static labeledRadio(
      {required String value,
      String? groupValue,
      required ValueChanged<String> onChanged,
      Color activeColor = Colors.blue,
      required String label}) {
    return InkWell(
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5.0),
        child: Row(
          children: <Widget>[
            Radio<String>(
                value: value,
                groupValue: groupValue,
                onChanged: (value) {
                  onChanged(value!);
                }),
            Text(label)
          ],
        ),
      ),
    );
  }

  static customCheckbox(
      {required bool value,
      required ValueChanged<bool> onChanged,
      required String text}) {
    return InkWell(
      onTap: () {
        onChanged(!value);
      },
      child: Row(
        children: [
          Checkbox(
              value: value,
              onChanged: (newValue) {
                onChanged(newValue!);
              }),
          Text(text),
        ],
      ),
    );
  }
}
