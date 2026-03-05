import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_boilerplate/home_screen.dart';
import 'package:flutter_boilerplate/sqlite/sqlite_provider.dart';
import 'package:flutter_boilerplate/sqlite/sqlite_screen.dart';
import 'package:provider/provider.dart';
import 'firebase/auth/email_password/email_auth_provider.dart';
import 'firebase/auth/google_sign_in/google_auth_provider.dart';
import 'firebase/firestore/firestore_provider.dart';
import 'firebase/firestore/firestore_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => EmailAuthProvider()),
          ChangeNotifierProvider(create: (_) => GoogleAuthProvider()),
          ChangeNotifierProvider(create: (_) => FirestoreProvider()),
          ChangeNotifierProvider(create: (_) => SqliteProvider()),
        ],
        child: MyApp(),
      ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: HomeScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Flutter")),
      body: Center(child: Scaffold()),
    );
  }
}
