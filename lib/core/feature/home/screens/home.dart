import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_swim_lane/core/common/constants/constants.dart';
import 'package:flutter_swim_lane/core/common/layouts/default_layout.dart';
import 'package:flutter_swim_lane/core/feature/auth/controller/auth_controller.dart';
import 'package:flutter_swim_lane/core/feature/home/delegates/search_lane_delegate.dart';
import 'package:flutter_swim_lane/core/feature/home/drawer/profile_drawer.dart';
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
  int _page = 0;

  void displayDrawer(BuildContext context) {
    Scaffold.of(context).openDrawer();
  }

  void displayEndDrawer(BuildContext context) {
    Scaffold.of(context).openEndDrawer();
  }

  void navigateToMyLaneList(context) {
    Routemaster.of(context).push('/my-lane-list-screen');
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    // print('HOME SCREEN ***** ${user}');
    // print('user : ${user}');
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('${user.name} 님 환영합니다'),
        actions: [
          IconButton(
              onPressed: () => showSearch(
                  context: context, delegate: SearchLaneDelegate(ref)),
              icon: Icon(Icons.search)),
          Builder(builder: (context) {
            return IconButton(
              icon: CircleAvatar(
                backgroundImage: NetworkImage(user.profilePic),
              ),
              onPressed: () => displayEndDrawer(context),
            );
          }),
        ],
        // leading: ElevatedButton(
        //   onPressed: () => navigateToMyLaneList(context),
        //   child: Icon(Icons.list_alt),
        // ),
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: Icon(Icons.list),
              onPressed: () => displayDrawer(context),
            );
          },
        ),
      ),
      body: Constants.tabWidgets[_page],
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.access_time_sharp),
        onPressed: () {},
      ),
      drawer: FavoriteLaneListDrawer(),
      endDrawer: ProfileDrawer(),
      bottomNavigationBar: CupertinoTabBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(
              icon: Icon(Icons.arrow_circle_up), label: "UP"),
          BottomNavigationBarItem(icon: Icon(Icons.post_add), label: "훈련 작성"),
        ],
        onTap: onPageChanged,
        currentIndex: _page,
      ),
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
