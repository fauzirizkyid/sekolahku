import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
  static inputDecoration(
          {@required enabled, @required icon, @required hint, dynamic onTap}) =>
      InputDecoration(
        enabled: enabled,
        suffixIconConstraints: BoxConstraints(
          minWidth: 2,
          minHeight: 2,
        ),
        suffixIcon: Padding(
          padding: const EdgeInsetsDirectional.only(end: 10),
          child: onTap != null
              ? IconButton(
                  icon: Icon(icon, size: 18),
                  onPressed: onTap,
                  iconSize: 14,
                )
              : Icon(icon, size: 14), // myIcon is a 48px-wide widget.
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
    bool? obsecureText,
    TextAlign align = TextAlign.left,
    TextInputType inputType = TextInputType.text,
    IconData? icon,
    int maxLines = 1,
    int? maxLength,
    dynamic onTap,
    dynamic onChanged,
    dynamic iconTap,
  }) {
    if (obsecureText == null) {
      obsecureText = title.contains('Password') ? true : false;
    }

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
                    obscureText: obsecureText!,
                    controller: inputController,
                    style: TextStyled.normalBody,
                    textAlign: align,
                    maxLines: maxLines,
                    maxLength: maxLength,
                    keyboardType: inputType,
                    onTap: onTap,
                    onChanged: onChanged,
                    decoration: Components.inputDecoration(
                        enabled: enabled, hint: hint, icon: icon, onTap: iconTap),
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

  static dateTimePicker(
      {required BuildContext context,
      String title = '',
      String hint = '',
      bool todayIsLastDate = true,
      bool decoration = false,
      bool mandatory = false,
      bool dateOnly = false,
      bool enabled = true,
      DateTime? initDateTime,
      required ValueChanged<DateTime> onDateTimeChanged}) {
    DateTime lastDate;
    DateFormat format = DateFormat("yyyy-MM-dd HH:mm");

    if (todayIsLastDate) {
      lastDate = DateTime.now();
    } else {
      lastDate = DateTime(2100);
    }

    if (dateOnly) {
      format = DateFormat("yyyy-MM-dd");
    }

    Widget _dateTimePicker() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
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
              width: double.infinity,
              padding: EdgeInsets.only(top: 10, bottom: 20),
              child: DateTimeField(
                format: format,
                maxLines: 1,
                resetIcon: null,
                initialValue: initDateTime,
                style: TextStyled.normalBody,
                decoration: Components.inputDecoration(
                    enabled: enabled,
                    hint: hint,
                    icon: FontAwesomeIcons.calendarAlt),
                onShowPicker: (context, currentValue) async {
                  final date = await showDatePicker(
                      context: context,
                      firstDate: DateTime(1900),
                      initialDate: currentValue ?? DateTime.now(),
                      lastDate: lastDate);
                  if (date != null && !dateOnly) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(
                          currentValue ?? DateTime.now()),
                    );
                    return DateTimeField.combine(date, time);
                  } else if (date != null && dateOnly) {
                    return DateTimeField.combine(date, null);
                  } else {
                    return currentValue;
                  }
                },
                onChanged: (currentValue) {
                  onDateTimeChanged(currentValue!);
                },
                validator: (value) {
                  if (mandatory) {
                    if (value == null) {
                      return 'Mohon isi ' + title;
                    }
                  }
                  return null;
                },
              ),
            ),
          ],
        );

    return _dateTimePicker();
  }
}
