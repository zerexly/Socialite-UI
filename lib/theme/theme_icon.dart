import 'package:flutter/material.dart';
import 'package:foap/theme/icon_enum.dart';

class ThemeIconWidget extends StatelessWidget {
  final ThemeIcon icon;
  final double? size;
  final Color? color;

  const ThemeIconWidget(this.icon, {Key? key, this.size, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return getIcon(context);
  }

  Widget getIcon(BuildContext context) {
    switch (icon) {
      case ThemeIcon.home:
        return Icon(
          Icons.home_max_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.cart:
        return Icon(
          Icons.shopping_cart_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.setting:
        return Icon(
          Icons.settings_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.search:
        return Icon(
          Icons.search,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.downArrow:
        return Icon(
          Icons.keyboard_arrow_down,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.star:
        return Icon(
          Icons.star_border,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.filledStar:
        return Icon(
          Icons.star,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.diamond:
        return Icon(
          Icons.diamond,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.checkMark:
        return Icon(
          Icons.check,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.edit:
        return Icon(
          Icons.edit_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.filterIcon:
        return Icon(
          Icons.filter_alt_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.sort:
        return Icon(
          Icons.sort,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.logout:
        return Icon(
          Icons.logout_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.review:
        return Icon(
          Icons.library_books_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.circle:
        return Icon(
          Icons.circle,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.circleOutline:
        return Icon(
          Icons.circle_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.fav:
        return Icon(
          Icons.favorite_border_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.favFilled:
        return Icon(
          Icons.favorite,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.close:
        return Icon(
          Icons.close,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.checkMarkWithCircle:
        return Icon(
          Icons.check_circle_outline,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.security:
        return Icon(
          Icons.security,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.bike:
        return Icon(
          Icons.delivery_dining_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.clock:
        return Icon(
          Icons.timer,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.calendar:
        return Icon(
          Icons.calendar_month,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.offer:
        return Icon(
          Icons.local_offer_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.orders:
        return Icon(
          Icons.list_alt_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.account:
        return Icon(
          Icons.person_outline,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.group:
        return Icon(
          Icons.group,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.privacyPolicy:
        return Icon(
          Icons.policy_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.info:
        return Icon(
          Icons.info,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.terms:
        return Icon(
          Icons.verified_user_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.add:
        return Icon(
          Icons.add,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.selectedRadio:
        return Icon(
          Icons.radio_button_checked,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.unSelectedRadio:
        return Icon(
          Icons.radio_button_off_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.more:
        return Icon(
          Icons.more_horiz,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.wallet:
        return Icon(
          Icons.account_balance_wallet,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.dashboard:
        return Icon(
          Icons.dashboard,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.nextArrow:
        return Icon(
          Icons.arrow_forward_ios,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.backArrow:
        return Icon(
          Icons.arrow_back_ios,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.menuIcon:
        return Icon(
          Icons.menu,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.eye:
        return Icon(
          Icons.remove_red_eye,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.password:
        return Icon(
          Icons.password_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.email:
        return Icon(
          Icons.email_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.showPwd:
        return Icon(
          Icons.visibility_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.hidePwd:
        return Icon(
          Icons.visibility_off_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.mobile:
        return Icon(
          Icons.phone_enabled_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.name:
        return Icon(
          Icons.person_outline,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.notification:
        return Icon(
          Icons.notifications_none,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.discount:
        return Icon(
          Icons.local_offer_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.share:
        return Icon(
          Icons.share_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.addressType:
        return Icon(
          Icons.location_city_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.plus:
        return Icon(
          Icons.add,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.minus:
        return Icon(
          Icons.remove,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.addressPin:
        return Icon(
          Icons.location_on_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.avatar:
        return Icon(
          Icons.person_outline,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.card:
        return Icon(
          Icons.credit_card,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.thumbsUp:
        return Icon(
          Icons.thumb_up_alt_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.mic:
        return Icon(
          Icons.mic_none_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.micOff:
        return Icon(
          Icons.mic_off,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.book:
        return Icon(
          Icons.library_books_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.helpHand:
        return Icon(
          Icons.live_help_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.about:
        return Icon(
          Icons.info_outline,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.videoPost:
        return Icon(
          Icons.video_library_rounded,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.delete:
        return Icon(
          Icons.delete_outline,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.message:
        return Icon(
          Icons.add_comment_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.chat:
        return Icon(
          Icons.messenger,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.closeCircle:
        return Icon(
          Icons.highlight_remove_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.bathTub:
        return Icon(
          Icons.bathtub_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.bed:
        return Icon(
          Icons.bed_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.area:
        return Icon(
          Icons.calculate_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.send:
        return Icon(
          Icons.send,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.bookMark:
        return Icon(
          Icons.bookmark_border_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.buildings:
        return Icon(
          Icons.home_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.lock:
        return Icon(
          Icons.lock_open_rounded,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.news:
        return Icon(
          Icons.list_alt_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.camera:
        return Icon(
          Icons.camera_alt_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.cameraSwitch:
        return Icon(
          Icons.switch_camera_rounded,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.play:
        return Icon(
          Icons.play_arrow_rounded,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.multiplePosts:
        return Icon(
          Icons.collections_rounded,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.sticker:
        return Icon(
          Icons.emoji_emotions_rounded,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.gif:
        return Icon(
          Icons.gif_box,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.stop:
        return Icon(
          Icons.stop_circle,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.sending:
        return Icon(
          Icons.error_outline_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.sent:
        return Icon(
          Icons.done,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.delivered:
        return Icon(
          Icons.done_all,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.read:
        return Icon(
          Icons.done_all,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.fwd:
        return Icon(
          Icons.send,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );

      case ThemeIcon.reply:
        return Icon(
          Icons.reply,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.videoCamera:
        return Icon(
          Icons.videocam,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.videoCameraOff:
        return Icon(
          Icons.videocam_off,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.callEnd:
        return Icon(
          Icons.call_end,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.emptyCheckbox:
        return Icon(
          Icons.check_box_outline_blank,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.selectedCheckbox:
        return Icon(
          Icons.check_box,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.gallery:
        return Icon(
          Icons.photo,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.wallpaper:
        return Icon(
          Icons.wallpaper,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.selectionType:
        return Icon(
          Icons.file_copy_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.contacts:
        return Icon(
          Icons.contact_phone_rounded,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.location:
        return Icon(
          Icons.location_on,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.drawing:
        return Icon(
          Icons.draw,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.report:
        return Icon(
          Icons.report_problem_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.hide:
        return Icon(
          Icons.visibility_off_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.addCircle:
        return Icon(
          Icons.add_circle,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.userGroup:
        return Icon(
          Icons.supervisor_account_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.public:
        return Icon(
          Icons.public,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.request:
        return Icon(
          Icons.task_sharp,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.files:
        return Icon(
          Icons.file_copy_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.fullScreen:
        return Icon(
          Icons.open_in_full_outlined,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.randomChat:
        return Icon(
          Icons.person_search,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.download:
        return Icon(
          Icons.file_download,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.pause:
        return Icon(
          Icons.pause,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.map:
        return Icon(
          Icons.map,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.music:
        return Icon(
          Icons.music_note,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
      case ThemeIcon.gift:
        return Icon(
          Icons.card_giftcard,
          size: size ?? 20,
          color: color ?? Theme.of(context).iconTheme.color,
        );
    }
  }
}
