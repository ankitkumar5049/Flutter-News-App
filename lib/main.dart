import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:untitled/src/Constants.dart';
import 'package:untitled/src/Strings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Constants.appName,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<dynamic> articles = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    const apiKey = Constants.newsApiKey;
    final response = await http.get(
      Uri.parse('${Constants.baseUrl}${Constants.newsEndpoint}?q=tesla&from=2023-12-07&sortBy=publishedAt&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      setState(() {
        articles = json.decode(response.body)['articles'];
      });
    } else {
      throw Exception(Strings.exception);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(Strings.companyName),
      ),
      body: Center(
        child: articles.isEmpty
            ? CircularProgressIndicator()
            : ListView.builder(
          itemCount: articles.length,
          itemBuilder: (BuildContext context, int index) {
            // Check if the image URL is available
            final imageUrl = articles[index]['urlToImage'];
            final hasImageUrl = imageUrl != null && imageUrl is String && imageUrl.isNotEmpty;

            return Card(
              margin: EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(articles[index]['title']),
                subtitle: Text(articles[index]['description']),
                leading: hasImageUrl
                    ? Image.network(
                  imageUrl,
                  width: 80.0,
                  height: 80.0,
                  fit: BoxFit.cover,
                )
                    : Container(
                  width: 80.0,
                  height: 80.0,
                  color: Colors.grey,
                  alignment: Alignment.center,
                  child: Text('No Image'),
                ),
                onTap: () {
                  // Handle tap on the news article if needed
                  // You can navigate to a detailed view or open the article in a webview.
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
