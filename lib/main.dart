import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final _emailController = TextEditingController();
  late final _passwordController = TextEditingController();
  bool _validateEmail = false;
  bool _validatePassword = false;
  bool _isLoading = false;

  //https://golalang-online-sklad-production.up.railway.app/login
  Future<void> _login() async {

    final response = await http.post(
      Uri.parse(
          "https://golalang-online-sklad-production.up.railway.app/login"),
      body: jsonEncode({
        "username": _emailController.text,
        "password": _passwordController.text,
      }),
    );
    print(response.body);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.06,
              ),
              Column(
                children: [
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 221, 221, 221),
                        border: Border.all(
                            color: const Color.fromARGB(255, 221, 221, 221),
                            width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        cursorColor: Colors.deepPurpleAccent,
                        controller: _emailController,
                        textAlign: TextAlign.left,
                        textInputAction: TextInputAction.next,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(left: 10, right: 10),
                          border: InputBorder.none,
                          hintText: 'Username',
                          errorText: _validateEmail ? 'Pochta kiriting' : null,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width / 2.5,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 221, 221, 221),
                        border: Border.all(
                            color: const Color.fromARGB(255, 221, 221, 221),
                            width: 2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        cursorColor: Colors.deepPurpleAccent,
                        controller: _passwordController,
                        textAlign: TextAlign.left,
                        textInputAction: TextInputAction.next,
                        obscureText: true,
                        enableSuggestions: false,
                        autocorrect: false,
                        decoration: InputDecoration(
                          contentPadding:
                              const EdgeInsets.only(left: 10, right: 10),
                          border: InputBorder.none,
                          hintText: 'Parol',
                          errorText:
                              _validatePassword ? 'Parol kiriting' : null,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Expanded(child: SizedBox()),
          Row(
            children: [
              const Expanded(child: SizedBox()),
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width / 7.5,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: const Color.fromRGBO(33, 158, 188, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (_emailController.text.isEmpty) {
                      setState(() {
                        _validateEmail = true;
                      });
                    } else if (_passwordController.text.isEmpty) {
                      setState(() {
                        _validatePassword = true;
                      });
                    } else {
                      setState(() {
                        _validateEmail = false;
                        _validatePassword = false;
                      });
                      _isLoading = true;
                      _login();
                    }
                  },
                  child: Row(
                    children: [
                      const SizedBox(
                        width: 5,
                      ),
                      const Text('Kirish'),
                      const Expanded(child: SizedBox()),
                      if (_isLoading)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                          width: MediaQuery.of(context).size.height * 0.03,
                          child: const CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        ),
                      if (!_isLoading) const Icon(Icons.arrow_forward),
                      const Expanded(child: SizedBox()),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.06,
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
        ],
      ),
    );
  }
}
