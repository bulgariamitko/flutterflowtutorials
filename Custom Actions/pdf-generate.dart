// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=9HngDsCIJPY
// video 2 include images - https://youtu.be/YcHR_bMSIPw
// video 3 save custom pdf to firebase storage - https://youtu.be/y5GfG-eX1QM
// if you have problem implementing this code you can hire me as a mentor - https://calendly.com/bulgaria_mitko

import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../auth/auth_util.dart';
import '../../backend/firebase_storage/storage.dart';

Future pdfInvoiceDownload(
  BuildContext context,
  String? title,
  String? body,
) async {
  // null safety
  title = title ?? '';
  body = body ?? '';

  final pdf = pw.Document();

  // add network image
  final netImage = await networkImage('https://www.nfet.net/nfet.jpg');

  // add asset image, IMPORTANT! Using assets will not work in Test/Run mode you can only test it using Web Publishing mode or using an actual device!
  final bytes =
      (await rootBundle.load('assets/images/demo.png')).buffer.asUint8List();
  final image = pw.MemoryImage(bytes);

  pdf.addPage(pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(children: [
          pw.Text(title ?? '',
              style: const pw.TextStyle(
                color: PdfColors.cyan,
                fontSize: 40,
              )),
          pw.Divider(thickness: 4),
          pw.Text("Hello World"),
          pw.SizedBox(height: 10),
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.SizedBox(width: 10),
              pw.Text(body ?? ''),
            ],
          ),
          pw.Container(
            decoration: pw.BoxDecoration(
              borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
            ),
            padding: const pw.EdgeInsets.only(
                left: 40, top: 10, bottom: 10, right: 20),
            alignment: pw.Alignment.centerLeft,
            height: 50,
            child: pw.DefaultTextStyle(
              style: pw.TextStyle(
                fontSize: 12,
              ),
              child: pw.GridView(
                crossAxisCount: 2,
                children: [
                  pw.Text('Invoice #'),
                  pw.Text('Invoice #'),
                  pw.Text('Date:'),
                  pw.Text('Invoice #'),
                  pw.Text('Hello World'),
                  pw.Image(netImage),
                  pw.Image(image),
                ],
              ),
            ),
          ),
          pw.Container(
            width: 100,
            height: 100,
            child: pw.Text('Hello World', style: pw.TextStyle(fontSize: 35)),
          ),
        ]);
      }));

  final pdfSaved = await pdf.save();

   // Get the current date and time
  final now = DateTime.now();

// Format the date and time as a string
  final formattedDateTime =
      '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}_${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}-${now.second.toString().padLeft(2, '0')}';

// Set the file name to the formatted date and time string
  final fileName = '$formattedDateTime.pdf';

// Set the directory where you want to store the file (e.g., a folder named 'pdfs' in your storage)
  String directoryPath = '/users/' + currentUserUid + '/pdfs';

// Combine the directory path and file name to create the full storage path
  final storagePath = '$directoryPath/$fileName';

  // SAVE IT TO FIREBASE STORE
  final downloadUrl = await uploadData(storagePath, pdfSaved);
  // FFAppState().name = downloadUrl ?? '';

  // PRINT IT
  await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdfSaved);
}