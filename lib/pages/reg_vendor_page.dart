import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegVendorPage extends StatefulWidget {
  @override
  _RegVendorPageState createState() => _RegVendorPageState();
}

class _RegVendorPageState extends State<RegVendorPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  String selectedCategory = "Electrical Appliance Repair";
  String selectedSubcategory = "Steam Iron Repair";
  String selectedArea = "Kangar";

  final List<String> categories = [
    "Electrical Appliance Repair",
    "Home Maintenance"
  ];
  final List<String> subcategories = [
    "Steam Iron Repair",
    "Washing Machine Repair"
  ];
  final List<String> areas = ["Kangar", "Alor Setar", "Ipoh"];

  Future<void> registerVendor() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance.collection('users').add({
          'name': nameController.text.trim(),
          'phone': phoneController.text.trim(),
          'email': emailController.text.trim(),
          'role': 'vendor',
          'category': selectedCategory,
          'subcategory': selectedSubcategory,
          'area': selectedArea,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Vendor berjaya didaftarkan!")),
        );

        // Reset Borang Selepas Pendaftaran
        nameController.clear();
        phoneController.clear();
        emailController.clear();
        setState(() {
          selectedCategory = categories.first;
          selectedSubcategory = subcategories.first;
          selectedArea = areas.first;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Ralat semasa pendaftaran: $e")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Daftar Vendor")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Nama Vendor"),
                validator: (value) =>
                    value!.isEmpty ? "Nama wajib diisi" : null,
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(labelText: "No. Telefon"),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value!.isEmpty ? "Telefon wajib diisi" : null,
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value!.isEmpty || !value.contains('@')
                    ? "Email tidak sah"
                    : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categories.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
                decoration: InputDecoration(labelText: "Kategori"),
                validator: (value) =>
                    value == null ? "Kategori wajib dipilih" : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedSubcategory,
                items: subcategories.map((subcategory) {
                  return DropdownMenuItem(
                    value: subcategory,
                    child: Text(subcategory),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedSubcategory = value!;
                  });
                },
                decoration: InputDecoration(labelText: "Subkategori"),
                validator: (value) =>
                    value == null ? "Subkategori wajib dipilih" : null,
              ),
              DropdownButtonFormField<String>(
                value: selectedArea,
                items: areas.map((area) {
                  return DropdownMenuItem(
                    value: area,
                    child: Text(area),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedArea = value!;
                  });
                },
                decoration: InputDecoration(labelText: "Kawasan"),
                validator: (value) =>
                    value == null ? "Kawasan wajib dipilih" : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: registerVendor,
                child: Text("Daftar Vendor"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
