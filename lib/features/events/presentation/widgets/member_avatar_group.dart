import 'package:flutter/material.dart';

import '../../../../core/utils/responsive_utils.dart';

class MemberAvatarGroup extends StatelessWidget {
  final int maxDisplayed;
  final int memberCount;

  const MemberAvatarGroup({
    super.key,
    required this.maxDisplayed,
    required this.memberCount,
  });

  @override
  Widget build(BuildContext context) {
    Responsive.init(context);

    final displayCount =
        memberCount > maxDisplayed ? maxDisplayed : memberCount;

    // Calculate responsive dimensions
    final avatarSize = Responsive.screenWidth * 0.10; // 12% of screen width
    final widthFactor = Responsive.isTablet ? 0.6 : 0.53;
    final spacing = Responsive.horizontalPadding * 0.4;
    final fontSize = Responsive.bodyFontSize;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Responsive.horizontalPadding,
        vertical: Responsive.verticalPadding * 0.5,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          for (int i = 0; i < displayCount; i++)
            Align(
              widthFactor: widthFactor,
              alignment: Alignment.center,
              child: Container(
                height: avatarSize,
                width: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                ),
                margin: EdgeInsets.only(left: i.toDouble() * spacing),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(images[i % images.length]),
                ),
              ),
            ),
          if (memberCount > maxDisplayed)
            Align(
              widthFactor: widthFactor,
              alignment: Alignment.center,
              child: Container(
                height: avatarSize,
                width: avatarSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white),
                ),
                margin:
                    EdgeInsets.only(left: displayCount.toDouble() * spacing),
                child: CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(
                    '+${memberCount - maxDisplayed}',
                    style: TextStyle(
                      color: Colors.black87,
                      fontSize: fontSize,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

final List<String> images = <String>[
  "https://images.unsplash.com/photo-1458071103673-6a6e4c4a3413?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
  "https://images.unsplash.com/photo-1518806118471-f28b20a1d79d?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=400&q=80",
  "https://images.unsplash.com/photo-1470406852800-b97e5d92e2aa?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80",
  "https://images.unsplash.com/photo-1473700216830-7e08d47f858e?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=750&q=80"
];
