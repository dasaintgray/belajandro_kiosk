import 'package:hasura_connect/hasura_connect.dart';
import 'package:belajandro_kiosk/services/controller/base_controller.dart';

class ServiceProvider extends BaseController {
  // QUERY
  static Future<dynamic> gQLQuery(
      {required String? graphQLURL,
      required String? documents,
      required Map<String, String>? headers,
      Map<String, dynamic>? docVar}) async {
    HasuraConnect hasuraConnect = HasuraConnect(graphQLURL!, headers: headers!);

    final response = docVar != null
        ? await hasuraConnect.query(documents!, variables: docVar)
        : await hasuraConnect.query(documents!);
    if (response != null) {
      return response!;
    } else {
      return null;
    }
  }

  // SUBSCRIPTION
  static Future<Snapshot<dynamic>> getSubscription(
      {required String? graphQLURL,
      required String? documents,
      required Map<String, String>? headers,
      Map<String, dynamic>? docVar}) async {
    HasuraConnect hasuraConnect = HasuraConnect(graphQLURL!, headers: headers!);

    final eventResponse = docVar != null
        ? await hasuraConnect.subscription(documents!, variables: docVar)
        : await hasuraConnect.subscription(documents!);
    return eventResponse;
  }

  // MUTATION
  static Future<dynamic> updateGraphQL(
      {required String? graphQLURL,
      required String? documents,
      required Map<String, String>? headers,
      Map<String, dynamic>? docVar}) async {
    HasuraConnect hasuraConnect = HasuraConnect(graphQLURL!, headers: headers!);

    final updateResponse = docVar != null
        ? await hasuraConnect.mutation(documents!, variables: docVar)
        : await hasuraConnect.mutation(documents!);
    if (updateResponse != null) {
      return updateResponse!;
    } else {
      return null;
    }
  }
}
