import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function()? onPressed;
  final String label;
  final bool isOutline;
  const MyButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.isOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.maxFinite,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutline
              ? Colors.transparent
              : Colors.orange.shade600,
          foregroundColor: isOutline ? Colors.orange.shade600 : Colors.white,
          side: isOutline
              ? const BorderSide(color: Colors.orange, width: 1.5)
              : null,
        ),
        child: Text(label.toUpperCase()),
      ),
    );
  }
}
