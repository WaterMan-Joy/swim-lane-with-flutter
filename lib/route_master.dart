import 'package:flutter/material.dart';
import 'package:flutter_swim_lane/core/feature/auth/screens/login_screen.dart';
import 'package:flutter_swim_lane/core/feature/home/screens/home.dart';
import 'package:flutter_swim_lane/core/feature/lane/screens/create_lane_screen.dart';
import 'package:flutter_swim_lane/core/feature/lane/screens/edit_lane_screen.dart';

import 'package:flutter_swim_lane/core/feature/lane/screens/lane_screen.dart';
import 'package:flutter_swim_lane/core/feature/lane/screens/mod_tools_screen.dart';
import 'package:routemaster/routemaster.dart';

import 'core/feature/home/drawer/my_lane_list_screen.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => MaterialPage(
        child: HomeScreen(),
        // paths: ['/feed', '/settings'],
      ),

  '/create-lane': (_) => MaterialPage(child: CreateLaneScreen()),
  '/my-lane-list-screen': (_) => MaterialPage(child: MyLaneListScreen()),
  '/:name': (route) => MaterialPage(
        child: LaneScreen(
          name: route.pathParameters['name']!,
        ),
      ),
  '/mod-tools/:name': (routeData) => MaterialPage(
        child: ModToolsScreen(
          name: routeData.pathParameters['name']!,
        ),
      ),
  '/edit-lane/:name': (routeData) => MaterialPage(
        child: EditLaneScreen(
          name: routeData.pathParameters['name']!,
        ),
      ),

  // '/feed/profile/:id': (info) => MaterialPage(
  //   child: ProfilePage(id: info.pathParameters['id'])
  // ),
});
