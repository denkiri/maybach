import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/upload_response.dart';
import '../../viewmodel/submit_views_view_model.dart';

class SubmitViewPage extends StatefulWidget {
  const SubmitViewPage({super.key});

  @override
  _SubmitViewPageState createState() => _SubmitViewPageState();
}

class _SubmitViewPageState extends State<SubmitViewPage> {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController viewsController = TextEditingController();
  Uint8List? _selectedFileBytes;
  String? _selectedFileName;

  Future<void> pickFile() async {
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error selecting file: ${e.toString()}")),
      );
    }
  }

  Future<void> _submitViews() async {
    if (_selectedFileBytes == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image first")),
      );
      return;
    }

    final phoneNumber = phoneController.text.trim();
    final viewsText = viewsController.text.trim();

    if (phoneNumber.isEmpty || viewsText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    final numberOfViews = int.tryParse(viewsText);
    if (numberOfViews == null || numberOfViews < 10 || numberOfViews > 400) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Views must be between 10 and 400")),
      );
      return;
    }

    final viewModel = Provider.of<SubmitViewsViewModel>(context, listen: false);
    try {
      await viewModel.submitViews(
        fileBytes: _selectedFileBytes!,
        fileName: _selectedFileName!,
        phoneNumber: phoneNumber,
        numberOfViews: numberOfViews,
      );

      // Clear form after successful submission
      setState(() {
        _selectedFileBytes = null;
        _selectedFileName = null;
      });
      phoneController.clear();
      viewsController.clear();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(viewModel.errorMessage ?? "An error occurred")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Colors.green, Colors.teal],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "SUBMIT WHATSAPP VIEWS",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: phoneController,
                          label: "PHONE NUMBER",
                          hint: "Enter phone number",
                          keyboardType: TextInputType.phone,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildTextField(
                          controller: viewsController,
                          label: "NUMBER OF VIEWS (MIN 10 - MAX 400)",
                          hint: "Enter views",
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFilePicker(),
                      ),
                      const SizedBox(width: 8),
                      _buildSubmitButton(),
                    ],
                  ),
                  if (_selectedFileName != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      "Selected file: $_selectedFileName",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildNoRecordsText(),
            Consumer<SubmitViewsViewModel>(
              builder: (context, viewModel, child) {
                if (viewModel.submitResponse != null) {
                  // Schedule auto-dismiss after 3 seconds
                  Future.delayed(const Duration(seconds: 3), () {
                    if (mounted) {
                      viewModel.clearResponse();
                    }
                  });
                  return _buildResponseMessage(viewModel.submitResponse!);
                }
                return const SizedBox.shrink();
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResponseMessage(SubmitViewsResponse response) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: 1.0,
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Success!",
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        response.details,
                        style: const TextStyle(color: Colors.black87),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          style: const TextStyle(color: Colors.white),
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.white.withOpacity(0.2),
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white70),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilePicker() {
    return GestureDetector(
      onTap: pickFile,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                _selectedFileName ?? "Choose File",
                style: const TextStyle(color: Colors.white, fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.file_upload, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Consumer<SubmitViewsViewModel>(
      builder: (context, viewModel, child) {
        return ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: viewModel.isLoading ? null : _submitViews,
          child: viewModel.isLoading
              ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : const Text(
            "Submit Views",
            style: TextStyle(color: Colors.white),
          ),
        );
      },
    );
  }

  Widget _buildNoRecordsText() {
    return Container(
      padding: const EdgeInsets.all(16),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Text(
          "There are no records to display",
          style: TextStyle(color: Colors.black54),
        ),
      ),
    );
  }
}