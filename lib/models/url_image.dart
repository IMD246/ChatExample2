enum TypeImage { local, remote }

class UrlImage {
   String? urlImage;
   TypeImage typeImage;

  UrlImage({
    this.urlImage,
    this.typeImage = TypeImage.remote,
  });
  
}
