import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class DrawingDetailPage extends StatefulWidget {
  const DrawingDetailPage({super.key, required this.url, required this.title});
  final String url, title;
  
  @override
  State<DrawingDetailPage> createState() => _DrawingDetailPageState();
}

class _DrawingDetailPageState extends State<DrawingDetailPage> with SingleTickerProviderStateMixin {
  late TransformationController _transformationController;
  late AnimationController _animationController;
  Animation<Matrix4>? _animation;

  @override
  void initState() {
    super.initState();
    _transformationController = TransformationController();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    )..addListener(() {
        if (_animation != null) {
          _transformationController.value = _animation!.value;
        }
      });
  }

  @override
  void dispose() {
    _transformationController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _handleDoubleTapDown(TapDownDetails details) {
    if (_transformationController.value != Matrix4.identity()) {
      // Zoom out
      _animation = Matrix4Tween(
        begin: _transformationController.value,
        end: Matrix4.identity(),
      ).animate(CurveTween(curve: Curves.easeOut).animate(_animationController));
    } else {
      // Zoom in
      final position = details.localPosition;
      final x = -position.dx;
      final y = -position.dy;
      final zoomed = Matrix4.identity()
        ..translate(x, y)
        ..scale(2.0);
        
      _animation = Matrix4Tween(
        begin: _transformationController.value,
        end: zoomed,
      ).animate(CurveTween(curve: Curves.easeOut).animate(_animationController));
    }
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final bool isPdf = widget.url.toLowerCase().endsWith('.pdf');
    final String encodedUrl = Uri.encodeFull(widget.url);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: isPdf
          ? SfPdfViewer.network(
              encodedUrl,
              canShowScrollHead: false,
              canShowScrollStatus: false,
            )
          : GestureDetector(
              onDoubleTapDown: _handleDoubleTapDown,
              child: Center(
                child: InteractiveViewer(
                  transformationController: _transformationController,
                  panEnabled: true,
                  minScale: 0.5,
                  maxScale: 4.0,
                  child: Image.network(
                    encodedUrl,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.broken_image, size: 100, color: Colors.grey),
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ),
            ),
    );
  }
}