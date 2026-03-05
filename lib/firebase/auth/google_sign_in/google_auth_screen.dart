import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'google_auth_provider.dart';

class GoogleAuthScreen extends StatefulWidget {
  @override
  State<GoogleAuthScreen> createState() => _GoogleAuthScreenState();
}

class _GoogleAuthScreenState extends State<GoogleAuthScreen> {
  @override
  void initState() {
    super.initState();
    // Check if user already logged in when screen opens
    Future.microtask(() =>
        Provider.of<GoogleAuthProvider>(context, listen: false)
            .checkCurrentUser());
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<GoogleAuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Google Sign In'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // If user is logged in — show their info
              if (provider.isLoggedIn) ...[
                // Show profile picture if available
                if (provider.user!.photoUrl != null)
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(provider.user!.photoUrl!),
                  ),

                SizedBox(height: 10),

                Text(
                  'Welcome, ${provider.user!.name}!',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 5),

                Text(provider.user!.email),

                SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    await provider.signOut();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

              ] else ...[
                // If user is NOT logged in — show Google sign in button

                Text(
                  'Welcome!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 10),

                Text('Please sign in to continue'),

                SizedBox(height: 30),

                // Show error if any
                if (provider.errorMessage.isNotEmpty)
                  Text(
                    provider.errorMessage,
                    style: TextStyle(color: Colors.red),
                  ),

                SizedBox(height: 10),

                // Loading or button
                provider.isLoading
                    ? CircularProgressIndicator()
                    : ElevatedButton.icon(
                  onPressed: () async {
                    bool success = await provider.signInWithGoogle();
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Signed in successfully!')),
                      );
                    }
                  },
                  icon: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/768px-Google_%22G%22_logo.svg.png',
                    height: 24,
                    width: 24,
                  ),
                  label: Text('Sign in with Google'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}