import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(profileViewModelProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Center(
        child: user == null
            ? ElevatedButton(
          onPressed: () async {
            await ref
                .read(profileViewModelProvider.notifier)
                .signInWithGoogle();
          },
          child: const Text('Sign in with Google'),
        )
            : Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (user.photoURL != null)
              CircleAvatar(
                backgroundImage: NetworkImage(user.photoURL!),
                radius: 40,
              ),
            const SizedBox(height: 16),
            Text('Welcome, ${user.displayName ?? "User"}'),
            Text('Email: ${user.email ?? "No email"}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
              },
              child: const Text('Sign Out'),
            ),
          ],
        ),
      ),
    );
  }
}
