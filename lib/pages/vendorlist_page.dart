import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:url_launcher/url_launcher.dart';

class VendorListPage extends StatelessWidget {
  final String area; // Nama kawasan dipilih

  VendorListPage({required this.area});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Vendor di $area")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users') // Koleksi users
            .where('role', isEqualTo: 'vendor') // Penapis berdasarkan role
            .where('area', isEqualTo: area) // Penapis berdasarkan kawasan
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text("Tiada vendor di kawasan ini."));
          }

          final vendors = snapshot.data!.docs;
          return ListView.builder(
            itemCount: vendors.length,
            itemBuilder: (context, index) {
              final vendor = vendors[index];
              final name = vendor['name'];
              final phone = vendor['phone'];
              final email = vendor['email'] ?? "Tiada email";
              return ListTile(
                title: Text(name),
                subtitle: Text("📱 $phone\n📧 $email"),
                onTap: () async {
                  final whatsappUrl =
                      Uri.parse("https://wa.me/${phone.replaceFirst("+", "")}");
                  if (await canLaunchUrl(whatsappUrl)) {
                    await launchUrl(whatsappUrl,
                        mode: LaunchMode.externalApplication);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Tidak dapat membuka WhatsApp")),
                    );
                  }
                },
              );
            },
          );
        },
      ),
    );
  }
}
