import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ilect_app/catalog.dart';
import 'package:ilect_app/provider.dart';

void main() => runApp(new ILectApp());

class ILectApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
    return MaterialApp(
      home: HomePage(title: title),
      // This is the theme of your application.
      theme: ThemeData(primaryColor: Colors.white),
      title: title,
    );
  }
}

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send),
            onPressed: () {},
          ),
        ],
        title: Text(feedback.substring(5)),
      ),
      body: Center(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class PPPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pp),
      ),
      body: Center(),
    );
  }
}

class SecondPage extends StatefulWidget {
  SecondPage({Key key, @required this.category}) : super(key: key);

  final String category;

  @override
  _SecondPageState createState() => _SecondPageState();
}

class ThirdPage extends StatelessWidget {
  ThirdPage({Key key, @required this.category, @required this.name})
      : super(key: key);

  final String category, name;
  List<Widget> _items;

  Widget build(BuildContext context) {
    switch (category) {
      case eat:
      case go:
        {
          _items = [
            Catalog().searchListTile(gmapsIcon, gmaps, name),
            Catalog().searchListDivider(),
            Catalog().searchListTile(amapsIcon, amaps, name),
            Catalog().searchListDivider(),
            Catalog().searchListTile(chromeIcon, chrome, name),
            Catalog().searchListDivider(),
            Catalog().searchListTile(safariIcon, safari, name),
            Catalog().searchListDivider(),
          ];
        }
        break;
      case listen:
      case watch:
        {
          _items = [
            Catalog().searchListTile(youtubeIcon, youtube, name),
            Catalog().searchListDivider(),
            Catalog().searchListTile(chromeIcon, chrome, name),
            Catalog().searchListDivider(),
            Catalog().searchListTile(safariIcon, safari, name),
            Catalog().searchListDivider(),
          ];
        }
        break;
    }
    return Scaffold(
      body: Stack(
        children: <Widget>[
          CupertinoPageScaffold(
            child: CustomScrollView(
              physics: NeverScrollableScrollPhysics(),
              slivers: <Widget>[
                CupertinoSliverNavigationBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.white,
                  largeTitle: Text(search),
                ),
                SliverSafeArea(
                  sliver: SliverList(
                    delegate: SliverChildListDelegate(
                      _items,
                    ),
                  ),
                  top: false,
                ),
              ],
            ),
          ),
          Container(
            child: Text(
              name,
              style: TextStyle(
                color: CupertinoColors.inactiveGray,
                fontSize: 17.0,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.4,
              ),
            ),
            padding: EdgeInsets.only(left: 16.0, top: 31.0),
          ),
        ],
      ),
      bottomNavigationBar: Catalog().bottomAppBar(title),
    );
  }
}

class ToSPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(tos),
      ),
      body: Center(),
    );
  }
}

class _HomePageState extends State<HomePage> {
  List<CardData> _items;
  StreamSubscription<Event> _onCategoryAddedSubscription;

  @override
  void dispose() {
    _onCategoryAddedSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _items = List();
    _onCategoryAddedSubscription =
        Provider().cardDataStreamSubscription(schema0).listen(onCategoryAdded);
  }

  void onCategoryAdded(Event event) {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _items.add(CardData.fromSnapshot(false, event.snapshot));
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Container(
        child: GridView.count(
          children: List.generate(
              _items.length, (i) => Catalog().categoryCard(i, _items)),
          controller: ScrollController(keepScrollOffset: false),
          crossAxisCount: 2,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
        ),
      ),
      bottomNavigationBar: Catalog().bottomAppBarExtended(true, widget.title),
    );
  }
}

class _SecondPageState extends State<SecondPage> {
  List<CardData> _items;
  StreamSubscription<Event> _onObjectAddedSubscription;
  String str = '';

  @override
  void dispose() {
    _onObjectAddedSubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _items = List();
    switch (widget.category) {
      case eat:
        {
          str = schema3;
        }
        break;
      case go:
        {
          str = schema4;
        }
        break;
      case listen:
        {
          str = schema2;
        }
        break;
      case watch:
        {
          str = schema1;
        }
        break;
    }
    _onObjectAddedSubscription =
        Provider().cardDataStreamSubscription(str).listen(onObjectAdded);
  }

  void onObjectAdded(Event event) {
    setState(() {
      _items.add(CardData.fromSnapshot(true, event.snapshot));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: ListView(
          children: List.generate(
              _items.length, (i) => Catalog().objectCard(i, _items)),
        ),
      ),
      bottomNavigationBar:
          Catalog().bottomAppBar(widget.category, widget.category),
    );
  }
}
