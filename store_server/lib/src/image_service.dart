import 'dart:async';
import 'dart:convert';

import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart' show Request, Response, Handler;
import 'package:shelf_router/shelf_router.dart';

part 'image_service.g.dart'; // generated with 'pub run build_runner build'

class ImageService {
  ImageService(this._staticHandler);

  final _log = Logger('ImageService');
  final Handler _staticHandler;

  @Route.get('/images/')
  Future<Response> _listImages(Request request) async => Response.ok(
        json.encode(['1', '2', '3', '4']),
        headers: {'content-type': 'application/json'},
      );

  // Order of declaration in this file matters, this must be the last Route.
  @Route.get('/<filepath|.*>')
  FutureOr<Response> content(Request request, String filepath) async {
    _log.info('serving $filepath');
    return _staticHandler(request);
  }

  // Create router using the generate function defined in 'userservice.g.dart'.
  Router get router => _$ImageServiceRouter(this);
}
