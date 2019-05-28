import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Table Tutorial',
      home: TableTutorial(),
    );
  }
}

class User {
  final String login;
  final String avatarUrl;
  final int id;
  User._({this.login, this.avatarUrl, this.id});
  factory User.fromJson(Map<String, dynamic> json) {
    return new User._(
      login: json['login'],
      avatarUrl: json['avatar_url'],
      id: json['id'],
    );
  }
}

class TableTutorial extends StatefulWidget {
  @override
  _TableTutorialState createState() => _TableTutorialState();
}

class _TableTutorialState extends State<TableTutorial> {
  List<User> list = List();
  var isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  _fetchUsers() async {
    setState(() {
      isLoading = true;
    });
    final response = await http.get("https://api.github.com/users?since=0");
    if (response.statusCode == 200) {
      list = (json.decode(response.body) as List)
          .map((data) => new User.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    } else {
      throw Exception('Failed to load users from github');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Flutter Table Tutorial"),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(8.0),
          child: RaisedButton(
            child: new Text("Fetch Users"),
            onPressed: _fetchUsers,
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    contentPadding: EdgeInsets.all(10.0),
                    leading: new Image.network(
                      list[index].avatarUrl,
                      fit: BoxFit.cover,
                      height: 50.0,
                      width: 50.0,
                    ),
                    title: new Text(list[index].login),
                  );
                }));
  }
}
