import 'package:flutter/material.dart';

import 'controllers/course_controller.dart';
import 'data/course_api.dart';
import 'models/course.dart';
import 'repositories/course_repository.dart';

void main() {
  final api = CourseApi();
  final repository = CourseRepository(api);
  runApp(CoursePracticeApp(controller: CourseController(repository)));
}

class CoursePracticeApp extends StatelessWidget {
  const CoursePracticeApp({super.key, required this.controller});

  final CourseController controller;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Course Practice Lab',
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: CourseHomePage(controller: controller),
    );
  }
}

class CourseHomePage extends StatefulWidget {
  const CourseHomePage({super.key, required this.controller});

  final CourseController controller;

  @override
  State<CourseHomePage> createState() => _CourseHomePageState();
}

class _CourseHomePageState extends State<CourseHomePage> {
  final _searchController = TextEditingController();
  bool _loading = true;
  String? _error;
  List<Course> _courses = const [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await widget.controller.loadCourses();
    if (!mounted) return;
    setState(() {
      _loading = false;
      _error = widget.controller.errorMessage;
      _courses = widget.controller.courses;
    });
  }

  Future<void> _search(String query) async {
    final results = await widget.controller.search(query);
    if (!mounted) return;
    setState(() => _courses = results);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Photography Courses')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              onChanged: _search,
              decoration: const InputDecoration(
                labelText: 'Search published courses',
                prefixIcon: Icon(Icons.search),
              ),
            ),
            const SizedBox(height: 12),
            if (_loading) const LinearProgressIndicator(),
            if (_error != null) Text(_error!, key: const Key('course-error')),
            Expanded(
              child: _courses.isEmpty && !_loading
                  ? const Center(child: Text('No courses found'))
                  : ListView.builder(
                      itemCount: _courses.length,
                      itemBuilder: (context, index) {
                        final course = _courses[index];
                        return ListTile(
                          title: Text(course.title),
                          subtitle: Text(course.description),
                          key: ValueKey(course.id),
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
