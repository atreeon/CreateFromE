import 'package:create_from_e_generator/src/classes.dart';
import 'package:create_from_e_generator/src/helpers.dart';
import 'package:test/test.dart';

void main() {
  group("getFieldsForCreateFor", () {
    test("1 match", () {
      var extType = ClassDef("Employee", [NameType("age", "int")], ["Person", "HasAge"]);
      var types = [
        ClassDef("Person", [NameType("age", "int")], []),
      ];

      var result = getFieldsForCreateFor(extType, types);

      expect(result[0].remainingFields.toString(), "[age|int]");
      expect(result[0].newFields.length, 0);
    });

    test("2 new fields (subclass specified)", () {
      var extType = ClassDef("Employee", [NameType("age", "int")], ["Person", "HasAge"]);
      var types = [
        ClassDef("Superman", [NameType("age", "int"), NameType("power", "String")], [])
      ];

      var result = getFieldsForCreateFor(extType, types);

      expect(result[0].remainingFields.toString(), "[age|int]");
      expect(result[0].newFields.toString(), "[power|String]");
    });

    test("3 removed fields (superclass specified)", () {
      var extType = ClassDef("Employee", [NameType("age", "int"), NameType("id", "int")], ["Person", "Animal"]);
      var types = [
        ClassDef("Animal", [NameType("age", "int")], []),
      ];

      var result = getFieldsForCreateFor(extType, types);

      expect(result[0].remainingFields.toString(), "[age|int]");
      expect(result[0].newFields.length, 0);
    });
  });

  group("checkIfAllTypesAreRelated", () {
    test("1 exists in supertype", () {
      var extType = ClassDef("Employee", [NameType("age", "int")], ["Person", "HasAge"]);
      var types = [
        ClassDef("Person", [NameType("age", "int")], [])
      ];

      var result = checkIfAllTypesAreRelated(extType, types);

      expect(result, true);
    });

    test("2 exists in subtype", () {
      var extType = ClassDef("Person", [NameType("age", "int")], ["HasAge"]);
      var types = [
        ClassDef("Employee", [NameType("age", "int")], ["Person"])
      ];

      var result = checkIfAllTypesAreRelated(extType, types);

      expect(result, true);
    });

    test("3 doesn't exist in either", () {
      var extType = ClassDef("Person", [NameType("age", "int")], ["HasAge"]);
      var types = [
        ClassDef("Car", [NameType("speed", "int")], ["Vehicle"])
      ];

      var result = checkIfAllTypesAreRelated(extType, types);

      expect(result, false);
    });
  });

  group("getCreateForParamList", () {
    test("1", () {
      var fields = [
        NameType("age", "int"),
        NameType("name", "String"),
      ];

      var result = getCreateForParamList(fields);

      expect(result, "@required int age, @required String name");
    });
  });

  group("getCreateForSignature", () {
    test("1", () {
      var result = getCreateFromSignature("Employee", [
        NameType("id", "int"),
      ]);

      expect(result, "Employee createEmployee({@required int id})");
    });
  });

  group("getPropertySet", () {
    test("1", () {
      var result = getPropertySet("age");

      expect(result, "age: age == null ? this.age : age");
    });
  });

//  group("getConstructorLines", () {
//    test("1 - simple", () {
//      var result = getConstructorLines(
//        ClassDef(false, "Person", [NameType("age", "int"), NameType("name", "String")]),
//        ClassDef(false, "Person", [NameType("age", "int"), NameType("name", "String")]),
//      );
//
//      expect(
//          result,
//          """
//age: age == null ? this.age : age,
//name: name == null ? this.name : name"""
//              .trim());
//    });

//    test("2 - on other type", () {
//      var result = getConstructorLines(
//        ClassDef(true, "HasAge", [NameType("age", "int")]),
//        ClassDef(false, "Person", [NameType("age", "int"), NameType("name", "String")]),
//      );
//
//      expect(
//          result,
//          """
//age: age == null ? this.age : age,
//name: (this as Person).name"""
//              .trim());
//    });
//  });
}
