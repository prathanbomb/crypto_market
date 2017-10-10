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

  Coin(this.id, this.name, this.symbol, this.rank, this.priceUsd, this.priceBtc,
      this.volumeUsd, this.marketCapUsd, this.availableSupply,
      this.totalSupply, this.percentChange1h, this.percentChange24h,
      this.percentChange7d, this.lastUpdated) {
    this.priceUsd = double.parse(this.priceUsd).toStringAsFixed(4);
    this.volumeUsd = double.parse(volumeUsd) >= 1000000 ? (double.parse(volumeUsd)/1000000).toStringAsFixed(2) + "M" : volumeUsd;
    this.percentChange1h = double.parse(this.percentChange1h).toStringAsFixed(1);
    this.percentChange24h = double.parse(this.percentChange24h).toStringAsFixed(1);
    this.percentChange7d = double.parse(this.percentChange7d).toStringAsFixed(1);
  }

}