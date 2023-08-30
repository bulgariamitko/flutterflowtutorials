// YouTube channel - https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=9HngDsCIJPY
// video 2 include images - https://youtube.com/watch?v=YcHR_bMSIPw
// video 3 save custom pdf to firebase storage - https://youtube.com/watch?v=y5GfG-eX1QM
// widgets - Cg9Db2x1bW5fN3Q4cWpyaHgSgAIKD0J1dHRvbl8xMXY5YmZjNBgJIo0BSnQKIAoIRG93bmxvYWQ6Bgj/////D0AFegoSCGR6em9xdGplGQAAAAAAAABAKQAAAAAAQGBAMQAAAAAAAERASQAAAAAAAPA/UgIQAVoCCAByJAkAAAAAAAAgQBEAAAAAAAAgQBkAAAAAAAAgQCEAAAAAAAAgQFoSEQAAAAAAADRAIQAAAAAAADRA+gMAYgCKAVgSUgoIeW1qamxqYjcSRtIBOAobChJwZGZJbnZvaWNlRG93bmxvYWQSBTR3bXg2EgwKChIITXkgdGl0bGUSCwoJEgdNeSBib2R5qgIIMTd6cWVsNW8aAggBEncKEkNvbnRhaW5lcl8yNGNiODhjaRgBIgP6AwBiSxI+CgpkaW1lbnNpb25zEjAKFAoKZGltZW5zaW9ucxIGY3VrcmltMhgiFgoJEQAAAAAAAFlAEgkJAAAAAAAAeUAaCUFzc2V0c0ltZ4IBCUFzc2V0c0ltZ5gBARJcChJQZGZWaWV3ZXJfeGtmM2cxdDQYOSJC8gM8CiVodHRwOi8vd3d3LnBkZjk5NS5jb20vc2FtcGxlcy9wZGYucGRmEAEaDQoAEgkJAAAAAADAckAgACgA+gMAYgAYBCIFIgD6AwA=
// Join the Klaturov army - https://www.youtube.com/@flutterflowexpert/join
// Support my work - https://github.com/sponsors/bulgariamitko
// Website - https://bulgariamitko.github.io/flutterflowtutorials/
// You can book me as FF mentor - https://calendly.com/bulgaria_mitko
// GitHub repo - https://github.com/bulgariamitko/flutterflowtutorials
// Discord channel - https://discord.gg/ERDVFBkJmY

import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:flutter/services.dart' show rootBundle;

import '../../auth/firebase_auth/auth_util.dart';
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

  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.a4,
      build: (pw.Context context) {
        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Invoice', style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Text('Invoice No.: 00123'),
            pw.Text('Date: 2023-03-14'),
            pw.SizedBox(height: 20),
            pw.Text('Bill To:', style: pw.TextStyle(fontSize: 18)),
            pw.Text('John Doe'),
            pw.Text('123 Main Street'),
            pw.Text('City, State 12345'),
            pw.SizedBox(height: 20),
            pw.Text('Items:', style: pw.TextStyle(fontSize: 18)),
            pw.Container(
              child: pw.Table.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                data: [
                  ['Item', 'Qty', 'Price', 'Total'],
                  ['Item 1', '1', '50', '50'],
                  ['Item 2', '2', '20', '40'],
                  ['Item 3', '3', '10', '30'],
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Subtotal:'),
                pw.Text('120'),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Tax (5%):'),
                pw.Text('6'),
              ],
            ),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total:'),
                pw.Text('126'),
                pw.Image(netImage),
                pw.Image(image),
              ],
            ),
          ],
        );
      },
    ),
  );

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