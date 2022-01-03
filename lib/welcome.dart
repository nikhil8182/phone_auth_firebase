import 'dart:async';
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';



final _auth = FirebaseAuth.instance;
final databaseReference = FirebaseDatabase.instance.reference();

class WelcomePage extends StatefulWidget {
  // final int id;
  //  WelcomePage({this.id});
  // final databaseReference = FirebaseDatabase.instance.reference();
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String name = " ";
  int waterLevel = 0;
  bool motorStatus = false;
  int board = 0;
  Timer timer;

  // idValue() async
  // {
  //   print(widget.id);
  //   final response = await http.get(Uri.parse("http://192.168.1.195/${widget.id}/"));
  //   var fetchdata = jsonDecode(response.body);
  //   var dum = fetchdata;
  //   setState(() {
  //     name = dum["User_Name"];
  //     waterLevel = dum["Water_Level"];
  //     motorStatus = dum["Motor_Status"];
  //     board = dum["Board_Id"];
  //   });
  // }

  @override
  void initState() {
    //idValue();
    // timer = Timer.periodic(Duration(seconds: 3), (Timer t) {
    //   IdValue();
    // });
    // TODO: implement initState
    super.initState();
  }
  int valveCount = 0;
  String x = "valve";
  var y;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: const Text("Water Tank Automation"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // const SizedBox(
          //   height: 50,
          // ),
          // Row(
          //   children:
          //   [
          //     const Text("Name: ",style: TextStyle(color: Colors.black,fontSize: 25),),
          //     Text(name ?? " ",style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
          //   ],
          // ),
          // Row(
          //   children: [
          //     const Text("Water Level: ",style: TextStyle(color: Colors.black,fontSize: 25),),
          //     Text(waterLevel.toString(),style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
          //   ],
          // ),
          // Row(
          //   children: [
          //     const Text("Motor Status: ",style: TextStyle(color: Colors.black,fontSize: 25),),
          //     Text(motorStatus.toString(),style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
          //   ],
          // ),
          // Row(
          //   children: [
          //     const Text("Board ID: ",style: TextStyle(color: Colors.black,fontSize: 25),),
          //     Text(board.toString(),style: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
          Text("hllooo world"),

          Center(
            child: ElevatedButton(onPressed: (){
              // getData();
              setState(() {

                // print(y['${_auth.currentUser.uid}']);
                // print(_auth.currentUser.uid);

                valveCount = y['${_auth.currentUser.uid}'].length == null ? 0 : valveCount + 1;
              });
              String a = x + valveCount.toString();
              databaseReference.child(a).set({
                a : "true",
                "z": "true"
              });
            }, child: Text("Valve")),
          ),
          Center(
            child: ElevatedButton(onPressed: (){
              getData();

              setState(() {

                print(y['${_auth.currentUser.uid}']);
                print(_auth.currentUser.uid);
                valveCount = y['${_auth.currentUser.uid}'].length;
                print('valve count = $valveCount');
              });
              String a = x + valveCount.toString();
              databaseReference.child(a).remove();
            }, child: Text("delete valve")),
          ),
          Center(
            child: ElevatedButton(onPressed: (){
             getData();
            }, child: Text("get data")),
          ),
          Center(
            child: ElevatedButton(onPressed: () async {
              print(_auth.currentUser);
              await _auth.signOut();
              Navigator.pop(context);
            }, child: Text("LogOut")),
          ),
            ],
          )
      );
  }
  void getData(){
    setState(() {
      databaseReference.once().then((value) =>  y = (value.snapshot.value));
      print(y);
      print(y['${_auth.currentUser.uid}'].length);
    });
  }

}

