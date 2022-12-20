import 'package:flutter/material.dart';
import 'package:joinquotation/models/lists.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  final void Function(bool prev) _onPageChanged;
  const SettingsPage(
      {Key? key, required void Function(bool prev) onPageChanged})
      : _onPageChanged = onPageChanged,
        super(key: key);

  void _handleURL(url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri))
      await launchUrl(uri);
    else
      print("Can't launch url");
  }

  GestureDetector DynamicWidget(context, i) {
    String name = "";
    if (i == 0)
      name = "profile";
    else if (i == 1)
      name = "privacy";
    else if (i == 2) name = "account";
    return GestureDetector(
      onTap: () => {
        showModalBottomSheet(
            context: context,
            builder: ((context) => Container(
                  height: 300,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Theme.of(context).canvasColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            blurRadius: 15,
                            spreadRadius: -5,
                            offset: Offset(0, 10))
                      ]),
                  child: Text("...coming soon"),
                )))
      },
      child: Container(
        decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                  color: Theme.of(context).primaryColor.withOpacity(0.5),
                  blurRadius: 15,
                  spreadRadius: -5,
                  offset: Offset(0, 10))
            ]),
        padding: EdgeInsets.all(20),
        margin: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width * 0.6,
        alignment: Alignment.center,
        child: Text(name,
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // return Scaffold(body: Center(child: GestureDetector(onTap: () {},child: Text("Settings"))));
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
          title: Text(".settings",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          leading: GestureDetector(
            onTap: () => _onPageChanged(true),
            child: Container(
              margin: EdgeInsets.only(left: 20),
              child: Icon(Icons.keyboard_arrow_left),
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // PROFILE WIDGET
                  for (int i = 0; i < 3; i++) DynamicWidget(context, i),
                  for (int i = 0; i < footer.length; i++)
                    Container(
                        margin: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Text(footer[i]["title"],
                                style: TextStyle(fontSize: 20)),
                            Padding(
                              padding: EdgeInsets.all(10),
                            ),
                            for (int j = 0; j < footer[i]["links"].length; j++)
                              GestureDetector(
                                onTap: () =>
                                    _handleURL(footer[i]["links"][j]["link"]),
                                child: Text(footer[i]["links"][j]["title"],
                                    style: TextStyle(fontSize: 15, height: 2)),
                              ),
                          ],
                        ))
                ],
              ),
            ),
          ),
        ));
  }
}
