enum RecordType{
  profile,
  post,
  hashtag,
  location,
}

enum SearchFrom{
  username,
  email,
  phone,
}

enum PostSource{
  posts,
  mentions
}

enum PostMediaType{
  all,
  photo,
  video,
}

enum MessageStatus{
  sending,
  sent,
  delivered,
  read,
}

enum MessageContentType{
  text,
  photo,
  video,
  audio,
  gif,
  sticker,
  contact,
  location,
  reply,
  forward,
  post,
  story
}

enum UploadMediaType{
  post,
  storyOrHighlights,
  chat,
}

enum ChatMessageActionMode{
  none,
  reply,
  forward,
  star,
  delete
}

enum AgoraCallType{
  audio,
  video,
}
