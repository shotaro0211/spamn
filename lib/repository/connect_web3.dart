import 'package:flutter_web3/flutter_web3.dart';
import 'dart:html' as html;

class ConnectWeb3 {
  Future<Signer?> getSigner() async {
    if (ethereum != null) {
      try {
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
    return null;
  }

  Future<bool> isConnected() async {
    final signer = await getSigner();
    return signer != null ? true : false;
  }

  Future addNetwork() async {
    await ethereum!.walletAddChain(
        chainId: 592,
        chainName: 'Astar Network',
        nativeCurrency:
            CurrencyParams(name: 'Astar', symbol: 'ASTR', decimals: 18),
        rpcUrls: ['https://rpc.astar.network:8545']);
  }
}
