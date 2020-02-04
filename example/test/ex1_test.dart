import 'package:create_from_e_annotation/CreateFromE.dart';
import 'package:test/test.dart';

part 'ex1_test.g.dart';

main() {
  test("1", () {
    var bob = Person(age: 5, name: "bob");
    var bobEmployee = bob.createEmployee();
    expect(bobEmployee.toString(), bob.toString());
    expect(bobEmployee is Employee, true);
  });
}

@CreateFromE([Employee])
class Person {
  final int age;
  final String name;

  Person({this.age, this.name});

  String toString() => "${age.toString()}, ${name.toString()}";
}

class Employee implements Person {
  final int age;
  final String name;

  Employee({this.age, this.name});

  String toString() => "${age.toString()}, ${name.toString()}";
}