import 'package:create_from_e_generator/src/classes.dart';
import 'package:create_from_e_generator/src/helpers.dart';
import 'package:dartx/dartx.dart';

String genCreateFrom(
  ClassDef extType,
  List<ClassDef> types,
) {
  checkIfAllTypesAreRelated(extType, types);

  var typesX = types.sortedBy((x) => x.name).toList();

  var typesFields = getFieldsForCreateFor(extType, typesX);

  var sb = StringBuffer();
  sb.writeln(getExtensionDef(extType.name) + "{");

  for (var o in typesFields) {
    sb.writeln(getCreateFromSignature(o.typeName, o.newFields) + "{");
    sb.writeln("return ${o.typeName} (");
    o.remainingFields.forEach((x) => //
        sb.writeln("${x.name}: this.${x.name},"));
    o.newFields.forEach((x) => //
        sb.writeln("${x.name}: ${x.name},"));
    sb.writeln(");}");
  }

  sb.writeln("}");

  return sb.toString();
}
