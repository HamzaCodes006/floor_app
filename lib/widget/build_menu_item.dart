import 'package:flutter/material.dart';

import '../values/size_config.dart';

class BuildMenuItem extends StatelessWidget {

  const BuildMenuItem({required this.icon, required this.text}) ;
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    var theme = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(
        icon,
        color: Colors.white,
      ),
      title: Text(
        text,
        style: theme.headline6!.copyWith(color: Colors.white),
      ),
      hoverColor: Colors.orange.shade700,
    );
  }
}
