import 'package:chat_app/Component.dart';
import 'package:chat_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Sign_Up extends StatelessWidget {
  final _auth =FirebaseAuth.instance;
  var emailController=TextEditingController();
  var passController=TextEditingController();
  var nameController=TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    width: 220,
                    height: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90)
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(90),
                      child: Image(
                        fit: BoxFit.contain,
                        image: AssetImage('images/download.png'),
                      ),
                    )
                ),
                SizedBox(height: 30.0,),
                defaultFormField(
                  controller: nameController,
                  type:TextInputType.text,
                  validate: (value){
                    if(value==null){
                      return 'This Field is Empty';
                    }
                  },
                  label: 'Name',
                  prefix: Icons.person,
                ),
                SizedBox(height: 15.0,),

                defaultFormField(
                  controller: emailController,
                  type:TextInputType.emailAddress,
                  validate: (value){
                    if(value==null){
                      return 'This Field is Empty';
                    }
                  },
                  label: 'email',
                  prefix: Icons.email,
                ),
                SizedBox(height: 15.0,),
                defaultFormField(
                  controller: passController,
                  type:TextInputType.visiblePassword,
                  validate: (value){
                    if(value==null){
                      return 'Enter an Password';
                    }
                  },
                  label: 'Password',
                  prefix: Icons.lock,
                  suffix: Icons.visibility_off,
                ),
                SizedBox(height: 30.0,),
                defaultButton(
                  function: ()async{
                  try{
                    final newuser = await _auth.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passController.text.trim());
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
                  }catch(e){
                    print(e);
                  }

                }, text: 'Sign Up',),
                SizedBox(height: 10.0,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
