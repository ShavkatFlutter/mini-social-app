import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DeleteComment extends StatelessWidget {
  final void Function()? onTap;
  const DeleteComment({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(Icons.cancel_outlined, size: 18, color: Colors.red[200]),
    );
  }
}
