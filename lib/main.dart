import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crypto_market/models.dart';
import 'package:crypto_market/info_page.dart';
import 'package:crypto_market/forecast_page.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(new MaterialApp(
    home: new HomePage(),
  ));
}

class HomePage extends StatefulWidget {

  @override
  HomePageState createState() => new HomePageState();

}

class HomePageState extends State<HomePage> {

  List data;

  Future<String> getData() async {
    var response = await http.get(
        Uri.encodeFull("https://api.coinmarketcap.com/v1/ticker/"),
        headers: {
          "Accept": "application/json"
        }
    );

    this.setState(() {
      data = JSON.decode(response.body);
    });
    print(data);

    return "Success!";
  }

  @override
  void initState() {
    this.getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("CryptoMarket"),
        centerTitle: true,
      ),
      body: new RefreshIndicator(
          child: new ListView.builder(
            addAutomaticKeepAlives: false,
            itemCount: data == null ? 0 : 300,
            addRepaintBoundaries: true,
            itemBuilder: _itemBuilder
          ),
          onRefresh: getData,
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    Coin coin = getCoin(index);
    return new CoinItemWidget(coin: coin);
  }

  Coin getCoin(int index) {
    return new Coin(
        data[index]["id"],
        data[index]["name"],
        data[index]["symbol"],
        data[index]["rank"],
        data[index]["price_usd"],
        data[index]["price_btc"],
        data[index]["24h_volume_usd"],
        data[index]["market_cap_usd"],
        data[index]["available_supply"],
        data[index]["total_supply"],
        data[index]["percent_change_1h"],
        data[index]["percent_change_24h"],
        data[index]["percent_change_7d"],
        data[index]["last_updated"]
    );
  }

}

class CoinItemWidget extends StatefulWidget {

  CoinItemWidget({Key key, this.coin}) : super(key: key);

  final Coin coin;

  @override
  _CoinItemWidgetState createState() => new _CoinItemWidgetState();

}

class _CoinItemWidgetState extends State<CoinItemWidget> {

  @override
  Widget build(BuildContext context) {
    return new Card(
      child: new Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          new ListTile(
            leading: new Image(
                image: new NetworkImage("https://files.coinmarketcap.com/static/img/coins/32x32/" + widget.coin.id + ".png", scale: 1.0)
            ),
            title: new Text(
              widget.coin.rank + ". " + widget.coin.name,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: new Container(
              child: new Row(
                children: <Widget>[
                  new Text(
                    "percent change 1h : ",
                    overflow: TextOverflow.ellipsis,
                  ),
                  new Text(
                    widget.coin.percentChange1h + "%",
                    style: new TextStyle(
                      color: double.parse(widget.coin.percentChange1h).isNegative ? Colors.red : Colors.green,
                    ),
                  )
                ],
              ),
            ),
          ),
          new ButtonTheme.bar( // make buttons use the appropriate styles for cards
            child: new ButtonBar(
              children: <Widget>[
                new MaterialButton(
                  child: const Text('INFO'),
                  onPressed: () {
                    _onTapInfo();
                  },
                ),
                new MaterialButton(
                  child: const Text('FORECAST'),
                  onPressed: () {
                    _onTapForecast();
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool isRaised(String priceChange) {
    return priceChange.substring(0, 1) != "-";
  }

  void _onTapInfo() {
    Route route = new MaterialPageRoute(
      settings: new RouteSettings(name: "/market/coin"),
      builder: (BuildContext context) => new InfoPage(coin: widget.coin),
    );
    Navigator.of(context).push(route);
  }

  void _onTapForecast() {
    Route route = new MaterialPageRoute(
      settings: new RouteSettings(name: "/market/coin"),
      builder: (BuildContext context) => new ForecastPage(coin: widget.coin),
    );
    Navigator.of(context).push(route);
  }

}