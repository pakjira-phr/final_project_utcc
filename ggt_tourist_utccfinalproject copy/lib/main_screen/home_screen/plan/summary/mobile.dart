//ไม่ใช้แล้ว
import 'package:firebase_storage/firebase_storage.dart';
// ignore: import_of_legacy_library_into_null_safe, unused_import
// import 'package:open_file/open_file.dart';
// ignore: depend_on_referenced_packages
import 'package:path_provider/path_provider.dart';

import 'dart:io';
import 'dart:developer' as devtools show log;


Future saveAndLaunchFile(List<int> bytesList, String fileName,int id, Map tourGuide,DateTime planDate) async {
  final path = Platform.isAndroid
      ? (await getExternalStorageDirectory())?.path
      : (await getApplicationSupportDirectory()).path;

  final file = File('$path/$fileName');
  await file.writeAsBytes(bytesList, flush: true);
  // OpenFile.open('$path/$fileName');

//-------------------------add to firebase--------------------------------------------------
  final storageRef = FirebaseStorage.instance.ref();
  final fileRef =
      storageRef.child("jobOrder").child('$id').child(fileName);
  await fileRef.putFile(file).whenComplete(() => devtools.log('pdf added'));
  //  String link = await fileRef.getDownloadURL();

   


}
