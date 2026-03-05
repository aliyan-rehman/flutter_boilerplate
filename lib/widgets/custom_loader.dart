import 'package:flutter/material.dart';

class CustomLoader extends StatelessWidget {
  final String? message; // optional message below spinner

  const CustomLoader({Key? key, this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: Colors.blue),
          if (message != null) ...[
            SizedBox(height: 12),
            Text(
              message!,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ],
      ),
    );
  }
}