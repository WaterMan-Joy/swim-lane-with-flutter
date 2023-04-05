import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/layouts/default_layout.dart';
import 'package:flutter_swim_lane/core/feature/auth/controller/auth_controller.dart';
import 'package:flutter_swim_lane/core/feature/home/delegates/search_lane_delegate.dart';
import 'package:flutter_swim_lane/models/user_model.dart';
import 'package:go_router/go_router.dart';
import 'package:routemaster/routemaster.dart';

import '../drawer/favorite_lane_list_drawer.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
    setState(() {});
  }

  void navigateToMyLaneList(context) {
    Routemaster.of(context).push('/my-lane-list-screen');
  }

  void signOut() {
    ref.read(authControllerProvider.notifier).signOut();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    // print('HOME SCREEN ***** ${user}');
    // print('user : ${user}');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${user?.name ?? '이름 없음'} 님 환영합니다'),
        actions: [
          IconButton(
              onPressed: () => showSearch(
                  context: context, delegate: SearchLaneDelegate(ref)),
              icon: Icon(Icons.search)),
          IconButton(
            onPressed: () {},
            icon: CircleAvatar(
              backgroundImage: NetworkImage(user?.profirePic ?? ''),
            ),
          ),
        ],
        // leading: ElevatedButton(
        //   onPressed: () => navigateToMyLaneList(context),
        //   child: Icon(Icons.list_alt),
        // ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              onPressed: () => displayDrawer(context),
              icon: Icon(Icons.list),
            );
          },
        ),
      ),
      body: DefaultLayout(
        child: Center(
          child: Column(
            children: [
              Text(
                'SWIM LANE',
                style: TextStyle(fontSize: 50),
              ),
              Text('name: ${user?.name ?? ''}'),
              Text('name: ${user?.uid ?? ''}'),
              Text('name: ${user?.profirePic ?? ''}'),
              ElevatedButton(
                onPressed: () {
                  print('sign out');
                  return signOut();
                },
                child: Text('로그아웃'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.access_time_sharp),
        onPressed: () {},
      ),
      drawer: FavoriteLaneListDrawer(),
    );
  }
}

// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});

  

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final user = ref.watch(userProvider);
//     print(user);
//     return Scaffold(
//       appBar: AppBar(title: Text('스윔 레인')),
//       body: Center(
//         child: Text('name: ${user?.name ?? ''}'),
//       ),
//     );
//   }
// }
