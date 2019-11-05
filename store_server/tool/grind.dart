import 'dart:io';

import 'package:grinder/grinder.dart';

void main(List<String> args) => grind(args);

@DefaultTask()
@Task()
@Depends(tuneup)
Future<void> serve() async {
  final process = await Process.start(
      Platform.executable, ['bin/server.dart', '--port', '8080']);
  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);
}

@Task()
void tuneup() => Pub.run('tuneup');

@Task()
void clean() => defaultClean();
