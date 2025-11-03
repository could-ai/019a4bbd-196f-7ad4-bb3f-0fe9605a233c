import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Estimate Comparison Tool',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.grey[100],
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[800],
          foregroundColor: Colors.white,
          elevation: 4,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      home: const ComparisonPage(),
    );
  }
}

class ComparisonPage extends StatefulWidget {
  const ComparisonPage({super.key});

  @override
  State<ComparisonPage> createState() => _ComparisonPageState();
}

class _ComparisonPageState extends State<ComparisonPage> {
  String? _excelFileName;
  String? _pdfFileName;

  Future<void> _pickFile(Function(String) onFilePicked, List<String> allowedExtensions) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: allowedExtensions,
      );

      if (result != null) {
        setState(() {
          onFilePicked(result.files.single.name);
        });
      }
    } catch (e) {
      // Handle potential errors, e.g., platform exceptions
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error picking file: $e")),
      );
    }
  }

  void _runComparison() {
    if (_excelFileName != null && _pdfFileName != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Comparison Ready'),
          content: Text(
              'Comparing "$_excelFileName" and "$_pdfFileName".\n\n(This is a placeholder. The actual comparison logic and report generation will be implemented in the next phase.)'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Files Missing'),
          content: const Text('Please upload both an Excel estimate and a PDF plan to continue.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estimate vs. Plans Comparison Tool'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  const Text(
                    'Upload Your Documents',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Upload an estimate spreadsheet and the marked-up plans to generate a discrepancy report.',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  _buildFileUploadWidget(
                    title: '1. Upload Estimate Spreadsheet',
                    fileType: 'Excel (.xlsx, .xls)',
                    fileName: _excelFileName,
                    onPressed: () => _pickFile((name) => _excelFileName = name, ['xlsx', 'xls']),
                    icon: Icons.table_chart_outlined,
                  ),
                  const SizedBox(height: 24),
                  _buildFileUploadWidget(
                    title: '2. Upload Marked-Up Plans',
                    fileType: 'PDF (.pdf)',
                    fileName: _pdfFileName,
                    onPressed: () => _pickFile((name) => _pdfFileName = name, ['pdf']),
                    icon: Icons.picture_as_pdf_outlined,
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton.icon(
                    onPressed: _runComparison,
                    icon: const Icon(Icons.compare_arrows, size: 24),
                    label: const Text('Run Comparison'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueGrey[700],
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFileUploadWidget({
    required String title,
    required String fileType,
    required String? fileName,
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(icon, size: 48, color: Theme.of(context).primaryColor),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(fileType, style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: onPressed,
              icon: const Icon(Icons.upload_file),
              label: const Text('Select File'),
            ),
            const SizedBox(height: 16),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              height: fileName != null ? 24 : 0,
              child: fileName != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            fileName,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
