import 'package:flutter/material.dart';

class SoldProduct extends StatefulWidget {
  const SoldProduct({super.key});

  @override
  State<SoldProduct> createState() => _SoldProductState();
}

class _SoldProductState extends State<SoldProduct> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(height: 20),
            Text(
              'Aucun produit vendu pour le moment car aucune livraison',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.onSurface,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              'Fonctionnalité à venir',
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.onSurface,
                fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.center,
            ),

          ],
        ),
      ),
    );
  }
}
