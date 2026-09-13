import 'package:flutter/material.dart';
import '../models/student.dart';

class StudentTile extends StatelessWidget {
  final Student student;
  final VoidCallback onChanged;

  const StudentTile({
    super.key,
    required this.student,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(student.name),
      subtitle: Text('Carné: ${student.carnet}'),
      trailing: Switch(
        value: student.present,
        onChanged: (_) => onChanged(),
      ),
    );
  }
}