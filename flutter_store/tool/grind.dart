import 'dart:io';

import 'package:grinder/grinder.dart';

void main(List<String> args) => grind(args);

@DefaultTask()
@Depends(tuneup)
Future<void> build() => Process.run('flutter', ['build', 'web']);

@Task()
void tuneup() => Pub.run('tuneup');

@Task()
void clean() => defaultClean();
