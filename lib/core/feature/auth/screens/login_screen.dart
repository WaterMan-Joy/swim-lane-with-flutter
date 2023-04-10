// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_swim_lane/core/common/layouts/default_layout.dart';
import 'package:flutter_swim_lane/core/common/widgets/loader.dart';
import 'package:flutter_swim_lane/core/feature/auth/controller/auth_controller.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    final user = ref.watch(userProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('스윔 레인'),
      ),
      body: DefaultLayout(
        child: isLoading
            ? Loader()
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _Icon(),
                    _LoginButton('구글 로그인'),
                    // _RegisterButton('회원가입'),
                    Text('name: ${user?.name ?? ''}'),
                  ],
                ),
              ),
      ),
    );
  }
}

class _Icon extends StatelessWidget {
  const _Icon();

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.pool,
      size: 300,
    );
  }
}

class _LoginButton extends ConsumerWidget {
  final String text;
  const _LoginButton(
    this.text,
  );

  void signInWithGoogle(BuildContext context, WidgetRef ref) {
    ref.read(authControllerProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton(
        child: Text(text),
        onPressed: () {
          return signInWithGoogle(context, ref);
        });
  }
}
