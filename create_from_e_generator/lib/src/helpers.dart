import 'package:create_from_e_generator/src/classes.dart';
import 'package:dartx/dartx.dart';

List<FieldsForCreateFor> getFieldsForCreateFor(
  ClassDef extType,
  List<ClassDef> types,
) {
  return types.map((type) {
    var remaining = extType.fields.intersect(type.fields).toList();
    var newFields = type.fields.except(extType.fields).toList();
    return FieldsForCreateFor(type.name, remaining, newFields);
  }).toList();
}

bool checkIfAllTypesAreRelated(
  ClassDef extType,
  List<ClassDef> types,
) {
  for (var type in types) {
    //check if each type is either a subtype or a supertype of the extType
    if (!extType.superTypes.any((x) => type.name == x) && //
        !type.superTypes.any((x) => x == extType.name)) //
      throw Exception("each type must be either subtype or a supertype");
  }

  return true;
}

String getCreateForParamList(
  List<NameType> fields,
) {
  var result = fields
      .map((x) => "@required ${x.type} ${x.name}") //
      .joinToString(separator: ", ");

  return result.toString();
}

String getCreateFromSignature(
  String className,
  List<NameType> newFields,
) {
  if (newFields.length > 0) {
    var paramList = getCreateForParamList(newFields.sortedBy((x) => x.name).toList());
    return "$className create$className({$paramList})";
  }

  return "$className create$className()";
}

String getPropertySetThis(String className, String fieldName) => //
    "$fieldName: (this as $className).$fieldName";

String getPropertySet(String name) => //
    "$name: $name == null ? this.$name : $name";

String getConstructorLines(ClassDef extType, ClassDef typeType) {
  var result = typeType.fields.map((field) {
    if (extType.fields.any((x) => field.name == x.name)) {
      return getPropertySet(field.name);
    } else {
      return getPropertySetThis(typeType.name, field.name);
    }
  }).joinToString(separator: ",\n");

  return result;
}

String getExtensionDef(String className) => //
    "extension ${className}Ext_CreateFromE on ${className}";
