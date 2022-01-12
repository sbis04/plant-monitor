import 'package:flutter/material.dart';
import 'package:flutter_mongodb_realm/flutter_mongo_realm.dart';
import 'package:intl/intl.dart';
import 'package:plant_tinker/res/palette.dart';
import 'package:plant_tinker/widgets/dashboard/humidity_chart.dart';
import 'package:plant_tinker/widgets/dashboard/light_chart.dart';
import 'package:plant_tinker/widgets/dashboard/moisture_chart.dart';
import 'package:flutter/services.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage();

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // late final Stream<QuerySnapshot<Map<String, dynamic>>> _plantDataStream;

  MongoCollection? dbCollection;
  List<MongoDocument>? retrievedDocs = [];

  setupMongo() async {
    final client = MongoRealmClient();

    final app = RealmApp();
    // final user = await app.currentUser;
    // print(user!.profile!.name);

    CoreRealmUser? mongoUser = await app.login(Credentials.anonymous());

    print('mongoUser: ${mongoUser!.id}');

    final collection =
        client.getDatabase('plantdata').getCollection('readings');

    var numberOfDocs = await collection.count();
    print('Number of Docs: $numberOfDocs');

    var docs = await collection.find(
      options: RemoteFindOptions(
        projection: {
          "temperature": ProjectionValue.INCLUDE,
          "humidity": ProjectionValue.INCLUDE,
          "light": ProjectionValue.INCLUDE,
          "timestamp": ProjectionValue.INCLUDE,
          "moisture": ProjectionValue.INCLUDE,
        },
        // limit: 70,
        sort: {
          "timestamp": OrderValue.ASCENDING,
        },
      ),
    );

    // var docs = await collection.find(
    //   options: RemoteFindOptions(limit: 200, sort: {
    //     "timestamp": OrderValue.DESCENDING,
    //   }),
    // );

    setState(() {
      dbCollection = collection;
      retrievedDocs = docs;
    });

    // final stream = collection.watch();

    // stream.listen((data) {
    //   // data contains JSON string of the document that was changed
    //   var fullDocument = MongoDocument.parse(data);

    //   print(fullDocument.get('sensors'));
    // });

    // var docs = await collection.find(
    //   options: RemoteFindOptions(limit: 5, sort: {
    //     "timestamp": OrderValue.DESCENDING,
    //   }),
    // );

    // for (var doc in docs) {
    //   double temp = doc.get('temperature');
    //   print('TEMPERATURE: $temp');
    // }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Palette.blue_gray,
      statusBarIconBrightness: Brightness.light,
    ));
    setupMongo();
    // _plantDataStream = FirebaseFirestore.instance
    //     .collection('plant')
    //     .where('timestamp',
    //         isGreaterThan:
    //             (DateTime.now().millisecondsSinceEpoch - 43200000) ~/ 1000)
    //     .orderBy('timestamp')
    //     // .limitToLast(200)
    //     .snapshots();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.blue_gray,
      body: SafeArea(
        child: dbCollection == null
            ? Center(child: CircularProgressIndicator())
            : StreamBuilder(
                stream: dbCollection!.watch(),
                builder: (_, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Something went wrong');
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.data != null) {
                    final retrievedDoc = MongoDocument.parse(snapshot.data!);

                    retrievedDocs!.add(retrievedDoc);

                    final data = retrievedDoc.get('sensors');
                    print(data.toString());
                    // {temperature: 21.89999962, humidity: 73, moisture: 89.18193054, light: 100, timestamp: 1641974084}
                    final num temperature = data['temperature'] as num;
                    final int humidity = data['humidity'] as int;
                    final num moisture = data['moisture'] as num;
                    final num light = data['light'] as num;
                    final int timestamp = data['timestamp'] as int;

                    final formatter = DateFormat.jm().add_yMMMMd();
                    String lastUpdatedDateTime = formatter.format(
                      (DateTime.fromMillisecondsSinceEpoch(timestamp * 1000)),
                    );

                    return Padding(
                      padding: const EdgeInsets.only(
                        top: 16.0,
                        left: 16.0,
                        right: 16.0,
                      ),
                      child: ListView(
                        physics: BouncingScrollPhysics(),
                        children: [
                          Text(
                            'Last updated on: $lastUpdatedDateTime',
                            style: TextStyle(
                              color: Palette.red_accent,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.w400,
                              letterSpacing: 1,
                              fontSize: 12.0,
                            ),
                          ),
                          SizedBox(height: 16.0),
                          Stack(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color:
                                          Palette.green_accent.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                'Health',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w400,
                                                  letterSpacing: 1,
                                                  fontSize: 24.0,
                                                ),
                                              ),
                                              Text(
                                                'Good',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Montserrat',
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 1,
                                                  fontSize: 24.0,
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 8.0),
                                          Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Icon(
                                                Icons.info,
                                                size: 26.0,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width: 4.0),
                                              Expanded(
                                                child: Text(
                                                  'The moisture content of the plant is alright',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'Montserrat',
                                                    fontWeight: FontWeight.w500,
                                                    letterSpacing: 1,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  Text(
                                    'Temperature',
                                    style: TextStyle(
                                      color: Palette.blue_accent,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                      fontSize: 30.0,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    temperature.toStringAsFixed(1) + '°C',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                      fontSize: 50.0,
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  Text(
                                    'Humidity',
                                    style: TextStyle(
                                      color: Palette.blue_accent,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                      fontSize: 30.0,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    humidity.toString() + '%',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                      fontSize: 50.0,
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  Text(
                                    'Moisture',
                                    style: TextStyle(
                                      color: Palette.blue_accent,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                      fontSize: 30.0,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    moisture.toStringAsFixed(2) + '%',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                      fontSize: 50.0,
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  Text(
                                    'Light',
                                    style: TextStyle(
                                      color: Palette.blue_accent,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                      fontSize: 30.0,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    light.toStringAsFixed(0) + '%',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 1,
                                      fontSize: 50.0,
                                    ),
                                  ),
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: Padding(
                                  padding: const EdgeInsets.only(top: 85.0),
                                  child: Image.asset(
                                    'assets/plant_shadow.png',
                                    height: 500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 24.0),
                          MoistureChart(
                            docs: retrievedDocs!,
                          ),
                          SizedBox(height: 24.0),
                          HumidityChart(
                            docs: retrievedDocs!,
                          ),
                          SizedBox(height: 24.0),
                          LightChart(
                            docs: retrievedDocs!,
                          ),
                          SizedBox(height: 24.0),
                        ],
                      ),
                    );
                  }

                  return Container();
                },
              ),
      ),
    );
  }
}
