import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(const HavaDurumuApp());
}

class HavaDurumuApp extends StatelessWidget {
  const HavaDurumuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HAVA DURUMU',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const HOMEPAGE(),
    );
  }
}

class HOMEPAGE extends StatefulWidget {
  const HOMEPAGE({super.key});

  @override
  State<HOMEPAGE> createState() => _HOMEPAGEState();
}

class _HOMEPAGEState extends State<HOMEPAGE> {
   List<String> sehirler = [
    'Adana',
'Adıyaman',
'Afyonkarahisar',
'Ağrı',
'Amasya',
'Ankara',
'Antalya',
'Artvin',
'Aydın',
'Balıkesir',
'Bilecik',
'Bingöl',
'Bitlis',
'Bolu',
'Burdur',
'Bursa',
'Çanakkale',
'Çankırı',
'Çorum',
'Denizli',
'Diyarbakır',
'Edirne',
'Elazığ',
'Erzincan',
'Erzurum',
'Eskişehir',
'Gaziantep',
'Giresun',
'Gümüşhane',
'Hakkâri',
'Hatay',
'Isparta',
'Mersin',
'İstanbul',
'İzmir',
'Kars',
'Kastamonu',
'Kayseri',
'Kırklareli',
'Kırşehir',
'Kocaeli',
'Konya',
'Kütahya',
'Malatya',
'Manisa',
'Kahramanmaraş',
'Mardin',
'Muğla',
'Muş',
'Nevşehir',
'Niğde',
'Ordu',
'Rize',
'Sakarya',
'Samsun',
'Siirt',
'Sinop',
'Sivas',
'Tekirdağ',
'Tokat',
'Trabzon',
'Tunceli',
'Şanlıurfa',
'Uşak',
'Van',
'Yozgat',
'Zonguldak',
'Aksaray',
'Bayburt',
'Karaman',
'Kırıkkale',
'Batman',
'Şırnak',
'Bartın',
'Ardahan',
'Iğdır',
'Yalova',
'Karabük',
'Kilis',
'Osmaniye',
'Düzce'
  ];

  String? SehirSec;
  Future<Map<String, dynamic>>? weatherFuture;

  final dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.openweathermap.org/data/2.5/',
      queryParameters: {
        'appid': '52880f51e41f9a5d8d8701a037d37bc7',
        'lang': 'tr',
        'units': 'metric',
      },
    ),
  );

  void secilenSehir(String sehir) {
    setState(() {
      SehirSec = sehir;
      weatherFuture = getWeather(sehir);
    });
  }

  Future<Map<String, dynamic>> getWeather(String sehir) async {
    final response = await dio.get('/weather', queryParameters: {'q': sehir});
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hava Durumu')),
      body: Column(
        children: [
          if (SehirSec != null)
            Expanded(
              child: FutureBuilder<Map<String, dynamic>>(
                future: weatherFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Hata: ${snapshot.error.toString()}'),
                    );
                  } else if (snapshot.hasData) {
                    final data = snapshot.data!;
                    final temp = data['main']['temp'];
                    final desc = data['weather'][0]['description'];
                    return Center(
                      child: Text(
                        '$SehirSec\n${temp.toString()}°C\n$desc',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  } else {
                    return const Center(child: Text('Veri bulunamadı'));
                  }
                },
              ),
            ),
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemCount: sehirler.length,
              padding: const EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => secilenSehir(sehirler[index]),
                  child: Card(
                    color: Colors.blue[100],
                    child: Center(
                      child: Text(
                        sehirler[index],
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
