import 'package:amplify_instagram/components/navigatior_page.dart';
import 'package:amplify_instagram/utils/navigation_view.dart';
import 'package:flutter/material.dart';

import 'shopping.dart';

NavigationView shoppingNavigationView = NavigationView(
  title: 'Shopping',
  builder: ({
    required GlobalKey<NavigatorState> navigatorKey,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) =>
      NavigatorPage(
    navigatorKey: navigatorKey,
    child: Shopping()
  ),
  icon: Icon(Icons.shopping_bag_outlined),
  navigatorKey: GlobalKey<NavigatorState>(),
  scaffoldKey: GlobalKey<ScaffoldState>(),
);