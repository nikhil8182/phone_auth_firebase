import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:phone_auth_firebase/src/signup.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import '../next.dart';
import '../welcome.dart';
import 'Widget/singinContainer.dart';


final _auth = FirebaseAuth.instance;


class SignInPage extends StatefulWidget {
  const SignInPage({Key key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController email = TextEditingController();
  TextEditingController pass = TextEditingController();

  var count = 0;

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    //return await FirebaseAuth.instance.signInWithCredential(credential);
    final result =  await FirebaseAuth.instance.signInWithCredential(credential);

    final user = result.user;

    if(user != null){
      print("hello ${user.email}");
      Navigator.push(context, MaterialPageRoute(
          builder: (context) => WelcomePage()
      ));
    }else{
      print("Error");
    }


  }

  Future<UserCredential> signInWithFacebook() async {
    // Trigger the sign-in flow
    //   print("im inside the face");
    try{
      final LoginResult loginResult = await FacebookAuth.instance.login();
      final userData = await FacebookAuth.instance.getUserData();
      // print("im inside the loginResult ${loginResult.accessToken.token}");
      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken.token);
      print("im inside the facebookAuthCredential $facebookAuthCredential");
      // Once signed in, return the UserCredential
      final result = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
       print("result of user   $result");
      print("result of user   ${result.user}");
      if(userData['email'] != null){
        Navigator.push(context,MaterialPageRoute(
            builder: (context) => WelcomePage()));
      }
    }catch(e){
      print("facebook log error $e");
    }
  }

   ///signin with apple
  // String generateNonce([int length = 32]) {
  //   final charset =
  //       '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
  //   final random = Random.secure();
  //   return List.generate(length, (_) => charset[random.nextInt(charset.length)])
  //       .join();
  // }
  //
  // /// Returns the sha256 hash of [input] in hex notation.
  // String sha256ofString(String input) {
  //   final bytes = utf8.encode(input);
  //   final digest = sha256.convert(bytes);
  //   return digest.toString();
  // }
  //
  // Future<UserCredential> signInWithApple() async {
  //   // To prevent replay attacks with the credential returned from Apple, we
  //   // include a nonce in the credential request. When signing in with
  //   // Firebase, the nonce in the id token returned by Apple, is expected to
  //   // match the sha256 hash of `rawNonce`.
  //   final rawNonce = generateNonce();
  //   final nonce = sha256ofString(rawNonce);
  //
  //   // Request credential for the currently signed in Apple account.
  //   final appleCredential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //     nonce: nonce,
  //   );
  //
  //   // Create an `OAuthCredential` from the credential returned by Apple.
  //   final oauthCredential = OAuthProvider("apple.com").credential(
  //     idToken: appleCredential.identityToken,
  //     rawNonce: rawNonce,
  //   );
  //
  //   // Sign in the user with Firebase. If the nonce we generated earlier does
  //   // not match the nonce in `appleCredential.identityToken`, sign in will fail.
  //   return await FirebaseAuth.instance.signInWithCredential(oauthCredential);
  // }


  @override
  void initState() {
    email = TextEditingController();
    pass = TextEditingController();
    // TODO: implement initState
    super.initState();
  }
  @override
  void dispose() {
    email.dispose();
    pass.dispose();
    super.dispose();
  }


  Widget _usernameWidget() {
    return Stack(
      children: [
        TextFormField(
          controller: email,
          style: const TextStyle(color: Colors.black),
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Email',
            labelStyle: TextStyle(
                color: Color.fromRGBO(173, 183, 192, 1),
                fontWeight: FontWeight.bold),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(173, 183, 192, 1)),
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
          style: const TextStyle(color: Colors.black),
          keyboardType: TextInputType.name,
          textInputAction: TextInputAction.next,
          decoration: const InputDecoration(
            labelText: 'Password',
            labelStyle: TextStyle(
                color: Color.fromRGBO(173, 183, 192, 1),
                fontWeight: FontWeight.bold),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Color.fromRGBO(173, 183, 192, 1)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _submitButton() {
    return Align(
      alignment: Alignment.centerRight,
      child: InkWell(
        onTap: () async {
          // final response = await http.get(Uri.parse("http://192.168.1.195/"));
          // var fetchdata = jsonDecode(response.body);
          // var dum= fetchdata;
          // //print("fetchdata ${dum[3]["email"]}");
          // for(int i =0; i<dum.length;i++) {
          //   print(dum[i]["email"].toString());
          //   if ((dum[i]["email"].toString() == email.text) && (dum[i]["User_Password"].toString() == pass.text))
          //   {
          //     print(dum[i]["id"].toString());
          //     var id= dum[i]["id"];
          //     if(dum[i]["Board_Id"] == 0){
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => QRViewExample(id: id,))
          //       );
          //     }else{
          //       Navigator.push(
          //           context,
          //           MaterialPageRoute(builder: (context) => WelcomePage(id: id,)),);
          //     }
          //     email.clear();
          //     pass.clear();
          //     break;
          //   }
          // }


          try {
            final user = await _auth.signInWithEmailAndPassword(
                email: email.text, password: pass.text);
            if (user != null) {
                  email.clear();
                  pass.clear();
              Navigator.push(context,
                          MaterialPageRoute(builder: (context) => WelcomePage()),);
            }
          } catch (e) {
            print(e);
          }
    },
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          const Text(
            'Sign in',
            style: TextStyle(
                color: Color.fromRGBO(76, 81, 93, 1),
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

  Widget _createAccountLabel() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          InkWell(
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => SignUpPage())),
            child: const Text(
              'Register',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                  decorationThickness: 2),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: Stack(
          children: [
            Positioned(
                height: MediaQuery.of(context).size.height * 0.50,
                child: SigninContainer()),
            SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        SizedBox(height: height * .55),
                        _usernameWidget(),
                        const SizedBox(height: 20),
                        _passwordWidget(),
                        const SizedBox(height: 30),
                        _submitButton(),
                        SizedBox(height: height * .010),
                        ElevatedButton(onPressed: ()
                        {
                          signInWithGoogle();
                        }, child: const Text("  Google Sign In   ")),
                        SizedBox(height: height * .010),
                        ElevatedButton(onPressed: ()
                        {
                          signInWithFacebook();
                        }, child: const Text("FaceBook Sign In ")),
                        // ElevatedButton(onPressed: ()
                        // {
                        //   signInWithApple();
                        // }, child: const Text("   Apple Sign In     ")),
                        SizedBox(height: height * .010),
                        _createAccountLabel(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            //Positioned(top: 60, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}
