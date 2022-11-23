import 'package:foap/helper/common_import.dart';
import 'package:foap/components/contact_tile.dart';
import 'package:get/get.dart';

class ContactList extends StatefulWidget {
  final Function(List<Contact>) selectedContactsHandler;

  const ContactList({Key? key, required this.selectedContactsHandler})
      : super(key: key);

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final ContactsController contactsController = Get.find();

  @override
  void initState() {
    // TODO: implement initState
    contactsController.loadContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const ThemeIconWidget(
                    ThemeIcon.close,
                    size: 20,
                  ).ripple(() {
                    Navigator.of(context).pop();
                  }),
                  Text(
                    LocalizationString.send,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium!
                        .copyWith(fontWeight: FontWeight.w600),
                  ).ripple(() {
                    Navigator.of(context).pop();
                    widget.selectedContactsHandler(
                        contactsController.selectedContacts);
                  }),
                ],
              ).hP16,
              Positioned(
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Obx(() => Text(
                          '${LocalizationString.shareContacts} ${contactsController.selectedContacts.length}/${contactsController.contacts.length}',
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall!
                              .copyWith(fontWeight: FontWeight.w600),
                        ))
                  ],
                ),
              )
            ],
          ),
          divider(context: context).tP16,
          Expanded(
            child: GetBuilder<ContactsController>(
                init: contactsController,
                builder: (ctx) {
                  return ListView.separated(
                      padding:
                          const EdgeInsets.only(left: 16, right: 16, top: 25),
                      itemCount: contactsController.contacts.length,
                      itemBuilder: (ctx, index) {
                        Contact contact = contactsController.contacts[index];
                        return ContactTile(
                          contact: contact,
                          isSelected: contactsController.selectedContacts
                              .contains(contact),
                        ).ripple(() {
                          contactsController.selectUnSelectContact(contact);
                        });
                      },
                      separatorBuilder: (ctx, index) {
                        return const SizedBox(
                          height: 20,
                        );
                      });
                }),
          )
        ],
      ),
    );
  }
}
