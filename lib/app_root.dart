import 'package:amplify_flutter/amplify.dart';
import 'features/profile/user_profile.dart';
import 'package:flutter/material.dart';

import 'features/auth/sign_in.dart';

class AppRoot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Amplify.Auth.getCurrentUser().then((value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => AuthenticatedRoot(),
          ),
        );
      }).catchError((error) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => SignInView(),
          ),
        );
      }),
      builder: (context, snapshot) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

class AuthenticatedRoot extends StatefulWidget {
  const AuthenticatedRoot({
    Key? key,
  }) : super(key: key);

  @override
  _AuthenticatedRootState createState() => _AuthenticatedRootState();
}

class NavigationBarView {
  Widget appBarTitle;
  Widget body;
  BottomNavigationBarItem bottomNavigationBarItem;
  FloatingActionButton? floatingActionButton;

  NavigationBarView({
    required this.appBarTitle,
    required this.body,
    required this.bottomNavigationBarItem,
    this.floatingActionButton,
  });
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
    List<NavigationBarView> _navigationBarViews = <NavigationBarView>[
      NavigationBarView(
        appBarTitle: Text('Home'),
        body: Scaffold(body: Center(child: Text('Home'))),
        bottomNavigationBarItem: BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
      ),
      NavigationBarView(
        appBarTitle: Text('Search'),
        body: Scaffold(body: Center(child: Text('Search'))),
        bottomNavigationBarItem: BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Search',
        ),
      ),
      NavigationBarView(
        appBarTitle: Text('Reels'),
        body: Scaffold(body: Center(child: Text('Reels'))),
        bottomNavigationBarItem: BottomNavigationBarItem(
          icon: Icon(Icons.video_collection),
          label: 'Reels',
        ),
      ),
      NavigationBarView(
        appBarTitle: Text('Shopping'),
        body: Scaffold(body: Center(child: Text('Shopping'))),
        bottomNavigationBarItem: BottomNavigationBarItem(
          icon: Icon(Icons.shopping_bag_outlined),
          label: 'Shopping',
        ),
      ),
      NavigationBarView(
        appBarTitle: Text('Profile'),
        body: UserProfile(),
        bottomNavigationBarItem: BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Amplify Instagram'),
      ),
      body: _navigationBarViews.elementAt(_selectedIndex).body,
      bottomNavigationBar: BottomNavigationBar(
        items: _navigationBarViews
            .map((view) => view.bottomNavigationBarItem)
            .toList(),
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      floatingActionButton:
          _navigationBarViews.elementAt(_selectedIndex).floatingActionButton,
    );
  }
}
