import 'package:foap/helper/common_import.dart';

class PaymentMethodTile extends StatelessWidget {
  const PaymentMethodTile({
    Key? key,
    required this.text,
    required this.icon,
    this.press,
  }) : super(key: key);

  final String? text, icon;
  final VoidCallback? press;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: const Color(0xFFF5F6F9),
      child: Row(
        children: [
          Container(
            height: 40,
            width: 40,
            color: Theme.of(context).primaryColor.lighten(),
            child: Image.asset(
              icon!,
              // width: 40,
            ).p8,
          ).circular,
          const SizedBox(width: 20),
          Expanded(
              child: Text(
            text!,
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(fontWeight: FontWeight.w700),
          )),
          Icon(
            Icons.arrow_forward_ios,
            size: 15,
            color: Theme.of(context).iconTheme.color,
          ),
        ],
      ).p16,
    ).ripple(press!);
  }
}
