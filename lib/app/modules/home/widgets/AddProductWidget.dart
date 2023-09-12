import 'dart:io';
import 'dart:math';

import 'package:admin_zp/app/data/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AddProductWidget extends StatefulWidget {
  AddProductWidget({Key? key}) : super(key: key);

  @override
  State<AddProductWidget> createState() => _AddProductWidgetState();
}

class _AddProductWidgetState extends State<AddProductWidget> {
  final FirebaseFirestore theDatabase = FirebaseFirestore.instance;

  PlatformFile? pickedFIle;

  Future selectFile() async{
    if(itemImageUrl != ""){
      FirebaseStorage.instance.refFromURL(itemImageUrl).delete();
    }
    final result = await FilePicker.platform.pickFiles();
    if(result == null) return;

    setState(() {
      pickedFIle = result.files.first;
    });

    uploadFIle();
  }

  UploadTask? uploadTask;
  String itemImageUrl = "";
  bool showImage = false;
  bool imageUploaded = false;

  Future uploadFIle() async {


    final path = 'itemImages/${pickedFIle!.name}';
    final file = File(pickedFIle!.path!);

    final ref =  FirebaseStorage.instance.ref().child(path);
    //ref.putFile(file);


    setState(() async{
      imageUploaded = false;

      uploadTask = ref.putFile(file);

      final snapSHot = await uploadTask!.whenComplete(() {

      });
      itemImageUrl = await snapSHot.ref.getDownloadURL();
    });

    setState(() {
      uploadTask = null;
      imageUploaded = true;
    });
  }

  addProduct(Product productData) async {
    await theDatabase.collection("product").add(productData.toJson()).whenComplete(() => Fluttertoast.showToast(msg: "New Product added!"));
  }

  TextEditingController nameCtrl = TextEditingController();

  TextEditingController mobileCtrl  = TextEditingController();

  TextEditingController addressCtrl = TextEditingController();

  TextEditingController descrCtrl = TextEditingController();

  final CollectionReference _red =
  FirebaseFirestore.instance.collection("product");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          // Container(
          //   alignment: Alignment.centerLeft,
          //   margin: const EdgeInsets.all(8),
          //   child: InkWell(
          //     onTap: () {
          //       Navigator.pop(context);
          //     },
          //     child: const Icon(Icons.arrow_back_ios_new,
          //       size: 28,),
          //
          //   ),
          // ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 15, top: 20),
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Product Details",
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(162, 0, 0, 0),
                      fontWeight: FontWeight.bold
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
                  controller: nameCtrl,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Name",
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
                  controller: descrCtrl,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "descr",
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
                  controller: mobileCtrl,
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Unit",
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
                  controller: addressCtrl,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Price",
                      hintStyle: TextStyle(
                          fontSize: 20
                      )
                  ),
                ),
              ),
              ElevatedButton(onPressed: selectFile, child: const Text("Select File")),
              ElevatedButton(onPressed: (){
                setState(() {
                  showImage = !showImage;
                });
              }, child: Text(showImage ? "Hide Image" : "Show Image")),
              if(pickedFIle != null)Container(
                color: Colors.blue[100],
                child: !showImage ? Center(
                  child: Text(pickedFIle!.name),
                ) : Image.file(File(pickedFIle!.path!),
                width: double.infinity,
                fit: BoxFit.contain,),
              ),
              const SizedBox(height: 50,),
              InkWell(
                onTap: () {

                  // DatabaseService(uid: 312.toString()).updateProduct(nameCtrl.text, int.parse(mobileCtrl.text.isNotEmpty == true ? mobileCtrl.text : "0"), addressCtrl.text).then((value){
                  //   Fluttertoast.showToast(msg: "Order Has Been Placed!");

                  // });

                  // _red.add({
                  //   'name': nameCtrl.text,
                  //   'expiry': addressCtrl.text,
                  //   'quantity':int.parse(mobileCtrl.text.isNotEmpty == true ? mobileCtrl.text : "0")
                  // }).whenComplete(() => Fluttertoast.showToast(msg: "New Item added!"));
                  // uploadFIle().whenComplete(() {
                  //
                  // });
                  //
                  // if(imageUploaded){
                  //   addProduct(Product(
                  //       name: nameCtrl.text,
                  //       price: int.parse(addressCtrl.text),
                  //       unit: mobileCtrl.text.isNotEmpty == true ? mobileCtrl.text : "gram",
                  //       description: descrCtrl.text,
                  //       productImage: itemImageUrl
                  //   )).whenComplete(() => Fluttertoast.showToast(msg: "New Product added!"));
                  //
                  //
                  //   nameCtrl.clear();
                  //   addressCtrl.clear();
                  //   mobileCtrl.clear();
                  //   descrCtrl.clear();
                  //   setState(() {
                  //     itemImageUrl = "";
                  //   });
                  // }

                  addProduct(Product(
                      name: nameCtrl.text,
                      price: int.parse(addressCtrl.text),
                      unit: mobileCtrl.text.isNotEmpty == true ? mobileCtrl.text : "gram",
                      description: descrCtrl.text,
                      productImage: itemImageUrl
                  )).whenComplete(() => Fluttertoast.showToast(msg: "New Product added!"));


                },
                child: Container(
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                      color: const Color(0xFFFFB608),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: const Text("Add Product",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold
                    ),),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
