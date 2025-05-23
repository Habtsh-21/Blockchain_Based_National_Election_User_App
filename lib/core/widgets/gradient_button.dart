import 'package:flutter/material.dart';

class GradientButton extends StatefulWidget {
  const GradientButton({super.key, required this.text, required this.onPress});

  final Widget text;
  final Function() onPress;

  @override
  State<GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<GradientButton> {
  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return SizedBox(
      width: double.infinity,
      height: height * 0.055,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.all(0),
          shape: const RoundedRectangleBorder(),
          elevation: 2,
        ),
        onPressed: widget.onPress,
        child: Ink(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 97, 7, 149),
                Color.fromARGB(255, 152, 1, 114),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Container(
            alignment: Alignment.center,
            child: widget.text
          ),
        ),
      ),
    );
  }
}
