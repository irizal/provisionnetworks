import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'area_page.dart';
import '../widgets/button1.dart';

class StatePage extends StatefulWidget {
  @override
  _StatePageState createState() => _StatePageState();
}

class _StatePageState extends State<StatePage>
    with SingleTickerProviderStateMixin {
  List<Map<String, String>> statesList = [];
  bool isLoading = true;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fetchStates();
  }

  Future<void> _fetchStates() async {
    try {
      final snapshot =
          await FirebaseFirestore.instance.collection('states').get();
      statesList = snapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "name": (doc['name'] ?? 'Unknown State').toString(),
          "flag": (doc['flag'] ?? '').toString(),
        };
      }).toList();

      setState(() {
        isLoading = false;
        _controller.forward(); // Mulakan animasi apabila data dimuatkan
      });
    } catch (e) {
      print("Error fetching states: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select State"),
        centerTitle: true,
        backgroundColor: const Color(0xFF008BFD),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 3,
              ),
              itemCount: statesList.length,
              itemBuilder: (context, index) {
                final state = statesList[index];
                final Animation<double> fadeAnimation =
                    Tween<double>(begin: 0, end: 1).animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Interval(
                      (index / statesList.length).clamp(0.0, 1.0),
                      1.0,
                      curve: Curves.easeOut,
                    ),
                  ),
                );

                final Animation<Offset> slideAnimation = Tween<Offset>(
                        begin: Offset(index % 2 == 0 ? -1 : 1, 0),
                        end: Offset(0, 0))
                    .animate(
                  CurvedAnimation(
                    parent: _controller,
                    curve: Interval(
                      (index / statesList.length).clamp(0.0, 1.0),
                      1.0,
                      curve: Curves.easeOut,
                    ),
                  ),
                );

                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return FadeTransition(
                      opacity: fadeAnimation,
                      child: SlideTransition(
                        position: slideAnimation,
                        child: Button1(
                          title: state['name']!,
                          imagePath:
                              state['flag']!.isNotEmpty ? state['flag'] : null,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => AreaPage(
                                  stateId: state['id']!,
                                  stateName: state['name']!,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/register-vendor');
        },
        child: Icon(Icons.add),
        backgroundColor: const Color(0xFF008BFD),
      ),
    );
  }
}
