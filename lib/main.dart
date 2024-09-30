import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Metamask Demo",
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SessionStatus? session;
  String? account;

  Future<void> walletConnect() async {
    final connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
        name: 'WalletConnect',
        description: 'WalletConnect Developer App',
        url: 'https://walletconnect.org',
        icons: [
          'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
        ],
      ),
    );

    // Subscribe to events
    if (!connector.connected) {
  print('Connector is not connected. Creating a new session...');
  session = await connector.createSession(
    chainId: 11155111, // Sepolia Testnet
    onDisplayUri: (uri) async {
      print('Display URI: $uri');
      
      final Uri metamaskUri = Uri.parse("metamask://wc?uri=${Uri.encodeComponent(uri)}");
      print('Display new URI: $metamaskUri');
      
      // Launch the MetaMask URI without checking
      await launchUrl(metamaskUri, mode: LaunchMode.externalApplication);
    },
  );
  print('Session created: ${session.toString()}');
}


    setState(() {
      account = session!.accounts[0];
      print('Account set: $account');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Metamask Demo"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.black,
                  shape: const StadiumBorder(),
                ),
                onPressed: walletConnect,
                child: const Padding(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    "Connect Wallet",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              account != null
                  ? Text(
                      "Address: $account",
                      style: const TextStyle(fontSize: 20),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
