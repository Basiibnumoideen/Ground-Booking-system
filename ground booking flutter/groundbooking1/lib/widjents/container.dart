import 'package:flutter/material.dart';

@override
Widget buildContainer(BuildContext context, ontap, text) {
  return InkWell(
    onTap: ontap,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xFF108554),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            spreadRadius: 3,
            blurRadius: 4,
            offset: const Offset(1, 4),
          ),
        ],
      ),
      height: 80,
      width: MediaQuery.of(context).size.width / 2 - 40,
      child: Center(
          child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(color: Colors.white),
      )),
    ),
  );
}
