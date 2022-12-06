// เอาไว้เก็บโค้ดที่อาจจะได้ใช้ในอนาคต

  // Future checkDatabase() async {
  //   FirebaseApp tourGuideApp = await Firebase.initializeApp(
  //     options: DefaultFirebaseOptions.currentPlatform,
  //   );
  //   print('Initialized default app ');

  //   FirebaseApp touristApp = await Firebase.initializeApp(
  //     
  //     options: DefaultFirebaseOptionsTourist.currentPlatform,
  //   );

  //   print('Initialized ');

  //   FirebaseFirestore tourGuideFirestore =
  //       FirebaseFirestore.instanceFor(app: tourGuideApp);
  //   FirebaseFirestore touristFirestore =
  //       FirebaseFirestore.instanceFor(app: touristApp);
  //   user = FirebaseAuth.instance.currentUser;
  //   // User? authtest = FirebaseAuth.instanceFor(app: touristApp).currentUser;
  //   // print(authtest?.uid);

  //   CollectionReference collectionRef = touristFirestore.collection('users');
  //   QuerySnapshot querySnapshot = await collectionRef.get();
  //   final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
  //   print(allData);
  // }


  