import 'package:flutter/material.dart';
import 'package:joinquotation/components/quote.dart';

class Trending extends StatelessWidget {
  final String _type;
  final List _payload;
  PersistentBottomSheetController? seeAllSheetController;

  Trending({
    Key? key,
    required String type,
    required List payload,
  })  : _type = type,
        _payload = payload,
        super(key: key);

  Column _loadAuthors() {
    return Column(
      children: [
        for (int i = 0; i < 3; i++)
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin:
                    EdgeInsets.only(left: 50, right: 30, top: 15, bottom: 15),
                height: 20,
                width: 2,
                color: Color(0xff3d3d3d),
              ),
              Text(
                  "@${_payload[i]["author"].toLowerCase().replaceAll(" ", "_")}",
                  style: TextStyle(
                    fontSize: 18,
                  ))
            ],
          ),
      ],
    );
  }

  Column _loadQuotes() {
    return Column(children: [
      for (int i = 0; i < 3; i++)
        Quote(
          quote: _payload[i]["quote"],
          author: _payload[i]["author"],
          likes: 10,
        ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (seeAllSheetController != null) {
          seeAllSheetController!.close();
          seeAllSheetController = null;
        }
      },
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.all(30),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                          _type == "authors"
                              ? ".trending authors"
                              : ".trending quotes",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                                decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20)),
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          blurRadius: 20)
                                    ]),
                                width: MediaQuery.of(context).size.width,
                                child: SingleChildScrollView(
                                    child: _type == "authors"
                                        ? _loadAuthors()
                                        : _loadQuotes())));
                      },
                      child: Text("see all",
                          style: TextStyle(
                            fontSize: 15,
                          )),
                    ),
                  ])),
          if (_type == "authors") _loadAuthors(),
          if (_type == "quotes") _loadQuotes(),
        ],
      ),
    );
  }
}
