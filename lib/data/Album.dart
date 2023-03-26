import 'package:music/data/Artist.dart';

class Album {
  String name = "";             //专辑名称
  String id = "";               //专辑ID
  String picUrl = "";           //封面URL
  List<Artist> artists = [];    //歌手

  Album(this.name, this.id, this.artists, { this.picUrl="" });


  get getPicUrl {
    return picUrl;
  }

  //将歌手名称转成 aaa/bbb 形式
  get getArtistsName {
    var result = "";
    for (var item in artists) {
      result += "${item.name}/";
    }
    result = result.substring(0, result.length - 1);
    return result;
  }
}

//将json对象, 转为Album对象
Album jsonToAlbum(dynamic album){
  return Album(
    album["name"],
    "${album["id"]}",
    jsonToArtists(album["artists"]),
    picUrl: album["picUrl"],
  );
}
