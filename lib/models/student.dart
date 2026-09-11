class Student {
  final String name;
  final String carnet;
  bool present;

  Student({
    required this.name,
    required this.carnet,
    this.present = false,
  });
}