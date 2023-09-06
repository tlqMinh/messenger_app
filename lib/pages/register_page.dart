import 'package:flutter/material.dart';
import 'package:messenger_app/components/my_button.dart';
import 'package:messenger_app/components/my_text_box.dart';
import 'package:messenger_app/services/auth/auth_services.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerConfirmPassword = TextEditingController();
  //sign up user
  void signUp() async{
    if(_controllerPassword.text != _controllerConfirmPassword.text){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Mat khau khong trung nhau")));
      return;
    }
    final authService = Provider.of<AuthServives>(context, listen:false);

    try{
      await authService.createUserWithEmailAndPassword(_controllerEmail.text, _controllerPassword.text);
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
              Text("Let's create a new account",style: TextStyle(fontSize: 18),),
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
              SizedBox(height: 10,),
              MyTextBox(
                controller: _controllerConfirmPassword,
                hintText: "Confirm Password",
                obscureText: true,
              ),
              SizedBox(height: 35),
              //login button
              MyButton(onTap: signUp, text: "Sign up"),
              SizedBox(height: 25),
              //register
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?"),
                  SizedBox(width: 5,),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text("Login now", style: TextStyle(fontWeight: FontWeight.bold),)
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
