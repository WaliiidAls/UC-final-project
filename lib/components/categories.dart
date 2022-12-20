import 'package:flutter/material.dart';
import 'package:joinquotation/models/categories.dart';
import 'package:joinquotation/pages/categoryPage.dart';

class Categories extends StatelessWidget {
  final CategoriesClass _item;
  const Categories({
    Key? key,
    required CategoriesClass item,
  })  : _item = item,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (() => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => CategoriesPage(category: _item)))),
      child: Container(
        width: 350,
        height: 350,
        margin: EdgeInsets.all(25),
        padding: EdgeInsets.all(25),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            /* 
            SvgPicture.asset(
              _item.imageUrl,
              height: 150,
              width: 150,
              colorBlendMode: BlendMode.modulate,
              color: Color(_ThemeColor),
            ),
            */
            Text(
              _item.emoji,
              style: TextStyle(
                fontSize: 80,
              ),
            ),
            Text(
              ".${_item.title.toLowerCase()}",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 30),
                  child: Image.asset(
                    "assets/images/quote.png",
                    height: 25,
                    width: 25,
                  ),
                ),
                Text(
                  _item.desc,
                  style: TextStyle(
                      fontSize: 15, color: Theme.of(context).primaryColor),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30),
                  child: Transform.rotate(
                    angle: 180 * 3.1415927 / 180,
                    child: Image.asset(
                      "assets/images/quote.png",
                      height: 25,
                      width: 25,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
