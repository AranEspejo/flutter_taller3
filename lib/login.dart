import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_taller3/MapSample.dart';
import 'package:flutter_taller3/map.dart';
import 'package:flutter_taller3/register.dart';
import 'package:flutter_taller3/home.dart';

class LoginPage extends StatelessWidget {

  var emailController = TextEditingController();
  var passController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(padding: EdgeInsetsGeometry.all(50.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: emailController,
            decoration: InputDecoration(border: OutlineInputBorder(),
            labelText: "Enter email"
            )
          ),
          SizedBox(height: 25),
          TextField(
            controller: passController,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Enter password"
            ),
          ),
          SizedBox(height: 50,),
          ElevatedButton(onPressed: (){
            String email = emailController.text.trim();
            String password = passController.text.trim();
            if(email.isEmpty || password.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter all the fields")));
            } else {
              //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login")));
              try{
                FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Login Successful")));
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MapPage()));
                });
              }catch(error){
                print(error);
              }
            }
          }, style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),child: Text("Login")),
          SizedBox(height: 50,),
          InkWell(
            onTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>RegisterPage()));
          }, child:
          Text("New user?", style: TextStyle(color: Colors.blueAccent),)
          )
        ],
        ),
      ),
    );
  }
}