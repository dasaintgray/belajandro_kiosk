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
  static const int connectionTimeOut = 20;
}
