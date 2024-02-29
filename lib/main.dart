import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:external_path/external_path.dart';
import 'package:steganograph/steganograph.dart';


void main() {
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyApp();
}
bool pageIndex = true;
class _MyApp extends State<MyApp> {
  void changePagetoRetrieve() {
    setState(() {
      pageIndex = false;
    });
  }
  void changePagetoEmbed() {
    setState(() {
      pageIndex = true;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: pageIndex ? EmbedPage(onPressed: ()=>changePagetoRetrieve(),) : RetrievePage(onPressed: ()=>changePagetoEmbed()),
    );
  }
}

class EmbedPage extends StatefulWidget {
  final void Function()? onPressed;
  const EmbedPage({super.key, required this.onPressed});
  @override
  State<EmbedPage> createState() => _EmbedPageState();
}

class _EmbedPageState extends State<EmbedPage> {
  late File? _image = null;
  var  ekey = TextEditingController();
  var message = TextEditingController();


  Future<void> _getImage() async {
    // ignore: no_leading_underscores_for_local_identifiers
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery); // or ImageSource.camera for taking a new photo

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Image.asset("assets/images/logo.jpeg",
                  width: 200, height: 200),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Expanded(
                    flex: 1,
                    child: Container(
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              bottomLeft: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(color: Colors.black, blurRadius: 5)
                          ]),
                      child: const Center(
                          child: Text("Embed",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                    )),
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: widget.onPressed,
                      child: Container(
                        height: 40,
                        decoration: const BoxDecoration(
                            color: Colors.lightBlueAccent,
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(color: Colors.black, blurRadius: 5)
                            ]),
                        child: const Center(
                            child: Text("Retrieve",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                      ),
                    )),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextField(
                      controller: ekey,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        labelText: 'Encryption Key',
                        hintText: 'Encryption Key',
                      )
                    )
                  ),
                  SizedBox(width: 20,),
                  FloatingActionButton(
                    onPressed: _getImage,
                    tooltip: 'Pick Image',
                    child: Icon(Icons.add_a_photo),
                  ),
                ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: message,
                maxLines: 9,
                textAlign: TextAlign.start,
                keyboardType: TextInputType.multiline,
                decoration: InputDecoration(
                  labelText: 'Type Your Message Here',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  )
                )
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: () async {
                  //Encode image with an encryption key
                  var path = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
                  File? file = await Steganograph.encode(
                    image: _image!,
                    message: message.text,
                    encryptionKey: ekey.text,
                    outputFilePath: '${path}/encode.png',
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Image encodeed successfully')),
                  );
                },
                child: Text("Embed"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RetrievePage extends StatefulWidget {
  final void Function()? onPressed;
  const RetrievePage({super.key, required this.onPressed});
  @override
  State<RetrievePage> createState() => _RetrievePageState();
}

class _RetrievePageState extends State<RetrievePage> {
  late File? _image = null;
  var  ekey = TextEditingController();

  Future<void> _getImage() async {
    // ignore: no_leading_underscores_for_local_identifiers
    final imagePicker = ImagePicker();
    final pickedImage = await imagePicker.pickImage(source: ImageSource.gallery); // or ImageSource.camera for taking a new photo

    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Center(
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Image.asset("assets/images/logo.jpeg",
                  width: 200, height: 200),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(children: [
                Expanded(
                    flex: 1,
                    child: GestureDetector(
                      onTap: widget.onPressed,
                      child: Container(
                        height: 40,
                        decoration: const BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(color: Colors.black, blurRadius: 5)
                            ]),
                        child: const Center(
                            child: Text("Embed",
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white))),
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Container(
                      height: 40,
                      decoration: const BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(10),
                              bottomRight: Radius.circular(10)),
                          boxShadow: [
                            BoxShadow(color: Colors.black, blurRadius: 5)
                          ]),
                      child: const Center(
                          child: Text("Retrieve",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white))),
                    )),
              ]),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: TextField(
                          controller: ekey,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              labelText: 'Decryption Key',
                              hintText: 'Decryption Key',
                            )
                        )
                    ),
                    SizedBox(width: 20,),
                    FloatingActionButton(
                      onPressed: _getImage,
                      tooltip: 'Pick Image',
                      child: Icon(Icons.add_a_photo),
                    ),
                  ]
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: width,
                height: 250,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black, width: 1.0),
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: _image == null ? Center(child: Text('No image selected')) : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(_image!, fit: BoxFit.fill),
                ),
              )
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                onPressed: ()  async {
                  // Get the directory for the external storage
                  //decode with same encryption key used to encode
                  //to retrieve encrypted message
                  String? embeddedMessage = await Steganograph.decode(
                    image: _image!,
                    encryptionKey: ekey.text,
                  );

                  var directory = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);
                  if (directory != null) {
                    File file = File('${directory}/Message.txt');
                    await file.writeAsString(embeddedMessage!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Message saved to: ${file.path}')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Failed to save text file.')),
                    );
                  }
                },
                child: Text("Retrieve"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



