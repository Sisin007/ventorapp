import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ventorapp/home_page.dart';
import 'package:ventorapp/reg_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  void loginVentor() async {
    final box = Hive.box('ventorBox');
    final ventor = box.get(usernameController.text);

    if (ventor == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("No ventor registered")));
      return;
    }
    if (usernameController.text == ventor['username'] &&
        passwordController.text == ventor['password']) {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      await preferences.setBool('isLoggedIn', true);
      await preferences.setString('loggedInUsername', usernameController.text);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(loggedInUsername: usernameController.text,)),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid username or password")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green[300],
        title: Center(
          child: Text(
            "Ventor App",

            style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Center(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Text(
                  "Sign In",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 15),
                TextFormField(
                  controller: usernameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required";
                    }
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter your Username",
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  controller: passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "This field is required";
                    }
                  },
                  obscureText: !isPasswordVisible,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          isPasswordVisible = !isPasswordVisible;
                        });
                      },
                    ),
                    hintText: "Enter your Password",
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      loginVentor();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green[300],
                  ),
                  child: Text(
                    "Sign In",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w200),
                  ),
                ),
                SizedBox(height: 15),

                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=> RegPage()));
                }, child: Text("No have an account? Register"))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
