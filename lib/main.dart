import 'package:chat_app/Screens/Login%20Screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  final auth=FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: auth.currentUser!=null?MyHomePage():Login_Screen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
User userSignin;
class _MyHomePageState extends State<MyHomePage> {
  final firestore=FirebaseFirestore.instance;
  final auth =FirebaseAuth.instance;
  String message;
  @override
  void initState() {
    super.initState();
    Current_user();
  }

  void Current_user(){
    try{
      final user=auth.currentUser;
      if(user != null){
        userSignin=user;
      }
    }catch(e){print(e);}
  }
  var messageController=TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60.0),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(60.0),
                child: Image(
                  image: AssetImage('images/download.png'),
                ),
              ),
            ),
            SizedBox(width: 20.0,),
            Text(
              'Massage me',
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: firestore.collection('messageID').orderBy('time').snapshots(),
                builder: (context,snapshot){
                  List<Widget> messageList=[];
                  if(!snapshot.hasData){
                    return Center(
                      child:Column(
                        children: [
                          Icon(Icons.chat,size: 50.0,),
                          Text('No Message Yet',style: TextStyle(fontSize: 30.0),),
                        ],
                      ) ,
                    );
                  }
                  final messages=snapshot.data.docs.reversed;
                  for(var m in messages){
                    final messageText=m.get('text');
                    final messageSender=m.get('sender');
                    final currentuser=userSignin.email;

                    if(currentuser==messageSender){}

                    final messagewidget=Messagelines(sender: messageSender,text: messageText,isme: currentuser==messageSender,);
                    messageList.add(messagewidget);
                  }
                  return Expanded(
                    child: ListView(
                      reverse: true,
                      children: messageList,
                    ),
                  );
                }
            ),
            Container(
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    width: 2,
                    color: Colors.blue,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: messageController,
                      onChanged: (value){
                        message=value;
                      },
                      decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
                        hintText: 'Enter your massage here...',
                        border: InputBorder.none,
                      )
                    ),
                  ),
                  CircleAvatar(
                    child: IconButton(
                      icon:Icon(Icons.send,),
                      onPressed: (){
                        messageController.clear();
                        firestore.collection('messageID').add({
                          'text': message,
                          'sender': userSignin.email,
                          'time':FieldValue.serverTimestamp(),
                        });
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Messagelines extends StatelessWidget {
  final String text;
  final String sender;
  final bool isme;

  const Messagelines({Key key, this.text, this.sender, @required this.isme}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isme ? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text('${sender}', style:TextStyle(
              fontSize: 16.0,
              color: Colors.black45,
            ),
          ),
          Material(
            elevation: 5,
            borderRadius:isme? BorderRadius.only(
              topLeft:Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ):BorderRadius.only(
              topRight:Radius.circular(30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            color: isme? Colors.blue[800]:Colors.white ,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
              child: Text(
                '${text}',
                style: TextStyle(fontSize: 24.0,color:isme? Colors.white:Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

