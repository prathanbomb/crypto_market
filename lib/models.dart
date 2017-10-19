import 'package:intl/intl.dart';

class Coin {
  String id;
  String name;
  String symbol;
  String rank;
  String priceUsd;
  String priceBtc;
  String volumeUsd;
  String marketCapUsd;
  String availableSupply;
  String totalSupply;
  String percentChange1h;
  String percentChange24h;
  String percentChange7d;
  String lastUpdated;
  String priceThb;
  String volumeThb;
  String marketCapThb;
  Coin(this.id, this.name, this.symbol, this.rank, this.priceUsd, this.priceBtc,
      this.volumeUsd, this.marketCapUsd, this.availableSupply,
      this.totalSupply, this.percentChange1h, this.percentChange24h,
      this.percentChange7d, this.lastUpdated, this.priceThb, this.volumeThb, this.marketCapThb) {
    this.priceUsd = double.parse(this.priceUsd).toStringAsFixed(4);
    this.volumeUsd = double.parse(this.volumeUsd) >= 1000000 ? (double.parse(this.volumeUsd)/1000000).toStringAsFixed(2) : this.volumeUsd;
    this.percentChange1h = double.parse(this.percentChange1h).toStringAsFixed(1);
    this.percentChange24h = double.parse(this.percentChange24h).toStringAsFixed(1);
    this.percentChange7d = double.parse(this.percentChange7d).toStringAsFixed(1);
    this.priceThb = double.parse(this.priceThb).toStringAsFixed(4);
    this.volumeThb = double.parse(this.volumeThb) >= 1000000 ? (double.parse(this.volumeThb)/1000000).toStringAsFixed(2) : this.volumeThb;
  }
  String formatCurrency(String amount) {
    final format = new NumberFormat("#,##0.0000", "en_US");
    return format.format(double.parse(amount));
  }
  String formatVolume(String amount) {
    final format = new NumberFormat("#,##0.00", "en_US");
    return format.format(double.parse(amount));
  }
}

class Forecast {
  String timestamp;
  double usd;
  String when;
  Forecast(this.timestamp, this.usd, this.when);
}