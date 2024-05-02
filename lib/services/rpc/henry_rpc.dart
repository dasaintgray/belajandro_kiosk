import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:uuid/uuid.dart';
import 'henry_rpc_request.dart';

/// Manage the communication between dart and C# RPC Server
class HenryRPC {
  Process? henryRPCProcess;
  final String _executablePath;
  final Uuid uuid = const Uuid();

  final List<HenryRPCRequest> _request = [];
  late RegExp _jsonInRPCMessegeExp;

  HenryRPC(this._executablePath) {
    _jsonInRPCMessegeExp = _getJsonsInRpcMessageExp(10);
  }

  // START C#- RPC CHILD PROCESS
  Future<HenryRPC> start() async {
    henryRPCProcess = await Process.start(_executablePath, []);
    henryRPCProcess?.stdout.listen(_onDataReceived);
    henryRPCProcess?.stderr.listen(_onLogReceived);

    return this;
  }

  // DIPOSE THE C# RPC CHILD PROCESS
  void dispose() {
    henryRPCProcess?.kill();
    _request.clear();
  }

  // INVOKE THE C# RPC METHOD BY NAME WITH OPTIONAL PARAM (S)

  Future<TResult> invoke<TResult>({required String method, List<dynamic>? params, Object? param}) {
    /// create a unique id for the rpc request

    var id = uuid.v4();

    /// encode json request in rpc format;
    /// jsonrpc version and 'Content-Length' header
    var jsonEncodeBody = jsonEncode({
      "jsonrpc": "2.0",
      "method": method,
      if (params != null || param != null) "params": params ?? [param],
      "id": id
    });

    var contentLengthHeader = 'Content-Length: ${jsonEncodeBody.length}';
    var messagePayload = '$contentLengthHeader\r\n\r\n$jsonEncodeBody';

    // write ('send') the request to the STDIN stream
    henryRPCProcess?.stdin.write(messagePayload);

    // create a HenryRPCRequest instance for this request
    var henryRPCRequest = HenryRPCRequest<TResult>(id);
    _request.add(henryRPCRequest);
    return henryRPCRequest.completer.future;
  }

  /// Build a RegExp that identifies the JSON code inside the RPC response
  RegExp _getJsonsInRpcMessageExp(int nestedJsonLevels) {
    /// base RegExp
    String jsonInRpcMessage = "{(?:[^{}]*|())*}";

    /// variable for building a recursive RegExp
    String jsonsInRpcMessage = jsonInRpcMessage;

    /// Duplicate (recursive) the RegExp value to support nested json objects
    for (var i = 0; i < nestedJsonLevels; i++) {
      jsonsInRpcMessage = jsonsInRpcMessage.replaceFirst('()', jsonInRpcMessage);
    }

    return RegExp(jsonsInRpcMessage);
  }

  /// get RPC response from the STDOUT stream and decode it to utf8-json format
  dynamic _onDataReceived(event) {
    var strMessage = utf8.decode(event);

    /// find the json-objects in the RPC response using RegExp
    var strJsons = _jsonInRPCMessegeExp.allMatches(strMessage).map((m) => m.group(0)!);

    /// for every json-string
    for (var strJson in strJsons) {
      /// first decode to json
      dynamic response = jsonDecode(strJson);

      /// then find by-ID the CsharpRpcRequest instance in the _requests list,
      /// to complete ('resolve') its CsharpRpcRequest.completer instance
      var request = _request.firstWhere((request) => request.requestId == response['id']);

      /// if error found in the RPC response content
      var error = response['error'];
      if (error != null) {
        throw Exception(error);
      }

      request.completer.complete(response['result']);
      _request.remove(request);
    }
  }

  /// write logs from the STDERR stream
  dynamic _onLogReceived(event) {
    // use 'assert' to print logs only if debug mode
    // this is workaround because dart don't have the kDebugMode constant
    assert(() {
      // ignore: avoid_print
      print(utf8.decode(event));
      return true;
    }());
  }
}
