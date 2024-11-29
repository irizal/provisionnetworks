import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'vendorlist_page.dart';

class AreaPage extends StatelessWidget {
  final String state;

  AreaPage({required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kawasan di $state"),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('areas') // Koleksi areas
            .where('state', isEqualTo: state) // Penapis berdasarkan negeri
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Tiada kawasan untuk negeri ini."));
          }

          final areas = snapshot.data!.docs;

          return ListView.builder(
            itemCount: areas.length,
            itemBuilder: (context, index) {
              final areaName = areas[index]['name'];
              return ListTile(
                title: Text(areaName),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VendorListPage(area: areaName),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
