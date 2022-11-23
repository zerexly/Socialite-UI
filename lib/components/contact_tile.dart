import 'package:foap/helper/common_import.dart';

class ContactTile extends StatelessWidget {
  final Contact contact;
  final bool isSelected;

  const ContactTile({Key? key, required this.contact, required this.isSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(contact.displayName,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.w600)),
              Text(contact.phones.map((e) => e.number).toList().join(','),
                  style: Theme.of(context).textTheme.titleSmall)
            ],
          ),
        ),
        isSelected
            ? ThemeIconWidget(
                ThemeIcon.checkMarkWithCircle,
                size: 20,
                color: Theme.of(context).primaryColor,
              )
            : const ThemeIconWidget(
                ThemeIcon.circleOutline,
                size: 20,
              )
      ],
    );
  }
}
