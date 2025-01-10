import 'package:flutter/material.dart';
import '../../../../../core/widgets/circle_vatar.dart';


class MemberAvatarGroup extends StatelessWidget {
  const MemberAvatarGroup({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Stack(
        children: [
          for (var i = 0; i < 3; i++)
            Positioned(
              left: i * 20.0,
              child: const Avatar(
                radius: 20,
              ),
            ),
          Positioned(
            left: 60,
            child: Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Center(
                child: Text(
                  '+10',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
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
