import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myblog/app_screens/authentic_screen.dart';
import 'package:myblog/widgets/loading_widget.dart';


class ResetScreen extends StatefulWidget {
  const ResetScreen({Key? key}) : super(key: key);

  @override
  _ResetScreenState createState() => _ResetScreenState();
}

class _ResetScreenState extends State<ResetScreen> {

  final TextEditingController _emailEditingController = TextEditingController();

   final String _buttonSub = "Submit";
   bool _load =false;

  void _validDateFields(){

     if(_emailEditingController.text.isEmpty){
      Fluttertoast.showToast(msg: 'Please enter your email',
        toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red,
        textColor: Colors.white,);
    }
    else{
       setState(() {
         _load = true;
       });
        FirebaseAuth.instance.sendPasswordResetEmail(email: _emailEditingController.text);
        Fluttertoast.showToast(msg: 'Password reset link sent successfully',
          toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red,
          textColor: Colors.white,);
        _moveToAuthenticScreen();
    }
  }

  void _moveToAuthenticScreen(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const AuthenticScreen()),);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reset"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(height: 70.0,),
                Image.asset('assets/images/logoo.png',
                  width: 200.0,
                  height: 95.0,
                  fit: BoxFit.cover,),
                const SizedBox(height: 50.0,),
                const Text("Submit your email for password reset",style: TextStyle(fontSize: 18.0,color: Colors.indigo),),
                const SizedBox(height: 20.0,),
                TextField(
                  controller: _emailEditingController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: "Email"
                  ),
                ),
                const SizedBox(height: 20.0,),
                _load ? circularProgressBar():GestureDetector(
                  onTap: _validDateFields,
                  child: Container(
                    color: Colors.indigo,
                    width: double.infinity,
                    height: 50.0,
                    child: Center(
                      child: Text(_buttonSub,style: const TextStyle(fontSize: 18.0,color: Colors.white),),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
