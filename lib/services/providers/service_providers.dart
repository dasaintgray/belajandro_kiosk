import 'package:hasura_connect/hasura_connect.dart';
import 'package:belajandro_kiosk/services/controller/base_controller.dart';

class ServiceProvider extends BaseController {
  // QUERY
  static Future<dynamic> gQLQuery(
      {required String? graphQLURL,
      required Map<String, String>? headers,
      required String? documents,
      Map<String, dynamic>? docVar}) async {
    HasuraConnect hasuraConnect = HasuraConnect(graphQLURL!, headers: headers!);

    final response = docVar == null
        ? await hasuraConnect.query(documents!)
        : await hasuraConnect.query(documents!, variables: docVar);
    if (response != null) {
      return response!;
    } else {
      return null;
    }
  }

  // SUBSCRIPTION
  static Future<Snapshot<dynamic>> getSubscription(
      {required String? graphQLURL,
      required Map<String, String>? headers,
      required String? documents,
      Map<String, dynamic>? docVar}) async {
    HasuraConnect hasuraConnect = HasuraConnect(graphQLURL!, headers: headers!);

    final eventResponse = docVar == null
        ? await hasuraConnect.subscription(documents!)
        : await hasuraConnect.subscription(documents!, variables: docVar);
    return eventResponse;
  }

  // MUTATION
  static Future<dynamic> updateGraphQL(
      {required String? graphQLURL,
      required Map<String, String>? headers,
      required String? documents,
      Map<String, dynamic>? docVar}) async {
    HasuraConnect hasuraConnect = HasuraConnect(graphQLURL!, headers: headers!);

    final updateResponse = docVar == null
        ? await hasuraConnect.mutation(documents!)
        : await hasuraConnect.mutation(documents!, variables: docVar);
    if (updateResponse != null) {
      return updateResponse!;
    } else {
      return null;
    }
  }
}
