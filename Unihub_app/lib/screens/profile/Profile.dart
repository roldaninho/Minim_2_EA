import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:unihub_app/controllers/editProfile_controller.dart';
import 'package:unihub_app/models/user.dart';
import 'package:unihub_app/screens/editProfile/editProfile.dart';
import 'package:unihub_app/screens/login/login.dart';
import 'package:unihub_app/widgets/textSection.dart';

UserApp currentUser;
String imageUser;
Image usrImg;
bool myProfile;

class ProfileScreen extends StatefulWidget {
  /*const ProfileScreen(this.myProfile, this.username);
  final bool myProfile;
  final String username;*/
  Profile createState() => Profile();
}

class Profile extends State<ProfileScreen> {
  String username;

  @override
  void initState() {
    super.initState();
  }

  Future<UserApp> getDataFromUser() async {
    //if (this.widget.myProfile) {
    if (true) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      username = preferences.getString('username');
    }
    currentUser = UserApp.fromMap(
        jsonDecode(await EditProfileController().getProfile(username)));
    return currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getDataFromUser(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                appBar: AppBar(
                  title: Text("Your profile"),
                  actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.brush_rounded),
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfileScreen(),
                                  settings:
                                      RouteSettings(arguments: currentUser)));
                        }),
                    IconButton(
                        icon: Icon(Icons.settings),
                        onPressed: () {
                          //Nos lleva a settings
                        }),
                    IconButton(
                        icon: Icon(Icons.logout),
                        onPressed: () async {
                          logOut(context);
                        })
                  ],
                ),
                body: SafeArea(
                    child: Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        child: ListView(children: [
                          SizedBox(
                            height: 15,
                          ),
                          Center(
                              child: Stack(children: [
                            Container(
                                width: 130,
                                height: 130,
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        width: 4,
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor),
                                    boxShadow: [
                                      BoxShadow(
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          color: Colors.black.withOpacity(0.5),
                                          offset: Offset(0, 2))
                                    ],
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          currentUser.profilePhoto),
                                    ))),
                          ])),
                          SizedBox(
                            height: 15,
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              TextSection("Full name", currentUser.fullname),
                              TextSection(
                                  "Description", currentUser.description),
                              TextSection("Role", currentUser.role),
                              TextSection(
                                  "University",
                                  currentUser.university == null
                                      ? 'Not Selected'
                                      : currentUser.university),
                              TextSection(
                                  "Degree",
                                  currentUser.degree == null
                                      ? 'Not Selected'
                                      : currentUser.degree),
                              TextSection(
                                  "Subjects already done",
                                  currentUser.subjectsDone.length == 0
                                      ? 'None'
                                      : currentUser.subjectsDone
                                          .toSet()
                                          .toString()),
                              TextSection(
                                  "Subjects asking for",
                                  currentUser.subjectsRequested.length == 0
                                      ? 'None'
                                      : currentUser.subjectsRequested
                                          .toSet()
                                          .toString()),
                              TextSection("E-mail", currentUser.username),
                              TextSection("Phone", currentUser.phone),
                            ],
                          ),
                          TextButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all<Color>(Colors.red),
                            ),
                            child: Text(
                              'Delete your account',
                              style:
                                  TextStyle(fontSize: 20, color: Colors.white),
                            ),
                            onPressed: () async {
                              showAlertDialog(context);
                            },
                          )
                        ]))));
          } else {
            return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(),
                  )
                ]);
          }
        });
  }

  logOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    Navigator.of(context)
        .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
  }
}

showAlertDialog(BuildContext context) {
  TextEditingController passwordController = new TextEditingController();
  // set up the buttons
  Widget confirmButton = TextButton(
    child: Text("Confirm"),
    onPressed: () async {
      // Delete account checking if password is correct
      if (passwordController.text == currentUser.password) {
        SharedPreferences preferences = await SharedPreferences.getInstance();
        var username = preferences.getString('username');
        http.Response response =
            await EditProfileController().deleteProfile(username);
        if (response.statusCode == 200) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.clear();
          createToast("Account correctly deleted", Colors.green);
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/login', (Route<dynamic> route) => false);
        } else {
          createToast("Couldn't delete account", Colors.red);
        }
      } else {
        createToast("Wrong password", Colors.red);
      }
    },
  );
  Widget cancelButton = TextButton(
    child: Text("Cancel"),
    onPressed: () {
      Navigator.pop(context);
    },
  );

  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Are you sure you want to delete your account?"),
    content: TextFormField(
      controller: passwordController,
      validator: (val) => val.isEmpty ? 'Enter your name' : null,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.only(bottom: 3),
          labelText: "Please confirm with your password",
          floatingLabelBehavior: FloatingLabelBehavior.always),
    ),
    actions: [cancelButton, confirmButton],
  );

  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
