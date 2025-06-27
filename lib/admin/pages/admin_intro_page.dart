import 'package:flutter/material.dart';
import 'package:shop_online/core/core.dart';


class AdminIntroPage extends StatefulWidget {
  const AdminIntroPage({super.key});

  @override
  State<AdminIntroPage> createState() => _AdminIntroPageState();
}

class _AdminIntroPageState extends State<AdminIntroPage> {
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
              child: Column(
                children: [
                  Text(
                    "Gestions des stocks de vêtements et administration",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                  Text(
                    "des commandes",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                    ),
                  ),
                ],
              )
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
                        RouteName.adminLogin,
                    );
                  },
                  child: Text(
                    "Commencer",
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
