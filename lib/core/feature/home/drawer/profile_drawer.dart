import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/feature/auth/controller/auth_controller.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void signOut(WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user.profirePic),
              radius: 70,
            ),
            SizedBox(height: 10),
            Text('${user.name}'),
            SizedBox(height: 30),
            ListTile(
              title: Text('프로필 수정'),
              leading: Icon(Icons.person),
              onTap: () {},
            ),
            ListTile(
              title: Text('로그아웃'),
              leading: Icon(Icons.logout),
              onTap: () => signOut(ref),
            ),
          ],
        ),
      ),
    );
  }
}
