import 'package:amplify_instagram/components/navigatior_page.dart';
import 'package:amplify_instagram/utils/navigation_view.dart';
import 'package:flutter/material.dart';

import 'profile.dart';

NavigationView profileNavigationView = NavigationView(
  title: 'Profile',
  builder: ({
    required GlobalKey<NavigatorState> navigatorKey,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) =>
      NavigatorPage(
    navigatorKey: navigatorKey,
    child: Profile()
  ),
  icon: Icon(Icons.person),
  navigatorKey: GlobalKey<NavigatorState>(),
  scaffoldKey: GlobalKey<ScaffoldState>(),
);