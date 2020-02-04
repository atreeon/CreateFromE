import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:create_from_e_annotation/CreateFromE.dart';
import 'package:create_from_e_generator/src/classes.dart';
import 'package:create_from_e_generator/src/genCreateFrom.dart';
import 'package:dartx/dartx.dart';
import 'package:source_gen/source_gen.dart';

List<NameType> getAllFields(List<InterfaceType> interfaceTypes, ClassElement element) {
  var superTypeFields = interfaceTypes //
      .where((x) => x.element.name != "Object")
      .flatMap((st) => st.element.fields.map((f) => NameType(f.name, f.type.toString())))
      .toList();
  var classFields = element.fields.map((f) => NameType(f.name, f.type.toString())).toList();

  return (classFields + superTypeFields).distinctBy((x) => x.name).toList();
}

class CreateFromEGenerator extends GeneratorForAnnotation<CreateFromE> {
  @override
  FutureOr<String> generateForAnnotatedElement(
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) {
    var sb = StringBuffer();

    var types = annotation
        .read('types') //
        .listValue
        .map((x) {
      var el = x.toTypeValue().element;

      if (el is! ClassElement) //
        throw Exception("the list of types must all be classes");

      var ce = (el as ClassElement);

      if (ce.isAbstract) //
        throw Exception("only non abstract classes are allowed - it is not possible to create abstract classes");

      var superTypes = ce.allSupertypes.map((x) => x.element.name).toList();

      return ClassDef(ce.name, getAllFields(ce.allSupertypes, ce), superTypes);
    }).toList();

    sb.writeln("//RULES: 1 all types must be non abstract classes");

    if (element is! ClassElement) //
      throw Exception("only allowed on concrete classes");
    var ce = (element as ClassElement);

    var superTypes = ce.allSupertypes.map((x) => x.element.name).toList();

    var extClass = ClassDef(
      element.name,
      getAllFields(ce.allSupertypes, element),
      superTypes,
    );

    sb.writeln(genCreateFrom(extClass, types));

    return element.session.getResolvedLibraryByElement(element.library).then((resolvedLibrary) {
      return sb.toString();
    });
  }
}
