

import 'package:builder_customer/core/config/flavor_config.dart';
import 'package:builder_customer/feature/drawing/domain/entities/drawing_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class DrawingList extends StatelessWidget {
  const DrawingList({super.key,required this.data});

  final List<DrawingEntity> data;

  @override
  Widget build(BuildContext context) {
    return   GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: data.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 2 columns
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 1, // adjust for your layout
              ),
              itemBuilder: (context, index) {
                final l = data[index];

                return _buildGridItem(
                  context,
                  image: '${FlavorConfig.appConfig.imageUrl}/${l.drawingViewUrl}',
                  title: l.drawingName ??'',
                  onTap: () {
Map<String, dynamic> params = {
  "url":'${FlavorConfig.appConfig.imageUrl}/${l.drawingViewUrl}',
  "title":l.drawingName ??'',
};

GoRouter.of(context).push('/drawingDetail', extra: params);

                  },
                );
              },
            );
  }

   Widget _buildGridItem(
      BuildContext context, {
        required String image,
        required String title,
        required VoidCallback onTap,
      }) {
        
    final bool isPdf = image.toLowerCase().endsWith('.pdf');
    final bool isDoc = image.toLowerCase().endsWith('.doc') || image.toLowerCase().endsWith('.docx');

    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Container(
                width: MediaQuery.sizeOf(context).width,
                height: 100,
                color: Colors.grey.shade200,
                child: isPdf
                  ? const Icon(Icons.picture_as_pdf, size: 50, color: Colors.red)
                  : isDoc
                    ? const Icon(Icons.description, size: 50, color: Colors.blue)
                    : Image.network(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          debugPrint('Image load failed: $error');
                          return const Icon(Icons.broken_image, size: 40, color: Colors.grey);
                        },
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
              ),
            ),
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}