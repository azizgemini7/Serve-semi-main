import 'package:flutter/material.dart';

class MyCustomInput extends StatelessWidget {
  final String labelText;
  final EdgeInsets containerMargin;
  final String initialValue;
  final String errorText;
  final Color labelColor;
  final bool expands;
  final FormFieldValidator<String> validator;
  final int inputMaxLines;
  final bool enabled;
  final TextInputType inputType;
  final EdgeInsets contentPadding;
  final ValueChanged<String> onFieldSubmitted;
  final TextInputAction textInputAction;
  final ValueChanged<String> onChanged;
  final FormFieldSetter<String> onSaved;
  final String placeholder;
  final TextEditingController textEditingController;
  final bool obsecureText;

  final Widget prefixIcon;

  final Widget prefixWidget;

  final bool filledEnabled;
  final FocusNode focusNode;
  final TextAlign textAlign;
  final bool autoFocus;
  final bool readOnly;
  final bool hasFocus;
  final BoxShadow boxShadow;

  final Widget suffixIcon;

  final BorderSide border;

  final bool enableBorder;
  bool multiline = false;
  MyCustomInput({
    this.labelText,
    this.contentPadding =
        const EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
    this.onChanged,
    this.enabled = true,
    this.textInputAction,
    this.errorText,
    this.onSaved,
    this.textEditingController,
    this.expands = false,
    this.placeholder,
    this.initialValue,
    this.inputMaxLines = 1,
    this.containerMargin,
    this.boxShadow,
    this.inputType,
    this.validator,
    this.prefixIcon,
    this.obsecureText = false,
    this.labelColor = Colors.black38,
    Key key,
    this.prefixWidget,
    this.filledEnabled = true,
    this.hasFocus = false,
    this.focusNode,
    this.suffixIcon,
    this.border,
    this.enableBorder = false,
    this.autoFocus = false,
    this.onFieldSubmitted,
    this.textAlign = TextAlign.start,
    this.readOnly = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        splashColor: Colors.transparent,
      ),
      child: TextFormField(
        expands: expands,
        textInputAction: textInputAction,
        readOnly: readOnly,
        style: TextStyle(
          height: 1.14285714,
          fontFamily: obsecureText
              ? 'roboto'
              : Theme.of(context).textTheme.subtitle2.fontFamily,
        ),
        maxLines: inputMaxLines ?? 1,
        validator: validator,
        enabled: enabled,
        textAlign: textAlign,
        keyboardType: inputType,
        onFieldSubmitted: onFieldSubmitted,
        autofocus: autoFocus,
        initialValue: initialValue,
        focusNode: focusNode,
        obscureText: obsecureText,
        onChanged: onChanged,
        onSaved: onSaved,
        controller: textEditingController,
        decoration: InputDecoration(
          hintText: placeholder,
          alignLabelWithHint: true,
          prefix: prefixWidget,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          errorText: errorText,
          enabledBorder: enableBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                      color: Color(0x2625364F),
                      style: BorderStyle.solid,
                      width: 1.0))
              : OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.zero,
                ),
          labelText: labelText,
          fillColor: Color(0xFFFBFBFB),
          filled: filledEnabled,
          border: enableBorder
              ? OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    width: 1.0,
                    color: Color(0x2625364F),
                  ),
                )
              : OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.zero,
                ),
        ),
      ),
    );
  }
}

class MyCustomComboBox extends StatefulWidget {
  final ValueChanged onChangedEvent;
  final int value;
  final labelText;
  final BuildContext context;
  final FormFieldSetter onSaved;
  final FormFieldValidator validator;
  final List<DropdownMenuItem> items;
  final Widget suffixIcon;
  final Widget prefixIcon;

  MyCustomComboBox({
    this.value,
    this.onSaved,
    this.validator,
    this.labelText,
    this.items = const [
      DropdownMenuItem(
        value: 0,
        child: Text(
          'المدينة...',
          style: TextStyle(
              fontSize: 16.0,
              color: const Color(0x8025364F),
              fontWeight: FontWeight.normal),
        ),
      ),
    ],
    this.onChangedEvent,
    this.suffixIcon,
    this.prefixIcon,
    this.context,
  });
  @override
  _MyCustomComboBoxState createState() => _MyCustomComboBoxState();
}

class _MyCustomComboBoxState extends State<MyCustomComboBox> {
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Theme(
      data: Theme.of(context).copyWith(brightness: Brightness.dark),
      child: DropdownButtonFormField(
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.only(right: widget.prefixIcon == null ? 15.0 : 0.0),
          suffixIcon: widget.suffixIcon,
          prefixIcon: widget.prefixIcon,
          filled: true,
          fillColor: Color(0xFFFBFBFB),
          enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
          labelText: widget.labelText,
          focusColor: Theme.of(context).primaryColor,
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          border: OutlineInputBorder(borderSide: BorderSide.none),
          labelStyle: TextStyle(
            fontSize: 16.0,
            color: const Color(0xFF25364F),
          ),
        ),
        validator: widget.validator,
        style: TextStyle(
          height: 1.14285714,
        ),
        onSaved: widget.onSaved,
        onChanged: widget.onChangedEvent,
        items: widget.items,
        value: widget.value,
      ),
    );
  }
}

class MyCustomFormButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressedEvent;
  final Color textColor;
  final double height;
  final double radius;
  final double fontSize;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;
  MyCustomFormButton({
    Key key,
    @required this.onPressedEvent,
    this.buttonText,
    this.fontSize = 16.0,
    this.height = 38.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 8.0),
    this.radius = 19.0,
    this.textColor = Colors.white,
    this.backgroundColor = const Color.fromARGB(255, 57, 186, 186),
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Container(
//      width: double.infinity,
      width: 150.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: SizedBox(
        height: height,
        width: double.infinity,
        child: MaterialButton(
          padding: padding,
          disabledColor: Theme.of(context).buttonColor.withOpacity(0.5),
          onPressed: onPressedEvent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          elevation: 0,
          color: backgroundColor,
          child: AnimatedSwitcher(
            switchOutCurve: Curves.easeOut,
            duration: Duration(milliseconds: 500),
            transitionBuilder: (Widget child, Animation<double> animation) =>
                FadeTransition(
              opacity: animation,
              child: child,
            ),
            switchInCurve: Curves.easeOut,
            child: Text(
              buttonText,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: fontSize,
//                          fontWeight: FontWeight.normal,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
