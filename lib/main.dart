import 'dart:convert';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Web Service Flutter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String key = "ogET2E4-btUX_OhYJLH2Fim18O3bI5pgLcU462IxkOo";
  String searchWord = "ecuador";

  Future <Map> getPics() async{
    String url = "https://api.unsplash.com/search/photos?query=$searchWord&client_id=$key";
    http.Response response = await http.get(url);
    return json.decode(response.body);
  }

  _listItem(index, Map data) {
    return Container(
        child: Card(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Image.network(
                  data['results'][index]['urls']['small'],
              ),
              Row(
                children: [
                  IconButton(icon: FaIcon(FontAwesomeIcons.thumbsUp)),
                  Text(data['results'][index]['likes'].toString()),
                  IconButton(icon: FaIcon(FontAwesomeIcons.user)),
                  Text(data['results'][index]['user']['username'])
                ],
              )
            ],
          ),
        )
    );
  }
  _searchBar(){
    return Padding(
        padding: const EdgeInsets.all(8),
        child: TextField(
            decoration: InputDecoration(hintText: 'Bucar'),
            onChanged: (text){
              text = text.toLowerCase();
              setState(() {
                searchWord = text;
              });
            },
        ),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getPics(),
        builder: (context, snapshot){

          final Map data = snapshot.data;
          if(snapshot.hasError) {
            return
              Center(
                  child: Text(
                    "Some error ocurred",
                    style: TextStyle(fontSize: 16.0, color: Colors.red),
                  ));
          }

          else if (snapshot.hasData){
            return
                ListView.builder(
                  itemCount: (data["results"] as List).length + 1,
                  itemBuilder: (context, index){
                    return index==0 ? _searchBar() : _listItem(index-1, data);
                  });

          }
          else{
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
    );
  }
}
