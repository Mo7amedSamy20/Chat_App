import 'package:chat_app/Component.dart';
import 'package:chat_app/Screens/SignUp.dart';
import 'package:chat_app/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Login_Screen extends StatelessWidget {
  final _auth =FirebaseAuth.instance;
  var emailController=TextEditingController();
  var passController=TextEditingController();
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
                  defaultButton(function: ()async{
                      try{
                        final newuser = await _auth.signInWithEmailAndPassword(email: emailController.text.trim(), password: passController.text.trim());
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyHomePage()));
                      }catch(e){
                        Fluttertoast.showToast(
                            msg: 'Invalid Email And Password',
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.red,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                        print(e);
                      }
                  }, text: 'Login',),
                  SizedBox(height: 10.0,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Don\'t have an account ?'),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>Sign_Up()));
                      }, child: Text('Sign Up')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
    );
  }
}