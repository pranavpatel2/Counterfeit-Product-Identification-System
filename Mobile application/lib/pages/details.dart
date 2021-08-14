import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';

class details extends StatefulWidget {
  var code;

  details(this.code);

  @override
  _detailState createState() => _detailState(code);
}

class _detailState extends State<details> {
  var code;

  _detailState(this.code);

  TextEditingController controller = TextEditingController();
  late SharedPreferences prefs;

  final String _rpcUrl =
      "https://rinkeby.infura.io/v3/645ab1809557495ca3e49b74c15d0707";
  final String _wsUrl =
      "wss://rinkeby.infura.io/ws/v3/645ab1809557495ca3e49b74c15d0707/";

  final String _privateKey =
      "c216459066bd438e3aab3edecffac1f65bb8c58a89735a1dfdd3e0e5cbb1b336";
  late final Web3Client _client;
  late var contract;

  Future<void> initialSetup() async {
    prefs = await SharedPreferences.getInstance();

    _client = Web3Client(_rpcUrl, Client(), socketConnector: () {
      return IOWebSocketChannel.connect(_wsUrl).cast<String>();
    });
  }

  setup() async {
    String abi = await rootBundle.loadString("android/app/src/abis/abi2.json");
    String contactAddress = "0xaC911d37C3773FE21757677B7B687044a3feF1bc";
    contract = DeployedContract(ContractAbi.fromJson(abi, "fakeProduct"),
        EthereumAddress.fromHex(contactAddress));
  }

  getname(String email) async {
    final ethFunction2 = contract.function("getCustomer");
    final result1 = await _client
        .call(contract: contract, function: ethFunction2, params: [email]);
    print(result1[0]);
    setState(() {
      user = result1[0];
      usr = true;
    });
  }

  changeOwner() async {
    var credentails = await _client.credentialsFromPrivateKey(
        "c216459066bd438e3aab3edecffac1f65bb8c58a89735a1dfdd3e0e5cbb1b336");
    final ethFunction = await contract.function("changeOwner");
    final result = await _client.sendTransaction(
      credentails,
      Transaction.callContract(
          contract: contract,
          function: ethFunction,
          parameters: [code, customer.text.toString()]),
      chainId: 4,
    );
    print(result);
  }

  get() async {
    await setup();

    var result = [];
    var result1 = [];
    var result2 = [];

    final ethFunction = contract.function("getProductDetails");
    final ethFunction2 = contract.function("getCustomer");
    final ethFunction3 = contract.function("getOwner");

    result = await _client
        .call(contract: contract, function: ethFunction, params: [code]);
    result2 = await _client
        .call(contract: contract, function: ethFunction3, params: [code]);
    print(result);

    if (result[0].length == 0) {
      yes = false;
      no = true;
    }
    if (result2[0].toString() == prefs.getString("uemail") &&
        prefs.getBool("loggedIn") == true)
      setState(() {
        islogin = true;
      });
    else
      setState(() {
        islogin = false;
      });
    result1 = await _client
        .call(contract: contract, function: ethFunction2, params: [result2[0]]);

    setState(() {
      pname = result[0].toString();
      mname = result[3].toString();
      date = result[5].toString();
      owner = result1[0].toString();
      model = result[1].toString();
      details = result[2].toString();
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    initialSetup();
    super.initState();
    get();
  }

  String pname = "";
  String mname = "";
  String date = "";
  String owner = "";
  String model = "";
  String details = "";
  String user = "";
  bool yes = true;
  bool no = false;
  bool islogin = false;
  bool submit = false;
  bool verify = true;
  bool usr = false;
  TextEditingController customer = new TextEditingController();

  createAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text(
                "Enter buyer detail",
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                    color: Colors.purple),
              ),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextField(
                      controller: customer,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(hintText: 'Email'),
                    ),
                    Visibility(
                      visible: verify,
                      child: RaisedButton(
                          color: Theme.of(context).accentColor,
                          child: Text('Verify'),
                          onPressed: () {
                            setState(() {
                              submit = true;
                              usr = true;
                              getname(customer.text.toString());
                            });
                          }),
                    ),
                    Padding(padding: EdgeInsets.only(left: 10)),
                    Visibility(
                        visible: usr,
                        child: Text(
                          '$user',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold),
                        )),
                    SizedBox(
                      height: 40,
                    ),
                    Visibility(
                      visible: submit,
                      child: RaisedButton(
                          color: Theme.of(context).accentColor,
                          child: Text('Submit'),
                          onPressed: () {
                            changeOwner();
                            get();
                            Navigator.of(context).pop();
                          }),
                    )
                  ],
                ),
              ),
              actions: [
                MaterialButton(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })
              ],
            );
          });
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Details"),
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  get();
                },
                child: Icon(
                  Icons.refresh,
                  size: 26.0,
                ),
              )),
        ],
        automaticallyImplyLeading: true,
      ),
      backgroundColor: Colors.teal,
      body: SingleChildScrollView(
        child: Card(
            margin: EdgeInsets.all(20.0),
            elevation: 5.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                    visible: no,
                    child: Center(
                      child: Container(
                          child: Text(
                        "No product found",
                        style: TextStyle(
                            color: Colors.red,
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold),
                      )),
                    )),
                Visibility(
                  visible: yes,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Product Details",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                              "Product Name:",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Text('$pname')
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                              "Model:",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Text('$model')
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                              "Manufacture:",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            Padding(padding: EdgeInsets.only(left: 15)),
                            Text('$mname')
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                              "Manufactor Date:",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Text('$date')
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                              "Description:",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Expanded(
                              child: Text(
                                '$details', overflow: TextOverflow.ellipsis,
                                // default is .clip
                                maxLines: 2,
                              ),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Text(
                              "Current Owner:",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 18.0),
                            ),
                            Padding(padding: EdgeInsets.only(left: 10)),
                            Text('$owner')
                          ],
                        ),
                        Padding(padding: const EdgeInsets.only(left: 10)),
                        SizedBox(
                          height: 40,
                        ),
                        Visibility(
                          visible: islogin,
                          child: Container(
                            child: Column(
                              children: [
                                Text(
                                  "YOU ARE OWNER OF THIS PRODUCT",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Colors.blueAccent),
                                ),
                                Text(
                                  " DO YOU WANT TO SELL IT?",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Colors.purple),
                                ),
                                RaisedButton(
                                    color: Theme.of(context).accentColor,
                                    child: Text('SELL'),
                                    onPressed: () {
                                      usr = false;
                                      customer.text = "";
                                      submit = false;
                                      createAlert(context);
                                    }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
    throw UnimplementedError();
  }
}
