import 'package:flutter_web3/flutter_web3.dart';
import 'dart:html' as html;

import 'package:url_launcher/url_launcher.dart';

class ConnectWeb3 {
  Future<Signer?> getSigner() async {
    if (ethereum != null) {
      try {
        await addNetwork();
        await ethereum!.requestAccount();
        const networkId = 592;
        await ethereum!.walletSwitchChain(networkId);
        final web3provider = Web3Provider(ethereum!);
        final network = await web3provider.getNetwork();
        final signer = web3provider.getSigner();
        if (network.chainId == networkId) {
          ethereum!.onAccountsChanged((accounts) {
            html.window.location.reload();
          });
          ethereum!.onChainChanged((chainId) {
            html.window.location.reload();
          });
          return signer;
        }
      } on EthereumUserRejected {
        print('User rejected the modal');
      }
    }
    await launch('https://metamask.app.link/dapp/spamn.app/');
    return null;
  }

  Future<bool> isConnected() async {
    if (ethereum != null) {
      const networkId = 592;
      final web3provider = Web3Provider(ethereum!);
      final network = await web3provider.getNetwork();
      final adress = await web3provider.getSigner().getAddress();
      if (adress.isNotEmpty && network.chainId == networkId) {
        return true;
      }
    }
    return false;
  }

  Future addNetwork() async {
    await ethereum!.walletAddChain(
        chainId: 592,
        chainName: 'Astar Network',
        nativeCurrency:
            CurrencyParams(name: 'Astar', symbol: 'ASTR', decimals: 18),
        rpcUrls: ['https://astar.api.onfinality.io/public']);
  }
}
