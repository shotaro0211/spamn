import 'package:flutter/material.dart';

class NoConnected extends StatelessWidget {
  const NoConnected({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding:
            EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
        child: Column(
          children: [
            Image.asset("images/logo.png"),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            OutlinedButton(
              onPressed: onPressed,
              child: const Text('START'),
            ),
          ],
        ));
  }
}
