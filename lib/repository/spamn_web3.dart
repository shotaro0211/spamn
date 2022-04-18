import 'package:flutter/services.dart';
import 'package:flutter_web3/flutter_web3.dart';

class SpamnWeb3 {
  final jsonName = 'json/spamn.json';

  Future<TransactionResponse> mint(Signer signer, String contractAddress,
      Map<String, dynamic> formValue) async {
    final abi = await rootBundle.loadString(jsonName);
    final contract = Contract(contractAddress, abi, signer);

    final value = await contract.send('mint', [
      formValue['title'].toString(),
      [
        formValue['choice1'].toString(),
        formValue['choice2'].toString(),
        formValue['choice3'].toString(),
        formValue['choice4'].toString(),
      ],
      int.parse(formValue['answer'].toString()),
      formValue['description'].toString(),
      formValue['address'].toString(),
    ]).then((value) {
      return value;
    });
    return value;
  }
}
