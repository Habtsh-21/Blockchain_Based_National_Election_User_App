import 'package:flutter/material.dart';

class Box1 extends StatefulWidget {
  final IconData iconData;
  final String text;
  final int amount;
  const Box1(
      {super.key,
      required this.iconData,
      required this.amount,
      required this.text});

  @override
  State<Box1> createState() => _Box1State();
}

class _Box1State extends State<Box1> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Column(
          children: [
            Icon(
              widget.iconData,
              size: width * 0.15,
              color: const Color.fromARGB(255, 153, 11, 134),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                '${widget.amount}',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22 * width / 420,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                widget.text,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18 * width / 420,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
