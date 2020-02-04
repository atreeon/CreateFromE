//CREATE MULTIPLE SUBCLASSES AND SUPERCLASSES
import 'package:create_from_e_annotation/CreateFromE.dart';
import 'package:meta/meta.dart';
import 'package:test/test.dart';

main() {
  test("1", () {
    var bob = Person(age: 5, name: "bob");
    var bobEmployee = bob.createEmployee();
    expect(bobEmployee.name, "bob");
    expect(bobEmployee.age, 5);
    expect(bobEmployee is Employee, true);

    var bobNamedThing = bob.createNamedThing();
    expect(bobNamedThing.toString(), "bob");
    expect(bobEmployee is NamedThing, true);

    var bobSuperman = bob.createSuperman(power: "flying");
    expect(bobSuperman.name, "bob");
    expect(bobSuperman.age, 5);
    expect(bobSuperman.power, "flying");

    expect(bobSuperman is Superman, true);
  });
}

class NamedThing {
  final String name;

  NamedThing({this.name});

  String toString() => name;
}

@CreateFromE([Employee, NamedThing, Superman])
class Person implements NamedThing {
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

class Superman implements Employee {
  final int age;
  final String name;
  final String power;

  Superman({this.age, this.name, this.power});

  String toString() => "${age.toString()}, ${name.toString()}, $power";
}

extension PersonExt on Person {
  Employee createEmployee() {
    return Employee(
      age: this.age,
      name: this.name,
    );
  }

  NamedThing createNamedThing() {
    return NamedThing(
      name: this.name,
    );
  }

  Superman createSuperman({
    @required String power,
  }) {
    return Superman(
      name: this.name,
      age: this.age,
      power: power,
    );
  }
}
