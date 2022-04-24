import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:routemaster/routemaster.dart';
import 'package:spamn/repository/spamn_web3.dart';
import 'package:spamn/ui/components/no_connected.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../repository/connect_web3.dart';
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
    '0xb90f8d694d0E248fA730Db660619EE3c1f20E62F',
    '0xC075047E7DB6b1E9Af139bD24A45F69337AC2dB8',
    '0xeD62679f9490AC35ABc7c2da1e01440dA397401E',
  ];
  final List<String> _titles = [];
  final List<String> _imageUrls = [];

  bool _isConnected = false;
  Signer? _signer;

  @override
  void initState() {
    super.initState();
    Future(() async {
      await ConnectWeb3().isConnected().then((value) {
        if (value) {
          _onConnected();
        }
      });
    });
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
                                    child: Image.network(
                                      _imageUrls[i],
                                    ),
                                  ),
                                ),
                                Text(_titles[i],
                                    style:
                                        Theme.of(context).textTheme.headline5),
                                FutureBuilder(
                                  future: SpamnWeb3().getTotalWatchCount(
                                      _signer!, _contracts[i]),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<int> snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        '${snapshot.data} watch'.toUpperCase(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5,
                                      );
                                    } else {
                                      return const CircularProgressIndicator();
                                    }
                                  },
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
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
                                    Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: FutureBuilder(
                                        future: SpamnWeb3()
                                            .watched(_signer!, _contracts[i]),
                                        builder: (BuildContext context,
                                            AsyncSnapshot<bool> snapshot) {
                                          if (snapshot.hasData) {
                                            if (snapshot.data == true) {
                                              return OutlinedButton(
                                                  child: Text(
                                                    'watched'.toUpperCase(),
                                                    style: const TextStyle(
                                                        fontSize: 24),
                                                  ),
                                                  onPressed: () {});
                                            } else {
                                              return OutlinedButton(
                                                child: Text(
                                                  'watch'.toUpperCase(),
                                                  style: const TextStyle(
                                                      fontSize: 24),
                                                ),
                                                onPressed: () async =>
                                                    await SpamnWeb3().addWatch(
                                                        _signer!,
                                                        _contracts[i]),
                                              );
                                            }
                                          } else {
                                            return const CircularProgressIndicator();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              )
            : NoConnected(onPressed: () async {
                _onConnected();
              }));
  }

  Widget box(Widget child) {
    return Container(margin: const EdgeInsets.all(10), child: child);
  }
}
