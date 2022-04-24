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
  // Polygon
  final String _baseUrl = 'https://opensea.io/assets/matic';
  final List<String> _contracts = [
    '0xA77C9240a7AA679B701fF922Bc7454a238F83148',
    '0xbd3729D4609327DdA496dA12F2694D77a1942923',
    '0x6985897284d01893950082d3e8B789DAA3034c2f',
  ];
  // Astar
  // final String _baseUrl = 'https://tofunft.com/nft/astar';
  // final List<String> _contracts = [
  //   '0x3F0676A3eF42330CD46435C6871C4BE4F72fC02D',
  //   '0xf08fFf1176c6baa173925D349413B2b81e96A2f0',
  //   '0xCB80568DC759d718B17d994a9A328E43764b64e1',
  // ];
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
