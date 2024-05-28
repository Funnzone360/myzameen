class CarouselModel {
  final String imageUrl;
  final String title;

  CarouselModel({
    required this.imageUrl,
    required this.title,
  });
}

List<CarouselModel> carouselSliderModel = [
  CarouselModel(
    imageUrl: 'assets/images/land.png',
    title: 'land',
  ),
  CarouselModel(
    imageUrl: 'assets/images/house.jpg',
    title: 'house',
  ),
  CarouselModel(
    imageUrl: 'assets/images/factory.jpg',
    title: 'factories',
  ),
  CarouselModel(
    imageUrl: 'assets/images/building.png',
    title: 'buildings',
  ),
  CarouselModel(
    imageUrl: 'assets/images/hotels.jpg',
    title: 'hotels',
  ),
];
