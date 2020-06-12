import 'package:flutter/material.dart';
import 'package:flutter_login_demo/pages/capstone_details.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser _user;
  List capstones = [
    'Capstone 1',
    'Capstone 2',
    'Capstone 3',
  ];
  GoogleSignIn _googleSignIn = new GoogleSignIn();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.orange,
      ),
      home: Scaffold(
        body: Container(
            color: Colors.orange[300],
            child: Center(
              child: _isLoggedIn
                  ? Stack(
                      children: <Widget>[
                        Scaffold(
                          backgroundColor: Colors.white,
                          appBar: AppBar(
                            title: Text("FPT Capstone Management"),
                          ),
                          drawer: Drawer(
                            child: ListView(
                              children: <Widget>[
                                DrawerHeader(
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Image.network(
                                          _googleSignIn.currentUser.photoUrl,
                                          height: 100.0,
                                          width: 100.0,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.centerRight,
                                        child: Text(
                                          _googleSignIn.currentUser.displayName,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10.0),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                ListTile(
                                  title: Text("Logout"),
                                  onTap: () {
                                    gooleSignout();
                                  },
                                )
                              ],
                            ),
                          ),
                          //------------------------------------------------end of drawer
                          body: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  'available capstone'.toUpperCase(),
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 15),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: capstones.length,
                                    shrinkWrap: true,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Container(
                                        margin: EdgeInsets.only(bottom: 15),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey[300],
                                              offset: Offset(0, 0),
                                              blurRadius: 5,
                                            ),
                                          ],
                                        ),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Material(
                                            child: InkWell(
                                              highlightColor:
                                                  Colors.white.withAlpha(50),
                                              onTap: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        CapstoneDetails(),
                                                  ),
                                                );
                                              },
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                      topLeft:
                                                          Radius.circular(10),
                                                      topRight:
                                                          Radius.circular(10),
                                                    ),
                                                    child: Image.asset(
                                                      'assets/$index.jpg',
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                          capstones[index]
                                                              .toString()
                                                              .toUpperCase(),
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            color: Theme.of(
                                                                    context)
                                                                .primaryColor,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 5),
                                                        ),
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          //////////////////////////////////////////////////////////////
                        ),
                      ],
                    )
                  : Stack(
                      children: <Widget>[
                        Image.asset('assets/FPT.png'),
                        Container(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                SignInButton(
                                  Buttons.Google,
                                  onPressed: () {
                                    handleSignIn();
                                  },
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
            )),
      ),
    );
  }

  bool _isLoggedIn = false;

  Future<void> handleSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.getCredential(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    AuthResult result = (await _auth.signInWithCredential(credential));

    _user = result.user;

    setState(() {
      _isLoggedIn = true;
    });
  }

  Future<void> gooleSignout() async {
    await _auth.signOut().then((onValue) {
      _googleSignIn.signOut();
      setState(() {
        _isLoggedIn = false;
      });
    });
  }
}
