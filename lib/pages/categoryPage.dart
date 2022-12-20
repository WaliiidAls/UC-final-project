// Quotation Category Page
import 'package:flutter/material.dart';
import 'package:joinquotation/components/quote.dart';
import 'package:joinquotation/models/categories.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoriesPage extends StatefulWidget {
  final CategoriesClass _category;

  CategoriesPage({
    Key? key,
    required CategoriesClass category,
  })  : _category = category,
        super(key: key);

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  Stream<QuerySnapshot>? _quotesStream;

  void initState() {
    _quotesStream = FirebaseFirestore.instance
        .collection('quotes')
        .doc(widget._category.dbTag)
        .collection("quote")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Icon(Icons.keyboard_arrow_left),
            ),
          ),
          title: Text(".${widget._category.title.toLowerCase()}",
              style: TextStyle(
                fontSize: 20,
              )),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: _quotesStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(".error"),
              );
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            final data = snapshot.requireData;
            return ListView.builder(
                itemCount: data.size,
                itemBuilder: (context, index) {
                  // print(data.docs[index].runtimeType);
                  return Quote(
                    quote: data.docs[index]["quote"],
                    author: data.docs[index]["author"],
                    likes: 10,
                  );
                });
          },
        ));
  }
}

/*
Text(_category.desc,
                        style: TextStyle(color: Theme.of(context).primaryColor)),
                        */