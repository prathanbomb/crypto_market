import 'package:flutter/material.dart';
import 'package:crypto_market/models.dart';

class ForecastPage extends StatefulWidget {

  ForecastPage({Key key, this.coin}) : super(key: key);

  final Coin coin;

  @override
  _ForecastPageState createState() => new _ForecastPageState();

}

class _ForecastPageState extends State<ForecastPage> {

  @override
  Widget build(BuildContext context) {

    var _children = <Widget>[
      new Text("symbol: " + widget.coin.symbol),
      new Text("name: " + widget.coin.name),
    ];

    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.coin.name),
        centerTitle: true,
      ),
      body: new Column(
        children: _children
      )
    );

  }

}