import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:food_delivery/common/color_extension.dart';

class RoundTextField extends StatefulWidget {
  final TextEditingController? controller;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Color? bgColor;
  final Widget? left;
  final bool autofocus;
  final String? Function(String?)? validator;

  const RoundTextField({
    super.key,
    this.controller,
    required this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.bgColor,
    this.left,
    this.autofocus = false,
    this.validator,
  });

  @override
  _RoundTextFieldState createState() => _RoundTextFieldState();
}

class _RoundTextFieldState extends State<RoundTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: widget.bgColor ?? TColor.textfield,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (widget.left != null)
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: widget.left!,
            ),
          Expanded(
            child: TextFormField(
              autocorrect: false,
              controller: widget.controller,
              obscureText: _obscureText,
              autofocus: widget.autofocus,
              validator: widget.validator,
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: widget.hintText,
                hintStyle: TextStyle(
                  fontSize: 14,
                  color: TColor.placeholder,
                  fontWeight: FontWeight.w500,
                ),
                suffixIcon: widget.obscureText
                    ? IconButton(
                        icon: Icon(
                          _obscureText
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: TColor.placeholder,
                        ),
                        onPressed: _toggleObscureText,
                      )
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RoundTitleTextfield extends StatefulWidget {
  final TextEditingController? controller;
  final String title;
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final Color? bgColor;
  final Widget? left;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;

  const RoundTitleTextfield({
    super.key,
    required this.title,
    required this.hintText,
    this.controller,
    this.keyboardType,
    this.bgColor,
    this.left,
    this.enabled = true,
    this.obscureText = false,
    this.inputFormatters,
    this.validator,
  });

  @override
  _RoundTitleTextfieldState createState() => _RoundTitleTextfieldState();
}

class _RoundTitleTextfieldState extends State<RoundTitleTextfield> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  void _toggleObscureText() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.bgColor ?? TColor.textfield,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Row(
        children: [
          if (widget.left != null)
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: widget.left!,
            ),
          Expanded(
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  alignment: Alignment.topLeft,
                  child: TextFormField(
                    autocorrect: false,
                    controller: widget.controller,
                    obscureText: _obscureText,
                    keyboardType: widget.keyboardType,
                    inputFormatters: widget.inputFormatters,
                    validator: widget.validator,
                    enabled: widget.enabled,
                    decoration: InputDecoration(
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 20),
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      hintText: widget.hintText,
                      hintStyle: TextStyle(
                        color: TColor.placeholder,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      suffixIcon: widget.obscureText
                          ? IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                                color: TColor.placeholder,
                              ),
                              onPressed: _toggleObscureText,
                            )
                          : null,
                    ),
                  ),
                ),
                Container(
                  height: 55,
                  margin: const EdgeInsets.only(top: 10, left: 20),
                  alignment: Alignment.topLeft,
                  child: Text(
                    widget.title,
                    style: TextStyle(color: TColor.secondaryText, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
