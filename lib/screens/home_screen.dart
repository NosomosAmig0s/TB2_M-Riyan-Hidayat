//@M RIYAN HIDAYAT (41822010024)
import 'package:flutter/material.dart';
import 'package:tb2riyan/model/student.dart';
import 'package:tb2riyan/utils/database_helper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper.instance;
  List<Student> students = [];
  int totalStudents = 0;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() async {
    List<Student> studentsList = await databaseHelper.getStudents();
    setState(() {
      students = studentsList;
      totalStudents = students.length;
    });
  }

  // Fungsi untuk menampilkan dialog tambah data mahasiswa
  void _showAddStudentDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController nimController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Create Student"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Student Name'),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: nimController,
                decoration: InputDecoration(labelText: 'NIM'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
              onPressed: () async {
                Student student = Student(
                  name: nameController.text,
                  nim: nimController.text,
                  phone: phoneController.text,
                  email: emailController.text,
                );
                await databaseHelper.insertStudent(student);
                _loadStudents();
                Navigator.of(context).pop();
              },
              child: Text("Create"),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog edit data mahasiswa
  void _showEditStudentDialog(Student student) {
    TextEditingController nameController =
    TextEditingController(text: student.name);
    TextEditingController nimController =
    TextEditingController(text: student.nim);
    TextEditingController phoneController =
    TextEditingController(text: student.phone);
    TextEditingController emailController =
    TextEditingController(text: student.email);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update student information"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Student Name'),
                keyboardType: TextInputType.text,
              ),
              TextField(
                controller: nimController,
                decoration: InputDecoration(labelText: 'NIM'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: phoneController,
                decoration: InputDecoration(labelText: 'Phone'),
                keyboardType: TextInputType.phone,
              ),
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
              onPressed: () async {
                Student updatedStudent = Student(
                  id: student.id,
                  name: nameController.text,
                  nim: nimController.text,
                  phone: phoneController.text,
                  email: emailController.text,
                );
                await databaseHelper.updateStudent(updatedStudent);
                _loadStudents();
                Navigator.of(context).pop();
              },
              child: Text("Update"),
            ),
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi hapus data mahasiswa
  void _showDeleteConfirmationDialog(Student student) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text("Are You sure, You wanted to delete this student?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "NO",
                style: TextStyle(color: Colors.pinkAccent),
              ),
            ),
            TextButton(
              onPressed: () async {
                await databaseHelper.deleteStudent(student.id!);
                _loadStudents();
                Navigator.of(context).pop();
              },
              child: Text(
                "YES",
                style: TextStyle(color: Colors.pinkAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog konfirmasi hapus semua data mahasiswa
  void _showDeleteAllConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete All Students"),
          content: Text("Are you sure you want to delete all students?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.pinkAccent),
              ),
            ),
            TextButton(
              onPressed: () {
                _deleteAllStudents();
                Navigator.of(context).pop();
              },
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.pinkAccent),
              ),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menghapus semua data mahasiswa
  void _deleteAllStudents() async {
    await databaseHelper.deleteAllStudents();
    setState(() {
      students.clear();
      totalStudents = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Student List",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _showDeleteAllConfirmationDialog();
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Total Students: $totalStudents',
              style: TextStyle(fontSize: 14),
            ),
          ),
          Expanded(
            child: students.isEmpty
                ? Center(
              child: Text(
                'List is Empty!',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            )
                : ListView.builder(
              itemCount: students.length,
              itemBuilder: (BuildContext context, int index) {
                Student student = students[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(1.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: DefaultTextStyle.of(context).style,
                              children: [
                                TextSpan(
                                  text: '${student.name}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit, color: Colors.grey),
                                onPressed: () {
                                  // Handle edit action
                                  _showEditStudentDialog(student);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.grey),
                                onPressed: () {
                                  // Handle delete action
                                  _showDeleteConfirmationDialog(student);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: 'NIM ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: '${student.nim}'),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: 'Phone ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: '${student.phone}'),
                          ],
                        ),
                      ),
                      RichText(
                        text: TextSpan(
                          style: DefaultTextStyle.of(context).style,
                          children: [
                            TextSpan(
                              text: 'Email ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(text: '${student.email}'),
                          ],
                        ),
                      ),
                      // Add more Text widgets or other widgets as needed
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddStudentDialog();
        },
        backgroundColor: Colors.pinkAccent,
        child: Icon(Icons.person_add),
      ),
    );
  }


}