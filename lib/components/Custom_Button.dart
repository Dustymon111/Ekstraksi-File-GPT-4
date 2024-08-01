import 'package:flutter/material.dart';

class CustomElevatedButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const CustomElevatedButton({
    Key? key,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return theme.colorScheme.onSurface.withOpacity(0.38);
          }
          return theme.colorScheme.primary;
        }),
        foregroundColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.disabled)) {
            return theme.colorScheme.onSurface.withOpacity(0.18);
          }
          return theme.colorScheme.onPrimary;
        }),
        padding: WidgetStateProperty.all(
            EdgeInsets.symmetric(horizontal: 24, vertical: 12)),
        textStyle: WidgetStateProperty.all(TextStyle(fontSize: 16)),
      ),
      onPressed: onPressed,
      child: Text(
        label,
        style: TextStyle(
          fontSize: 16,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }
}
