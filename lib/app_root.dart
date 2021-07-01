import 'package:amplify_flutter/amplify.dart';
// import 'features/profile/user_profile.dart';
import 'package:flutter/material.dart';

import 'features/auth/sign_in.dart';
import 'features/navigation_views.dart';
import 'utils/navigation_view.dart';

class AppRoot extends StatefulWidget {
  @override
  _AppRootState createState() => _AppRootState();
}

class _AppRootState extends State<AppRoot> {
  @override
  void initState() {
    _initView();
    super.initState();
  }

  Future<void> _initView() async {
    try {
      await Amplify.Auth.getCurrentUser(); //.then((value) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => AuthenticatedRoot(),
        ),
      );
      // });
    } catch (e) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => SignInView(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: CircularProgressIndicator(),
    ));
  }
}

class AuthenticatedRoot extends StatefulWidget {
  const AuthenticatedRoot({
    Key? key,
  }) : super(key: key);

  @override
  _AuthenticatedRootState createState() => _AuthenticatedRootState();
}

class _AuthenticatedRootState extends State<AuthenticatedRoot> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isKeyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    return Column(
      children: <Widget>[
        Expanded(
          child: WillPopScope(
            onWillPop: () async => !await navigationViews[_selectedIndex]
                .navigatorKey
                .currentState!
                .maybePop(),
            child: Stack(
              children: navigationViews
                  .map(
                    (view) => Offstage(
                      offstage: navigationViews[_selectedIndex] != view,
                      child: view.builder(
                        navigatorKey: view.navigatorKey,
                        scaffoldKey: view.scaffoldKey,
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        isKeyboardOpen
            ? Container(height: 0)
            : Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).dividerColor,
                          blurRadius: 0.0,
                        ),
                      ],
                    ),
                    child: BottomNavigationBar(
                      currentIndex: _selectedIndex,
                      onTap: (index) => _onItemTapped(index),
                      type: BottomNavigationBarType.fixed,
                      items: navigationViews.map<BottomNavigationBarItem>(
                        (NavigationView navigationView) {
                          return BottomNavigationBarItem(
                            icon: navigationView.icon,
                            label: navigationView.title,
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ],
              ),
      ],
    );
  }
}
