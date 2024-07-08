class GlobalConstant {
  static const Map<String, String> globalHeader = {
    'content-type': 'application/json',
    'x-hasura-admin-secret': 'iph2020agorah!'
  };

  static const Map<String, String> httpHeader = {
    'content-type': 'application/json',
    'connection': 'keep-alive',
  };

  static const String gqlURL = 'https://graphql.circuitmindz.com/v1/graphql';
  static const String pmsURL = 'https://pms.circuitmindz.com';

  static const weatherURL = 'http://api.weatherapi.com';
  static const weatherEndpoint = '/v1/current.json?key=48954ba0e91f4dc6bfd12110223105&';
  static const weatherParams = 'q=Angeles City';

  static const int receiveTimeOut = 20;
  static const int connectionTimeOut = 25;

  // HARDWARE
  // CASH ACCEPTOR
  static const String startCashAcceptor = 'CASA';
  static const String stopCashAcceptor = 'CASH';
  static const String getCashCount = 'CASC';
  static const String postPayOut = 'CASD';
  static const String resetCashAcceptor = 'CASR';
  static const String emptyCashAcceptor = 'CASE';
  static const String cashInsert = 'CASI';
}

enum Pera {
  bente(20.00, "p20"),
  tapwe(50.00, "p50"),
  isangdaan(100.00, "p100"),
  dalawangdaan(200.00, "p200"),
  limangdaan(500.00, "p500"),
  isanglibo(1000.00, "p1000");

  final double halaga;
  final String value;

  const Pera(this.halaga, this.value);
}
