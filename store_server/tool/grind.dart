import 'dart:io';

import 'package:grinder/grinder.dart';

void main(List<String> args) => grind(args);

@DefaultTask()
@Depends(tuneup)
void build() {}

@Task()
@Depends(build)
Future<void> serve() async {
  final process = await Process.start(
      Platform.executable, ['bin/server.dart', '--port', '8080']);
  await stdout.addStream(process.stdout);
  await stderr.addStream(process.stderr);
}

@Task()
@Depends(genShelfRoutes)
void tuneup() => Pub.run('tuneup');

@Task()
void genShelfRoutes() => Pub.run('build_runner', arguments: ['build']);

@Task()
void clean() => defaultClean();
