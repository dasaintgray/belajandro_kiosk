import 'dart:async';

class HenryRPCRequest<TResult> {
  // ignore: unused_field
  final String _requestId;
  String get requestId => this.requestId;

  final Completer<TResult> _completer = Completer();

  // this completer will resolve after response came back to RPC
  Completer<TResult> get completer => this._completer;

  HenryRPCRequest(this._requestId);
}
