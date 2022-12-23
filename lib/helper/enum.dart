enum RecordType {
  profile,
  post,
  hashtag,
  location,
}

enum SearchFrom {
  username,
  email,
  phone,
}

enum PostSource { posts, mentions }

enum PostMediaType {
  all,
  photo,
  video,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
}

enum MessageContentType {
  text,
  photo,
  video,
  audio,
  gif,
  sticker,
  contact,
  file,
  location,
  reply,
  forward,
  post,
  story,
  drawing,
  profile,
  group,
  groupAction,
  gift
}

enum UploadMediaType { post, storyOrHighlights, chat, club, verification }

///Media picker selection type
enum GalleryMediaType {
  ///make picker to select only image file
  photo,

  ///make picker to select only video file
  video,

  ///make picker to select only audio file
  audio,

  ///make picker to select only pdf file
  pdf,

  ///make picker to select only ppt file
  ppt,

  ///make picker to select only doc file
  doc,

  ///make picker to select only xls file
  xls,

  ///make picker to select only txt file
  txt,

  ///make picker to select any media file
  all,
}

enum ChatMessageActionMode { none, reply, forward, star, delete, edit }

enum AgoraCallType {
  audio,
  video,
}

enum PaymentGateway {
  creditCard,
  applePay,
  paypal,
  razorpay,
  wallet,
  stripe,
  googlePay,
  inAppPurchse
}

enum BookingStatus { confirmed, cancelled }

enum EventStatus { upcoming, active, completed }
