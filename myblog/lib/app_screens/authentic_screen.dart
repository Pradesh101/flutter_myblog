import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:myblog/app_screens/reset_screen.dart';
import 'package:myblog/widgets/loading_widget.dart';
import 'home_screen.dart';


class AuthenticScreen extends StatefulWidget {
  const AuthenticScreen({Key? key}) : super(key: key);

  @override
  _AuthenticScreenState createState() => _AuthenticScreenState();
}

class _AuthenticScreenState extends State<AuthenticScreen> {

  final TextEditingController _emailEditingController = TextEditingController();
  final TextEditingController _passwordEditingController = TextEditingController();

  String _buttonText = "Login";
  String _switchText= "Don't have an account? Register";
  bool _loading = false;
  bool _isObscure = true;

  void _validDateFields(){
    if(_emailEditingController.text.isEmpty && _passwordEditingController.text.isEmpty){
      Fluttertoast.showToast(msg: 'Please enter your email and password',
          toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red,
          textColor: Colors.white,);
    }
    else if(_emailEditingController.text.isEmpty){
      Fluttertoast.showToast(msg: 'Please enter your email',
        toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red,
        textColor: Colors.white,);
    }
    else if(_passwordEditingController.text.isEmpty){
      Fluttertoast.showToast(msg: 'Please enter your password',
        toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red,
        textColor: Colors.white,);
    }
    else{
      setState(() {
        _loading = true;
      });
      if(_buttonText=="Login"){
        _login();
      }
      else{
        _register();
      }
    }
  }

  void _moveToHomeScreen(){
    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const HomeScreen()),);
  }

  void _login(){
    FirebaseAuth.instance.signInWithEmailAndPassword
      (email: _emailEditingController.text,
        password: _passwordEditingController.text).then((UserCredential userCredential){
      //move to home screen
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(msg: 'Login Successfully',
        toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.green,
        textColor: Colors.white,);
      _moveToHomeScreen();
    }).catchError((error){
      //show error message
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast( msg: 'Your email or password is incorrect',//msg: error.toString(),
        toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red,
        textColor: Colors.white,);
    });
  }

  void _register(){
    FirebaseAuth.instance.createUserWithEmailAndPassword
      (email: _emailEditingController.text,
        password: _passwordEditingController.text).then((UserCredential userCredential){
          //move to home screen
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(msg: 'Registered Successfully',
        toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.green,
        textColor: Colors.white,);
      _moveToHomeScreen();
    }).catchError((error){
      //show error message
      setState(() {
        _loading = false;
      });
      Fluttertoast.showToast(msg: error.toString(),
        toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.BOTTOM, backgroundColor: Colors.red,
        textColor: Colors.white,);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Blog App"),
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
                 const SizedBox(height: 70.0,),
                TextField(
                  controller: _emailEditingController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    labelText: "Email"
                  ),
                ),
                const SizedBox(height: 15.0,),
                TextField(
                  controller: _passwordEditingController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(),
                      labelText: "Password",
                    suffixIcon: IconButton(
                        icon: Icon(
                          _isObscure ? Icons.visibility : Icons.visibility_off
                        ),
                    onPressed: (){
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                    },
                    )
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => const ResetScreen()),);
                        },
                        child: const Text("Forget Password?"),
                        style: TextButton.styleFrom(
                          primary: Colors.indigo,
                          textStyle: const TextStyle(fontSize: 15.0,))
                    ),
                  ],
                ),
                const SizedBox(height: 10.0,),
                _loading ? circularProgressBar():GestureDetector(
                  onTap: _validDateFields,
                  child: Container(
                    color: Colors.indigo,
                    width: double.infinity,
                    height: 50.0,
                    child: Center(
                      child: Text(_buttonText,style: const TextStyle(fontSize: 18.0,color: Colors.white),),
                    ),
                  ),
                ),
                const SizedBox(height: 20.0,),
                TextButton(
                    style: TextButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 18.0,color: Colors.indigo),
                    ),
                    onPressed: () {
                      setState(() {
                         if(_buttonText=='Login'){
                           _buttonText = "Register";
                           _switchText= "Already have an account? Login";
                         }
                         else{
                           _buttonText = "Login";
                           _switchText= "Don't have an account? Register";
                         }
                      });
                    },
                    child: Text(_switchText,)
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
