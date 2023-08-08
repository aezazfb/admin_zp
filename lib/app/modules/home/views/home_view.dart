import 'package:admin_zp/app/data/functionalities/firebaseMessaging.dart';
import 'package:admin_zp/app/modules/home/widgets/AddProductWidget.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({Key? key}) : super(key: key);
  TextEditingController titleCntrl = TextEditingController();
  TextEditingController messageBodyCntrl  = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Panel'),
        centerTitle: true,
        bottom:  TabBar(controller: controller.tabController,
            tabs: [
          Tab(icon: const Icon(Icons.add),
          ),
          const Tab(icon: Icon(Icons.list),),
          const Tab(icon: Icon(Icons.radar_sharp),),
        ]),
      ),

      body: TabBarView(
        controller: controller.tabController,
        children: [
          AddProductWidget(),
          Column(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15, top: 15),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                width: 370,
                child: TextFormField(
                  controller: titleCntrl,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Title",
                      hintStyle: TextStyle(
                          fontSize: 20
                      )
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(left: 15, top: 15),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10)
                ),
                width: 370,
                child: TextFormField(
                  controller: messageBodyCntrl,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Body Message",
                      hintStyle: TextStyle(
                          fontSize: 20
                      )
                  ),
                ),
              ),
              ElevatedButton(onPressed: (){
                FirebaseApi().createPushNotification(titleCntrl.text, messageBodyCntrl.text);
              }, child: Text('Send Notification')),

              Icon(Icons.cabin),
            ],
          ),
          Icon(Icons.car_crash)
        ],
      ),
    );
  }
}
