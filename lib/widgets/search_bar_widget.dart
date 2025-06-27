// search_bar_widget.dart
import 'package:flutter/material.dart';
import 'package:shop_online/core/core.dart'; // Assurez-vous que ce chemin est correct
import 'package:redacted/redacted.dart';

class CustomSearchBar extends StatefulWidget {
  final bool isLoading;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;


  const CustomSearchBar({
    super.key,
    required this.isLoading,
    required this.controller,
    required this.onChanged,
  });

  @override
  State<CustomSearchBar> createState() => _CustomSearchBarState();
}

class _CustomSearchBarState extends State<CustomSearchBar> {
  bool _hasText = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_updateHasText);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_updateHasText);
    super.dispose();
  }

  void _updateHasText() {
    setState(() {
      _hasText = widget.controller.text.isNotEmpty;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ).redacted(
                  context: context,
                  redact: true,
                  configuration: RedactedConfiguration(
                    animationDuration: const Duration(milliseconds: 800),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Icon(Icons.search, color: Colors.grey[400]),
            ],
          ),
        ),
      );
    } else {
      return Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).colorScheme.onSecondary,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  onChanged: widget.onChanged,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Rechercher ...",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.onTertiary,
                    ),
                  ),
                ),
              ),
              if (_hasText) // Afficher l'icône de suppression seulement s'il y a du texte
                IconButton(
                  icon: const Icon(Icons.clear),
                  color: Theme.of(context).colorScheme.primary,
                  onPressed: () {
                    widget.controller.clear();
                    widget.onChanged(''); // Notifier le changement avec une chaîne vide
                    setState(() {
                      _hasText = false;
                    });
                  },
                ),
               Icon(Icons.search, color: Theme.of(context).colorScheme.onTertiary),
            ],
          ),
        ),
      );
    }
  }
}