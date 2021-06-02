import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:unihub_app/controllers/feed_controller.dart';
import 'package:unihub_app/models/feedPublication.dart';
import 'package:unihub_app/models/sugerencia.dart';
import 'package:unihub_app/screens/addOffer/addOffer.dart';
import 'package:unihub_app/widgets/feedPostSection.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:unihub_app/widgets/sugerenciaPostSection.dart';

class SugerenciasScreen extends StatefulWidget {
  Sugerencias createState() => Sugerencias();
}

class Sugerencias extends State<SugerenciasScreen> {
  String username;
  List<SugerenciaPublication> pubsList;

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

  Future<List<SugerenciaPublication>> getAllSugerencias() async {
    http.Response response = await FeedController().getSugerenciaPubs();
    List<SugerenciaPublication> preSugerenciaList = [];
    for (var sugerenciaPub in jsonDecode(response.body)) {
      preSugerenciaList.add(SugerenciaPublication.fromMap(sugerenciaPub));
    }
    return preSugerenciaList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SugerenciaPublication>>(
      future: getAllSugerencias(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Scaffold(
              appBar: AppBar(
                title: Text("Sugerencias de los Usuarios"),
              ),
              body: SafeArea(
                  child: ListView.builder(
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        if (snapshot.data.reversed.elementAt(index).username ==
                            this.username) {
                          this.pubsList = new List<SugerenciaPublication>.from(
                              snapshot.data.reversed);
                          return new Dismissible(
                              key: ObjectKey(this.pubsList.elementAt(index)),
                              child: new SugerenciaPost(
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
                          return new SugerenciaPost(
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
        child: Text("Añadir Sugerencia"),
        onPressed: () async {
          //Submit post
          http.Response response = await FeedController().createSugerenciaPub(
              this.username, contentController.text, DateTime.now().toString());
          if (response.statusCode == 200) {
            createToast('Sugerencia añadida correctamente', Colors.green);
            setState(() {
              print(jsonDecode(response.body));
              pubsList.insert(
                  0, SugerenciaPublication.fromMap(jsonDecode(response.body)));
            });
            Navigator.pop(context);
          }
        });

    Widget dismissButton = TextButton(
      child: Text("Descartar Sugerencia"),
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
            labelText: 'Añadir Sugerencia',
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
            .deleteSugerenciaPost(this.pubsList.elementAt(index).id)
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
        content: Text('Seguro que desea eliminar la sugerencia?'),
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
