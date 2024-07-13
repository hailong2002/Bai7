import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../controller/user_controller.dart';
import '../../data/model/body/tracking.dart';
import '../../data/model/body/user.dart';

class TrackingScreen extends StatefulWidget {
  const TrackingScreen({Key? key}) : super(key: key);

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {

  final TextEditingController _contentController = TextEditingController();
  final _key = GlobalKey<FormState>();

  DateTime? _selectedDate;
  Future<void> _selectDate(BuildContext context) async {
    _selectedDate = null;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), // Default to today's date
      firstDate: DateTime(1900), // Earliest date that can be picked
      lastDate: DateTime.now(), // Latest date that can be picked
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void showTrackingForm({int? id, String? date, String? content, User? user}){
    if(content != null){
      setState(()=> _contentController.text = content);
    }else{
      _contentController.clear();
    }
    showDialog(
        context: context,
        builder:(context){
          return AlertDialog(
            title: id != null ? const Text('Cập nhật ghi chép', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20)) :
                const Text('Thêm ghi chép', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 20)),
            content: GetBuilder<AuthController>(
                builder: ( controller) {
                  return SizedBox(
                    height: 250,
                    child: Form(
                        key: _key,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(0),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Hôm nay: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}. '
                                    'Lúc ${DateTime.now().hour}:${DateTime.now().minute}',
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 20),
                                SizedBox(
                                  width: 350,
                                  child: TextFormField(
                                    controller: _contentController,
                                    textInputAction: TextInputAction.next,
                                    validator: (value){
                                      if(value == null || value.isEmpty){
                                        return 'Vui lòng điền nội dung';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                        contentPadding:
                                        const EdgeInsets.only(left: 28),
                                        border: OutlineInputBorder(
                                            borderSide: const BorderSide(
                                                width: 1,
                                                color:
                                                Color.fromRGBO(244, 244, 244, 1)),
                                            borderRadius: BorderRadius.circular(15)),
                                        hintText: "Nhập Nội dung",
                                        hintStyle: const TextStyle(
                                            color: Colors.grey)),
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(top: 20),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // date != null ? SizedBox(width:200 ,child: Text('Thời gian: $date', overflow: TextOverflow.ellipsis, maxLines: 1)) : const Text(''),
                                        Row(
                                          children: [
                                            ElevatedButton(onPressed: ()=>_selectDate(context), child: const Icon(Icons.access_time_filled_sharp)),
                                            const SizedBox(width:10),
                                            _selectedDate == null  ? (date != null ? SizedBox(width:150 ,child: Text(date, overflow: TextOverflow.ellipsis, maxLines: 1)): const SizedBox()) :
                                            Text('${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year} - '
                                                '${_selectedDate!.hour}:${_selectedDate!.minute}')

                                          ],
                                        ),
                                      ],
                                    )
                                ),

                                ElevatedButton(
                                    onPressed: (){
                                      if(_key.currentState!.validate()){
                                        if(id != null){
                                          Get.find<UserController>().updateTracking(content: _contentController.text, user: controller.user, id: id, date: _selectedDate);
                                        }else{
                                          Get.find<UserController>().fillTracking(
                                              content: _contentController.text,
                                              user: controller.user
                                          );
                                        }
                                        ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                                            content: id == null ?  const Text("Thêm mới ghi chú thành công") :
                                            const Text("Cập nhật ghi chú thành công") ,
                                            backgroundColor: Colors.greenAccent,
                                        ));
                                        Navigator.pop(context);
                                      }
                                    },
                                    child: const Text('Hoàn tất')
                                ),
                                const SizedBox(height: 20),

                              ],
                            ),
                          ),
                        ),
                      ),

                  );
                }
            ),

          );
        }
    );
  }

  void showDeleteTracking(int id){
    showDialog(
        context: context,
        builder: (context){
          return AlertDialog(
            title: const Text('Xóa ghi chú'),
            content: const Text('Bạn có chắc muốn xóa ghi chú này không?'),
            actions: [
              ElevatedButton(onPressed:()=>Navigator.pop(context), child: const Text('Không')),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed:(){
                    Get.find<UserController>().deleteTracking(id: id);
                    Navigator.pop(context);
                  },
                  child: const Text('Xóa')
              )
            ],
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    Get.find<AuthController>().getCurrentUser();
    Get.find<UserController>().getAllTracking();
    return Scaffold(
      appBar: AppBar(
          title: const Text('Ghi chép của tôi'),
          actions: [
            IconButton(onPressed: showTrackingForm, icon: const Icon(Icons.add))
          ],
      ),
      body: GetBuilder<UserController>(
            builder: (controller) {
              return SingleChildScrollView(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                            child: Column(
                                    children: [
                                      const SizedBox(height: 20),
                                      const Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                                        children: [
                                          Text('Thời gian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                          // const SizedBox(width: 100),
                                          Text('Nội dung', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      SizedBox(
                                        width: 350,
                                        height: 600,
                                        child: ListView.builder(
                                            itemCount: controller.trackingList.length,
                                            itemBuilder: (context, index){
                                              Tracking tracking = controller.trackingList[index];
                                              return InkWell(
                                                onLongPress: ()=>showDeleteTracking(tracking.id!),
                                                onTap: (){
                                                  showTrackingForm(
                                                      id: tracking.id,
                                                      date: tracking.date,
                                                      content: tracking.content,
                                                  );
                                                },
                                                child: Row(
                                                  children: [
                                                    Container(
                                                        width: 175,
                                                        height: 50,
                                                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                        decoration: BoxDecoration(
                                                            border: Border.all(color: Colors.green, width: 1)
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                            '${tracking.date}',
                                                          ),
                                                        ),
                                                    ),
                                                    Container(
                                                      width: 175,
                                                      height: 50,
                                                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                                                      decoration: BoxDecoration(
                                                          border: Border.all(color: Colors.green, width: 1)
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          '${tracking.content}',
                                                        ),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                              );
                                            }
                                        ),
                                      ),
                                  ],
                          
                            ),
                          ),

              );
            },
        
      )
    );
  }
}
