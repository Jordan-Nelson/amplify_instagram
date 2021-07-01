import 'package:amplify_instagram/components/navigatior_page.dart';
import 'package:amplify_instagram/utils/navigation_view.dart';
import 'package:flutter/material.dart';

import 'home.dart';

NavigationView homeNavigationView = NavigationView(
  title: 'Home',
  builder: ({
    required GlobalKey<NavigatorState> navigatorKey,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) =>
      NavigatorPage(
    navigatorKey: navigatorKey,
    child: Home()
  ),
  icon: Icon(Icons.home),
  navigatorKey: GlobalKey<NavigatorState>(),
  scaffoldKey: GlobalKey<ScaffoldState>(),
);