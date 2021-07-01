import '../utils/navigation_view.dart';

import 'home/home_navigation_view.dart';
import 'profile/profile_navigation_view.dart';
import 'reels/reels_navigation_view.dart';
import 'search/search_navigation_view.dart';
import 'shopping/shopping_navigation_view.dart';

List<NavigationView> navigationViews = [
  homeNavigationView,
  searchNavigationView,
  reelsNavigationView,
  shoppingNavigationView,
  profileNavigationView,
];

void popAllNavigators() {
  navigationViews.forEach((navigationView) {
      navigationView.navigatorKey.currentState?.popUntil((predicate) {
        return !navigationView.navigatorKey.currentState!.canPop();
      });
  });
}