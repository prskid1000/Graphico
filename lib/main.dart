import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    theme: ThemeData.dark(),
    initialRoute: 'Login',
    routes: {
      'Login': (context) => Login(),
      'Signup': (context) => Signup(),
      'Forgot': (context) => Forgot(),
      'Home': (context) => Home(),
      'About': (context) => About(),
    },
    debugShowCheckedModeBanner: false,
  ));
}

final FirebaseAuth mAuth = FirebaseAuth.instance;
User user;
List<int> ed1 = new List();
List<int> ed2 = new List();
List<int> vtx = new List();

class Login extends StatelessWidget {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Graphico'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Log In',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                FlatButton(
                  onPressed: (){
                    Navigator.pushNamed(context, 'Forgot');
                  },
                  textColor: Colors.green,
                  child: Text('Forgot Password?'),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text('Log In'),
                      onPressed: () async
                      {
                        await LogInAuth();
                        if(user != null)
                          if(user.emailVerified == true)
                          {
                            Navigator.pushNamedAndRemoveUntil(context, "Home", (r) => false);
                          }
                      },
                    )),
                Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      children: <Widget>[
                        Text('Does not have account?'),
                        FlatButton(
                          textColor: Colors.green,
                          child: Text(
                            'Sign Up',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(context, "Signup", (r) => false);
                          },
                        )
                      ],
                    ))
              ],
            )));
  }

  void LogInAuth() async
  {
    try
    {
      await mAuth.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
      user =  mAuth.currentUser;
      //print(user.toString());
    }
    catch(e)
    {
      print(e.toString());
    }
    finally
        {
          // ignore: control_flow_in_finally
          return;
        }
  }

}

class Signup extends StatelessWidget {

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Graphico'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),

                Container(
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
                  child: TextFormField(
                    obscureText: true,
                    controller: passwordController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Password',
                    ),
                  ),
                ),
                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text('Sign Up'),
                      onPressed: () {
                        SignUpAuth();

                        Navigator.pushNamedAndRemoveUntil(context, "Login", (r) => false);
                      },
                    )),
                Container(
                    child: Row(
                      children: <Widget>[
                        Text('Already have an account?'),
                        FlatButton(
                          textColor: Colors.green,
                          child: Text(
                            'Log In',
                            style: TextStyle(fontSize: 20),
                          ),
                          onPressed: () {
                            Navigator.pushNamedAndRemoveUntil(context, "Login", (r) => false);
                          },
                        )
                      ],
                      mainAxisAlignment: MainAxisAlignment.center,
                    ))
              ],
            )));
  }

  void SignUpAuth() async
    {
      try
      {
        await mAuth.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
        user = mAuth.currentUser;
        await user.sendEmailVerification();
      }
      catch(e)
      {
        print(e.toString());
      }
    }
}

class Forgot extends StatelessWidget {
  TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Graphico'),
        ),
        body: Padding(
            padding: EdgeInsets.all(10),
            child: ListView(
              children: <Widget>[
                Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Forgot Password',
                      style: TextStyle(fontSize: 20),
                    )),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'User Name',
                    ),
                  ),
                ),

                Container(
                    height: 50,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: RaisedButton(
                      textColor: Colors.white,
                      color: Colors.green,
                      child: Text('Reset'),
                      onPressed: () async {
                        Reset();
                        Navigator.pushNamed(context, 'Login');
                      },
                    )),
              ],
            )));
  }

  void Reset() async
  {
    try
    {
      await mAuth.sendPasswordResetEmail(email: emailController.text);
    }
    catch(e)
    {
      print(e.toString());
    }
  }
}

class Home extends StatelessWidget {

  TextEditingController v = TextEditingController();
  TextEditingController e1 = TextEditingController();
  TextEditingController e2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graphico'),
      ),
      body: Center(
        child: CustomPaint(
          painter: OpenPainter(),
        ),
      ),
      drawer: Drawer(
        // Add a ListView to the drawer. This ensures the user can scroll
        // through the options in the drawer if there isn't enough vertical
        // space to fit everything.
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.all(10),
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.green,
              ),
              child: Center(
                  child: Icon(
                    Icons.home,
                    color: Colors.white,
                    size: 128,
                  ),
              ),
            ),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  'Vertex',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child:TextFormField(
                  controller: v,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Vertex',
                  ),
                ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.green,
                child: Text('Add'),
                onPressed: () {
                           int point = int.parse(v.text);
                           vtx.add(point);
                           Navigator.pushNamedAndRemoveUntil(context, "Home", (r) => false);
                        },
                    ),
            ),
            Center(
              child:
              const Divider(
                color: Colors.green,
                height: 20,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
            ),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Text(
                  'Edge',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child:TextFormField(
                controller: e1,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Start Vertex',
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child:TextFormField(
                controller: e2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'End Vertex',
                ),
              ),
            ),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              child: RaisedButton(
                textColor: Colors.white,
                color: Colors.green,
                child: Text('Add'),
                onPressed: () {
                  int x = int.parse(e1.text);
                  int y = int.parse(e2.text);
                  ed1.add(x);
                  ed2.add(y);
                  Navigator.pushNamedAndRemoveUntil(context, "Home", (r) => false);
                },
              ),
            ),
            Center(
              child:
              const Divider(
                color: Colors.green,
                height: 20,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
            ),
            Center(
              child: Column(
                    children: <Widget>[
                      FlatButton(
                        textColor: Colors.green,
                        child: Text(
                          'About',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          Navigator.pushNamedAndRemoveUntil(context, "About", (r) => false);
                        },
                      ),
                      FlatButton(
                        textColor: Colors.green,
                        child: Text(
                          'Reset',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          vtx.clear();
                          ed1.clear();
                          ed2.clear();
                          Navigator.pushNamedAndRemoveUntil(context, "Home", (r) => false);
                        },
                      ),
                      FlatButton(
                        textColor: Colors.green,
                        child: Text(
                          'Exit',
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          SystemNavigator.pop();
                        },
                      ),
                    ],
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class About extends StatelessWidget {
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Graphico'),
    ),
    body: Padding(
      padding: EdgeInsets.all(50),
      child: ListView(
          children: <Widget>[
            Center(
              child:
              const Divider(
                color: Colors.green,
                height: 20,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
            ),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(30,10,30,10),
                child: Text(
                  'I am a Data Science and DevOps enthusiast , Web developer , Graphics designer',
                  style: TextStyle(fontSize: 20),
                )),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.fromLTRB(30,10,30,10),
                child: Text(
                  'and a Multi-Platform App developer.',
                  style: TextStyle(fontSize: 20),
                )),
            Center(
              child:
              const Divider(
                color: Colors.green,
                height: 20,
                thickness: 2,
                indent: 20,
                endIndent: 20,
              ),
            ),
            Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(10),
                child: Row(
                  children: <Widget>[
                    IconButton(
                        icon: FaIcon(FontAwesomeIcons.github),
                        iconSize: 48,
                        onPressed: () {
                          launch("https://github.com/prskid1000");
                        }
                    ),
                    IconButton(
                        icon: FaIcon(FontAwesomeIcons.dochub),
                        iconSize: 48,
                        onPressed: () {
                          launch("https://hub.docker.com/u/prskid1000");
                        }
                    ),
                    IconButton(
                        icon: FaIcon(FontAwesomeIcons.facebook),
                        iconSize: 48,
                        onPressed: () {
                          launch("https://www.facebook.com/prskid1000");
                        }
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.center,
                ))
            ]
      ),
    ),
    drawer: Drawer(
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Center(
              child: Icon(
                Icons.home,
                color: Colors.white,
                size: 128,
              ),
            ),
          ),
          Center(
            child: Column(
              children: <Widget>[
                FlatButton(
                  textColor: Colors.green,
                  child: Text(
                    'Home',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    Navigator.pushNamedAndRemoveUntil(context, "Home", (r) => false);
                  },
                ),
                FlatButton(
                  textColor: Colors.green,
                  child: Text(
                    'Exit',
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    SystemNavigator.pop();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
}

class Vertex
{
  List<double> xset = new List(24);
  List<double> yset = new List(24);

  Vertex()
  {
    xset[0] = -200;
    xset[1] = -100;
    xset[2] = 0;
    xset[3] = 100;

    xset[4] = -200;
    xset[5] = -100;
    xset[6] = 0;
    xset[7] = 100;

    xset[8] = -200;
    xset[9] = -100;
    xset[10] = 0;
    xset[11] = 100;

    xset[12] = -200;
    xset[13] = -100;
    xset[14] = 0;
    xset[15] = 100;

    xset[16] = -200;
    xset[17] = -100;
    xset[18] = 0;
    xset[19] = 100;

    yset[0] = -200;
    yset[1] = -200;
    yset[2] = -200;
    yset[3] = -200;

    yset[4] = -100;
    yset[5] = -100;
    yset[6] = -100;
    yset[7] = -100;

    yset[8] = 0;
    yset[9] = 0;
    yset[10] = 0;
    yset[11] = 0;

    yset[12] = 100;
    yset[13] = 100;
    yset[14] = 100;
    yset[15] = 100;

    yset[16] = 200;
    yset[17] = 200;
    yset[18] = 200;
    yset[19] = 200;

  }
}

class OpenPainter extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {

    final paint = Paint();
    final textStyle = TextStyle(color: Colors.white, fontSize: 10);
    Vertex v = new Vertex();

    List colors = [Colors.orange, Colors.pink, Colors.lightBlueAccent];
    Random random = new Random();

    for(var i = 0; i < ed1.length; i++)
    {
      //print(vtx.toString());
      var point1 = Offset(v.xset[ed1[i]] + 50 , v.yset[ed1[i]] + 50);
      var point2 = Offset(v.xset[ed2[i]] + 50 , v.yset[ed2[i]] + 50);
      paint.color = colors[random.nextInt(3)];
      canvas.drawLine(point1, point2, paint);
    }

    int count = 0;

    for(var i = 0; i < 20; i++)
    {
      //print(vtx.toString())
      if(count <= 9)
        {
          var textSpan = TextSpan(text: (count++).toString(), style: textStyle);
          var textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
          textPainter.layout(minWidth: 0, maxWidth: size.width);
          var offset = Offset(v.xset[i] - 3 + 50 , v.yset[i] - 5 + 50);
          textPainter.paint(canvas, offset);
        }
      else
        {
          var textSpan = TextSpan(text: (1).toString(), style: textStyle);
          var textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
          textPainter.layout(minWidth: 0, maxWidth: size.width);
          var offset = Offset(v.xset[i] - 3 + 50 , v.yset[i] - 5 + 50);
          textPainter.paint(canvas, offset);

          textSpan = TextSpan(text: (count++ - 10).toString(), style: textStyle);
          textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
          textPainter.layout(minWidth: 0, maxWidth: size.width);
          offset = Offset(v.xset[i] + 52 , v.yset[i] - 5 + 50);
          textPainter.paint(canvas, offset);
        }
    }

    paint.color = Colors.green;
    for(var i in vtx)
      {
        //print(vtx.toString());
        var point = Offset(v.xset[i] + 50 , v.yset[i] + 50);
        canvas.drawCircle(point, 10, paint);
      }

      for(var i in vtx)
        {
          var textSpan = TextSpan(text: String.fromCharCode(65 + i), style: textStyle);
          var textPainter = TextPainter(text: textSpan, textDirection: TextDirection.ltr);
          textPainter.layout(minWidth: 0, maxWidth: size.width);
          var offset = Offset(v.xset[i] - 3 + 50 , v.yset[i] - 5 + 50);
          textPainter.paint(canvas, offset);
        }

  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
