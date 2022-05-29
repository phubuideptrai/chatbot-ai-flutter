import 'dart:convert';

import 'package:bubble/bubble.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey();
  List<String> _data = [];

  static const String BOT_URL = 'https://chatbot-ai-flutter.herokuapp.com/bot';
  TextEditingController queryController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.blue,
        title: const Text('ChatBot'),
      ),
      body: Stack(children: [
        AnimatedList(
            key: _listKey,
            initialItemCount: _data.length,
            itemBuilder:
                (BuildContext context, int index, Animation<double> animation) {
              return buildItem(_data[index], index, animation);
            }),
        Align(
          alignment: Alignment.bottomCenter,
          child: ColorFiltered(
            colorFilter: ColorFilter.linearToSrgbGamma(),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: TextField(
                  decoration: const InputDecoration(
                      icon: Icon(
                        Icons.message,
                        color: Colors.blue,
                      ),
                      hintText: 'Type message here',
                      fillColor: Colors.white12),
                  controller: queryController,
                  textInputAction: TextInputAction.send,
                  onSubmitted: (msg) {
                    this.getRespone();
                    queryController.clear();
                  },
                ),
              ),
            ),
          ),
        )
      ]),
    );
  }

  void getRespone() {
    if (queryController.text.isNotEmpty) {
      this.insertSingleItem(queryController.text);
      var client = getClient();
      try {
        client.post(Uri.parse(BOT_URL), body: {"query": queryController.text})
          ..then((response) {
            Map<String, dynamic> data = jsonDecode(response.body);
            insertSingleItem(data["response"] + "<bot>");
          });
      } finally {
        client.close();
        queryController.clear();
      }
    }
  }

  void insertSingleItem(String text) {
    _data.add(text);
    _listKey.currentState?.insertItem(_data.length - 1);
  }

  http.Client getClient() {
    return http.Client();
  }
}

Widget buildItem(String data, int index, Animation<double> animation) {
  bool mine = data.endsWith("<bot>");
  return SizeTransition(
    sizeFactor: animation,
    child: Padding(
      padding: EdgeInsets.only(top: 10),
      child: Container(
        alignment: mine ? Alignment.topLeft : Alignment.topRight,
        child: Bubble(
          child: Text(
            data.replaceAll("<bot>", ""),
            style: TextStyle(color: mine ? Colors.white : Colors.black),
          ),
          color: mine ? Colors.black : Colors.white,
          padding: BubbleEdges.all(10),
        ),
      ),
    ),
  );
}
