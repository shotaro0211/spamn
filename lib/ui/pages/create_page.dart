import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_web3/flutter_web3.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:spamn/repository/spamn_web3.dart';
import 'package:spamn/ui/components/main_scaffold.dart';
import 'package:spamn/ui/components/no_connected.dart';

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
    return MainScaffold(
      title: widget.title,
      child: _isConnected
          ? Column(
              children: <Widget>[
                FormBuilder(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      FormBuilderTextField(
                        name: 'value',
                        decoration: const InputDecoration(
                          labelText: 'VALUE (ASTR)',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                          FormBuilderValidators.numeric(context),
                        ]),
                      ),
                      FormBuilderTextField(
                        name: 'title',
                        decoration: const InputDecoration(
                          labelText: 'TITLE',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      FormBuilderTextField(
                        name: 'choice1',
                        decoration: const InputDecoration(
                          labelText: 'CHOICE 1',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                      ),
                      FormBuilderTextField(
                        name: 'choice2',
                        decoration: const InputDecoration(
                          labelText: 'CHOICE 2',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                      ),
                      FormBuilderTextField(
                        name: 'choice3',
                        decoration: const InputDecoration(
                          labelText: 'CHOICE 3',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                      ),
                      FormBuilderTextField(
                        name: 'choice4',
                        decoration: const InputDecoration(
                          labelText: 'CHOICE 4',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                      ),
                      FormBuilderChoiceChip(
                        name: 'answer',
                        decoration: const InputDecoration(
                          labelText: 'ANSWER',
                        ),
                        options: const [
                          FormBuilderFieldOption(
                              value: 1, child: Text('CHOICE 1')),
                          FormBuilderFieldOption(
                              value: 2, child: Text('CHOICE 2')),
                          FormBuilderFieldOption(
                              value: 3, child: Text('CHOICE 3')),
                          FormBuilderFieldOption(
                              value: 4, child: Text('CHOICE 4')),
                        ],
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      FormBuilderTextField(
                        name: 'description',
                        decoration: const InputDecoration(
                          labelText: 'ANSWER DESCRIPTION',
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(context),
                        ]),
                      ),
                      const SizedBox(height: 20),
                      FormBuilderTextField(
                        name: 'address',
                        decoration: const InputDecoration(
                          labelText: 'SEND ADDRESS ※If none, sent to WATCH',
                        ),
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
                          "SEND",
                          style: TextStyle(fontSize: 20),
                        ),
                        onPressed: () {
                          _formKey.currentState!.save();
                          if (_formKey.currentState!.validate()) {
                            if (_formKey.currentState!.value['address'] !=
                                null) {
                              SpamnWeb3().mint(_signer!, widget.contractAddress,
                                  _formKey.currentState!.value);
                            } else {
                              SpamnWeb3().watchMint(
                                  _signer!,
                                  widget.contractAddress,
                                  _formKey.currentState!.value);
                            }
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: OutlinedButton(
                        child: const Text(
                          "CLEAR",
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
            )
          : NoConnected(onPressed: () async {
              _onConnected();
            }),
    );
  }
}
