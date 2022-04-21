import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';
import 'package:spamn/repository/connect_web3.dart';
import 'package:url_launcher/url_launcher.dart';

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
          title: TextButton(
            onPressed: () => Routemaster.of(context).pop('/'),
            child: Image.asset(
              'images/logo.png',
              height: 40,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(5),
              child: TextButton(
                onPressed: () async => await launch(
                    'https://metamask.app.link/dapp/spamn1.web.app/'),
                child: Image.asset('images/metamask.png'),
              ),
            ),
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
