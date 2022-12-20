import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';

List _ColorsList = [
  {
    "hex": 0xffFF6F6F,
    "name": "Red",
  },
  {
    "hex": 0xffFFC06F,
    "name": "Orange",
  },
  {
    "hex": 0xffFF6F9D,
    "name": "Pink",
  },
  {
    "hex": 0xff6F6FFF,
    "name": "Blue",
  },
];

class Quote extends StatefulWidget {
  final String _quote;
  final String _author;
  final int _likes;

  const Quote({
    Key? key,
    required String quote,
    required String author,
    required int likes,
  })  : _quote = quote,
        _author = author,
        _likes = likes,
        super(key: key);

  @override
  State<Quote> createState() => _QuoteState();
}

class _QuoteState extends State<Quote> {
  Map _payload = {
    "isLiked": false,
    "isSaved": false,
  };

  void handleEvent(e) {
    setState(() {
      _payload[e] = !_payload[e];
    });
  }

  Future<void> share() async {
    await FlutterShare.share(
        title: widget._quote,
        text:
            "${widget._author} once said, '${widget._quote}'\n\ncheck out https://joinquotation.netlify.app for more quotes",
        linkUrl: "https://joinquotation.netlify.app",
        chooserTitle: widget._quote);
  }

  // random index from _ColorsList
  int _randomIndex = Random().nextInt(_ColorsList.length);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350,
      // height: 200,
      padding: EdgeInsets.all(25),
      margin: EdgeInsets.all(25),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0xff000000).withOpacity(0.05),
              blurRadius: 15,
              spreadRadius: -5,
            )
          ],
          borderRadius: BorderRadius.circular(25)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 15,
                backgroundColor: Color(_ColorsList[_randomIndex]["hex"]),
              ),
              Padding(padding: EdgeInsets.symmetric(horizontal: 5)),
              Text(
                widget._author != null
                    ? "@${widget._author.toLowerCase().replaceAll(" ", "_")}"
                    : "@username",
                style: TextStyle(color: Color(0xff3d3d3d)),
              ),
            ],
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          Text(
            widget._quote,
            overflow: TextOverflow.fade,
          ),
          Padding(padding: EdgeInsets.only(bottom: 10)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Container(
              width: 70,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () => handleEvent("isLiked"),
                    child: _payload["isLiked"]
                        ? Icon(Icons.favorite, color: Color(0xff3d3d3d))
                        : Icon(Icons.favorite_border, color: Color(0xff000000)),
                  ),
                  GestureDetector(
                    onTap: () => handleEvent("isSaved"),
                    child: _payload["isSaved"]
                        ? Icon(Icons.bookmark, color: Color(0xff3d3d3d))
                        : Icon(Icons.bookmark_border, color: Color(0xff000000)),
                  ),
                  // Icon(Icons.bookmark_border),
                ],
              ),
            ),
            GestureDetector(onTap: share, child: Icon(Icons.share)),
          ]),
        ],
      ),
    );
  }
}
