import 'package:amplify_instagram/components/navigatior_page.dart';
import 'package:amplify_instagram/utils/navigation_view.dart';
import 'package:flutter/material.dart';

import 'search.dart';

NavigationView searchNavigationView = NavigationView(
  title: 'Search',
  builder: ({
    required GlobalKey<NavigatorState> navigatorKey,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) =>
      NavigatorPage(
    navigatorKey: navigatorKey,
    child: Search()
  ),
  icon: Icon(Icons.search),
  navigatorKey: GlobalKey<NavigatorState>(),
  scaffoldKey: GlobalKey<ScaffoldState>(),
);