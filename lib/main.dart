// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: LoginScreen(),
    );
  }
}

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Email e senha fixos para validação
  final String validEmail = "grdearaujo@uniara.edu";
  final String validPassword = "12345";

  void _validateLogin(BuildContext context) {
    final String email = emailController.text;
    final String password = passwordController.text;

    if (email == validEmail && password == validPassword) {
      // Redireciona para a HomePage se o login for válido
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } else {
      // Exibe uma mensagem de erro se o login for inválido
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email ou senha inválidos!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Faça Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 16),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Senha',
                border: OutlineInputBorder(),
              ),
              obscureText: true, // Esconde a senha
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _validateLogin(context); // Chama a função de validação
              },
              child: Text('Entrar'),
            ),
          ],
        ),
      ),
    );
  }
}
