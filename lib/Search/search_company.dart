import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d0_an_co_so/Widgets/all_companies_widget.dart';
import 'package:flutter/material.dart';
import '../Widgets/bottom_nav_bar.dart';

class AllWorkerScreen extends StatefulWidget {

  @override
  State<AllWorkerScreen> createState() => _AllWorkerScreenState();
}

class _AllWorkerScreenState extends State<AllWorkerScreen> {

  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = 'Truy vấn tìm kiếm';

  Widget _buildSearchField(){
    return TextField(
      controller: _searchQueryController,
      autocorrect: true,
      decoration: const InputDecoration(
        hintText: 'Tìm kiếm công ty ...',
        border: InputBorder.none,
        hintStyle: TextStyle(
          color: Colors.white,
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 16,
      ),
      onChanged: (query) => updateSearchQuery(query),
    );
  }

  List<Widget> _buildActions(){
    return <Widget>[
      IconButton(
        icon:const Icon(Icons.clear,color: Colors.white,),
        onPressed: (){
          _clearSearchQuery();
        },
      )
    ];
  }

  void _clearSearchQuery(){
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery('');
    });
  }

  void updateSearchQuery(String newQuery){
    setState(() {
      searchQuery = newQuery;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [Colors.deepOrange.shade300, Colors.blueAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const [0.2,0.9]
        ),
      ),
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 1),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.deepOrange.shade300, Colors.blueAccent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  stops: const [0.2,0.9]
              ),
              border: Border(
                bottom: BorderSide(
                  color: Colors.black.withOpacity(0.3), // Màu viền
                  width: 2.0, // Độ dày viền
                ),
              ),
            ),
          ),
          automaticallyImplyLeading:  false,
          title: _buildSearchField(),
          actions: _buildActions(),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('name', isGreaterThanOrEqualTo: searchQuery)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot){
            if(snapshot.connectionState == ConnectionState.waiting){
              return const Center(child: CircularProgressIndicator(),);
            }
            else if(snapshot.connectionState == ConnectionState.active){
              if(snapshot.data!.docs.isNotEmpty){
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index){
                     return AllWorkerWidget(
                         userID: snapshot.data!.docs[index]['id'],
                         userName: snapshot.data!.docs[index]['name'],
                         userEmail: snapshot.data!.docs[index]['email'],
                          phoneNumber: snapshot.data!.docs[index]['phoneNumber'],
                         userImageUrl: snapshot.data!.docs[index]['userImage'],
                     );
                    }
                );
              }
              else{
                return const Center(
                  child: Text('Không có người dùng nào'),
                );
              }
            }
            return const Center(
              child: Text(
                'Có gì đó sai sai',
                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),
              ),
            );
        },
        ),
      ),
    );
  }
}
