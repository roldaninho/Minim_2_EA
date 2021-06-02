import 'package:flutter/material.dart';
import 'package:unihub_app/screens/profile/Profile.dart';
import '../forum/forum.dart';
import '../feed/feed.dart';
import '../search/search.dart';

class HomepageScreen extends StatefulWidget {
  Homepage createState() => Homepage();
}

class Homepage extends State<HomepageScreen> {
  int currentTab = 0;
  final List<Widget> screens = [
    FeedScreen(),
    //  Chat(),
    SearchScreen(),
    ProfileScreen()
  ];
  //
  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = FeedScreen();

  @override
  Widget build(BuildContext context) {
    if (ModalRoute.of(context).settings.arguments != null) {
      setState(() {
        currentTab = 3;
        currentScreen = ProfileScreen();
      });
    } else {}
    return Scaffold(
      body: SafeArea(
          child: PageStorage(
        child: currentScreen,
        bucket: bucket,
      )),
      floatingActionButton: FloatingActionButton(
        heroTag: "btnOffers",
        child: Icon(Icons.menu_book_outlined),
        elevation: currentTab == 4 ? 15.0 : 0.0,
        onPressed: () {
          setState(() {
            currentScreen = ForumScreen();
            currentTab = 4;
          });
        },
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 10,
        child: Container(
          height: 50,
          width: MediaQuery.of(context).size.width -
              MediaQuery.of(context).size.width * 0.2,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              MaterialButton(
                  minWidth: 50,
                  onPressed: () {
                    setState(() {
                      currentScreen = FeedScreen();
                      currentTab = 0;
                    });
                  },
                  child: Icon(
                    Icons.home_outlined,
                    color: currentTab == 0 ? Colors.blue : Colors.grey[400],
                  )),
              MaterialButton(
                  minWidth: 50,
                  onPressed: () {
                    setState(() {
                      currentScreen = SearchScreen();
                      currentTab = 1;
                    });
                  },
                  child: Icon(
                    Icons.search,
                    color: currentTab == 1 ? Colors.blue : Colors.grey[400],
                  )),
              MaterialButton(
                  minWidth: 50,
                  onPressed: () {
                    setState(() {
                      //currentScreen = ;
                      currentTab = 2;
                    });
                  },
                  child: Icon(
                    Icons.chat_bubble_outline,
                    color: currentTab == 2 ? Colors.blue : Colors.grey[400],
                  )),
              MaterialButton(
                  minWidth: 50,
                  onPressed: () {
                    setState(() {
                      currentScreen = ProfileScreen();
                      currentTab = 3;
                    });
                  },
                  child: Icon(
                    Icons.person_outlined,
                    color: currentTab == 3 ? Colors.blue : Colors.grey[400],
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
