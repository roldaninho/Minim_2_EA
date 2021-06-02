import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:unihub_app/controllers/feed_controller.dart';
import 'package:unihub_app/models/feedPublication.dart';
import 'package:unihub_app/screens/addOffer/addOffer.dart';
import 'package:unihub_app/widgets/feedPostSection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class FeedScreen extends StatefulWidget {
  Feed createState() => Feed();
}

class Feed extends State<FeedScreen> {
  String username;
  List<FeedPublication> pubsList;

  @override
  void initState() {
    getUsername();
    //Aquí se llama a la API cuando cargamos esta vista
    super.initState();
  }

  getUsername() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      this.username = prefs.getString('username');
    });
    return this.username;
  }

  final TextEditingController contentController = TextEditingController();

  Future<List<FeedPublication>> getAllFeeds() async {
    http.Response response = await FeedController().getFeedPubs();
    List<FeedPublication> preFeedList = [];
    for (var feedPub in jsonDecode(response.body)) {
      preFeedList.add(FeedPublication.fromMap(feedPub));
    }
    return preFeedList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<FeedPublication>>(
      future: getAllFeeds(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Feed"),
              ),
              body: SafeArea(
                  child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data.reversed.elementAt(index).username ==
                            this.username) {
                          this.pubsList = new List<FeedPublication>.from(
                              snapshot.data.reversed);
                          return new Dismissible(
                              key: ObjectKey(this.pubsList.elementAt(index)),
                              child: new FeedPost(
                                  this.pubsList.elementAt(index).id,
                                  this.pubsList.elementAt(index).username,
                                  this.pubsList.elementAt(index).content,
                                  this
                                      .pubsList
                                      .elementAt(index)
                                      .publicationDate,
                                  this.pubsList.elementAt(index).likes,
                                  this.pubsList.elementAt(index).comments,
                                  this.username),
                              confirmDismiss: (direction) {
                                if (this.pubsList.elementAt(index).username ==
                                    this.username) {
                                  return showDeletePostAlertDialog(
                                      context, index);
                                } else {
                                  return null;
                                }
                              },
                              onDismissed: (direction) {});
                        } else {
                          return new FeedPost(
                              snapshot.data.reversed.elementAt(index).id,
                              snapshot.data.reversed.elementAt(index).username,
                              snapshot.data.reversed.elementAt(index).content,
                              snapshot.data.reversed
                                  .elementAt(index)
                                  .publicationDate,
                              snapshot.data.reversed.elementAt(index).likes,
                              snapshot.data.reversed.elementAt(index).comments,
                              this.username);
                        }
                      })),
              floatingActionButton: FloatingActionButton(
                heroTag: "btnAddFeed",
                child: Icon(Icons.add),
                onPressed: () {
                  showNewPostAlertDialog(context);
                },
              ));
        } else {
          return Scaffold(
              appBar: AppBar(
                title: Text("Feed"),
              ),
              body: Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              /*child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Text('No posts available')],
              )),*/
              floatingActionButton: FloatingActionButton(
                heroTag: "btnAddFeed",
                child: Icon(Icons.add),
                onPressed: () {
                  showNewPostAlertDialog(context);
                },
              ));
        }
      },
    );
  }

  showNewPostAlertDialog(BuildContext context) {
    contentController.text = '';
    // set up the buttons
    Widget submitButton = TextButton(
        child: Text("Create new post"),
        onPressed: () async {
          //Submit post
          http.Response response = await FeedController().createFeedPub(
              this.username, contentController.text, DateTime.now().toString());
          if (response.statusCode == 200) {
            createToast('Post correctly uploaded', Colors.green);
            setState(() {
              print(jsonDecode(response.body));
              pubsList.insert(
                  0, FeedPublication.fromMap(jsonDecode(response.body)));
            });
            Navigator.pop(context);
          }
        });

    Widget dismissButton = TextButton(
      child: Text("Discard post"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
        content: TextFormField(
          controller: contentController,
          keyboardType: TextInputType.multiline,
          minLines: 4,
          maxLines: null,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: 'New post',
            floatingLabelBehavior: FloatingLabelBehavior.always,
          ),
        ),
        actions: [dismissButton, submitButton]);

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showDeletePostAlertDialog(BuildContext context, int index) {
    // set up the buttons
    Widget submitButton = TextButton(
      child: Text("Yes"),
      onPressed: () async {
        //delete post
        await FeedController()
            .deleteFeedPost(this.pubsList.elementAt(index).id)
            .whenComplete(() {
          setState(() {
            this.pubsList.removeAt(index);
          });
          Navigator.pop(context);
        });
      },
    );
    Widget dismissButton = TextButton(
      child: Text("No"),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
        content: Text('Are you sure that you want to delete this post?'),
        actions: [dismissButton, submitButton]);

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
