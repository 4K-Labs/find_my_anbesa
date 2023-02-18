// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:find_my_anbesa/services/api_services.dart';
import 'package:find_my_anbesa/views/home.dart';
import 'package:find_my_anbesa/views/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:progress_indicator_button/progress_button.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var emailError = false;
  var passwordError = false;
  var passwordErrorText = "Please enter password";
  var emailErrorText = "Please enter email";
  APIService apiService = APIService();
  var _passwordVisible = false;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();

    return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(7, 0, 7, 0),
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/bus_logo.png'),

                      SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Email', style: TextStyle(fontWeight: FontWeight.w600,),
                        ),

                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        onChanged: (value){
                          if(value.trim().isNotEmpty){
                            setState(() {
                              emailError = false;
                            });
                          }
                        },
                        //validator: (input) => !input!.contains('@') ? "Email should be valid" : null,
                        decoration: InputDecoration(
                          errorText: emailError? emailErrorText : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Color(0xfffbc02d), width: 2.5),
                          ),
                          filled: true,
                          fillColor: Color(0xffedede7),
                          hintText: 'Email',
                          focusColor: Colors.yellow[700],
                          prefixIcon: Icon(
                            Icons.email,
                            color: Colors.yellow[700],
                          ),
                        ),
                      ),
                      SizedBox(height: 25),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Password', style: TextStyle(fontWeight: FontWeight.w600,),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: !_passwordVisible,
                        controller: passwordController,
                        onChanged: (value){
                          if(value.isNotEmpty){
                            setState(() {
                              passwordError = false;
                            });
                          }
                        },
                        //validator: (input) => input!.length < 5 ? "Password should be at least 5 characters long" : null,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(
                              _passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.orange,
                            ),
                            onPressed: () {
                              setState(() {
                                _passwordVisible = !_passwordVisible;
                              });
                            },
                          ),
                          errorText: passwordError? passwordErrorText : null,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: BorderSide(
                                color: Color(0xfffbc02d), width: 2.5),
                          ),
                          filled: true,
                          fillColor: Color(0xffedede7),
                          hintText: 'Password',
                          focusColor: Colors.yellow[700],
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.yellow[700],
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                Container(
                      width: double.infinity,
                    child: ProgressButton(

                      //animationDuration: Duration(milliseconds: 1),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.yellow[700],

                      strokeWidth: 2,
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            color: Colors.white, fontSize: 16.0),
                      ),
                      // color: Colors.tealAccent[700],
                      onPressed: (AnimationController controller) async {

                          if (emailController.text.trim().isNotEmpty && passwordController.text.isNotEmpty) {

                            controller.forward();

                            var connectivityResult = await (Connectivity().checkConnectivity());

                            if (connectivityResult == ConnectivityResult.mobile ||connectivityResult == ConnectivityResult.wifi) {

                              await apiService.signIn(email: emailController.text, password: passwordController.text).then((value) {

                                //save user info
                                box.write('logged_in', true);
                                box.write('first_name', value.firstName!);
                                box.write('last_time', value.lastName!);
                                box.write('email', value.email!);
                                box.write('phone', value.phone!);
                                box.write('user_id', value.userId);
                                box.write('activity_points', value.activityPoints!);

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => Home())
                                );


                              }).catchError((onError) {

                                setState(() {

                                  controller.reset();

                                  emailErrorText = onError;
                                  passwordErrorText = onError;
                                  emailError = true;
                                  passwordError = true;

                                });

                              });

                            }else{
                              setState(() {
                                controller.reset();
                                passwordError = false;
                                emailError = false;
                                final snackBar = SnackBar(content: Text('No Connection'));
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);

                              });
                            }
                          } else {
                            setState(() {
                              emailErrorText = "Please enter email";
                              passwordErrorText = "Please enter password";
                              if(emailController.text.trim().isEmpty){
                                emailError = true;
                              }
                              if(passwordController.text.isEmpty){
                                passwordError = true;
                              }
                            });
                          }
                        },

                      ),),

                      SizedBox(height: 17),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Text('Don\'t have an account? ', style: TextStyle(color: Colors.black),),

                        GestureDetector(
                          child: Text(
                            'Sign up',
                            style: TextStyle(
                              color: Colors.orange,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          onTap: () {
                           /*Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));*/
                          },
                        ),
                      ]),
                    ]),
                  ),
              )
            ));
  }
}
