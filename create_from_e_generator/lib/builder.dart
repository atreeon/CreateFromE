import 'package:build/build.dart';
import 'package:create_from_e_generator/src/CreateFromEGenerator.dart';
import 'package:source_gen/source_gen.dart';

Builder createFromEBuilder(BuilderOptions options) => //
    SharedPartBuilder([CreateFromEGenerator()], 'create_from_e_');
