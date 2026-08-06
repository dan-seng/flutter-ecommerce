import '../models/product.dart';

const bannerImageUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuCepgfuYMUCW8p-_hUtxg8fRttnCQjffbjhvX3dz2MAOTPghW6kswo18K2cT1FTPFPeuNJQSdPQatQ_cjqk8Pz2URURp4_ubf_2Ovy7ckqJpYnJevP3EUr1xy60BP6N5EZxE23oBXOJyccMR_4LvGk_CL0YgMsJVmnu2BQ1K-1oF0a0Cd5Tk9Kfru-QSoueqVeu5TVJE-IAHBX0f55BE1ELYbtY5kos3XpJ133l9-tf9vEIjQn2wMq0pw';

const bentoImageUrl =
    'https://lh3.googleusercontent.com/aida-public/AB6AXuAMgDxiNtbPHxCZMdE7FJ9Sz4hpIO2RZwiXaZqjPVYIlIAfwc7AIS5-U8QIMuvJHIFRzLruHbbooZ9EjLeZ5rg7a95bhyyML0Gvifbt8i3yxqj3eSGJRZvUobPeV1OH8ussNsylA9XGrmzMGCMfBj0Pf81WH9sszOIPy0Y7XDgMiGi5QyutnUoYmD-XhxWsN6I7KOm2zk_phL_c3maWsOb_bt27FegxtmGymeSzlnJXQqy233czUer66g';

/// FakeStore seed catalog, used for offline fallback and tests.
const sampleProducts = [
  Product(
    id: 1,
    name: 'Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops',
    description:
        'Your perfect pack for everyday use and walks in the forest. Stash your laptop (up to 15 inches) in the padded sleeve, your everyday',
    category: "men's clothing",
    price: 109.95,
    rating: 3.9,
    reviewCount: 120,
    imageUrl: 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
  ),
  Product(
    id: 2,
    name: 'Mens Casual Premium Slim Fit T-Shirts',
    description:
        'Slim-fitting style, contrast raglan long sleeve, three-button henley placket, light weight & soft fabric for breathable and comfortable wearing.',
    category: "men's clothing",
    price: 22.30,
    rating: 4.1,
    reviewCount: 259,
    imageUrl:
        'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg',
  ),
  Product(
    id: 3,
    name: 'Solid Gold Petite Micropave',
    description:
        'Satisfaction Guaranteed. Return or exchange any order within 30 days.',
    category: 'jewelery',
    price: 168.00,
    rating: 3.9,
    reviewCount: 70,
    imageUrl: 'https://fakestoreapi.com/img/61sbMiUnoGL._AC_UL640_QL65_ML3_.jpg',
  ),
  Product(
    id: 4,
    name: 'WD 4TB Gaming Drive Works with Playstation 4 Portable External Hard Drive',
    description:
        'Expand your PS4 gaming experience, Play anywhere. Fast and easy, setup.',
    category: 'electronics',
    price: 114.00,
    rating: 4.8,
    reviewCount: 400,
    imageUrl: 'https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_.jpg',
  ),
  Product(
    id: 5,
    name: 'White Gold Plated Princess',
    description:
        'Classic Created Wedding Engagement Solitaire Diamond Promise Ring for Her.',
    category: 'jewelery',
    price: 9.99,
    rating: 3.0,
    reviewCount: 400,
    imageUrl: 'https://fakestoreapi.com/img/71YAIFU48IL._AC_UL640_QL65_ML3_.jpg',
  ),
  Product(
    id: 6,
    name: 'SanDisk SSD PLUS 1TB Internal SSD - SATA III 6 Gb/s',
    description:
        'Easy upgrade for faster boot up, shutdown, application load and response.',
    category: 'electronics',
    price: 109.00,
    rating: 4.8,
    reviewCount: 470,
    imageUrl: 'https://fakestoreapi.com/img/61U7T1koQqL._AC_SX679_.jpg',
  ),
];
