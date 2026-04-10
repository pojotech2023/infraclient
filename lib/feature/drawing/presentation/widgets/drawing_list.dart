

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
    return InkWell(
      onTap: onTap,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child:      Container(
                width: MediaQuery.sizeOf(context).width,
                height: 100,
                margin: EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(image),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      debugPrint('Image load failed: $exception');
                    },
                  ),borderRadius:BorderRadius.circular(8),
              
                ),
              ),
            ),
          
            Center(
              child: Text(
                title,
                textAlign: TextAlign.center,
          
              ),
            ),
      

          ],
        ),
      ),
    );

  }
}