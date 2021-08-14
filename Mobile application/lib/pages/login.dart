import 'package:Fake_product_detection/pages/app.dart';
import 'package:Fake_product_detection/pages/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/rendering.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String _email, _password;
  final auth = FirebaseAuth.instance;
  late SharedPreferences prefs;

  bool _isvisible = true;
  bool _islogin = true;
  bool _issignup = false;
  bool _isaddr = false;
  String _radioSelected = "one";
  int _initswitch = 0;
  TextEditingController name = TextEditingController();

  shared() async {
    prefs = await SharedPreferences.getInstance();
  }

  final String _rpcUrl =
      "https://rinkeby.infura.io/v3/645ab1809557495ca3e49b74c15d0707";
  final String _wsUrl =
      "wss://rinkeby.infura.io/ws/v3/645ab1809557495ca3e49b74c15d0707/";

  final String _privateKey =
      "c216459066bd438e3aab3edecffac1f65bb8c58a89735a1dfdd3e0e5cbb1b336";
  late final Web3Client _client;
  late final contract;

  setup() async {
    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });

    String abi = await rootBundle.loadString("android/app/src/abis/abi2.json");
    String contactAddress = "0xaC911d37C3773FE21757677B7B687044a3feF1bc";
    contract = DeployedContract(ContractAbi.fromJson(abi, "fakeProduct"),
        EthereumAddress.fromHex(contactAddress));
  }

  Adddetail() async {
    var credentails = await _client.credentialsFromPrivateKey(
        "c216459066bd438e3aab3edecffac1f65bb8c58a89735a1dfdd3e0e5cbb1b336");
    final ethFunction2 = contract.function("addCustomer");
    final result = await _client.sendTransaction(
      credentails,
      Transaction.callContract(
          contract: contract,
          function: ethFunction2,
          parameters: [name.text.toString(), _email]),
      chainId: 4,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    shared();
    setup();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Login'),
          automaticallyImplyLeading: true,
        ),
        backgroundColor: Colors.blueGrey,
        body: SingleChildScrollView(
          child: Card(
            margin: EdgeInsets.all(30.0),
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                ToggleSwitch(
                  minWidth: 140.0,
                  cornerRadius: 20.0,
                  activeBgColors: [
                    [Colors.blue],
                    [Colors.pink]
                  ],
                  activeFgColor: Colors.white,
                  inactiveBgColor: Colors.grey,
                  inactiveFgColor: Colors.white,
                  initialLabelIndex: _initswitch,
                  totalSwitches: 2,
                  labels: ['Log In', 'Sign up'],
                  radiusStyle: true,
                  onToggle: (index) {
                    setState(() {
                      if (index == 1) {
                        _initswitch = 1;
                        _islogin = false;
                        _issignup = true;
                        _isaddr = false;
                      } else {
                        _initswitch = 0;
                        _islogin = true;
                        _issignup = false;
                      }
                    });
                  },
                ),
                Visibility(
                  visible: _islogin,
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Email',
                                labelText: 'Email'),
                            onChanged: (value) {
                              setState(() {
                                _email = value.trim();
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: 'Password',
                              labelText: "Password",
                            ),
                            onChanged: (value) {
                              setState(() {
                                _password = value.trim();
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: RaisedButton(
                              color: Theme.of(context).accentColor,
                              child: Text('Log in'),
                              onPressed: () {
                                auth
                                    .signInWithEmailAndPassword(
                                        email: _email, password: _password)
                                    .then((_) {
                                  prefs.setBool("loggedIn", true);
                                  prefs.setString("uemail", _email);
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => App()));
                                });
                              }),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: _issignup,
                  child: Container(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Customer'),
                            Radio(
                              value: 1,
                              groupValue: "_radioSelected",
                              activeColor: Colors.blue,
                              onChanged: (value) {
                                setState(() {
                                  _radioSelected = "one";
                                  _isaddr = false;
                                });
                              },
                            ),
                            Text('Retailer'),
                            Radio(
                              value: 2,
                              groupValue: "_radioSelected",
                              activeColor: Colors.red,
                              onChanged: (value) {
                                setState(() {
                                  _radioSelected = "two";
                                  _isaddr = true;
                                });
                              },
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Visibility(
                            visible: _isvisible,
                            child: TextField(
                              controller: name,
                              decoration: InputDecoration(hintText: 'Name'),
                              onChanged: (value) {
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(hintText: 'Email'),
                            onChanged: (value) {
                              setState(() {
                                _email = value.trim();
                              });
                            },
                          ),
                        ),
                        Visibility(
                          visible: _isaddr,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: TextField(
                                decoration:
                                    InputDecoration(hintText: 'Address'),
                                onChanged: (value) {
                                  setState(() {});
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(hintText: 'Password'),
                            onChanged: (value) {
                              setState(() {
                                _password = value.trim();
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            obscureText: true,
                            decoration:
                                InputDecoration(hintText: 'Confirm Password'),
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                          child: RaisedButton(
                              color: Theme.of(context).accentColor,
                              child: Text('Sign up'),
                              onPressed: () {
                                auth
                                    .createUserWithEmailAndPassword(
                                        email: _email, password: _password)
                                    .then((_) {
                                  prefs.setBool("loggedIn", true);
                                  prefs.setString("uemail", _email);
                                  Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                          builder: (context) => App()));
                                  Adddetail();
                                });
                              }),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
