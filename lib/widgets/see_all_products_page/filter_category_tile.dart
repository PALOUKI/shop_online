import 'package:flutter/material.dart';
import 'package:shop_online/core/core.dart';
import '../../models/Category.dart';

class FilterCategoryTile extends StatelessWidget {
  final List<Category> categories;
  final int index; // Ajout de l'index pour gérer les couleurs dynamiques
  final List<Color> colors = [ Colors.deepPurpleAccent, Colors.green, Colors.orange, Colors.blue,];

  FilterCategoryTile({
    super.key,
    required this.categories,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    AppConfigSize.init(context);
    return Container(
      //width: getWidth(150),
      //height: getHeight(100),
      margin: EdgeInsets.symmetric(horizontal: getHeight(8), vertical: getHeight(10)),
      decoration: BoxDecoration(
        color: colors[index % colors.length],
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(

        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                categories[index].imagePath,
                fit: BoxFit.cover,
                height: 150,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 150,
                    color: Colors.grey[300],
                    child: Icon(Icons.error_outline, color: Colors.grey[500]),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Container(
                    height: 150,
                    color: Colors.grey[200],
                    child: Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                            : null,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          // Nom de la catégorie
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5,left: 3, right: 10),
            child: Text(
                categories[index].name,
                style: AppTextStyles.subtitle1.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[100]
                )
            ),
          ),

        ],
      ),
    );
  }
}
