import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_taller3/login.dart';

class RegisterPage extends StatelessWidget {

  var emailController = TextEditingController();
  var passController = TextEditingController();

  RegisterPage({super.key});

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
          ElevatedButton(onPressed: () async {
            String email = emailController.text.trim();
            String password = passController.text.trim();
            if(email.isEmpty || password.isEmpty){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Enter all the fields")));
            } else {
              //ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Register")));
              try{
                await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password).then((value){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Register Successful")));
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                });
              }catch(error){
                print(error);
              }
            
            }
          }, style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),child: Text("Register")),
          SizedBox(height: 50,),
          InkWell(
            onTap: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()));
          }, child:
          Text("Already have an account?", style: TextStyle(color: Colors.blueAccent),)
          )
        ],
        ),
      ),
    );
  }
}