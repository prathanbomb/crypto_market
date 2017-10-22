import 'dart:io';
import 'package:flutter/material.dart';
import 'package:crypto_market/models.dart';

class InfoPage extends StatefulWidget {

  InfoPage({Key key, this.coin}) : super(key: key);

  final Coin coin;

  @override
  _InfoPageState createState() => new _InfoPageState();

}

class _InfoPageState extends State<InfoPage> {

  @override
  Widget build(BuildContext context) {

    var _child = new Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        new Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Padding(
                      padding: new EdgeInsets.only(
                          top: 10.0,
                          left: 5.0,
                          right: 15.0,
                          bottom: 15.0
                      ),
                      child: new Container(
                        child: new Image(
                          image: new NetworkImage("https://files.coinmarketcap.com/static/img/coins/32x32/" + widget.coin.id + ".png", scale: 1.0),
                        ),
                      ),
                    ),
                  ],
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Align(
                      alignment: FractionalOffset.centerRight,
                    ),
                    new Text(
                      widget.coin.symbol,
                      style: new TextStyle(
                        fontSize: 26.0,
                        letterSpacing: -2.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new Text(
                      widget.coin.name,
                      style: new TextStyle(
                        fontSize: 14.0,
                        color: Colors.grey,
                      ),
                    )
                  ],
                ),
              ],
            ),
            new Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.only(
                    top: 5.0,
                  ),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      new Text(
                        widget.coin.formatCurrency(widget.coin.priceThb).substring(0, widget.coin.formatCurrency(widget.coin.priceThb).length - 4),
                        style: new TextStyle(
                          fontSize: 28.0,
                        ),
                      ),
                      new Padding(
                        padding: new EdgeInsets.only(top: Platform.isIOS ? 10.0 : 9.0),
                        child: new Text(
                          widget.coin.formatCurrency(widget.coin.priceThb).substring(widget.coin.formatCurrency(widget.coin.priceThb).length - 4, widget.coin.formatCurrency(widget.coin.priceThb).length),
                          style: new TextStyle(
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                      new Text(
                        " THB",
                        style: new TextStyle(
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
                new Text(
                  "Changed",
                  style: new TextStyle(
                    fontSize: 10.0,
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        new Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.only(
                    left: 5.0,
                  ),
                  child: new Text(
                    "Volume",
                    style: new TextStyle(
                      fontSize: 10.0,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                new Padding(
                  padding: new EdgeInsets.only(
                    left: 5.0,
                  ),
                  child: new Text(
                    "\$" + widget.coin.formatVolume(widget.coin.volumeUsd) + "M",
                    style: new TextStyle(
                      fontSize: 12.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            new Row(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.only(
                    right: 15.0,
                  ),
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Text(
                        "1H:",
                        style: new TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      new Text(
                        "24H:",
                        style: new TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                      new Text(
                        "7D:",
                        style: new TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    new Text(
                      (double.parse(widget.coin.percentChange1h).isNegative ? "" : "+") + widget.coin.percentChange1h + "%",
                      style: new TextStyle(
                        fontSize: 12.0,
                        color: double.parse(widget.coin.percentChange1h).isNegative ? Colors.red : Colors.green,
                      ),
                    ),
                    new Text(
                      (double.parse(widget.coin.percentChange24h).isNegative ? "" : "+") + widget.coin.percentChange24h + "%",
                      style: new TextStyle(
                        fontSize: 12.0,
                        color: double.parse(widget.coin.percentChange24h).isNegative ? Colors.red : Colors.green,
                      ),
                    ),
                    new Text(
                      (double.parse(widget.coin.percentChange7d).isNegative ? "" : "+") + widget.coin.percentChange7d + "%",
                      style: new TextStyle(
                        fontSize: 12.0,
                        color: double.parse(widget.coin.percentChange7d).isNegative ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );

    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Information"),
        centerTitle: true,
      ),
      body: new Card(
        child: new Padding(
          padding: new EdgeInsets.all(10.0),
          child: _child,
        ),
      ),
    );

  }

}