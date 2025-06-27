import 'package:flutter/material.dart';
import 'package:shop_online/core/appConfigSize.dart';
import 'package:shop_online/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import '../../core/routes/routes_names.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  bool _isEditing = false;




  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, child) {
        if (!auth.isAuthenticated) {
          return const LoginPage();
        }

        final user = auth.currentUser!;
        var firstLetter = (user.fullName?.isNotEmpty ?? false)
            ? user.fullName!.substring(0, 1).toUpperCase()
            : '';


        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding:  EdgeInsets.all(getSize(20)),
                  decoration: BoxDecoration(
                    color: Colors.deepPurpleAccent,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        children: [
                          SizedBox(height: getHeight(45)),
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            child: Text(
                              firstLetter,
                              style: TextStyle(
                                fontSize: 40,
                                color: Theme.of(context).colorScheme.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (!_isEditing) ...[
                        Text(
                          user.fullName,
                          style:  TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),


                //Theme preferences
                SizedBox(height: getHeight(15),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Preferences",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: (){
                    final themeProvider = context.read<ThemeProvider>();
                    themeProvider.toggleTheme();
                  },
                  child: Container(
                      margin: EdgeInsets.symmetric(horizontal: getWidth(14), vertical: getHeight(3)),
                      height: getHeight(60),
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onSecondary,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                              offset: Offset(0, 2),
                            ),
                          ]
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.dark_mode_outlined),
                              SizedBox(width: getWidth(10),),
                              Text(
                                "Thème",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text(
                                "sombre",
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.tertiary,
                                    fontWeight: FontWeight.bold
                                ),
                              ),
                              SizedBox(width: getWidth(10),),
                              Icon(Icons.dark_mode_outlined, color: Theme.of(context).colorScheme.tertiary),
                            ],
                          ),
                        ],
                      )
                  ),
                ),

                //Container for profile editing
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Compte",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary
                      ),
                  ),
                ),
                Container(
                  //height: getHeight(100),
                    margin: EdgeInsets.symmetric(horizontal: getWidth(14), vertical: getHeight(3)),
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onSecondary,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ]
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: (){
                            Navigator.pushNamed(
                                context,
                                RouteName.editProfile,
                              arguments: null
                            );
                        },
                        child: ListTile(
                          leading: Icon(Icons.manage_accounts_rounded),
                          title: Text(
                            "Modifier le profil",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_outlined, size: getSize(20),),
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(
                            context,
                            RouteName.navigation,
                            arguments: 1
                          );
                        },
                        child: ListTile(
                          leading: Icon(Icons.favorite),
                          title: Text(
                              "Mes favoris",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_outlined, size: getSize(20),),
                        ),
                      ),

                      GestureDetector(
                        onTap: (){
                          Navigator.pushNamed(
                              context,
                              RouteName.orderPage,
                            arguments: null
                          );
                        },
                        child: ListTile(
                          leading: Icon(Icons.shopping_bag_rounded),
                          title: Text(
                              "Mes commandes",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_outlined, size: getSize(20),),
                        ),
                      )
                    ],
                  )
                  ),


                //Container for à propos and logout
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Autres",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary
                    ),
                  ),
                ),
                Container(
                  //height: getHeight(100),
                    margin: EdgeInsets.symmetric(horizontal: getWidth(14), vertical: getHeight(3)),
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.onSecondary,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ]
                    ),
                    child: Column(
                      children: [
                        ListTile(
                          leading: Icon(Icons.info),
                          title: Text(
                              "A propos",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold
                            ),
                          ),
                          trailing: Icon(Icons.arrow_forward_ios_outlined , size: getSize(20),),
                        ),

                        GestureDetector(
                          onTap: (){

                              auth.signOut();
                              Navigator.pushNamed(
                                  context,
                                  RouteName.signup,
                                arguments: null
                              );

                          },
                          child: ListTile(
                            leading: Icon(Icons.logout_outlined, size: getSize(20),),
                            title: Text(
                                "Deconnexion",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold
                              ),

                            ),
                            trailing: Icon(Icons.arrow_forward_ios_outlined, size: getSize(20),),
                          ),
                        )
                      ],
                    )
                ),

              ],
            ),
          ),
        );
      },
    );
  }
}
