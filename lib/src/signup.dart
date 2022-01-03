import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../welcome.dart';
import 'Widget/signupContainer.dart';



final _auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController number = TextEditingController();
  TextEditingController codeController = TextEditingController();

  Future<bool> loginUser(String phone, BuildContext context) async{

    _auth.verifyPhoneNumber(
        phoneNumber:"+91 $phone",
        timeout: Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async{
          Navigator.of(context).pop();

          final result = await _auth.signInWithCredential(credential);

          final user = result.user;

          if(user != null){

            Navigator.push(context, MaterialPageRoute(
                          builder: (context) => WelcomePage()
                      ));
          }else{
            print("Error");
          }

          //This callback would gets called when verification is done auto maticlly
        },
        verificationFailed: (FirebaseAuthException exception){
          print(exception);
        },
        codeSent: (String verificationId, int forceResendingToken){
          showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) {
                return AlertDialog(
                  title: Text("Give the code?"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        controller: codeController,
                      ),
                    ],
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Confirm"),
                      textColor: Colors.white,
                      color: Colors.blue,
                      onPressed: () async{
                        final code = codeController.text.trim();
                        AuthCredential credential =  PhoneAuthProvider.credential(verificationId: verificationId, smsCode: code);

                        final result = await _auth.signInWithCredential(credential);

                        final user = result.user;

                        if(user != null){
                          Navigator.push(context, MaterialPageRoute(
                                                      builder: (context) => WelcomePage()
                                                  ));
                        }else{
                          print("Error");
                        }
                      },
                    )
                  ],
                );
              }
          );
        },
        codeAutoRetrievalTimeout: null
    );
  }

Timer timer;

  @override
  void initState() {
    // timer = Timer.periodic(Duration(seconds: 5), (Timer t) {
    //   confirmation();
    // });
    email = TextEditingController();
    pass = TextEditingController();
    name = TextEditingController();
    number = TextEditingController();
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    name.dispose();
    number.dispose();
    super.dispose();
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 20, bottom: 10),
              child: const Icon(Icons.keyboard_arrow_left, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _nameWidget() {
    return Stack(
      children: [

        TextFormField(
          controller: name,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            // hintText: 'Enter your full name',
            labelText: 'Name',
            labelStyle: TextStyle(
                color: Color.fromRGBO(226, 222, 211, 1),
                fontWeight: FontWeight.w500,
                fontSize: 13),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(226, 222, 211, 1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _numberWidget() {
    return Stack(
      children: [

        TextFormField(
          controller: number,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            // hintText: 'Enter your full name',
            labelText: 'Phone',
            labelStyle: TextStyle(
                color: Color.fromRGBO(226, 222, 211, 1),
                fontWeight: FontWeight.w500,
                fontSize: 13),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(226, 222, 211, 1),
              ),
            ),
          ),
        ),
      ],
    );
  }


  Widget _emailWidget() {
    return Stack(
      children: [
        TextFormField(
          controller: email,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            // hintText: 'Enter your full name',
            labelText: 'Email',
            labelStyle: TextStyle(
                color: Color.fromRGBO(226, 222, 211, 1),
                fontWeight: FontWeight.w500,
                fontSize: 13),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(226, 222, 211, 1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _passwordWidget() {
    return Stack(
      children: [
        TextFormField(
          controller: pass,
          style: const TextStyle(color: Colors.white),
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(
                color: Color.fromRGBO(226, 222, 211, 1),
                fontWeight: FontWeight.w500,
                fontSize: 13),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Color.fromRGBO(226, 222, 211, 1),
              ),
            ),
          ),
        ),
      ],
    );
  }


  confirmation() async {
    final verifyUser = await _auth.currentUser;
    if(verifyUser.emailVerified){
      print("im inside the verify");
      setState(() {
        Navigator.pop(context);
      });
    }else{
      print("still outside");
      verifyUser.reload();
      confirmation();
    }
  }



  verifyEmail() async {

    final verifyUser = await _auth.currentUser;
    if(verifyUser != null)
    {
      await verifyUser.sendEmailVerification();
      print("Verification Mail has been sent");
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(backgroundColor:Colors.orangeAccent,content: Text("Verification Mail has been sent",style: TextStyle(color: Colors.green),)));
      confirmation();
    }else{
      print("email is not verified");
    }

  }


  Widget _submitButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () async {
          //createAlbum(name.text, email.text, pass.text);
          //name.clear();
          // email.clear();
          // pass.clear();
          //loginUser(number.text, context);

          try {
            final newUser = await _auth.createUserWithEmailAndPassword(
                email: email.text, password: pass.text);

            if (newUser != null) {
              // Navigator.pop(context);
              print("successfully registered");
              verifyEmail();

            }

            databaseReference.child(_auth.currentUser.uid).set({
              'name': name.text,
              'phone': number.text,
              'email' : email.text,
            });

          } catch (e) {
            print(e);
          }
          //  Navigator.pop(context);
           //Navigator.push(
           // context, MaterialPageRoute(builder: (context) => SignUpPage()));
        },
        child:
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text(
            'Sign up',
            style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w500,
                height: 1.6),
          ),
          SizedBox.fromSize(
            size: const Size.square(70.0), // button width and height
            child: const ClipOval(
              child: Material(
                color: Color.fromRGBO(76, 81, 93, 1),
                child: Icon(Icons.arrow_forward,
                    color: Colors.white), // button color
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _numberSubmitButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () async {
          //createAlbum(name.text, email.text, pass.text);
          //name.clear();
          // email.clear();
          // pass.clear();
          loginUser(number.text, context);
          // try {
          //   final newUser = await _auth.createUserWithEmailAndPassword(
          //       email: email.text, password: pass.text);
          //   databaseReference.child(_auth.currentUser.uid).set({
          //     'name': name.text,
          //     'phone': number.text,
          //     'email' : email.text,
          //   });
          //   if (newUser != null) {
          //     Navigator.pop(context);
          //   }
          // } catch (e) {
          //   print(e);
          // }
          //Navigator.pop(context);
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => SignUpPage()));
        },
        child:
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text(
            'Verify Otp',
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w500,
                height: 1.6),
          ),
          SizedBox.fromSize(
            size: const Size.square(50.0), // button width and height
            child: const ClipOval(
              child: Material(
                color: Color.fromRGBO(76, 81, 93, 1),
                child: Icon(Icons.arrow_forward,
                    color: Colors.white), // button color
              ),
            ),
          ),
        ]),
      ),
    );
  }

  // Widget _createLoginLabel() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(vertical: 20),
  //     alignment: Alignment.bottomLeft,
  //     child: InkWell(
  //       onTap: () => Navigator.push(
  //           context, MaterialPageRoute(builder: (context) => SignInPage())),
  //       child: Text(
  //         'Login',
  //         style: TextStyle(
  //           fontSize: 14,
  //           fontWeight: FontWeight.bold,
  //           color: Colors.white,
  //           decoration: TextDecoration.underline,
  //           decorationThickness: 2,
  //         ),
  //       ),
  //     ),
  //   );
  // }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned(
                height: MediaQuery.of(context).size.height * 1,
                child: const SignUpContainer()),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: height * .35),
                        _nameWidget(),
                        const SizedBox(height: 20),
                        _emailWidget(),
                        const SizedBox(height: 20),
                        _passwordWidget(),
                        const SizedBox(height: 30),
                        _submitButton(),
                        const SizedBox(height: 20),
                        const Text("Or",style: TextStyle(fontWeight: FontWeight.bold,),),
                        const SizedBox(height: 10),
                        _numberWidget(),
                        const SizedBox(height: 20),
                        _numberSubmitButton()
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(top: 60, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}


Future<Album> createAlbum(
    String name, String email, String password) async {
  final response = await http.post(
    Uri.parse('http://192.168.1.195/'),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'User_Name': name,
      'email': email,
      'User_Password': password,
    }),
  );

  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Album.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to create album.');
  }
}

class Album {
  final String name;
  final String email;
  final String password;

  Album({
    @required this.name,
    @required this.email,
    @required this.password,
  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      name: json['User_Name'],
      email: json['email'],
      password: json['User_Password'],

    );
  }
}
