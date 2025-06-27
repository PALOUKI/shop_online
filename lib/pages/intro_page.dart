import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shop_online/core/core.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {

  @override
  void initState() {
    super.initState();
    // 🔐 Forcer l'orientation portrait uniquement
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  @override
  void dispose() {
    // 🔄 Réinitialiser l'orientation à la normale quand on quitte la page
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    AppConfigSize.init(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(AssetsConstants.nikeLoo, color: Theme.of(context).colorScheme.primary,),
            SizedBox(height: 40,),
            Text(
                "Just Do It",
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 23
              ),
            ),
            SizedBox(height: 40,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: Text(
                "Des baskets flambant neuves et des modèles personnalisés fabriqués avec une qualité premium.",
                style: TextStyle(
                  color: Colors.grey[500],
                ),
              ),
            ),
            SizedBox(height: 60,),
            Container(
              width: 300,
              height: 65,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.primary),
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  foregroundColor: WidgetStatePropertyAll(Colors.white)
                ),
                        onPressed: (){
                            Navigator.pushNamed(
                                context,
                              RouteName.navigation,
                              arguments: 0
                            );
                        },
                  child: Text(
                    "Shop now",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.secondary
                    ),
                  )
              ),
            )
          ],
        ),
      ),
    );
  }
}
