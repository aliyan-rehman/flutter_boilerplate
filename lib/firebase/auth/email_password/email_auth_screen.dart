import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../widgets/custom_textfield.dart';
import 'email_auth_provider.dart';

class EmailAuthScreen extends StatefulWidget {
  @override
  State<EmailAuthScreen> createState() => _EmailAuthScreenState();
}

class _EmailAuthScreenState extends State<EmailAuthScreen> {
  // Controllers — to read what user typed
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Toggle between sign in and sign up
  bool _isSignUp = true;

  @override
  void dispose() {
    // Always dispose controllers to free memory
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Watch provider — screen rebuilds when provider calls notifyListeners()
    final provider = Provider.of<EmailAuthProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(_isSignUp ? 'Sign Up' : 'Sign In')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show name field only for sign up
            if (_isSignUp)
              CustomTextField(controller: _nameController, labelText: 'Name'),
            SizedBox(height: 10),

            CustomTextField(
              labelText: 'Email',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 10),
            CustomTextField(
              labelText: 'Password',
              controller: _passwordController,
              obscureText: true,
            ),

            SizedBox(height: 20),

            // Show error message if any
            if (provider.errorMessage.isNotEmpty)
              Text(provider.errorMessage, style: TextStyle(color: Colors.red)),

            SizedBox(height: 10),

            // Show loading spinner or button
            provider.isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
                    onPressed: () async {
                      bool success;

                      if (_isSignUp) {
                        success = await provider.signUp(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                          _nameController.text.trim(),
                        );
                      } else {
                        success = await provider.signIn(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );
                      }

                      // If success, show a message
                      if (success) {
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text('Success!')));
                      }
                    },
                    child: Text(_isSignUp ? 'Sign Up' : 'Sign In'),
                  ),

            SizedBox(height: 10),

            // Toggle between sign in / sign up
            TextButton(
              onPressed: () {
                setState(() {
                  _isSignUp = !_isSignUp;
                });
              },
              child: Text(
                _isSignUp
                    ? 'Already have account? Sign In'
                    : 'No account? Sign Up',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
