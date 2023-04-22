import 'dart:convert';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Country API',
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const MyHomePage(title: ''),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController input = TextEditingController();
  String desc = "";
  String resultName = '';
  String resultCurrencyCode = '';
  String resultCurrencyName = '';
  String resultCapital = '';
  String resultiso2 = '';
  final player = AudioPlayer();
  late ImageProvider imageProvider; // declare the image provider variable

  @override
  void initState() {
    super.initState();
    // initialize the image provider variable with an empty image
    imageProvider = const NetworkImage('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Country API'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const SizedBox(height: 40),
                TextField(
                  controller: input,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    hintText: "Enter the country",
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  height: 40,
                  width: 120,
                  child: ElevatedButton.icon(
                      onPressed: _getCountry,
                      icon: const Icon(Icons.search),
                      label: const Text("Search")),
                ),
                const SizedBox(height: 20),
                Container(
                    height: 400,
                    width: 400,
                    decoration: BoxDecoration(
                      border: Border.all(
                          color: const Color.fromARGB(255, 255, 16, 179),
                          width: 4),
                      color: const Color.fromARGB(255, 251, 106, 227),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          desc,
                          style: const TextStyle(
                            fontSize: 26,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Image(
                          image:
                              imageProvider,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return const Text('');
                          },
                        ),
                        const SizedBox(height: 20),
                      ],
                    )),
              ]),
        ),
      ),
    );
  }

  Future<void> _getCountry() async {
    String country = input.text;
    String apiid = "103qsLOFlUBvS83HleLbfQ==hH6jTfx2EmgKZlAx";
    Uri url = Uri.parse('https://api.api-ninjas.com/v1/country?name=$country');
    var response = await http.get(url, headers: {"X-Api-Key": apiid});
    if (response.statusCode == 200) {
      var jsonData = response.body;
      List parsedJson = json.decode(jsonData);
      List countryName = [];
      List countryCurrencyCode = [];
      List countryCurrencyName = [];
      List countryCapital = [];
      List countryiso2 = [];
      if (parsedJson.isNotEmpty) {
        countryName.add(parsedJson[0]['name']);
        countryCurrencyCode.add(parsedJson[0]['currency']['code']);
        countryCurrencyName.add(parsedJson[0]['currency']['name']);
        countryCapital.add(parsedJson[0]['capital']);
        countryiso2.add(parsedJson[0]['iso2']);
        resultName = countryName.join(",");
        resultCurrencyCode = countryCurrencyCode.join(",");
        resultCurrencyName = countryCurrencyName.join(",");
        resultCapital = countryCapital.join(",");
        resultiso2 = countryiso2.join(",");
        desc =
            "Country: \n$resultName \n\nCapital: \n$resultCapital \n\nCurrency: \n$resultCurrencyCode, $resultCurrencyName ";
        imageProvider = NetworkImage('https://flagsapi.com/$resultiso2/shiny/64.png');
        player.play(AssetSource("audios/Correct.mp3"));
        setState(() {});
      } else {
        player.play(AssetSource("audios/Error.mp3"));
        Widget okButton = TextButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          },
        );
        // ignore: use_build_context_synchronously
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Invalid country name OR code"),
              content: const Text("Please re-enter a new one"),
              actions: [
                okButton,
              ],
            );
          },
        );
      }
    }
  }
}
