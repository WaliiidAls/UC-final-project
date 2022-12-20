import 'package:flutter/material.dart';
import 'package:joinquotation/components/categories.dart';
import 'package:joinquotation/components/trending.dart';
import 'package:joinquotation/models/categories.dart';

class HomePage extends StatefulWidget {
  final void Function(bool prev) _onPageChanged;

  const HomePage({
    Key? key,
    required void Function(bool prev) onPageChanged,
  })  : _onPageChanged = onPageChanged,
        super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _title = ".home";

  final _controller = ScrollController();

  @override
  void initState() {
    _controller.addListener(scrollListener);
    super.initState();
  }

  scrollListener() {
    setState(() {
      if (_controller.position.pixels < 50) {
        _title = ".home";
      } else if (_controller.position.pixels < 1100) {
        _title = ".trending";
      } else {
        _title = ".categories";
      }
    });
  }

  void handleTitle(String title) {
    setState(() {
      _title = title;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
          title: Text(_title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          actions: [
            GestureDetector(
              onTap: () => widget._onPageChanged(false),
              child: Container(
                margin: EdgeInsets.only(right: 20),
                child: Icon(Icons.keyboard_arrow_right),
              ),
            ),
          ],
        ),
        body: SafeArea(
            child: CustomScrollView(
          controller: _controller,
          slivers: [
            // trending authors
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Trending(type: "authors", payload: [
                  {
                    "author": "James Sutter",
                  },
                  {
                    "author": "Jacklynn Crawford",
                  },
                  {"author": "Sam Delfino"},
                ]),
                childCount: 1,
              ),
            ),
            // trending quotes
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Trending(type: "quotes", payload: [
                  {
                    "author": "Khalifatul Masih III",
                    "quote": "Love For All, Hatred For None."
                  },
                  {
                    "author": "Amy Poehler",
                    "quote": "Change the world by being yourself."
                  },
                  {
                    "author": "T.S Eliot",
                    "quote": "Every moment is a fresh beginning."
                  },
                ]),
                childCount: 1,
              ),
            ),
            // categories heading
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) => Container(
                  margin: EdgeInsets.all(30),
                  child: Text(".categories",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      )),
                ),
                childCount: 1,
              ),
            ),
            // categories
            SliverList(
                delegate: SliverChildBuilderDelegate(
              (context, index) => Categories(
                item: CategoriesClass.menu[index],
              ),
              childCount: CategoriesClass.menu.length,
            )),
          ],
        )));
  }
}
