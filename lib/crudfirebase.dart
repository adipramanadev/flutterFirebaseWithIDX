import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CrudFirebase extends StatefulWidget {
  const CrudFirebase({super.key});

  @override
  State<CrudFirebase> createState() => _CrudFirebaseState();
}

class _CrudFirebaseState extends State<CrudFirebase> {
  //variabel form
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();

  //simpan Data ke database firebase
  Future<void> addUser() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final age = int.tryParse(_ageController.text.trim());

    if (name.isNotEmpty && email.isNotEmpty && age != null) {
      await FirebaseFirestore.instance
          .collection('user')
          .add({'name': name, 'email': email, 'age': age});
      _nameController.clear();
      _emailController.clear();
      _ageController.clear();
    }
  }

  //delete
  Future<void> deleteUser(String id) async {
    await FirebaseFirestore.instance.collection('user').doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Crud Firebase"),
      ),
      body: Column(
        //input field
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                ),
                TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: _ageController,
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                ),
                ElevatedButton(
                  onPressed: () {
                    addUser();
                    print('Klik Data simpan');
                  },
                  child: const Text('AddUser'),
                )
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection('user').snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) return const CircularProgressIndicator();
                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      final user = doc.data() as Map<String, dynamic>;
                      return ListTile(
                        title: Text(user['name']),
                        subtitle: Text(user['email']),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.edit),
                            ),
                            IconButton(
                              onPressed: () =>
                                  [deleteUser(doc.id), print('Klik Delete ')],
                              icon: const Icon(Icons.delete),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  );
                }),
          )
        ],
      ),
    );
  }
}
