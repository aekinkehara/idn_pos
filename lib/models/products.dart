class Product{
  final String name;
  final int price;

  Product({required this.name, required this.price});
}

final List<Product> menus = [
  Product(name: "Nasi Goreng", price: 25000),
  Product(name: "Ayam Bakar", price: 22000),
  Product(name: "Sate Ayam", price: 30000),
  Product(name: "Mie Nyemek", price: 18000),
  Product(name: "Es Teh", price: 5000),
  Product(name: "Es Jeruk", price: 7000),
  Product(name: "Americano", price: 8000),
  Product(name: "Air Mineral", price: 4000)
];