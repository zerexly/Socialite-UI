import 'package:foap/helper/common_import.dart';

class FaqList extends StatefulWidget {
  const FaqList({Key? key}) : super(key: key);

  @override
  State<FaqList> createState() => _FaqListState();
}

class _FaqListState extends State<FaqList> {
  List<Map<String, String>> faqs = [
    {'question' :'1. What is phozio?', 'answer': 'Phozio is a platform that helps you sell your photos and videos for money.'},
    {'question' :'2. How to make money on PHOZIO?', 'answer': 'Selling your photos and videos to big brands. b. Entering our elite quests.'},
    {'question' :'3. How to buy a photo/video on PHOZIO?', 'answer': 'Through elite quest, and also from user.'},
    {'question' :'4. I have published a photo/video. When will I get money for that?', 'answer': 'As soon as the buyer pays for your photo/video.'},
    {'question' :'5. The payment for photo/video has failed. What should I do?', 'answer': 'Wait a little while and try again, if the issue continues you will send a complaint to the management.'},
    {'question' :'6. How do I withdraw my money?', 'answer': 'Withdrawals can be made directly to your bank account which must match the account details deposit was made from.'},
    {'question' :'7. How do I deposit money into my account?', 'answer': ' Deposit can be made from the deposit section of the app.'},
    {'question' :'8. How do I promote my brand/business on PHOZIO?', 'answer': 'By hosting an elite quest or contacting us to host it for you.'},
    {'question' :'9. The app says my photo is too small/poor quality. What should I do?', 'answer': 'Upload high quality photos'},
    {'question' :'10. The app says my video quality is poor. What should I do?', 'answer': 'Upload high quality videos'},
    {'question' :'11. How do I join ELITE QUESTS? ', 'answer': 'You can join the elite quest, simply by upload photos/videos that meet the standard of the quest theme. You can find the elite quest button in the homepage and, will need zio coin to upload a photo or video '},
    {'question' :'12.	How do I find friends on PHOZIO?', 'answer': 'You can access the find friends menu in your profile setting.'},
    {'question' :'13.	How long does it take before I can withdraw money from PHOZIO?', 'answer': 'As soon as the money appears in your account.'},
    {'question' :'14.	Do I get penalized for stealing another users content?', 'answer': 'Yes, the guilty party account will be restricted and penalized.'},
    {'question' :'15. How do I get zio coin?', 'answer': 'By watching ads or depositing funds into your account.'},

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          backNavigationBar(context, LocalizationString.faq),
          divider(context: context).vP8,
          Expanded(
            child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 50),
                itemCount: faqs.length,
                itemBuilder: (ctx, index) {
                  return ExpansionTile(
                    title: Text(faqs[index]['question']!, style: Theme.of(context).textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.w900)),
                    children:  <Widget>[
                      ListTile(title: Text(faqs[index]['answer']!, style: Theme.of(context).textTheme.bodyLarge)),
                    ],
                    onExpansionChanged: (bool expanded) {},
                  );
                }),
          )
        ],
      ),
    );
  }
}
