import 'package:foap/helper/common_import.dart';

class VerificationRejectReason extends StatelessWidget {
  const VerificationRejectReason({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          backNavigationBar(context: context, title: LocalizationString.reply),
          divider(context: context).tP8,
          const SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            child: Text(
              'Lorem ipsum dolor sit amet. Ut ipsam architecto aut Quis incidunt ut vero ipsum. Id porro consequuntur ut culpa error ex incidunt placeat id molestiae harum eos recusandae voluptatem. 33 tenetur praesentium et culpa quasi quo illum totam et ipsa galisum ut soluta dolores qui dolores blanditiis. Hic distinctio voluptatem sit nihil aliquid sit commodi nisi et iusto reiciendis in dolor rerum ex expedita suscipit et sequi quia. </p><p>Est provident numquam ut itaque omnis eos voluptas saepe ut consequatur minus est officiis optio? Ut inventore labore et numquam enim ut deserunt quam est eius voluptas id sapiente aliquam ut perspiciatis asperiores. </p><p>A modi unde et recusandae odit hic nesciunt voluptatibus At similique officiis. Qui illo dolores aut perspiciatis incidunt sit galisum fuga qui facilis voluptate. Ab illo impedit aut quasi quaerat qui fugit ullam qui fugiat ducimus?',
              style: Theme.of(context).textTheme.bodyLarge,
            ).hP16,
          )
        ],
      ),
    );
  }
}
