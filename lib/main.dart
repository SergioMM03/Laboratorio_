import 'package:flutter/material.dart';

import 'data/student_data.dart';
import 'models/student.dart';
import 'widgets/student_tile.dart';

void main() {
  runApp(const AttendanceApp());
}

class AttendanceApp extends StatelessWidget {
  const AttendanceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AttendanceScreen(),
    );
  }
}

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  late List<Student> students;

    @override
  void initState() {
    super.initState();

    students = _copyInitialStudents();
  }

  List<Student> _copyInitialStudents() {
    return initialStudents
        .map(
          (student) => Student(
            name: student.name,
            carnet: student.carnet,
            present: student.present,
          ),
        )
        .toList();
  }

  int get presentCount {
    return students.where((student) => student.present).length;
  }

  void toggleStudent(int index) {
    setState(() {
      students[index].present = !students[index].present;
    });
  }

  void markAllPresent() {
    setState(() {
      for (final student in students) {
        student.present = true;
      }
    });
  }
  void resetStudents() {
    setState(() {
      students = _copyInitialStudents();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de asistencia'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Grupo 01',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Presentes: $presentCount / ${students.length}',
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: markAllPresent,
                          child: const Text('Marcar todos'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: resetStudents,
                          child: const Text('Restablecer'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: students.length,
                itemBuilder: (context, index) {
                  final student = students[index];

                  return StudentTile(
                    student: student,
                    onChanged: () => toggleStudent(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}