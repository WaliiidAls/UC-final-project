// Profile page with a list of posts, and a button to add a new post
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:joinquotation/components/quote.dart';
import 'package:joinquotation/models/lists.dart';

class ProfilePage extends StatefulWidget {
  final int _themeColor;
  final void Function(bool prev) _onPageChanged;
  final void Function(BuildContext context, int Color) _switchTheme;
  final void Function(BuildContext context) _handleBottomSheet;
  final String _emojiAvatar;
  final void Function(String emoji) _handleEmoji;
  final String _userID;
  ProfilePage({
    Key? key,
    required int themeColor,
    required void Function(bool prev) onPageChanged,
    required void Function(BuildContext context, int Color) switchTheme,
    required void Function(BuildContext context) handleBottomSheet,
    required String emojiAvatar,
    required void Function(String emoji) handleEmoji,
    required String userID,
  })  : _themeColor = themeColor,
        _onPageChanged = onPageChanged,
        _switchTheme = switchTheme,
        _handleBottomSheet = handleBottomSheet,
        _emojiAvatar = emojiAvatar,
        _handleEmoji = handleEmoji,
        _userID = userID,
        super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Stream<QuerySnapshot> quotesStream = FirebaseFirestore.instance
      .collection("users")
      .doc(widget._userID)
      .collection("account")
      .snapshots();

  final TextEditingController _quoteController = TextEditingController();
  void _handleAddQuote() {
    String msg;
    if (_quoteController.text.isNotEmpty) {
      FirebaseFirestore.instance
          .collection("users")
          .doc(widget._userID)
          .collection("account")
          .doc("quotes")
          .update({
        "quotes": FieldValue.arrayUnion([_quoteController.text])
      });
      _quoteController.clear();
      Navigator.pop(context);
      msg = "Quote added successfully ✏️";
    } else {
      msg = "Please enter a quote to add 📝";
      Navigator.pop(context);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
          leading: GestureDetector(
            onTap: () => widget._onPageChanged(true),
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Icon(
                Icons.home,
                size: 28,
              ),
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () => widget._onPageChanged(false),
              child: Container(
                margin: EdgeInsets.only(right: 20),
                child: Icon(
                  Icons.settings,
                  size: 28,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: StreamBuilder<QuerySnapshot>(
              stream: quotesStream,
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text("Error"),
                  );
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final data = snapshot.requireData;

                final String username = data.docs[0]["user"]["nickname"];
                final List quotes = data.docs[1]["quotes"];

                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: ((context) => Container(
                                  height: 600,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(20),
                                          topRight: Radius.circular(20))),
                                  child: EmojiPicker(
                                    onEmojiSelected: (category, emoji) {
                                      Navigator.pop(context);
                                      widget._handleEmoji(emoji.emoji);
                                    },
                                    config: Config(
                                      columns: 7,
                                      emojiSizeMax:
                                          32 * (Platform.isIOS ? 1.30 : 1.0),
                                      verticalSpacing: 0,
                                      horizontalSpacing: 0,
                                      gridPadding: EdgeInsets.zero,
                                      initCategory: Category.SMILEYS,
                                      bgColor: Colors.white,
                                      indicatorColor:
                                          Theme.of(context).primaryColor,
                                      iconColor: Colors.grey,
                                      iconColorSelected: Color(0xFF3d3d3d),
                                      enableSkinTones: false,
                                      showRecentsTab: false,
                                      loadingIndicator: const SizedBox.shrink(),
                                      tabIndicatorAnimDuration:
                                          kTabScrollDuration,
                                      categoryIcons: const CategoryIcons(),
                                      buttonMode: ButtonMode.CUPERTINO,
                                    ),
                                  ),
                                )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Color(widget._themeColor),
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                  color: Color(widget._themeColor)
                                      .withOpacity(0.8),
                                  blurRadius: 15,
                                  spreadRadius: -5,
                                  offset: Offset(0, 10))
                            ]),
                        width: 100,
                        height: 100,
                        child: Center(
                          child: Text(
                            widget._emojiAvatar,
                            style: TextStyle(fontSize: 48),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10, bottom: 17.5),
                      width: 200,
                      child: GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                              isScrollControlled: true,
                              context: context,
                              builder: (context) => Container(
                                    height: ColorsList.length * 90,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).canvasColor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20)),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              blurRadius: 15,
                                              spreadRadius: -5,
                                              offset: Offset(0, 10))
                                        ]),
                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Text(".select a color",
                                              style: TextStyle(
                                                  fontSize: 17, height: 4)),
                                          for (Map color in ColorsList)
                                            ListTile(
                                              title: Text(color["name"]),
                                              subtitle: Text(color["desc"]),
                                              onTap: () => widget._switchTheme(
                                                  context, color["hex"]),
                                              leading: Icon(
                                                Icons.circle,
                                                color: Color(color["hex"]),
                                              ),
                                            )
                                        ],
                                      ),
                                    ),
                                  ));
                        },
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("@$username",
                                  style: TextStyle(fontSize: 20)),
                              Icon(Icons.keyboard_arrow_down)
                            ]),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => Container(
                                    padding: EdgeInsets.all(30),
                                    height: 300,
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).canvasColor,
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20)),
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.3),
                                              blurRadius: 15,
                                              spreadRadius: -5,
                                              offset: Offset(0, 10))
                                        ]),
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text("...writing quote"),
                                          Container(
                                            padding: EdgeInsets.all(20),
                                            decoration: BoxDecoration(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(15),
                                            ),
                                            child: TextFormField(
                                              minLines: 1,
                                              textAlign: TextAlign.center,
                                              maxLines: 4,
                                              controller: _quoteController,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintStyle: TextStyle(
                                                    color: Colors.white
                                                        .withOpacity(0.75)),
                                                hintText:
                                                    "whatever come first on your mind",
                                              ),
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          ElevatedButton(
                                              onPressed: () =>
                                                  _handleAddQuote(),
                                              style: ButtonStyle(
                                                  elevation:
                                                      MaterialStateProperty
                                                          .all(0),
                                                  shape:
                                                      MaterialStateProperty.all(
                                                          RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20))),
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Theme.of(context)
                                                              .indicatorColor)),
                                              child: Text(".post")),
                                        ])));
                          },
                          child: Container(
                              decoration: BoxDecoration(
                                  color: Color(widget._themeColor),
                                  borderRadius: BorderRadius.circular(50),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Color(widget._themeColor)
                                            .withOpacity(0.5),
                                        blurRadius: 15,
                                        spreadRadius: -5,
                                        offset: Offset(0, 10))
                                  ]),
                              width: 100,
                              height: 50,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(".add",
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold)),
                                  SizedBox(width: 10),
                                  Icon(Icons.edit_note,
                                      color: Colors.white, size: 23),
                                ],
                              )),
                        ),
                        for (int i = 0; i < 2; i++)
                          Container(
                            decoration: BoxDecoration(
                                color: Color(widget._themeColor),
                                borderRadius: BorderRadius.circular(50),
                                boxShadow: [
                                  BoxShadow(
                                      color: Color(widget._themeColor)
                                          .withOpacity(0.5),
                                      blurRadius: 15,
                                      spreadRadius: -5,
                                      offset: Offset(0, 10))
                                ]),
                            width: 50,
                            height: 50,
                            child: Icon(i == 0 ? Icons.qr_code : Icons.adb,
                                color: Colors.white, size: 23),
                          ),
                      ],
                    ),
                    Flexible(
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          for (int i = 0; i < quotes.length; i++)
                            Quote(
                              quote: quotes[i],
                              author: username,
                              likes: i,
                            )
                        ],
                      ),
                    ),
                  ],
                );
              }),
        ));
  }
}
