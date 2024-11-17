import 'package:flareup/features/home/presentation/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(actions: [
        IconButton(onPressed: () {}, icon: const FaIcon(FontAwesomeIcons.bell)),
      ]),
      drawer: const AppDrawer(),
      body: Center(child: Text('home')),
    );
  }
}
