import 'package:foap/helper/common_import.dart';

class PaymentMethodTile extends StatelessWidget {
  const PaymentMethodTile({
    Key? key,
    required this.text,
    required this.price,
    required this.icon,
    required this.isSelected,
    this.press,
  }) : super(key: key);

  final String text, price, icon;
  final VoidCallback? press;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: const Color(0xFFF5F6F9),
      child: Row(
        children: [
          Container(
            height: 35,
            width: 35,
            color: Theme.of(context).primaryColor.lighten(),
            child: Image.asset(
              icon,
              // width: 40,
            ).p8,
          ).circular,
          const SizedBox(width: 15),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 5),
              Row(
                children: [
                  Text(
                    LocalizationString.pay,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    price,
                    style: Theme.of(context).textTheme.bodySmall!.copyWith(
                        fontWeight: FontWeight.w900,
                        color: Theme.of(context).primaryColor),
                  ),
                ],
              )
            ],
          )),
          ThemeIconWidget(
            isSelected ? ThemeIcon.selectedCheckbox : ThemeIcon.emptyCheckbox,
            color: isSelected ? Theme.of(context).primaryColor : null,
          ),
        ],
      ).vP16,
    ).ripple(press!);
  }
}
