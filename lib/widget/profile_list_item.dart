import 'package:floor_app/values/my_colors.dart';
import 'package:flutter/material.dart';

// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:line_awesome_flutter/line_awesome_flutter.dart';
// import 'package:profile_app_ui/constants.dart';

class ProfileListItem extends StatelessWidget {
  final String? name;
  final IconData? icon;
  final IconData? secondIcon;

  const ProfileListItem({this.name, this.icon, this.secondIcon});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).textTheme;
    // SizeConfig().init(context);
    Size size = MediaQuery.of(context).size;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0),
      child: Container(
        height: size.height * 0.08,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.0),
          color: MyColors.primaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Icon(
                icon,
                color: Colors.white,
              ),
            ),
            Text(
              name!,
              style: theme.bodyText1!.copyWith(fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Icon(
                secondIcon,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
