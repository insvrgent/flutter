import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool auth = false;
  int pageIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: this.pageIndex);
  }

  Widget buildUnauthScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Theme.of(context).primaryColor, Theme.of(context).accentColor],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Fluttergram",
                style: TextStyle(fontSize: 24, color: Colors.white),
              ),
            ),
            GestureDetector(
              onTap: () async {
                final url = Uri.parse('https://dev.api.kedaimaster.com/item/get-cafe-items/galauers');
                final response = await http.get(url);

                if (response.statusCode == 200) {
                  // If the server returns a 200 OK response, parse the JSON.
                  final responseData = json.decode(response.body);
                  print('Response data: $responseData');
                  // You can now use the responseData to update your UI or state.
                  setState(() {
                    auth = true; // Set auth to true after successful API call
                  });
                } else {
                  // If the server did not return a 200 OK response, throw an exception.
                  print('Failed to load data');
                }
              },
              child: Container(
                width: MediaQuery.of(context).size.width * .9,
                height: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assets/images/google-login.png')),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildAuthScreen() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Gram'),
      ),
      body: PageView(
        controller: pageController,
        children: [
          Text('Timeline'),
          Text('Search'),
          Text('Post'),
          Text('Notifications'),
          Text('Profile'),
        ],
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: this.pageIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).primaryColor,
        onTap: (index) {
          setState(() {
            this.pageIndex = index;
          });
          pageController.animateToPage(index, duration: Duration(milliseconds: 300), curve: Curves.easeIn);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Timeline'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.photo_camera,
                size: 32,
              ),
              label: 'Upload'),
          BottomNavigationBarItem(icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(icon: Icon(Icons.account_circle), label: 'Profile'),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: auth ? buildAuthScreen() : buildUnauthScreen(),
    );
  }
}
