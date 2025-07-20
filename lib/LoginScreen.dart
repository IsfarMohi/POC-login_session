import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomeScreen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage;

  Future<void> _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;
    try {
      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('username', username)
          .eq('password', password)
          .maybeSingle();

      if (response != null) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('loggedIn', true);
        await prefs.setString('userId', response['id']);
        await prefs.setString('username', response['username']);
        await prefs.setString('name', response['name']);
        await prefs.setInt('age', response['age']);
        await prefs.setString('dob', response['date_of_birth']);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
      } else {
        setState(() {
          _errorMessage = 'Invalid username or password';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Login failed: \\${e.toString()}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(labelText: 'Username'),
                validator: (value) => value == null || value.isEmpty ? 'Enter username' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value == null || value.isEmpty ? 'Enter password' : null,
              ),
              SizedBox(height: 24),
              if (_errorMessage != null)
                Text(_errorMessage!, style: TextStyle(color: Colors.red)),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _login();
                  }
                },
                child: Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
