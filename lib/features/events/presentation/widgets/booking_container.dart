import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/theme/app_palette.dart';
import '../../../../core/widgets/primary_button.dart';

class BookingPlace extends StatelessWidget {
  final void Function() onTap;
  final String? price;
  const BookingPlace({super.key, required this.onTap, this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 120,
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppPalette.darkCard,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Price',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: '\$ ${price ?? ''}',
                          style: const TextStyle(
                            color: AppPalette.payment,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' /person',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16),
                  child: PrimaryButton(
                    onTap: onTap,
                    iconData: FontAwesomeIcons.ticketSimple,
                    text: "Book Now",
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
