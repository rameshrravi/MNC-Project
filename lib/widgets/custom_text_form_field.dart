import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
//import 'package:flutter_icons/flutter_icons.dart';
import 'package:midnightcity/constants/app_colors.dart';
import 'package:midnightcity/constants/input.styles.dart';

class CustomTextFormField extends StatefulWidget {
  CustomTextFormField(
      {Key? key,
      this.filled,
      this.fillColor,
      this.textEditingController,
      this.obscureText = false,
      this.textInputAction = TextInputAction.done,
      this.keyboardType = TextInputType.text,
      this.labelText,
      this.hintText,
      this.errorText,
      this.validator,
      this.onChanged,
      this.onFieldSubmitted,
      this.focusNode,
      this.nextFocusNode,
      this.isReadOnly = false,
      this.onTap,
      this.minLines,
      this.maxLines,
      this.suffixIcon,
      this.prefixIcon,
      this.underline = false,
      this.inputFormatters,
      this.borderRadius = 90,
      this.labelColor,
      this.textColor,
      this.cursorColor})
      : super(key: key);

  //
  final bool? filled;
  final Color? fillColor;
  final TextEditingController? textEditingController;
  final bool? obscureText;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;

  //
  final String? labelText;
  final Color? labelColor;
  final Color? textColor;
  final Color? cursorColor;
  final String? hintText;
  final String? errorText;

  final VoidCallback? onChanged;
  final Function? onFieldSubmitted;
  final Function(String)? validator;
  final FocusNode? focusNode;
  final FocusNode? nextFocusNode;

  final bool? isReadOnly;
  final Function? onTap;
  final int? minLines;
  final int? maxLines;

  final Widget? prefixIcon;
  final Widget? suffixIcon;

  final bool? underline;
  final List<TextInputFormatter>? inputFormatters;
  final double? borderRadius;

  @override
  _CustomTextFormFieldState createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(widget!.borderRadius!)),
            borderSide: BorderSide(
              color: Colors.white,
            )),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        alignLabelWithHint: false,
        hintStyle: TextStyle(
            color: Colors.grey,
            fontWeight: FontWeight.w300,
            fontFamily: "Poppins",
            fontStyle: FontStyle.normal,
            fontSize: 14.0),
        labelText: widget.labelText,
        hintText: widget.hintText,
        errorText: widget.errorText,
        enabledBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius!)),
            borderSide: BorderSide(
              color: Colors.transparent,
            )),

        /*  widget.underline
            ? InputStyles.inputUnderlineEnabledBorder()
            : InputStyles.inputEnabledBorder(),*/
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius!)),
          borderSide: BorderSide(
            color: Colors.red,
          ),
        ),

        /*  widget.underline
            ? InputStyles.inputUnderlineEnabledBorder()
            : InputStyles.inputEnabledBorder(),*/

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(widget.borderRadius!)),
          borderSide: BorderSide(
            color: AppColor.primaryTextColor,
          ),
        ),

        /*   widget.underline
            ? InputStyles.inputUnderlineFocusBorder()
            : InputStyles.inputFocusBorder(),
*/
        focusedBorder: OutlineInputBorder(
            borderRadius:
                BorderRadius.all(Radius.circular(widget.borderRadius!)),
            borderSide: BorderSide(
              color: AppColor.primaryTextColor,
            )),
        /* widget.underline
            ? InputStyles.inputUnderlineFocusBorder()
            : InputStyles.inputFocusBorder(),*/
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.suffixIcon ?? _getSuffixWidget(),
        labelStyle: TextStyle(
            color: widget.labelColor ?? Colors.black,
            fontWeight: FontWeight.w300,
            fontFamily: "Poppins",
            fontStyle: FontStyle.normal,
            fontSize: 14.0),
        contentPadding: EdgeInsets.all(10),
        filled: true, // widget.fillColor != null,
        fillColor: widget.fillColor,
      ),
      inputFormatters: widget.inputFormatters,
      cursorColor: widget.cursorColor ?? AppColor.white,
      obscureText: (widget.obscureText!) ? !makePasswordVisible : false,
      onTap: () {},
      readOnly: widget.isReadOnly!,
      controller: widget.textEditingController,
      // validator: widget.validator!!,
      focusNode: widget.focusNode,
      onFieldSubmitted: (data) {
        // if (widget.onFieldSubmitted != null) {
        //   widget.onFieldSubmitted(data);
        // } else {
        //   FocusScope.of(context).requestFocus(widget.nextFocusNode);
        // }
      },
      style: TextStyle(color: widget.textColor ?? Colors.black),
      //onChanged: widget.onChanged!,
      textInputAction: widget.textInputAction,
      keyboardType: widget.keyboardType,
      minLines: widget.minLines,
      maxLines: widget.obscureText! ? 1 : widget.maxLines,
    );
  }

  //check if it's password input
  bool makePasswordVisible = false;
  Widget _getSuffixWidget() {
    if (widget.obscureText!) {
      return ButtonTheme(
        minWidth: 30,
        height: 30,
        padding: EdgeInsets.all(0),
        child: TextButton(
          style: TextButton.styleFrom(
            padding: EdgeInsets.all(0),
          ),
          onPressed: () {
            setState(() {
              makePasswordVisible = !makePasswordVisible;
            });
          },
          child: Icon(
            (!makePasswordVisible)
                ? FlutterIcons.md_eye_off_ion
                : FlutterIcons.md_eye_ion,
            color: Colors.grey,
          ),
        ),
      );
    } else {
      return SizedBox.shrink();
    }
  }
}
