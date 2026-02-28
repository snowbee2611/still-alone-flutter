import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'dart:io';
import 'package:saver_gallery/saver_gallery.dart';

import '../services/mood_engine.dart';

class ResultScreen extends StatefulWidget {
  final String choice;

  const ResultScreen({super.key, required this.choice});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  late String _quote;
  final GlobalKey _cardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _quote = MoodEngine.getQuote(widget.choice);
  }

  Future<void> _sharePostcard() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final boundary =
      _cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 3);
      final byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return;

      final pngBytes = byteData.buffer.asUint8List();

      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/still_alone_postcard.png');
      await file.writeAsBytes(pngBytes);

      await Share.shareXFiles([XFile(file.path)]);
    } catch (e) {
      debugPrint("Share error: $e");
    }
  }

  Future<void> _downloadPostcard() async {
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final boundary =
      _cardKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 3);
      final byteData =
      await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return;

      final pngBytes = byteData.buffer.asUint8List();

      final result = await SaverGallery.saveImage(
        pngBytes,
        quality: 100,
        name: "still_alone_${DateTime.now().millisecondsSinceEpoch}.png",
        androidRelativePath: "Pictures/StillAlone",
        androidExistNotSave: false,
      );
      if (result.isSuccess && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Postcard saved to Gallery 💜"),
          ),
        );
      }
    } catch (e) {
      debugPrint("Download error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDE7F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFEDE7F6),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Still alone?",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
        children: [

          // Top Answer Bar
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.deepPurple,
            child: Text(
              "You answered: ${widget.choice}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Postcard
          Center(
            child: RepaintBoundary(
              key: _cardKey,
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFF3E8FF), // soft lavender
                      Color(0xFFEDE7F6), // light purple
                      Color(0xFFD1C4E9), // slightly deeper lilac
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.mail_outline,
                        color: Colors.deepPurple, size: 28),
                    const SizedBox(height: 12),
                    Text(
                      "Still alone?",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    const SizedBox(height: 18),

                    Text(
                      "Answer: ${widget.choice}",
                      style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 22),

                    Text(
                      _quote,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 1.6,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Text(
                      "@stillalone.app",
                      style: TextStyle(
                        color: Colors.deepPurple.shade700,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Buttons Section
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              children: [

                // Share + Download row
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _sharePostcard,
                        icon: const Icon(Icons.share),
                        label: const Text("Share"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _downloadPostcard,
                        icon: const Icon(Icons.download),
                        label: const Text("Download"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.deepPurple,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Home button full width
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.home),
                    label: const Text("Home"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
        ),
      );
  }
}