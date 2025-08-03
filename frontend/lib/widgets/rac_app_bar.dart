import 'package:flutter/material.dart';
import 'package:frontend/_services/auth_service.dart';

class RacAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;

  const RacAppBar({super.key, required this.title, this.actions});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      title: Text(title),
      actions: actions ?? [Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () => { 
            AuthService().logout()
              .then((value) => Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false)),
          }, 
          child: const Icon(Icons.logout)),
      ), ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}