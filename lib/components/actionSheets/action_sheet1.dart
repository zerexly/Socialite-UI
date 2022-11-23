import 'package:foap/helper/common_import.dart';

class ActionSheet1 extends StatelessWidget {
  final List<GenericItem> items;
  final Function(GenericItem) itemCallBack;

  const ActionSheet1(
      {Key? key, required this.items, required this.itemCallBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: items.length * 60,
      color: Theme.of(context).cardColor,
      child: Column(
        children: [
          for (int i = 0; i < items.length; i++)
            Row(
              children: <Widget>[
                items[i].icon != null
                    ? ThemeIconWidget(
                        items[i].icon!,
                        color: Theme.of(context).iconTheme.color,
                      )
                    : Container(),
                const SizedBox(width: 20),
                Text(
                  items[i].title,
                  style: Theme.of(context)
                      .textTheme
                      .titleSmall!
                      .copyWith(fontWeight: FontWeight.w600),
                )
              ],
            ).p16.ripple(() {
              Navigator.pop(context);
              itemCallBack(items[i]);
            })
        ],
      ),
    ).topRounded(20);
  }
}
