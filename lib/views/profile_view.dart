import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/reddit_controller.dart';
import 'login_view.dart';

class ProfileView extends StatelessWidget {
  final RedditController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              controller.logout();
              Get.offAll(() => LoginView());
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Username: ${controller.currentUser.value!.username}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Email: ${controller.currentUser.value!.email}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            ElevatedButton(
              child: Text('Edit Profile'),
              onPressed: () => _showEditProfileDialog(context),
            ),
            ElevatedButton(
              child: Text('Delete Account'),
              onPressed: () => _showDeleteAccountDialog(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    final TextEditingController usernameController = TextEditingController(text: controller.currentUser.value!.username);
    final TextEditingController emailController = TextEditingController(text: controller.currentUser.value!.email);
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
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
              decoration: InputDecoration(labelText: 'New Password'),
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Save'),
            onPressed: () {
              controller.updateUser(
                controller.currentUser.value!.id,
                username: usernameController.text,
                email: emailController.text,
                password: passwordController.text.isNotEmpty ? passwordController.text : null,
              );
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Account'),
        content: Text('Are you sure you want to delete your account?'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.of(context).pop(),
          ),
          TextButton(
            child: Text('Delete'),
            onPressed: () {
              controller.deleteUser(controller.currentUser.value!.id);
              controller.logout();
              Get.offAll(() => LoginView());
            },
          ),
        ],
      ),
    );
  }
}
