import 'package:flutter/material.dart';
import 'theme.dart';

class HomeBar extends StatelessWidget {
  final AppTheme theme;

  const HomeBar({super.key, required this.theme});

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
      title: Text(theme.title,
          style: const TextStyle(fontWeight: FontWeight.bold)),
      backgroundColor: theme.backgroundColor,
      foregroundColor: theme.foregroundColor,
    );
  }
}
