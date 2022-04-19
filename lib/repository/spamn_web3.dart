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

  Future<TransactionResponse> setAnswer(
      Signer signer, String contractAddress, int tokenId, int answer) async {
    final abi = await rootBundle.loadString(jsonName);
    final contract = Contract(contractAddress, abi, signer);

    final value = await contract.send('setAnswer', [
      tokenId,
      answer,
    ]).then((value) {
      return value;
    });
    return value;
  }

  Future<String> getQuestionTitle(
      Signer signer, String contractAddress, int tokenId) async {
    final abi = await rootBundle.loadString(jsonName);
    final contract = Contract(contractAddress, abi, signer);

    final value =
        await contract.call('getQuestionTitle', [tokenId]).then((value) {
      return value.toString();
    });
    return value;
  }

  Future<List<dynamic>> getQuestionChoices(
      Signer signer, String contractAddress, int tokenId) async {
    final abi = await rootBundle.loadString(jsonName);
    final contract = Contract(contractAddress, abi, signer);

    final value = await contract
        .call<List<dynamic>>('getQuestionChoices', [tokenId]).then((value) {
      return value;
    });
    return value;
  }

  Future<int> getQuestionValue(
      Signer signer, String contractAddress, int tokenId) async {
    final abi = await rootBundle.loadString(jsonName);
    final contract = Contract(contractAddress, abi, signer);

    final value =
        await contract.call('getQuestionValue', [tokenId]).then((value) {
      return value.toString();
    });
    return int.parse(value);
  }

  Future<bool> getQuestionCorrected(
      Signer signer, String contractAddress, int tokenId) async {
    final abi = await rootBundle.loadString(jsonName);
    final contract = Contract(contractAddress, abi, signer);

    final value = await contract
        .call<bool>('getQuestionCorrected', [tokenId]).then((value) {
      return value;
    });
    return value;
  }

  Future<bool> getQuestionAnswered(
      Signer signer, String contractAddress, int tokenId) async {
    final abi = await rootBundle.loadString(jsonName);
    final contract = Contract(contractAddress, abi, signer);

    final value = await contract
        .call<bool>('getQuestionAnswered', [tokenId]).then((value) {
      return value;
    });
    return value;
  }
}
