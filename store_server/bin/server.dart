import 'dart:io';

import 'package:args/args.dart';
import 'package:logging/logging.dart';
import 'package:shelf/shelf.dart' as shelf;
import 'package:shelf/shelf_io.dart' as io;
import 'package:shelf_static/shelf_static.dart';
import 'package:store_server/store_server.dart';

final _hostname = InternetAddress.anyIPv4;

Future<void> main(List<String> args) async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) {
    // ignore: avoid_print
    print('${rec.level.name}: ${rec.time}: ${rec.message}');
  });

  final log = Logger('main');
  final parser = ArgParser()..addOption('port', abbr: 'p');
  final result = parser.parse(args);

  // For Google Cloud Run, we respect the PORT environment variable
  final portStr =
      result['port'] as String ?? Platform.environment['PORT'] ?? '8080';
  final port = int.tryParse(portStr);

  if (port == null) {
    stdout.writeln('Could not parse port value "$portStr" into a number.');
    // 64: command line usage error
    exitCode = 64;
    return;
  }

  final staticHandler = createStaticHandler('../flutter_store/build/web/',
      defaultDocument: 'index.html');

  final handler = const shelf.Pipeline()
      .addMiddleware(shelf.logRequests())
      .addHandler(ImageService(staticHandler).router.handler);

  final server = await io.serve(handler, _hostname, port);
  log.info('Serving at http://${server.address.host}:${server.port}');
}
