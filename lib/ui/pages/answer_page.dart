import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:spamn/repository/spamn_web3.dart';
import 'package:spamn/ui/components/no_connected.dart';

import '../../repository/connect_web3.dart';
import '../../utils/ether_ext.dart';
import '../components/main_scaffold.dart';

class AnswerPage extends StatefulWidget {
  const AnswerPage(
      {Key? key,
      required this.title,
      required this.contractAddress,
      required this.tokenId})
      : super(key: key);

  final String title;
  final String contractAddress;
  final int tokenId;

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  bool _isConnected = false;
  Signer? _signer;
  String _title = '';
  List<dynamic> _choices = [];
  int _value = 0;

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
        _title = await SpamnWeb3()
            .getQuestionTitle(_signer!, widget.contractAddress, widget.tokenId);
        _choices = await SpamnWeb3().getQuestionChoices(
            _signer!, widget.contractAddress, widget.tokenId);
        _value = await SpamnWeb3()
            .getQuestionValue(_signer!, widget.contractAddress, widget.tokenId);
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
          ? FittedBox(
              fit: BoxFit.fitWidth,
              child: Column(
                children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    child: Text(
                      _title,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                  for (int i = 0; i < _choices.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: OutlinedButton(
                        child: Text(
                          _choices[i].toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                        onPressed: () async {
                          await SpamnWeb3().setAnswer(_signer!,
                              widget.contractAddress, widget.tokenId, i + 1);
                        },
                      ),
                    ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                  Text(
                    "Reward: ${toEther(_value).toString()} MATIC",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                ],
              ),
            )
          : NoConnected(onPressed: () async {
              _onConnected();
            }),
    );
  }
}
