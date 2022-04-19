import 'package:flutter/material.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:spamn/repository/spamn_web3.dart';

import '../../repository/connect_web3.dart';

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
  bool _corrected = false;
  bool _answered = false;

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
        _title = await SpamnWeb3()
            .getQuestionTitle(_signer!, widget.contractAddress, widget.tokenId);
        _choices = await SpamnWeb3().getQuestionChoices(
            _signer!, widget.contractAddress, widget.tokenId);
        _value = await SpamnWeb3()
            .getQuestionValue(_signer!, widget.contractAddress, widget.tokenId);
        _corrected = await SpamnWeb3().getQuestionCorrected(
            _signer!, widget.contractAddress, widget.tokenId);
        _answered = await SpamnWeb3().getQuestionCorrected(
            _signer!, widget.contractAddress, widget.tokenId);
      }
      setState(() {
        _isConnected = isConnected;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _title,
              style: Theme.of(context).textTheme.headline2,
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
            Text(
              _value.toString(),
              style: Theme.of(context).textTheme.headline2,
            ),
          ],
        ),
      ),
    );
  }
}
