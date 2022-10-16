import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../global.dart';
import '../helpers/currency_convert_api_helper.dart';
import '../main.dart';
import '../modals/currency_convert_model_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<CurrencyConvert?> future;
  TextEditingController amtController = TextEditingController();

  TextStyle fromToStyle = TextStyle(
    color: Color(0xff937DA8),
    fontSize: 20,
    decoration: TextDecoration.none,
        fontWeight: FontWeight.bold,
  );

  @override
  void initState() {
    super.initState();
    future = CurrencyConvertApiHelper.currencyConvertApiHelper
        .currencyConvertorAPI(from: "USD", to: "INR", amount: 1);

    amtController.text = "1";
  }

  String fromCurrency = "USD";
  String toCurrency = "INR";

  @override
  Widget build(BuildContext context) {
    return (Global.isAndroid)
        ? buildCupertino()
        : buildMaterial();
  }

  Scaffold buildMaterial(){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        title: const Text("Currency Convertor"),
        actions: [
          Switch(
              onChanged: (val) {
                Global.isAndroid = val;
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (context) => const MyApp(),
                    ),
                        (route) => false);
              },
              value: Global.isAndroid),
        ],
      ),
      body: FutureBuilder(
        future: future,
        builder: (context, snapShot) {
          if (snapShot.hasError) {
            return Center(
              child: Text("${snapShot.error}"),
            );
          } else if (snapShot.hasData) {
            CurrencyConvert? data = snapShot.data;

            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  SizedBox(
                    height: 240,
                    child: Image.asset(
                      "assets/images/digital_currency.png",
                    ),
                  ),
                  Row(
                    children: [
                      Text("Amount  :", style: fromToStyle),
                      Expanded(
                        child: Container(
                          padding:
                          const EdgeInsets.symmetric(horizontal: 10),
                          child: TextField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              contentPadding:
                              const EdgeInsets.only(left: 20),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            controller: amtController,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Divider(
                    color: Global.appColor,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("From", style: fromToStyle),
                              DropdownButtonFormField(
                                value: fromCurrency,
                                onChanged: (val) {
                                  setState(() {
                                    fromCurrency = val!;
                                  });
                                },
                                items: Global.currency.map((e) {
                                  return DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("To", style: fromToStyle),
                              DropdownButtonFormField(
                                value: toCurrency,
                                onChanged: (val) {
                                  setState(() {
                                    toCurrency = val!;
                                  });
                                },
                                items: Global.currency.map((e) {
                                  return DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        "$fromCurrency :",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.none,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        " 1",
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontSize: 18,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "$toCurrency :",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.none,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        " ${data!.rate.round()}",
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Text(
                        "$fromCurrency :",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.none,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        " ${amtController.text}",
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontSize: 18,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "$toCurrency :",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.none,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        " ${data.difference.round()}",
                        style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      onPressed: () {
                        if (amtController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              backgroundColor: Global.appColor,
                              behavior: SnackBarBehavior.floating,
                              content: const Text("Please Enter Amount"),
                            ),
                          );
                        } else {
                          int amount = int.parse(amtController.text);
                          setState(() {
                            future = CurrencyConvertApiHelper.currencyConvertApiHelper
                                .currencyConvertorAPI(
                              from: fromCurrency,
                              to: toCurrency,
                              amount: amount,
                            );
                          });
                        }
                      },
                      child: const Text(
                        "CONVERT",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  CupertinoPageScaffold buildCupertino(){
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        trailing: CupertinoSwitch(
            activeColor: CupertinoColors.activeBlue.withOpacity(0.5),
            onChanged: (val) {
              Global.isAndroid = val;
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(
                    builder: (context) => const MyApp(),
                  ),
                      (route) => false);
            },
            value: Global.isAndroid),
        backgroundColor: Theme.of(context).primaryColor,
        middle: const Text(
          "Currency Convertor",
          style: TextStyle(color: CupertinoColors.white),
        ),
      ),
      backgroundColor: CupertinoColors.white,
      child: FutureBuilder(
        future: future,
        builder: (context, snapShot) {
          if (snapShot.hasError) {
            return Center(
              child: Text("${snapShot.error}"),
            );
          } else if (snapShot.hasData) {
            CurrencyConvert? data = snapShot.data;

            return Container(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    SizedBox(
                      height: 240,
                      child: Image.asset(
                        "assets/images/digital_currency.png",
                      ),
                    ),
                    Row(
                      children: [
                        Text("Amount  :", style: fromToStyle),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10),
                            child: CupertinoTextField(
                              keyboardType: TextInputType.number,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border:
                                Border.all(color: Global.appColor),
                              ),
                              controller: amtController,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Divider(
                      color: Global.appColor,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text("From", style: fromToStyle),
                                GestureDetector(
                                  onTap: () {
                                    showCupertinoModalPopup(
                                        context: context,
                                        builder: (_) => SizedBox(
                                          width:
                                          MediaQuery.of(context)
                                              .size
                                              .width *
                                              0.60,
                                          height: 250,
                                          child: CupertinoPicker(
                                            backgroundColor:
                                            Colors.white,
                                            itemExtent: 30,
                                            children: Global.currency
                                                .map((e) {
                                              return Text(e);
                                            }).toList(),
                                            onSelectedItemChanged:
                                                (value) {
                                              setState(() {
                                                fromCurrency = Global
                                                    .currency[value];
                                              });
                                            },
                                          ),
                                        ));
                                  },
                                  child: Container(
                                    color:
                                    Global.appColor.withOpacity(0.1),
                                    height: 45,
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        Text(
                                          fromCurrency,style: const TextStyle(
                                        color: Colors.black,
                                          fontSize: 20,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.bold,
                                        )
                                        ),
                                        const Spacer(),
                                        const Icon(CupertinoIcons
                                            .arrow_2_squarepath),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Text("To", style: fromToStyle),
                                GestureDetector(
                                  onTap: () {
                                    showCupertinoModalPopup(
                                      context: context,
                                      builder: (_) => SizedBox(
                                        width: MediaQuery.of(context)
                                            .size
                                            .width *
                                            0.60,
                                        height: 250,
                                        child: CupertinoPicker(
                                          backgroundColor: Colors.white,
                                          itemExtent: 30,
                                          children:
                                          Global.currency.map((e) {
                                            return Text(e);
                                          }).toList(),
                                          onSelectedItemChanged: (value) {
                                            setState(() {
                                              toCurrency =
                                              Global.currency[value];
                                            });
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    color:
                                    Global.appColor.withOpacity(0.1),
                                    height: 45,
                                    child: Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        Text(
                                          toCurrency,style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20,
                                          decoration: TextDecoration.none,
                                          fontWeight: FontWeight.bold,
                                        )
                                        ),
                                        const Spacer(),
                                        const Icon(CupertinoIcons
                                            .arrow_2_squarepath),
                                        const SizedBox(width: 10),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Text(
                          "$fromCurrency :",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.none,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          " 1",
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 18,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "$toCurrency :",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.none,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          " ${data!.rate.round()}",
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          "$fromCurrency :",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.none,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          " ${amtController.text}",
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 18,
                          ),
                        ),
                        Spacer(),
                        Text(
                          "$toCurrency :",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            decoration: TextDecoration.none,
                            fontSize: 22,
                          ),
                        ),
                        Text(
                          " ${data.difference.round()}",
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.none,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: CupertinoButton(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(50),
                        onPressed: () {
                          if (amtController.text.isEmpty) {
                          } else {
                            int amount = int.parse(amtController.text);
                            setState(() {
                              future = CurrencyConvertApiHelper.currencyConvertApiHelper
                                  .currencyConvertorAPI(
                                from: fromCurrency,
                                to: toCurrency,
                                amount: amount,
                              );
                            });
                          }
                        },
                        child: const Text(
                          "CONVERT",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
