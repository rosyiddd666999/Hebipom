import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final void Function() onPressed;
  final String label;
  final bool isOutline;
  final Icon? icon;
  final bool isSquare;
  final bool isPrimaryColor;

  const MyButton({
    super.key,
    required this.onPressed,
    this.label = '',
    this.isOutline = false,
    this.icon,
    this.isSquare = true,
    this.isPrimaryColor = true,
  });

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    final Color baseColor = isPrimaryColor
        ? colorScheme.primary
        : colorScheme.surfaceContainerHighest;

    final Color contentColor = isOutline
        ? baseColor
        : isPrimaryColor
        ? colorScheme.onPrimary
        : colorScheme.onSurface;

    final Color buttonBackgroundColor = isOutline
        ? Colors.transparent
        : baseColor;

    final Border? border = isOutline
        ? Border.all(color: baseColor, width: 1.5)
        : null;

    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(16.0),
      child: Container(
        padding: label.isEmpty
            ? const EdgeInsets.all(12.0)
            : const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),

        decoration: BoxDecoration(
          color: buttonBackgroundColor,
          border: border,
          borderRadius: isSquare == true ? BorderRadius.circular(16.0) : null,
        ),

        child: Row(
          mainAxisSize: label.isEmpty ? MainAxisSize.min : MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            if (icon != null) Icon(icon!.icon, color: contentColor, size: 24),

            if (icon != null && label.isNotEmpty) const SizedBox(width: 8),

            if (label.isNotEmpty)
              Text(
                label.toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: contentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
