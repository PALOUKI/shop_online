import 'package:flutter/material.dart';
import 'package:shop_online/core/appStyles.dart';
import 'package:shop_online/widgets/profile_page/edit_profile.dart';
import 'package:provider/provider.dart';
import '../../../core/appConfigSize.dart';
import '../../../providers/auth_provider.dart';
import '../../../widgets/notificationHelper.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _initControllers(context);
    // Charger les commandes au démarrage
    WidgetsBinding.instance.addPostFrameCallback((_) {

    });
  }

  void _initControllers(BuildContext context) {
    final user = context.read<AuthProvider>().currentUser;
    _fullNameController = TextEditingController(text: user?.fullName ?? '');
    _phoneController = TextEditingController(text: user?.phoneNumber ?? '');
    _addressController = TextEditingController(text: user?.address ?? '');
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await context.read<AuthProvider>().updateProfile(
        fullName: _fullNameController.text,
        phoneNumber: _phoneController.text,
        address: _addressController.text,
      );

      if (mounted) {
        if (success) {
          setState(() => _isEditing = false);
          // Utilisation du widget de notification réutilisable
          NotificationHelper.showSuccess(
              context,
              "Modifier le profil",
              "les informations du profil sont modifiés avec sucès"
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profil mis à jour avec succès')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Erreur lors de la mise à jour du profil'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }



  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        final _user = authProvider.currentUser!;

        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Column(
              children: [
                Expanded(
                  flex: 1,
                    child: Row(
                      children: [
                        SizedBox(width: getWidth(15),),
                          Container(
                            height: getHeight(40),
                            width: getWidth(40),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.onSecondary,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(2, 2),
                                ),
                              ],
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: Icon(
                                Icons.arrow_back_ios_new_outlined,
                                size: 20,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        SizedBox(width: getWidth(50),),
                        Text(
                          "Modifier le profil",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    )
                ),


                Expanded(
                  flex: 5,
                    child: Column(
                  children: [
                    SizedBox(height: getSize(80),),
                      Padding(
                        padding: EdgeInsets.only(left: getWidth(15)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text(
                                "Complèter/Modifier",
                              style: AppTextStyles.subtitle1.copyWith(
                                color: Theme.of(context).colorScheme.tertiary,
                                fontWeight: FontWeight.bold
                              )
                            ),
                            _isEditing
                            ?
                                IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: (){
                                    setState(() {
                                      _isEditing = false;
                                    });
                                },
                              )
                                :
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: _toggleEdit,
                            )

                          ],
                        ),
                      ),

                    EditProfile(
                      isEditing: _isEditing,
                      saveProfile: _saveProfile,
                      fullNameController: _fullNameController,
                      phoneController: _phoneController,
                      addressController: _addressController,
                      user: _user,
                      formKey: _formKey,
                    ),
                  ],
                ))

              ],
            ),
        );
      },
    );
  }
}