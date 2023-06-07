import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';

import 'package:http/http.dart' as http;
import "Wisata.dart";
void main() {
  runApp(const dashboard());
}
const kPrimaryColor = Color(0xFF0C9869);
class dashboard extends StatelessWidget {
  const dashboard({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.green
      ),
      home: const mydashboard(title: 'Dashboard'),
      debugShowCheckedModeBanner: false
    );
  }
}

class mydashboard extends StatefulWidget {
  const mydashboard({super.key, required this.title});

  final String title;

  @override
  State<mydashboard> createState() => _mydashboardstate();

}
List filterwisata = [];

Future<List<Wisata>> fetchWisata() async {

  final res =
  await http.get(Uri.parse('http://192.168.1.10:8000/api/Home'));
  print("BBBBBBBB");
  print(res.statusCode);
  if (res.statusCode == 200) {
    var data = jsonDecode(res.body);
    var parsed = data['tour']['data'].cast<Map<String, dynamic>>();
    print(parsed);
    filterwisata = parsed;
    var output = parsed.map<Wisata>((json) => Wisata.fromJson(json)).toList();
    return output;
  } else {
    throw Exception('Failed');
  }
}


class _mydashboardstate extends State<mydashboard> {
  late Future<List<Wisata>> wisata;
  final TextEditingController _searchController = TextEditingController();



  String searchstring = '';
  // void search(String query) {
  //   if (query.isEmpty) {
  //     daftarwisata = searchresult;
  //     setState(() {});
  //     return;
  //   }
  //
  //   query = query.toLowerCase();
  //   print(query);
  //   List result = [];
  //   daftarwisata.forEach((p) {
  //     var namawis = p["nama"].toString().toLowerCase();
  //     if (namawis.contains(query)) {
  //       result.add(p);
  //     }
  //   });
  //
  //   daftarwisata = result;
  //   setState(() {});
  // }

  @override
  void initState() {
    super.initState();
    wisata =  fetchWisata();
    List daftarwisata = [];
  }




  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Color.fromARGB(255, 11, 140, 14)),
        // leading: const Padding(
        //     padding: EdgeInsets.all(8.0),
        //     child: Material(
        //       shape: CircleBorder(),
        //       color: Colors.grey,
        //     )
        //
        // ),
        centerTitle: true,
        title: const Text(
          'Wisata',style: TextStyle(
          color: Color.fromARGB(255, 11, 140, 14)
        ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.menu, color: Color.fromARGB(255, 11, 140, 14)),
        //     onPressed: (){
        //
        //     },
        //   )
        // ],
      ),

        drawer: Drawer(

          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              UserAccountsDrawerHeader(
                  accountName: Text('Putera'),
                accountEmail: Text('putera123@gmail.com'),
                currentAccountPicture: CircleAvatar(
                  child: ClipOval(
                    child: Image.asset("images/img.jpg",width: 100,
                      height: 100,
                      fit: BoxFit.cover,),
                  ),
                ),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("images/gunung.jpg"),
                    fit: BoxFit.cover,
                  )
                ),
              ),
              ListTile(
                leading: Icon(
                  Icons.home,
                ),
                title: const Text('Dashboard'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              ListTile(
                leading: Icon(
                  Icons.place,
                ),
                title: const Text('Wisata'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),


    body:

        SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: const Text("Let's Explore NTB",
                    style:
                    TextStyle(fontWeight: FontWeight.w800, color: Color.fromARGB(255, 11, 140, 14),
                        fontSize: 22),
                    textAlign: TextAlign.left,
                  ),
                ),


                Container(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search...',

                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () => _searchController.clear(),
                      ),
                      // Add a search icon or button to the search bar
                      prefixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {

                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onChanged: (value){
                      setState(() {
                         searchstring = value;
                      });
                    }
                  ),
                ),

                Container(
                  child: GroupButton(
                    buttons: ["All","Popular","Recomended"],
                  ),
                  alignment: Alignment.topLeft,
                  margin: EdgeInsets.symmetric(vertical: 10.0),
                ),

                SizedBox(
                    height: 300,
                    child: FutureBuilder<List<Wisata>>(
                      future: wisata,
                      builder: (context, snapshot) {
                        print(snapshot.hasData);
                        if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text(
                                'No data',
                                style: TextStyle(color: Colors.teal, fontSize: 25),
                              ),
                            );
                          }

                          return ListView.builder(
                              itemCount: snapshot.data!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {

                                return GestureDetector(
                                    onTap: () {

                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(right: 15),
                                        width: 250.0,
                                        child: Column(children: <Widget>[
                                          Image.asset("images/img.jpg"),
                                          Container(
                                            padding: EdgeInsets.all(30.0 / 2),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(10),
                                                  bottomRight: Radius.circular(10),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset: Offset(0, 10),
                                                      blurRadius: 50,
                                                      color: kPrimaryColor.withOpacity(0.23))
                                                ]),
                                            child: Container(
                                              width: 250.0,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot.data![index].nama,
                                                    style:
                                                    TextStyle(color: Colors.blue, fontSize: 20),
                                                  ),
                                                  Text(
                                                    snapshot.data![index].lokasi.toString(),
                                                    style: TextStyle(
                                                        color: Colors.black, fontSize: 20),
                                                  ),
                                                  Container(
                                                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                                                      child :Text('Details',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .button
                                                            ?.copyWith(color: kPrimaryColor),
                                                      )
                                                  )

                                                ],
                                              ),
                                            ),

                                          )
                                        ])

                                    )
                                );
                              }
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )

                ),





                Container(
                  margin: const EdgeInsets.symmetric(vertical: 20.0),
                  height: 35.0,
                  child: ListView(
                    // This next line does the trick.
                    scrollDirection: Axis.horizontal,
                    children: <Widget>[
                      Container(
                        width: 90,
                        height: 30,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Color.fromARGB(255, 11, 140, 14))
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "All",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 90,
                        height: 30,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Color.fromARGB(255, 11, 140, 14))
                            ),
                          ),
                          onPressed: () {
                            print("semua");
                          },
                          child: const Text(
                            "Waterfalls",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 90,
                        height: 30,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Color.fromARGB(255, 11, 140, 14))
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Mountains",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 90,
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Color.fromARGB(255, 11, 140, 14))
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Beaches",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: 90,
                        height: 50,
                        margin: EdgeInsets.symmetric(horizontal: 8.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Color.fromARGB(255, 11, 140, 14))
                            ),
                          ),
                          onPressed: () {},
                          child: const Text(
                            "Camping",
                            style: TextStyle(
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                    height: 300,
                    child: FutureBuilder<List<Wisata>>(
                      future: wisata,
                      builder: (context, snapshot) {
                        print(snapshot.hasData);
                        if (snapshot.hasData) {
                          if (snapshot.data!.isEmpty) {
                            return const Center(
                              child: Text(
                                'No data',
                                style: TextStyle(color: Colors.teal, fontSize: 25),
                              ),
                            );
                          }

                          return ListView.builder(
                              itemCount: snapshot.data!.length,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {

                                return GestureDetector(
                                    onTap: () {

                                    },
                                    child: Container(
                                        margin: EdgeInsets.only(right: 15),
                                        width: 250.0,
                                        child: Column(children: <Widget>[
                                          Image.asset("images/img.jpg"),
                                          Container(
                                            padding: EdgeInsets.all(30.0 / 2),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(10),
                                                  bottomRight: Radius.circular(10),
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                      offset: Offset(0, 10),
                                                      blurRadius: 50,
                                                      color: kPrimaryColor.withOpacity(0.23))
                                                ]),
                                            child: Container(
                                              width: 250.0,
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    snapshot.data![index].nama,
                                                    style:
                                                    TextStyle(color: Colors.blue, fontSize: 20),
                                                  ),
                                                  Text(
                                                    snapshot.data![index].lokasi.toString(),
                                                    style: TextStyle(
                                                        color: Colors.black, fontSize: 20),
                                                  ),
                                                  Container(
                                                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                                                      child :Text('Details',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .button
                                                            ?.copyWith(color: kPrimaryColor),
                                                      )
                                                  )

                                                ],
                                              ),
                                            ),

                                          )
                                        ])

                                    )
                                );
                              }
                          );
                        } else {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      },
                    )
                ),
              ],
            )
        )

    );
  }
  Widget listViewWisata(daftarwisata){
    return SizedBox(
        height: 300,
        child: FutureBuilder<List<Wisata>>(
          future: wisata,
          builder: (context, snapshot) {
            print(snapshot.hasData);
            if (snapshot.hasData) {
              if (snapshot.data!.isEmpty) {
                return const Center(
                  child: Text(
                    'No data',
                    style: TextStyle(color: Colors.teal, fontSize: 25),
                  ),
                );
              }

              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {

                    return GestureDetector(
                        onTap: () {

                        },
                        child: Container(
                            margin: EdgeInsets.only(right: 15),
                            width: 250.0,
                            child: Column(children: <Widget>[
                              Image.asset("images/img.jpg"),
                              Container(
                                padding: EdgeInsets.all(30.0 / 2),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                          offset: Offset(0, 10),
                                          blurRadius: 50,
                                          color: kPrimaryColor.withOpacity(0.23))
                                    ]),
                                child: Container(
                                  width: 250.0,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        snapshot.data![index].nama,
                                        style:
                                        TextStyle(color: Colors.blue, fontSize: 20),
                                      ),
                                      Text(
                                        snapshot.data![index].lokasi.toString(),
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 20),
                                      ),
                                      Container(
                                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                                          child :Text('Details',
                                            style: Theme.of(context)
                                                .textTheme
                                                .button
                                                ?.copyWith(color: kPrimaryColor),
                                          )
                                      )
                                    ],
                                  ),
                                ),

                              )
                            ])

                        )
                    );
                  }
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        )
    );
  }
}