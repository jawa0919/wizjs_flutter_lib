import 'package:flutter/material.dart';

import 'H5Page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      routes: <String, WidgetBuilder>{
        "/": (context) => MyHomePage(),
        "/H5": (context) => H5Page(),
        // "/Storage": (context) => StoragePage(),
        // "/explore": (context) => ExplorePage(),
        // "/demo/issues": (context) => IssuesPage(),
        // "/my": (context) => MyPage(),
      },
      onUnknownRoute: (RouteSettings settings) {
        return MaterialPageRoute(builder: (context) {
          return Scaffold(
            appBar: AppBar(title: Text(settings.name ?? "")),
            body: Center(child: Text("Page not found")),
          );
        });
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("wizjs_flutter_lib_example")),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: Text("H5"),
              onPressed: () {
                Navigator.of(context).pushNamed("/H5");
              },
            ),
            ElevatedButton(
              child: Text("Storage"),
              onPressed: () {
                Navigator.of(context).pushNamed("/Storage");
              },
            ),
          ],
        ),
      ),
    );
  }
}
