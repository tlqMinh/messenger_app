import 'package:flutter/material.dart';
import 'package:messenger_app/components/my_button.dart';
import 'package:messenger_app/components/my_text_box.dart';
import 'package:messenger_app/services/auth/auth_services.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  //sign in user
  void signIn() async{
    //get auth services
    final authService = Provider.of<AuthServives>(context, listen: false);

    try{
      await authService.signInWithEmailAndPassword(_controllerEmail.text, _controllerPassword.text);
    }
    catch(e){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              //logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image(image: AssetImage('assets/images/logo/insta_text_logo.png'), height: 200, width: 300,),
                ],
              ),
              Text("Welcome back",style: TextStyle(fontSize: 18),),
              SizedBox(height: 15,),
              //email
              MyTextBox(
                controller: _controllerEmail,
                hintText: "Email",
                obscureText: false
              ),
              SizedBox(height: 10,),
              //password
              MyTextBox(
                  controller: _controllerPassword,
                  hintText: "Password",
                  obscureText: true,
              ),

              SizedBox(height: 35),
              //login button
              MyButton(onTap: signIn, text: "Sign in"),
              SizedBox(height: 25),
              //register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?"),
                  SizedBox(width: 5,),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text("Register now", style: TextStyle(fontWeight: FontWeight.bold),))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
