import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'area_page.dart';

class StatePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Steam Iron Repairer"),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('states').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Tiada negeri tersedia."));
          }

          final states = snapshot.data!.docs;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Tetapkan bilangan lajur kepada 2
                crossAxisSpacing: 8, // Jarak antara lajur
                mainAxisSpacing: 8, // Jarak antara baris
                childAspectRatio: 3, // Nisbah lebar:tinggi untuk item grid
              ),
              itemCount: states.length, // Bilangan negeri berdasarkan Firebase
              itemBuilder: (context, index) {
                final stateName =
                    states[index]['name']; // Nama negeri dari Firestore

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AreaPage(state: stateName),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        stateName, // Paparkan nama negeri
                        style: TextStyle(
                          fontSize: 16, // Saiz font sederhana
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
