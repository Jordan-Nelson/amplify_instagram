import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_instagram/models/ModelProvider.dart';
import 'package:flutter/material.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  List<User>? users;

  Future fetchUsers() async {
    List<User> _users = await Amplify.DataStore.query(User.classType);
    setState(() {
      users = _users;
    });
  }

  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Search')),
      body: users == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : RefreshIndicator(
              onRefresh: fetchUsers,
              child: ListView.builder(
                itemCount: users!.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(users![index].name),
                    subtitle: Text('@' + users![index].username),
                  );
                },
              ),
            ),
    );
  }
}
