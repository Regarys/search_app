import 'package:flutter/material.dart';
import 'package:tugas_pencarian/Connection/api_koneksi.dart';
import 'package:tugas_pencarian/Response/respon_data.dart';
import 'package:tugas_pencarian/ui/detail_page.dart';
import '../Model/model_makanan.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    super.key,
  });

  @override
  State<SearchPage> createState() => _SearchPageState();
}

final apiService = ApiService();

class _SearchPageState extends State<SearchPage> {
  List<ModelMakanan> allMakanan = [];
  List<ModelMakanan> searchResults = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      ResponseMakanan responseMakanan = await apiService.getapi();
      setState(() {
        allMakanan = responseMakanan.listMakanan;
        searchResults = List.from(allMakanan);
      });
    } catch (error) {
      debugPrint('Error fetching data: $error');
    }
  }

  // ...

  void updateList(String query) {
    setState(() {
      if (query.isEmpty) {
        searchResults = List.from(allMakanan);
      } else {
        List<String> keywords = query.toLowerCase().split(' ');

        searchResults = allMakanan.where((makanan) {
          return keywords.every(
                  (keyword) => makanan.nama!.toLowerCase().contains(keyword)) &&
              keywords.any(
                  (keyword) => makanan.nama!.toLowerCase().startsWith(keyword));
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF43766C),
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: const Color(0xFF43766C),
        actions: [
          IconButton(
              onPressed: () {
                fetchData();
              },
              icon: const Icon(
                Icons.refresh,
                color: Color(0xFFF8FAE5),
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Cari Makanan Mu!',
              style: TextStyle(
                  color: Color(0xFFF8FAE5),
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              enabled: true,
              onChanged: (query) {
                updateList(query);
              },
              style: const TextStyle(color: Color(0xFFF8FAE5)),
              decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFB19470),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'cth: Nasi Padang',
                  suffixIcon: const Icon(Icons.search),
                  suffixIconColor: const Color(0xFFF8FAE5)),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: FutureBuilder(
                  future: apiService.getapi(),
                  builder:
                      (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: searchResults.length,
                          itemBuilder: (context, index) => ListTile(
                                contentPadding: const EdgeInsets.all(8.0),
                                title: Text(
                                  searchResults[index].nama.toString(),
                                  style: const TextStyle(
                                      color: Color(0xFFF8FAE5),
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Text(
                                  '${searchResults[index].harga}',
                                  style: const TextStyle(color: Colors.white60),
                                ),
                                leading: SizedBox(
                                  height: 80,
                                  width: 80,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(
                                              0, 3), // Adjust the shadow offset
                                        ),
                                      ],
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: Image.network(
                                        searchResults[index].link.toString(),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => DetailPage(
                                        makanan: searchResults[index],
                                      ),
                                    ),
                                  );
                                },
                              ));
                    }
                    return Container();
                  }),
            )
          ],
        ),
      ),
    );
  }
}
