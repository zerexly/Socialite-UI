import 'package:foap/helper/common_import.dart';

class TransactionTile extends StatelessWidget {
  final PaymentModel model;

  const TransactionTile({Key? key, required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 15.0),
            child: Row(children: [
              Container(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                height: 31,
                width: 31,
                child: ThemeIconWidget(ThemeIcon.wallet,
                    color: Theme.of(context).iconTheme.color, size: 18),
              ).circular,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    LocalizationString.withdrawal,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    model.createDate,
                    style: Theme.of(context).textTheme.bodySmall,
                  )
                ],
              ).lP8,
              const Spacer(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '\$${model.amount}',
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.w800),
                  ).bP4,
                  Text(
                    model.status == 1
                        ? LocalizationString.pending
                        : model.status == 2
                            ? LocalizationString.rejected
                            : LocalizationString.completed,
                    style: model.status == 1
                        ? Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.w600)
                        : Theme.of(context).textTheme.bodyMedium!.copyWith(
                            color: Theme.of(context).errorColor,
                            fontWeight: FontWeight.w600),
                  ),
                ],
              )
            ])),
      ],
    );
  }
}
