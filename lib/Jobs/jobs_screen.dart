import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d0_an_co_so/Search/search_job.dart';
import 'package:d0_an_co_so/Widgets/bottom_nav_bar.dart';
import 'package:d0_an_co_so/Widgets/job_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Persistent/persistent.dart';

class JobScreen extends StatefulWidget {
  @override
  State<JobScreen> createState() => _JobScreenState();
}

class _JobScreenState extends State<JobScreen> {

  String? jobCategoryFilter;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _showTaskCategoriesDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: const Text(
              'Các mục công việc',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
            content: Container(
              width: size.width * 0.9,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: Persistent.jobCategoryList.length,
                itemBuilder: (ctx, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        jobCategoryFilter = Persistent.jobCategoryList[index];
                      });
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                      print('jobCategoryList[index], ${Persistent.jobCategoryList[index]}');
                    },
                    child: Row(
                      children: [
                        const Icon(
                          Icons.arrow_right_alt_outlined,
                          color: Colors.grey,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            Persistent.jobCategoryList[index],
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text(
                    'Đóng',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  )
              ),
              TextButton(
                  onPressed: () {
                    setState(() {
                      jobCategoryFilter = null;
                    });
                    Navigator.canPop(context) ? Navigator.pop(context) : null;
                  },
                  child: const Text(
                    'Hủy',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 20,
                    ),
                  )
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Persistent persistentObject = Persistent();
    persistentObject.getMyData();
  }

  @override
  Widget build(BuildContext context) {

    Size size = MediaQuery.of(context).size;

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
        bottomNavigationBar: BottomNavigationBarForApp(indexNum: 0),
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Bảng các việc làm'),
          centerTitle: true,
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
          automaticallyImplyLeading: false,
          leading: IconButton(
            icon: const Icon(Icons.filter_list_rounded, color: Colors.black,),
            onPressed: (){
              _showTaskCategoriesDialog(size: size);
            },
          ),
          actions: [
            IconButton(
                onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SearchScreen()));
                },
                icon: const Icon(Icons.search_outlined,color: Colors.black,)
            )
          ],
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance.collection('jobs')
              .where('jobCategory', isEqualTo: jobCategoryFilter)
              .where('recruitment', isEqualTo: true)
              .orderBy('createAt', descending: false)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshort){
            if(snapshort.connectionState == ConnectionState.waiting){
              return Center(child:  CircularProgressIndicator(),);
            }
            else if(snapshort.connectionState == ConnectionState.active){
              if(snapshort.data?.docs.isNotEmpty == true){
                return ListView.builder(
                    itemCount: snapshort.data?.docs.length,
                    itemBuilder: (BuildContext context, int index){
                      return JobWidget(
                          jobTitle: snapshort.data?.docs[index]['jobTitle'],
                          jobDescription: snapshort.data?.docs[index]['jobDescription'],
                          jobId: snapshort.data?.docs[index]['jobId'],
                          uploadedBy: snapshort.data?.docs[index]['uploadedBy'],
                          userImage: snapshort.data?.docs[index]['userImage'],
                          name: snapshort.data?.docs[index]['name'],
                          recruitment: snapshort.data?.docs[index]['recruitment'],
                          email: snapshort.data?.docs[index]['email'],
                          location: snapshort.data?.docs[index]['location']
                      );
                    },
                );
              }
           else{
                return const Center(
                  child: Text('Ở đây đang không có công việc nào'),
                );
              }
            }
            return const Center(
              child: Text(
                'Có gì đó sai sai',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
