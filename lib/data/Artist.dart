
//歌手
class Artist {
  String name = "";
  String id = "";
  String picUrl = "";

  Artist(this.name, this.id, { this.picUrl="" });

  get getPicUrl {
    return picUrl;
  }
}

// json  转 List<Artist>
// [ {}, {} ]
List<Artist> jsonToArtists(dynamic json){
  List<Artist> result = [];
  List<dynamic> artists = json;
  for (var item in artists) {
    result.add(
        Artist(
            item["name"],
            "${item["id"]}",
            picUrl: item["picUrl"]
        )
    );
  }
  return result;
}

