


class User {
  String userId = "";                   //ID
  String nickname = "";                 //昵称
  String signature = "";                //个性签名
  String avatarUrl = "";                //头像

  User({
    required this.userId,
    required this.nickname,
    this.signature = "",
    this.avatarUrl = "",
  });

  get getAvatarUrl {
    return avatarUrl;
  }

  get getSignature {
    if(signature==""){
      return "未填写个性签名";
    } else {
      return signature;
    }
  }
}


