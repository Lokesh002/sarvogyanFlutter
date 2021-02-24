import 'package:native_pdf_view/native_pdf_view.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:developer';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:sarvogyan/components/sizeConfig.dart';

class PDFViewer extends StatefulWidget {
  Uint8List data;
  String name;
  PDFViewer(this.data, this.name);
  @override
  _PDFViewerState createState() => _PDFViewerState();
}

class _PDFViewerState extends State<PDFViewer> {
  int _actualPageNumber = 1, _allPagesCount = 0;
  bool isSampleDoc = true;
  PdfController _pdfController;

  @override
  void initState() {
    _pdfController = PdfController(
      document: PdfDocument.openData(widget.data),
    );
    super.initState();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  SizeConfig screenSize;
  @override
  Widget build(BuildContext context) {
    screenSize = SizeConfig(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.name,
          style: TextStyle(
              fontSize: widget.name.length > 30
                  ? screenSize.screenHeight * 2
                  : screenSize.screenHeight * 2.5),
        ),
      ),
      body: PdfView(
        documentLoader: Center(child: CircularProgressIndicator()),
        pageLoader: Center(child: CircularProgressIndicator()),
        controller: _pdfController,
        onDocumentLoaded: (document) {
          setState(() {
            _actualPageNumber = 1;
            _allPagesCount = document.pagesCount;
          });
        },
        onPageChanged: (page) {
          setState(() {
            _actualPageNumber = page;
          });
        },
      ),
    );
  }
}
