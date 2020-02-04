import 'package:quiver/core.dart';

class NameType {
  final String type;
  final String name;

  NameType(this.name, this.type);

  bool operator ==(o) => o is NameType && name == o.name && type == o.type;
  int get hashCode => hash2(name.hashCode, type.hashCode);
  String toString() => "$name|$type";
}

class ClassDef {
  final String name;
  final List<NameType> fields;
  final List<String> superTypes;

  ClassDef(this.name, this.fields, this.superTypes);
}

class FieldsForCreateFor {
  final String typeName;
  final List<NameType> remainingFields;
  final List<NameType> newFields;

  FieldsForCreateFor(this.typeName, this.remainingFields, this.newFields);
}
