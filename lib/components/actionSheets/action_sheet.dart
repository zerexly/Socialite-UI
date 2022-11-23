import 'package:foap/helper/common_import.dart';

class ActionSheet extends StatefulWidget {
  final List<GenericItem> items;
  final Function(GenericItem) itemCallBack;

  const ActionSheet({Key? key, required this.items, required this.itemCallBack})
      : super(key: key);

  @override
  ActionSheetState createState() => ActionSheetState();
}

class ActionSheetState extends State<ActionSheet> {
  late List<GenericItem> items;
  late Function(GenericItem) itemCallBack;
  GenericItem? selectedItem;

  @override
  void initState() {
    // TODO: implement initState
    items = widget.items;
    itemCallBack = widget.itemCallBack;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: (items.length * 76) + 100,
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const ThemeIconWidget(
                ThemeIcon.close,
                size: 20,
              ).ripple(() {
                Navigator.pop(context);
              }),
              const Spacer(),
              Text(LocalizationString.choosePrivacy,
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(fontWeight: FontWeight.w600)),
              const Spacer(),
              Text(
                LocalizationString.done,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.w600),
              ).ripple(() {
                if (selectedItem != null) {
                  itemCallBack(selectedItem!);
                }
                Navigator.pop(context);
              })
            ],
          ).setPadding(left: 16, right: 16, top: 25),
          divider(context: context, height: 0.2).tP25,
          for (int i = 0; i < items.length; i++)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                        color: Theme.of(context).backgroundColor,
                        child: ThemeIconWidget(
                          items[i].icon!,
                          color: Theme.of(context).iconTheme.color,
                        ).p8)
                    .circular,
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        items[i].title,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge!
                            .copyWith(fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        items[i].subTitle!,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                // Spacer(),
                ThemeIconWidget(
                  selectedItem?.id == items[i].id
                      ? ThemeIcon.selectedRadio
                      : ThemeIcon.unSelectedRadio,
                  size: 25,
                  color: selectedItem?.id == items[i].id
                      ? Theme.of(context).primaryColor
                      : Theme.of(context).iconTheme.color,
                )
              ],
            ).p16.ripple(() {
              setState(() {
                selectedItem = items[i];
              });
              // itemCallBack(items[i]);
              // Navigator.pop(context);
            })
        ],
      ),
    ).topRounded(20);
  }
}
