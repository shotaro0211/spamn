import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:routemaster/routemaster.dart';
import 'package:spamn/repository/spamn_web3.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../repository/connect_web3.dart';
import '../components/center_single_child_scroll_view.dart';
import '../components/main_scaffold.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String _baseUrl = 'https://tofunft.com/nft/astar';
  final List<String> _contracts = [
    '0x0619003F76dB6C029D239312f63dD6543AAeB9C5',
    '0xf1A368A3Aa972106A74eF2232a4Eb3a322CbF855',
  ];
  final List<String> _titles = [];
  final List<String> _imageUrls = [];

  bool _isConnected = false;
  Signer? _signer;

  @override
  void initState() {
    super.initState();
    _onConnected();
  }

  void _onConnected() async {
    await ConnectWeb3().getSigner().then((value) async {
      final isConnected = value != null ? true : false;
      if (isConnected) {
        _signer = value;
        for (int i = 0; i < _contracts.length; i++) {
          _titles.add(await SpamnWeb3().getTitle(_signer!, _contracts[i]));
          _imageUrls
              .add(await SpamnWeb3().getImageUrl(_signer!, _contracts[i]));
        }
      }
      setState(() {
        _isConnected = isConnected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: widget.title,
      child: _isConnected
          ? Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.2,
                  child: FittedBox(
                    fit: BoxFit.fitWidth,
                    child: Text('collection'.toUpperCase(),
                        style: Theme.of(context).textTheme.headline1),
                  ),
                ),
                const SizedBox(height: 20),
                FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Row(
                    children: [
                      for (int i = 0; i < _contracts.length; i++)
                        box(
                          Column(
                            children: [
                              MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    launch('$_baseUrl/${_contracts[i]}/1');
                                  },
                                  child: Image.network(_imageUrls[i]),
                                ),
                              ),
                              Text(_titles[i],
                                  style: Theme.of(context).textTheme.headline5),
                              const SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: OutlinedButton(
                                  child: Text(
                                    'create'.toUpperCase(),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  onPressed: () {
                                    Routemaster.of(context)
                                        .push('/${_contracts[i]}/create');
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      box(
                        Column(
                          children: [
                            MouseRegion(
                              cursor: SystemMouseCursors.click,
                              child: GestureDetector(
                                onTap: () {},
                                child: Image.network(
                                  'https://dentou-s3.s3.ap-northeast-1.amazonaws.com/public/4814.jpg',
                                  width: 400,
                                ),
                              ),
                            ),
                            Text('comming soon'.toUpperCase(),
                                style: Theme.of(context).textTheme.headline5),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.all(10),
                              child: OutlinedButton(
                                child: Text(
                                  'create'.toUpperCase(),
                                  style: const TextStyle(fontSize: 24),
                                ),
                                onPressed: () {},
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  Widget box(Widget child) {
    return Container(margin: const EdgeInsets.all(10), child: child);
  }
}
