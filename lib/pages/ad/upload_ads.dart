import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../viewmodel/ad_viewmodel.dart';
class UploadAdsPage extends StatefulWidget {
  const UploadAdsPage({super.key});

  @override
  State<UploadAdsPage> createState() => _UploadAdsPageState();
}

class _UploadAdsPageState extends State<UploadAdsPage> {
  Uint8List? _selectedFileBytes;
  String? _selectedFileName;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdViewModel>(context, listen: false).loadAds();
    });
  }

  Future<void> _pickFile() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          _selectedFileBytes = file.bytes;
          _selectedFileName = file.name;
        });
      }
    } catch (e) {
      _showError("Error selecting file: ${e.toString()}");
    }
  }

  Future<void> _uploadAd() async {
    if (_selectedFileBytes == null) {
      _showError("Please select an image first");
      return;
    }

    final viewModel = Provider.of<AdViewModel>(context, listen: false);
    try {
      await viewModel.uploadAndPostAd(
        _selectedFileBytes!,
        _selectedFileName!,
      );

      // Clear selection after successful upload
      setState(() {
        _selectedFileBytes = null;
        _selectedFileName = null;
      });
    } catch (e) {
      _showError(viewModel.errorMessage ?? "An error occurred");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor:Colors.cyan,
        title: const Text('Ads',style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => Provider.of<AdViewModel>(context, listen: false).loadAds(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Upload Section
            Card(
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Upload New Ad',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _pickFile,
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: BorderSide(
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.upload_file),
                                const SizedBox(width: 8),
                                Text(
                                  _selectedFileName ?? 'Select Image',
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Consumer<AdViewModel>(
                          builder: (context, viewModel, child) {
                            return ElevatedButton(
                              onPressed: viewModel.isLoading ? null : _uploadAd,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                  horizontal: 24,
                                ),
                                backgroundColor: Colors.green
                              ),

                              child: viewModel.isLoading
                                  ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Text('Upload',style: TextStyle(color: Colors.white),),
                            );
                          },
                        ),
                      ],
                    ),
                    if (_selectedFileName != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        'Selected: $_selectedFileName',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Ads List Section
            const Text(
              'Current Ads',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Consumer<AdViewModel>(
                builder: (context, viewModel, child) {
                  if (viewModel.isLoading && viewModel.ads.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (viewModel.errorMessage != null) {
                    return Center(
                      child: Text(
                        viewModel.errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    );
                  }

                  if (viewModel.ads.isEmpty) {
                    return const Center(
                      child: Text('No ads available'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () => viewModel.loadAds(),
                    child: GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: 0.8,
                      ),
                      itemCount: viewModel.ads.length,
                      itemBuilder: (context, index) {
                        final ad = viewModel.ads[index];
                        return Card(
                          elevation: 2,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(8)),
                                  child: Image.network(
                                    ad.file.fileUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Center(
                                        child: Icon(Icons.broken_image),
                                      );
                                    },
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Text(
                                    //   'Ad #${ad.id}',
                                    //   style: const TextStyle(
                                    //     fontWeight: FontWeight.bold,
                                    //   ),
                                    // ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Uploaded: ${ad.dateCreated}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey[600],
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
