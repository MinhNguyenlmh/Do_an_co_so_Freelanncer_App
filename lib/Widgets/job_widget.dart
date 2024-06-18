import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:d0_an_co_so/Jobs/job_details.dart';
import 'package:d0_an_co_so/Services/global_method.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class JobWidget extends StatefulWidget {
  final String jobTitle;
  final String jobDescription;
  final String jobId;
  final String uploadedBy;
  final String userImage;
  final String name;
  final bool recruitment;
  final String email;
  final String location;

  const JobWidget({
    required this.jobTitle,
    required this.jobDescription,
    required this.jobId,
    required this.uploadedBy,
    required this.userImage,
    required this.name,
    required this.recruitment,
    required this.email,
    required this.location,
  });

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {

  final FirebaseAuth _auth = FirebaseAuth.instance;

  _deleteDialog(){
    User? user = _auth.currentUser;
    final _uid = user!.uid;
    showDialog(
        context: context,
        builder: (ctx){
          return AlertDialog(
            actions: [
              SizedBox(height: 10,),
              TextButton(

                  onPressed: () async{
                    try{
                      if(widget.uploadedBy == _uid){
                        await FirebaseFirestore.instance.collection('jobs')
                            .doc(widget.jobId).delete();
                        await Fluttertoast.showToast(
                            msg: 'Công việc đã được xóa',
                            toastLength: Toast.LENGTH_LONG,
                            backgroundColor: Colors.grey,
                            fontSize: 18.0
                        );
                        Navigator.canPop(context) ? Navigator.pop(context) : null;
                      }
                      else{
                        GlobalMethod.showErrorDialog(
                            error: 'Bạn không thể biểu diễn hành động này',
                            ctx: ctx
                        );
                      }
                    }
                    catch(error){
                      GlobalMethod.showErrorDialog(
                          error: 'Mục này không thể bị xóa',
                          ctx: ctx
                      );
                    }
                    finally{}
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      Text(
                        'Xóa',
                        style: TextStyle(
                          color: Colors.red
                        ),
                      )
                    ],
                  )
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white24,
      elevation: 8,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => JobDetailsScreen(
            uploadedBy: widget.uploadedBy,
            jobID: widget.jobId,
          )));
        },
        onLongPress: () {
          _deleteDialog();
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        leading: Container(
          padding: const EdgeInsets.only(right: 12),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          // Sử dụng Container để điều chỉnh kích thước ảnh
          child: Container(
            width: 100, // Điều chỉnh kích thước ảnh ở đây
            height: 100, // Điều chỉnh kích thước ảnh ở đây
            child: Image.network(
              widget.userImage,
              fit: BoxFit.cover, // Đảm bảo ảnh vừa với kích thước container
            ),
          ),
        ),
        title: Text(
          widget.jobTitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Colors.amber,
            fontWeight: FontWeight.bold,
            fontSize: 25,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.blueAccent,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.jobDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          color: Colors.black,
          size: 30,
        ),
      ),
    );
  }
}
