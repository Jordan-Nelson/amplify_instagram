import 'package:amplify_instagram/components/navigatior_page.dart';
import 'package:amplify_instagram/utils/navigation_view.dart';
import 'package:flutter/material.dart';

import 'reels.dart';

NavigationView reelsNavigationView = NavigationView(
  title: 'Reels',
  builder: ({
    required GlobalKey<NavigatorState> navigatorKey,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) =>
      NavigatorPage(
    navigatorKey: navigatorKey,
    child: Reels()
  ),
  icon: Icon(Icons.video_collection),
  navigatorKey: GlobalKey<NavigatorState>(),
  scaffoldKey: GlobalKey<ScaffoldState>(),
);