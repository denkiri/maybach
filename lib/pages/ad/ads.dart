import 'dart:html' as html;
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../viewmodel/ad_viewmodel.dart';
class AdsPage extends StatefulWidget {
  const AdsPage({super.key});
  @override
  State<AdsPage> createState() => _AdsPageState();
}
class _AdsPageState extends State<AdsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<AdViewModel>(context, listen: false).loadAds());
  }


  Future<void> downloadImage(String url, String fileName) async {
    try {
      Dio dio = Dio();
      var response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      // Convert bytes to Blob and trigger download
      final blob = html.Blob([response.data]);
      final urlObject = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: urlObject)
        ..setAttribute("download", fileName)
        ..click();

      html.Url.revokeObjectUrl(urlObject);
    } catch (e) {
      print("Download error: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    final adViewModel = Provider.of<AdViewModel>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.cyan,

            borderRadius: BorderRadius.circular(8.0),
          ),
          child: const Center(
            child: Text(
              "Advertisements",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
      body: adViewModel.isLoading
          ? const Center(child: CircularProgressIndicator())
          : adViewModel.ads.isEmpty
          ? const Center(child: Text("No ads available"))
          : Padding(
        padding: const EdgeInsets.all(16.0),
child: ListView.builder(
  itemCount: adViewModel.ads.length,
  itemBuilder: (context, index) {
    final ad = adViewModel.ads[index];
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CachedNetworkImage(
            imageUrl: ad.file.fileUrl,
            placeholder: (context, url) =>
                const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) =>
                const Icon(Icons.error),
            fit: BoxFit.cover,
            width: double.infinity,
            height: 200, // Constrain height for better mobile experience
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => downloadImage(ad.file.fileUrl, ad.file.name),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Text("Download", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  },
),
      ),
    );
  }
}








