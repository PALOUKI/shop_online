import 'package:flutter/material.dart';

import '../../core/core.dart';

class NewsSection extends StatefulWidget {
  const NewsSection({super.key});

  @override
  State<NewsSection> createState() => _NewsSectionState();
}

class _NewsSectionState extends State<NewsSection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height:  MediaQuery.of(context).orientation == Orientation.portrait ? getHeight(160) : getHeight(320),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          Container(
            width: MediaQuery.of(context).size.width/1.15,
            height: getHeight(150),
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.orange, // Conserver le fond rouge
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
              children: [
                // Image de l'article
                ClipRRect(
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                  child: Image.asset(
                    AssetsConstants.specialOffer,
                    fit: BoxFit.cover,
                    //width: 100,
                    height: double.infinity,

                  ),
                ),
                SizedBox(width: 10),
                // Détails de l'article
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Titre
                        Text(
                          "Offres spéciales",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white, // Contraste avec le fond rouge
                          ),
                        ),
                        SizedBox(height: 5),
                        // Description
                        Text(
                          "Tendance pour un look décontracté. Confortable et durable.",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w500
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width/1.15,
            height: 150,
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.red, // Conserver le fond rouge
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
              children: [
                // Image de l'article
                ClipRRect(
                  borderRadius: BorderRadius.horizontal(left: Radius.circular(10)),
                  child: Image.asset(
                    AssetsConstants.cloth1,
                    fit: BoxFit.cover,
                    width: getWidth(100),
                    height: double.infinity,
                  ),
                ),
                SizedBox(width: 10),
                // Détails de l'article
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Titre
                        Text(
                          "Nouveau T-Shirt",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.white, // Contraste avec le fond rouge
                          ),
                        ),
                        SizedBox(height: 5),
                        // Description
                        Text(
                          "T-shirt tendance pour un look décontracté. Confortable et durable.",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white.withOpacity(0.8),
                              fontWeight: FontWeight.w500
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

        ],
      ),
    );
  }
}
