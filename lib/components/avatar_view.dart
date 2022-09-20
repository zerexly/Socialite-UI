import 'package:foap/helper/common_import.dart';

class AvatarView extends StatelessWidget {
  final String? url;
  final String? name;

  final double? size;
  final Color? borderColor;

  const AvatarView(
      {Key? key,
      required this.url,
      this.size = 60,
      this.borderColor,
      this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String initials = '';

    if (name != null) {
      List<String> nameParts = (name ?? '').split(' ');
      if (nameParts.length > 1) {
        initials = nameParts[0].substring(0, 1).toUpperCase() +
            nameParts[1].substring(0, 1).toUpperCase();
      } else {
        initials = nameParts[0].substring(0, 1).toUpperCase();
      }
    }

    return SizedBox(
      height: size ?? 60,
      width: size ?? 60,
      child: url != null
          ? CachedNetworkImage(
              imageUrl: url!,
              fit: BoxFit.cover,
              placeholder: (context, url) => SizedBox(
                  height: 20,
                  width: 20,
                  child: const CircularProgressIndicator().p16),
              errorWidget: (context, url, error) => const Icon(
                Icons.error,
              ),
            ).round(18)
          : Center(
              child: Text(initials,
                      style: TextStyle(
                          fontSize: (size ?? 60) / 2.3,
                          fontWeight: FontWeight.w600))
                  .p8,
            ),
    ).borderWithRadius(
        context: context,
        value: 2,
        radius: 20,
        color: borderColor ?? Theme.of(context).primaryColor);
  }
}

class UserAvatarView extends StatelessWidget {
  final UserModel user;
  final double? size;
  final VoidCallback? onTapHandler;

  const UserAvatarView(
      {Key? key, required this.user, this.size = 60, this.onTapHandler})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size ?? 60,
      width: size ?? 60,
      child: Stack(
        children: [
          user.liveCallDetail != null
              ? liveUserWidget(size: size ?? 60, context: context).ripple(() {
                  if (onTapHandler != null) {
                    onTapHandler!();
                  }
                })
              : userPictureView(size: size ?? 60, context: context),
          user.liveCallDetail == null
              ? Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    height: 15,
                    width: 15,
                    color: user.isOnline == true
                        ? Theme.of(context).primaryColor
                        : Colors.transparent,
                  ).circular)
              : Container(),
        ],
      ),
    );
  }

  Widget userPictureView(
      {required double size, double? radius, required BuildContext context}) {
    return user.picture != null
        ? CachedNetworkImage(
            imageUrl: user.picture!,
            fit: BoxFit.cover,
            height: size,
            width: size,
            placeholder: (context, url) => SizedBox(
                height: 20,
                width: 20,
                child: const CircularProgressIndicator().p16),
            errorWidget: (context, url, error) => SizedBox(
                height: size, width: size, child: const Icon(Icons.error)),
          ).round(radius ?? 10)
        : SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Center(
              child: Text(
                user.getInitials,
                style: TextStyle(
                    fontSize: size / 2.3, fontWeight: FontWeight.w600),
              ).p8,
            ),
          ).borderWithRadius(
            context: context,
            value: 1,
            radius: 15,
            color: Theme.of(context).primaryColor);
  }

  Widget liveUserWidget({required double size, required BuildContext context}) {
    return Stack(
      children: [
        userPictureView(size: size, radius: 13, context: context)
            .borderWithRadius(
                context: context,
                value: 2,
                radius: 15,
                color: Theme.of(context).primaryColor),
        Positioned(
            right: 0,
            left: 0,
            bottom: 0,
            child: Container(
              height: 18,
              color: Theme.of(context).primaryColor,
              child: Center(
                child: Text(
                  LocalizationString.live,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ).round(5))
      ],
    );
  }
}