import 'package:create_from_e_generator/src/classes.dart';
import 'package:create_from_e_generator/src/genCreateFrom.dart';
import 'package:test/test.dart';

void main() {
  group("createFrom", () {
    test("1", () {
      var extType = ClassDef("Person", [
        NameType("age", "int"),
        NameType("name", "String"),
      ], []);

      var types = [
        ClassDef("Employee", [
          NameType("age", "int"),
          NameType("name", "String"),
        ], [
          "Person"
        ])
      ];

      var result = genCreateFrom(extType, types).trim();

      var expected = """extension PersonExt on Person{
Employee createEmployee(){
return Employee (
age: this.age,
name: this.name,
);}
}""";

      expect(result, expected);
    });

    test("4", () {
      var extType = ClassDef("Person", [
        NameType("age", "int"),
        NameType("name", "String"),
      ], [
        "NamedThing"
      ]);

      var types = [
        ClassDef("Employee", [
          NameType("age", "int"),
          NameType("name", "String"),
        ], [
          "Person"
        ]),
        ClassDef("NamedThing", [
          NameType("name", "String"),
        ], []),
        ClassDef("Superman", [
          NameType("age", "int"),
          NameType("name", "String"),
          NameType("power", "String"),
        ], [
          "Employee", "Person"
        ])
      ];

      var result = genCreateFrom(extType, types).trim();

      var expected = """extension PersonExt on Person{
Employee createEmployee(){
return Employee (
age: this.age,
name: this.name,
);}
NamedThing createNamedThing(){
return NamedThing (
name: this.name,
);}
Superman createSuperman({@required String power}){
return Superman (
age: this.age,
name: this.name,
power: power,
);}
}""";

      expect(result, expected);
    });
  });
}
