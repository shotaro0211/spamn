import 'package:flutter/services.dart';
import 'package:flutter_web3/flutter_web3.dart';

class SpamnWeb3 {
  final jsonName = 'json/spamn.json';

  Future<TransactionResponse> watchMint(Signer signer, String contractAddress,
      Map<String, dynamic> formValue) async {
    final abi = await rootBundle.loadString(jsonName);
    final contract = Contract(contractAddress, abi, signer);

    final value = await contract.send('watchMint', [
      formValue['title'].toString(),
      [
        formValue['choice1'].toString(),
        formValue['choice2'].toString(),
        formValue['choice3'].toString(),
        formValue['choice4'].toString(),
      ],
      int.parse(formValue['answer'].toString()),
      formValue['description'].toString(),
    ]).then((value) {
      return value;
    });
    return value;
  }

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

  Future<bool> watched(Signer signer, String contractAddress) async {
    final abi = await rootBundle.loadString(jsonName);
    final contract = Contract(contractAddress, abi, signer);

    final value = await contract.call<bool>('watched', []).then((value) {
      return value;
    });
    return value;
  }

  Future<int> getTotalWatchCount(Signer signer, String contractAddress) async {
    final abi = await rootBundle.loadString(jsonName);
    final contract = Contract(contractAddress, abi, signer);

    final value = await contract.call('getTotalWatchCount', []).then((value) {
      return value.toString();
    });
    return int.parse(value);
  }

  Future<TransactionResponse> addWatch(
      Signer signer, String contractAddress) async {
    final abi = await rootBundle.loadString(jsonName);
    final contract = Contract(contractAddress, abi, signer);

    final value = await contract.send('addWatch', []).then((value) {
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

  Future<String> getImageUrl(Signer signer, String contractAddress) async {
    final abi = await rootBundle.loadString(jsonName);
    final contract = Contract(contractAddress, abi, signer);

    final value = await contract.call('getImageUrl').then((value) {
      return value.toString();
    });
    return value;
  }

  Future<String> getTitle(Signer signer, String contractAddress) async {
    final abi = await rootBundle.loadString(jsonName);
    final contract = Contract(contractAddress, abi, signer);

    final value = await contract.call('getTitle').then((value) {
      return value.toString();
    });
    return value;
  }
}
