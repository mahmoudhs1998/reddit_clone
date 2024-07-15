import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/reddit_controller.dart';

class RegisterView extends StatelessWidget {
  final RedditController controller = Get.find();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Register'),
              onPressed: () {
                controller.register(
                  usernameController.text,
                  emailController.text,
                  passwordController.text,
                );
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
