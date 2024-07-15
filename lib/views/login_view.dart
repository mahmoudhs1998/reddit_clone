import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:reddit_clone/views/reddit_post_view.dart';
import 'package:reddit_clone/views/register_view.dart';

import '../controllers/reddit_controller.dart';

class LoginView extends StatelessWidget {
  final RedditController controller = Get.put(RedditController());
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
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
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () {
                if (controller.login(usernameController.text, passwordController.text)) {
                  Get.off(() => RedditPostView());
                } else {
                  Get.snackbar('Error', 'Invalid username or password');
                }
              },
            ),
            TextButton(
              child: Text('Register'),
              onPressed: () => Get.to(() => RegisterView()),
            ),
          ],
        ),
      ),
    );
  }
}
