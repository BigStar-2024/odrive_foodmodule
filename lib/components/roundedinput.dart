import 'package:flutter/material.dart';

import '../themes/theme.dart';

class RoundedTextField extends StatelessWidget {
  final String hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final TextEditingController controller;
  final bool error;

  const RoundedTextField(
      {required this.hintText,
        this.keyboardType,
        this.obscureText = false,
        required this.controller,
        required this.error});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        // hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
        //   color: Theme.of(context).colorScheme.onSecondary,
        // ),
        hintText: hintText,
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(15),
        //     borderSide: BorderSide(color: errorColor)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: error
              ? BorderSide(color: MyAppColors.errorColor)
              : BorderSide(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }
}

class RoundedPasswordField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final void Function(String)? onChanged;
  final bool error;

  const RoundedPasswordField(
      {required this.hintText,
        required this.controller,
        required this.onChanged,
        required this.error});

  @override
  _RoundedPasswordFieldState createState() => _RoundedPasswordFieldState();
}

class _RoundedPasswordFieldState extends State<RoundedPasswordField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isObscure,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: widget.hintText,
        // hintStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
        //   color: Theme.of(context).colorScheme.onSecondary,
        // ),
        // border: OutlineInputBorder(
        //     borderRadius: BorderRadius.circular(15),
        //     borderSide: widget.error
        //         ? BorderSide(color: errorColor)
        //         : BorderSide(color: greyShade3)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: widget.error
              ? BorderSide(color: MyAppColors.errorColor)
              : BorderSide(color: Theme.of(context).colorScheme.onPrimary),
        ),
        suffixIcon: IconButton(
          icon: Icon(_isObscure ? Icons.visibility : Icons.visibility_off,),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
      onChanged: widget.onChanged,
    );
  }
}