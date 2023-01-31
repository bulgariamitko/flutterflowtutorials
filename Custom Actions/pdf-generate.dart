// code created by https://www.youtube.com/@flutterflowexpert
// video - https://www.youtube.com/watch?v=9HngDsCIJPY

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

Future pdfInvoiceDownload(
  String? title,
  String? body,
) async {
  // null safety
  title = title ?? '';
  body = body ?? '';

  final pdf = pw.Document();

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

  await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save());
}