import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
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
  bool isLoading = true;

  Future<bool> getDataFromAPI() async {
    var response = await http.get(
      Uri.encodeFull("https://api.coinmarketcap.com/v1/ticker/?convert=THB&limit=100"),
      headers: {
        "Accept": "application/json"
      },
    );

    this.setState(() {
      data = JSON.decode(response.body);
      isLoading = false;
    });
    String content = response.body;
    (await getLocalFile()).writeAsString('$content');
    print(data);

    return true;
  }

  Future<File> getLocalFile() async {
    // get the path to the document directory.
    String dir = (await getApplicationDocumentsDirectory()).path;
    return new File('$dir/coin_list.txt');
  }

  Future<bool> getDataFromLocal() async {
    try {
      File file = await getLocalFile();
      // read the variable as a string from the file.
      String contents = await file.readAsString();

      this.setState(() {
        data = JSON.decode(contents);
        isLoading = false;
      });
      print(data);

      return true;
    } on FileSystemException {
      return false;
    }
  }

  Future<bool> getData() async {
    if(!(await getDataFromLocal())) {
      await getDataFromAPI();
    }
    return true;
  }

  @override
  void initState() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("CryptoMarket"),
        centerTitle: true,
      ),
      body: isLoading ? showProgressIndicator() : new RefreshIndicator(
          child: new ListView.builder(
            itemCount: data == null ? 0 : 300,
            itemBuilder: _itemBuilder
          ),
          onRefresh: getDataFromAPI,
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    Coin coin = getCoin(index);
    return new CoinItemWidget(coin: coin);
  }

  Widget showProgressIndicator() {
    return new Center(
      child: Platform.isAndroid ? new CircularProgressIndicator() : new CupertinoActivityIndicator(),
    );
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
        data[index]["last_updated"],
        data[index]["price_thb"],
        data[index]["24h_volume_thb"],
        data[index]["market_cap_thb"],
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
      child: new Padding(
        padding: new EdgeInsets.only(
          left: 10.0,
          top: 10.0,
          right: 10.0,
        ),
        child: new Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Row(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.only(
                    right: 10.0,
                  ),
                  child: new Image(
                    image: new NetworkImage("https://files.coinmarketcap.com/static/img/coins/32x32/" + widget.coin.id + ".png", scale: 1.0),
                  ),
                ),
                new Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    new Text(
                      widget.coin.rank + ". " + widget.coin.name + " (" + widget.coin.symbol + ")",
                      overflow: TextOverflow.ellipsis,
                      style: new TextStyle(
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    new Padding(
                      padding: new EdgeInsets.only(
                        top: 5.0,
                        bottom: 5.0,
                      ),
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        textBaseline: TextBaseline.alphabetic,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        children: <Widget>[
                          new Text(
                            widget.coin.formatCurrency(widget.coin.priceThb) + " THB",
                            style: new TextStyle(
                              fontSize: 18.0,
                            ),
                          ),
                          new CustomPaint(
                            size: new Size(10.0, 10.0),
                            painter: new BarChartPainter(double.parse(widget.coin.percentChange1h).isNegative),
                          ),
                          new Text(
                            (double.parse(widget.coin.percentChange1h).isNegative ? "" : "+") + widget.coin.percentChange1h + "%",
                            style: new TextStyle(
                              fontSize: 12.0,
                              color: double.parse(widget.coin.percentChange1h).isNegative ? Colors.red : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ),
                    new Text(
                      "Last updated : " + new DateTime.fromMillisecondsSinceEpoch(int.parse(widget.coin.lastUpdated)*1000).toString(),
                      style: new TextStyle(
                        fontSize: 10.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            new ButtonTheme.bar(
              padding: new EdgeInsets.all(2.0),
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
      ),
    );
  }

  void _onTapInfo() {
    Route route = new MaterialPageRoute(
      settings: new RouteSettings(name: "/market/coin"),
      builder: (BuildContext context) => new InfoPage(coin: widget.coin),
    );
    Navigator.of(context).push(route);
  }

  void _onTapForecast() {
    Route route = Platform.isAndroid ? new MaterialPageRoute(
      settings: new RouteSettings(name: "/market/coin"),
      builder: (BuildContext context) => new ForecastPage(coin: widget.coin),
    ) : new CupertinoPageRoute(
      settings: new RouteSettings(name: "/market/coin"),
      builder: (BuildContext context) => new ForecastPage(coin: widget.coin),
    );
    Navigator.of(context).push(route);
  }

}

class BarChartPainter extends CustomPainter {

  BarChartPainter(this.isDropped);

  final bool isDropped;

  @override
  void paint(Canvas canvas, Size size) {

    final paint = new Paint()
      ..color = isDropped ? Colors.red : Colors.green
      ..style = PaintingStyle.fill;

    canvas.drawRect(
      new Rect.fromLTRB(
        2.0,
        8.0,
        10.0,
        18.0,
      ),
      paint,
    );

    canvas.clipRect(
      new Rect.fromLTRB(
        2.0,
        8.0,
        10.0,
        18.0,
      ),
    );

  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }

}