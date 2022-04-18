import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:spamn/repository/spamn_web3.dart';

import '../../repository/connect_web3.dart';

final _formKey = GlobalKey<FormBuilderState>();

class CreatePage extends StatefulWidget {
  const CreatePage(
      {Key? key, required this.title, required this.contractAddress})
      : super(key: key);

  final String title;
  final String contractAddress;

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
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
      if (isConnected == true) {
        _signer = value;
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
      body: Column(
        children: <Widget>[
          FormBuilder(
            key: _formKey,
            child: Column(
              children: <Widget>[
                FormBuilderTextField(
                  name: 'value',
                  decoration: const InputDecoration(
                    labelText: '懸賞金',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                ),
                FormBuilderTextField(
                  name: 'title',
                  decoration: const InputDecoration(
                    labelText: '問題文',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                ),
                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'choice1',
                  decoration: const InputDecoration(
                    labelText: '選択肢１',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                ),
                FormBuilderTextField(
                  name: 'choice2',
                  decoration: const InputDecoration(
                    labelText: '選択肢２',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                ),
                FormBuilderTextField(
                  name: 'choice3',
                  decoration: const InputDecoration(
                    labelText: '選択肢３',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                ),
                FormBuilderTextField(
                  name: 'choice4',
                  decoration: const InputDecoration(
                    labelText: '選択肢４',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                ),
                FormBuilderChoiceChip(
                  name: 'answer',
                  decoration: const InputDecoration(
                    labelText: '答えの選択肢を選んでください',
                  ),
                  options: const [
                    FormBuilderFieldOption(value: 1, child: Text('選択肢１')),
                    FormBuilderFieldOption(value: 2, child: Text('選択肢２')),
                    FormBuilderFieldOption(value: 3, child: Text('選択肢３')),
                    FormBuilderFieldOption(value: 4, child: Text('選択肢４')),
                  ],
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                ),
                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'description',
                  decoration: const InputDecoration(
                    labelText: '解説',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                ),
                const SizedBox(height: 20),
                FormBuilderTextField(
                  name: 'address',
                  decoration: const InputDecoration(
                    labelText: 'ウォレットアドレス',
                  ),
                  validator: FormBuilderValidators.compose([
                    FormBuilderValidators.required(context),
                  ]),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
          Row(
            children: <Widget>[
              Expanded(
                child: OutlinedButton(
                  child: const Text(
                    "送りつける",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    _formKey.currentState!.save();
                    if (_formKey.currentState!.validate()) {
                      SpamnWeb3().mint(_signer!, widget.contractAddress,
                          _formKey.currentState!.value);
                      // showDialog(
                      //   context: context,
                      //   builder: (value) {
                      //     return AlertDialog(
                      //       title: const Text("スパム作成ありがとうございます！"),
                      //       content: const Text(
                      //         "このスパムが良問と判断された場合、運営側から特別なNFTを配布いたします",
                      //       ),
                      //       actions: [
                      //         OutlinedButton(
                      //           onPressed: () {
                      //             Navigator.popUntil(
                      //                 context, (route) => route.isFirst);
                      //           },
                      //           child: const Text('Home'),
                      //         ),
                      //       ],
                      //     );
                      //   },
                      // );
                    }
                  },
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: OutlinedButton(
                  child: const Text(
                    "やり直す",
                    style: TextStyle(fontSize: 20),
                  ),
                  onPressed: () {
                    _formKey.currentState!.reset();
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
