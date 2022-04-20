import 'package:flutter/material.dart';
import 'package:spamn/repository/connect_web3.dart';

class MainScaffold extends StatelessWidget {
  const MainScaffold({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(title),
          actions: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextButton(
                onPressed: () async => await ConnectWeb3().addNetwork(),
                child: Image.asset('images/astar.png'),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(20),
          child: child,
        )));
  }
}
