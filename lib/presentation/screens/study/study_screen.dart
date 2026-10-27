import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/pdf_file.dart';
import '../../../data/services/hive_service.dart';
import '../../providers/app_provider.dart';
import '../../widgets/glass_card.dart';

class StudyScreen extends StatefulWidget {
  const StudyScreen({super.key});

  @override
  State<StudyScreen> createState() => _StudyScreenState();
}

class _StudyScreenState extends State<StudyScreen> {
  List<PdfFile> _pdfs = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    setState(() {
      _pdfs = HiveService.pdfsBox.values.toList()
        ..sort((a, b) => b.addedAt.compareTo(a.addedAt));
    });
  }

  Future<void> _pickPdf() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );
    if (result != null && result.files.single.path != null) {
      final file = result.files.single;
      final pdf = PdfFile(
        name: file.name,
        path: file.path!,
      );
      await HiveService.pdfsBox.put(pdf.id, pdf);
      _load();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isAr = context.watch<AppProvider>().isArabic;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: Row(
                children: [
                  Text(
                    isAr ? 'المذاكرة والمكتبة' : 'Study & Library',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: _pickPdf,
                    icon: const Icon(Icons.upload_file_rounded, color: AppColors.primary),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _pdfs.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.picture_as_pdf_outlined, size: 64, color: AppColors.primary.withOpacity(0.4)),
                          const SizedBox(height: 16),
                          Text(isAr ? 'لا توجد ملفات بعد' : 'No PDFs yet'),
                          const SizedBox(height: 12),
                          ElevatedButton.icon(
                            onPressed: _pickPdf,
                            icon: const Icon(Icons.add),
                            label: Text(isAr ? 'رفع PDF' : 'Upload PDF'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async => _load(),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                        itemCount: _pdfs.length,
                        itemBuilder: (context, index) {
                          final pdf = _pdfs[index];
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: GlassCard(
                              onTap: () {
                                // Navigate to PDF viewer (simplified)
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('فتح: ${pdf.name}')),
                                );
                              },
                              child: Row(
                                children: [
                                  Container(
                                    width: 48,
                                    height: 48,
                                    decoration: BoxDecoration(
                                      color: AppColors.primarySoft,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(Icons.picture_as_pdf, color: AppColors.primary),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pdf.name,
                                          style: const TextStyle(fontWeight: FontWeight.w600),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '${pdf.addedAt.day}/${pdf.addedAt.month}/${pdf.addedAt.year}',
                                          style: const TextStyle(fontSize: 12, color: AppColors.textSecondaryLight),
                                        ),
                                      ],
                                    ),
                                  ),
                                  PopupMenuButton<String>(
                                    onSelected: (v) async {
                                      if (v == 'delete') {
                                        final ok = await showDialog<bool>(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            title: const Text('تأكيد الحذف'),
                                            content: const Text('هل تريد حذف هذا الملف؟'),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('لا')),
                                              TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('نعم')),
                                            ],
                                          ),
                                        );
                                        if (ok == true) {
                                          await HiveService.pdfsBox.delete(pdf.id);
                                          _load();
                                        }
                                      }
                                    },
                                    itemBuilder: (_) => [
                                      const PopupMenuItem(value: 'ocr', child: Text('OCR Scan')),
                                      const PopupMenuItem(value: 'exam', child: Text('Generate Exam')),
                                      const PopupMenuItem(value: 'delete', child: Text('حذف')),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
