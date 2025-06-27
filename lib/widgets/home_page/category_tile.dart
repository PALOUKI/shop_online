import 'package:flutter/material.dart';
import 'package:shop_online/core/core.dart';
import 'package:redacted/redacted.dart';
import '../../models/Category.dart';

class CategoryTile extends StatelessWidget {
  final List<Category> categories; // La liste des catégories (même si vide en mode redacted)
  final int index; // L'index de la catégorie à afficher
  final List<Color> colors = [Colors.deepPurpleAccent, Colors.green, Colors.orange, Colors.blue];
  final bool isRedacted; // Un indicateur pour afficher la version "redacted"

  CategoryTile({
    super.key,
    required this.categories,
    required this.index,
    this.isRedacted = false, // Par défaut, n'est pas en mode "redacted"
  });

  @override
  Widget build(BuildContext context) {
    AppConfigSize.init(context);

    // Si isRedacted est true, on affiche une version placeholder
    if (isRedacted) {
      return Container(
        width: 200,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: Colors.grey[300], // Couleur de fond du placeholder
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder pour l'image
            Container(
              height: 150,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
              ),
            ).redacted(context: context, redact: true), // Applique l'effet redacted
            // Placeholder pour le nom
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Container(
                width: 120,
                height: 20,
                color: Colors.grey[400],
              ).redacted(context: context, redact: true), // Applique l'effet redacted
            ),
            // Placeholder pour la description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Container(
                width: double.infinity,
                height: 16,
                color: Colors.grey[400],
              ).redacted(context: context, redact: true), // Applique l'effet redacted
            ),
          ],
        ),
      );
    }
    // Si isRedacted est false, on affiche la tuile de catégorie normale
    else {
      return Container(
        width: 200,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: colors[index % colors.length],
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image de la catégorie (chargée depuis le réseau)
            Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                child: Image.network(
                  categories[index].imagePath,
                  fit: BoxFit.cover,
                  height: 150,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 150,
                      color: Colors.grey[300],
                      child: const Icon(Icons.error_outline, color: Colors.grey),
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
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
              child: Text(
                categories[index].name,
                style: AppTextStyles.headline3.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[100],
                ),
              ),
            ),
            // Description de la catégorie
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                categories[index].description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      );
    }
  }
}