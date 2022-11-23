import 'package:foap/helper/common_import.dart';

class ProfilePictureWithName extends StatelessWidget {
  final UserModel user;

  const ProfilePictureWithName({Key? key, required this.user})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: AspectRatio(
                  aspectRatio: 1,
                  // height: 56,
                  // width: 56,
                  child: user.picture != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(21.0),
                          child: CachedNetworkImage(
                            imageUrl: user.picture!,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                AppUtil.addProgressIndicator(context,50),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ))
                      : Icon(Icons.person,
                          color: Theme.of(context).primaryColor))
              .borderWithRadius(context: context,
              value: 2, radius: 30, color: Theme.of(context).primaryColor),
        ),
        Text(
          user.userName,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(color: Theme.of(context).primaryColor),
        ).vP8
      ],
    );
  }
}
