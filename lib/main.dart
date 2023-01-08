import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ombor_web/admin/sample_page.dart';
import 'package:ombor_web/user/sample_page_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  Future<void> _login() async {
    final response = await http.post(
      Uri.parse(
          'https://golalang-online-sklad-production.up.railway.app/login'),
      body: jsonEncode(<String, String>{
        'username': _emailController.text,
        'password': _passwordController.text,
      }),
    );
    if (response.statusCode == 200) {
      _isLoading = false;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final data = jsonDecode(response.body);
      if (data['message'] == 'User not found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bunday foydalanuvchi mavjud emas'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            duration: Duration(milliseconds: 1700),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
        _isLoading = false;
        setState(() {});
        return;
      }
      if (data['message'] == 'Wrong password') {
        _isLoading = false;
        _passwordController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Parolingiz noto\'g\'ri'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            duration: Duration(milliseconds: 1700),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
        setState(() {});
        return;
      }
      if (data['message'] == 'User blocked') {
        _isLoading = false;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Foydalanuvchi bloklangan iltimos administrator bilan bog\'laning'),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            duration: Duration(milliseconds: 3000),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Colors.red,
          ),
        );
        setState(() {});
        return;
      }
      prefs.setString('name', data['name']);
      prefs.setString('surname', data['surname']);
      prefs.setString('phone', data['phone']);
      prefs.setString('username', data['username']);
      prefs.setString('userid', data['userid']);
      prefs.setString('role', data['role']);
      prefs.setString('userstatus', data['userstatus']);
      prefs.setString('registerdate', data['registerdate']);
      prefs.setBool('blocked', data['blocked']);
      _isLoading = false;
      setState(() {});
      if (data['role'] == 'admin' || data['role'] == 'creator') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SamplePage(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SamplePageUser(),
          ),
        );
      }
    } else {
      _isLoading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Iltimos login yoki parolni tekshiring'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          duration: Duration(milliseconds: 1700),
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() {});
    }
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
                      const SizedBox(width: 5,),
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
                      if (!_isLoading)
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                          width: MediaQuery.of(context).size.height * 0.03,
                          child: const Icon(
                            color: Colors.white,
                            Icons.arrow_forward,
                          ),
                        ),
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
