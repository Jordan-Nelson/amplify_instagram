import '../components/navigatior_page.dart';
import 'package:flutter/material.dart';

class NavigationView {
   NavigationView({
    required this.builder,
    required this.title,
    required this.icon,
    required this.navigatorKey,
    required this.scaffoldKey,
  });
  NavigatorPage Function({
    required GlobalKey<NavigatorState> navigatorKey,
    required GlobalKey<ScaffoldState> scaffoldKey,
  }) builder;
  String title;
  Widget icon;
  GlobalKey<NavigatorState> navigatorKey;
  GlobalKey<ScaffoldState> scaffoldKey;
  ScrollController? scrollController;

  scrollToTop() {
    return this.scrollController?.animateTo(
          0,
          duration: Duration(milliseconds: 250),
          curve: Curves.easeIn,
        );
  }

  canPop() {
    return this.navigatorKey.currentState?.canPop();
  }

  popUntilRoot() {
    this.navigatorKey.currentState?.popUntil((predicate) {
      return !navigatorKey.currentState!.canPop() ;
    });
  }

}