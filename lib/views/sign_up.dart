// ignore_for_file: prefer_const_constructors

import 'package:find_my_anbesa/views/sign_in.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child : SingleChildScrollView(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Sign Up',),
              Text('First Name',),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'First Name',
                ),),
              Text('Last Name',),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Last Name',
                ),),
              Text('Email',),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Email',
                ),),
              Text('Phone',),
              TextField(
                decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Phone',
              ),),
              Text('Password',),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                //controller : passwordController,
                validator: (input) => input!.length < 5 ? "Password should be at least 5 characters" : null,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Password',
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Verify password',
                ),),
              ElevatedButton(onPressed: (){}, child: Text("Sign Up"),),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Already have an account? '),
                GestureDetector(
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SignIn()));
                  },
                ),
              ]),
            ],
          ),
        )
        ),
      );
  }
}
