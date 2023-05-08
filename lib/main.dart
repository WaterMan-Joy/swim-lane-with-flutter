import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/widgets/error_text.dart';
import 'package:flutter_swim_lane/core/common/widgets/loader.dart';
import 'package:flutter_swim_lane/core/feature/auth/controller/auth_controller.dart';
import 'package:flutter_swim_lane/core/feature/auth/screens/login_screen.dart';
import 'package:flutter_swim_lane/core/feature/home/screens/home.dart';
import 'package:flutter_swim_lane/route_master.dart';
import 'package:flutter_swim_lane/router.dart';
import 'package:routemaster/routemaster.dart';
import 'firebase_options.dart';
import 'models/user_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(ProviderScope(child: const MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getData(WidgetRef ref, User data) async {
    userModel = await ref
        .watch(authControllerProvider.notifier)
        .getUserData(data.uid)
        .first;
    ref.read(userProvider.notifier).update((state) => userModel);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
        data: (user) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Swim Lain',
            theme: ThemeData(useMaterial3: true),
            routerDelegate: RoutemasterDelegate(
              routesBuilder: (context) {
                if (user != null) {
                  getData(ref, user);
                  if (userModel != null) {
                    return loggedInRoute;
                  }
                }
                return loggedOutRoute;
              },
            ),
            routeInformationParser: RoutemasterParser(),
          );
        },
        error: (error, stackTrace) {
          return ErrorText(error: error.toString());
        },
        loading: () => Loader());
  }
}
