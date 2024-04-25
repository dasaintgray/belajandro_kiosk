import 'package:belajandro_kiosk/services/exceptions/base_client_exception.dart';
import 'package:belajandro_kiosk/services/helpers/dialog_helper.dart';

mixin class BaseController {
  void handleError(error) {
    hideLoading();
    if (error is BadRequestException) {
      var message = error.message;
      DialogHelper.showErroDialog(description: message);
    } else if (error is FetchDataException) {
      var message = error.message;
      DialogHelper.showErroDialog(description: message);
    } else if (error is ApiNotRespondingException) {
      DialogHelper.showErroDialog(description: 'Oops! It took longer to respond the api, call the developer.');
    }
  }

  void showLoading([String? message]) {
    DialogHelper.showLoading(message);
  }

  void hideLoading() {
    DialogHelper.hideLoading();
  }
}
