import 'package:flutter/material.dart';
import 'package:shop_online/core/core.dart';


class AdminLogin extends StatefulWidget {
  const AdminLogin({super.key});

  @override
  State<AdminLogin> createState() => _LoginPageState();
}

class _LoginPageState extends State<AdminLogin> {

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;


  void adminLogin(){
    if(_formKey.currentState!.validate()){
      if(
        _emailController.text == "admin@gmail.com" &&
            _passwordController.text == "admin"
      ){
          Navigator.pushNamed(context, RouteName.adminNavigation, arguments: 0);
      }else{
        return;
      }
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Administrateur',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        children: [
                          Text(
                            'Connectez-vous pour accéder à votre',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                          Text(
                            'application',
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      TextFormField(
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(
                             borderRadius: BorderRadius.all(Radius.circular(13))
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Veuillez entrer votre email';
                          }
                          if (!value!.contains('@')) {
                            return 'Veuillez entrer un email valide';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(13))),
                        ),
                        obscureText: !_isPasswordVisible,
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Veuillez entrer votre mot de passe';
                          }
                          if (value!.length < 4) {
                            return 'Le mot de passe doit contenir au moins 4 caractères';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                       Container(
                         decoration: BoxDecoration(
                           color: Colors.grey[900],
                           borderRadius: BorderRadius.circular(13),
                         ),
                         child: TextButton(
                           onPressed: adminLogin,
                           style: ElevatedButton.styleFrom(
                             padding: const EdgeInsets.symmetric(vertical: 16),
                           ),
                           child: const Text(
                             'Se connecter',
                             style: TextStyle(fontSize: 16, color: Colors.white),
                           ),
                         ),
                       )
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
    );
  }
}
