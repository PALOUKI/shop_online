import 'package:flutter/material.dart';
import 'package:shop_online/models/user_model.dart';

class EditProfile extends StatefulWidget {
  final bool isEditing;
  final void Function() saveProfile;
  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController addressController;
  final UserModel user;
  final GlobalKey<FormState> formKey;

  const EditProfile({
    super.key,
    required this.isEditing,
    required this.saveProfile,
    required this.fullNameController,
    required this.phoneController,
    required this.addressController,
    required this.user,
    required this.formKey,
  });

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.isEditing)
            Form(
              key: widget.formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: widget.fullNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nom complet',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value?.isEmpty ?? true) {
                        return 'Veuillez entrer votre nom';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: widget.phoneController,
                    decoration: const InputDecoration(
                      labelText: 'Téléphone',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: widget.addressController,
                    decoration: const InputDecoration(
                      labelText: 'Adresse',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: widget.saveProfile,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text('Sauvegarder'),
                  ),
                ],
              ),
            )
          else
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.onSecondary,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Informations',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Divider(),
                    if (widget.user.fullName?.isNotEmpty ?? false) ...[
                      const Text(
                        'Nom',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(widget.user.fullName!),
                      const SizedBox(height: 16),
                    ],
                    if (widget.user.email?.isNotEmpty ?? false) ...[
                      const Text(
                        'Email',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(widget.user.email!),
                      const SizedBox(height: 16),
                    ],
                    if (widget.user.phoneNumber?.isNotEmpty ?? false) ...[
                      const Text(
                        'Téléphone',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(widget.user.phoneNumber!),
                      const SizedBox(height: 16),
                    ],
                    if (widget.user.address?.isNotEmpty ?? false) ...[
                      const Text(
                        'Adresse',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(widget.user.address!),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}