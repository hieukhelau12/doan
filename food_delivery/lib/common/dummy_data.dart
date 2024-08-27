import 'package:food_delivery/common/image_strings.dart';
import 'package:food_delivery/models/category_model.dart';
import 'package:food_delivery/models/restaurant_model.dart';

class DummyData {
  static final List<CategoryModel> categories = [
    CategoryModel(
        itemCategoryID: "1",
        categoryName: 'Cơm',
        imageUrl: ImageStrings.riceImage),
    CategoryModel(
        itemCategoryID: "2",
        categoryName: 'Pizza',
        imageUrl: ImageStrings.pizzaImage),
    CategoryModel(
        itemCategoryID: "3",
        categoryName: 'Trà sữa',
        imageUrl: ImageStrings.milkTeaImage),
    CategoryModel(
        itemCategoryID: "4",
        categoryName: 'Phở',
        imageUrl: ImageStrings.noodleImage),
    CategoryModel(
        itemCategoryID: "5",
        categoryName: 'Bánh mì',
        imageUrl: ImageStrings.breadImage),
    CategoryModel(
        itemCategoryID: "6",
        categoryName: 'Cà phê',
        imageUrl: ImageStrings.coffeeImage),
    CategoryModel(
        itemCategoryID: "7",
        categoryName: 'Gà rán',
        imageUrl: ImageStrings.chickenImage),
    CategoryModel(
        itemCategoryID: "8",
        categoryName: 'Bún chả',
        imageUrl: ImageStrings.bunchaImage),
  ];

  static final List<RestaurantModel> restaurants = [
    // Nhà hàng Cơm
    RestaurantModel(
        restaurantID: "1",
        restaurantName: "Cơm Thố Anh Nguyễn",
        address: "BT12 KĐT An Hưng, P.La Khê, Hà Đông, Hà Nội",
        openingTime: "10:00",
        closingTime: "22:00",
        imageUrl: ImageStrings.comThoImage),
    RestaurantModel(
        restaurantID: "2",
        restaurantName: "Cơm Gà Min Food",
        address: "40 Ngõ 1 Trần Văn Chuông, P.Yết Kiêu, Hà Đông, Hà Nội",
        openingTime: "00:00",
        closingTime: "23:59",
        imageUrl: ImageStrings.comGaImage),
    RestaurantModel(
        restaurantID: "3",
        restaurantName:
            "Cơm Tấm Delichi - Cơm Tấm Sườn Nướng, Cơm Tấm Sườn Bì Chả - Văn Phú",
        address: "14 Đường Hoàn Đôn Hoà, P.Phú La, Hà Đông, Hà Nội",
        openingTime: "10:00",
        closingTime: "22:00",
        imageUrl: ImageStrings.comTamImage),
    RestaurantModel(
        restaurantID: "4",
        restaurantName: "Cơm Văn Phòng & Cơm Niêu Hợp Tác Xã - Nguyễn Thái Học",
        address: "16 Ngõ 15 Nguyễn Thái Học, P.Quang Trung, Hà Đông, Hà Nội",
        openingTime: "9:00",
        closingTime: "22:00",
        imageUrl: ImageStrings.comVanPhongImage),
    // // Nhà hàng Pizza
    RestaurantModel(
        restaurantID: "5",
        restaurantName: "Let's Pizza - Pizza & Mỳ Ý - Ngô Thị Nhậm",
        address: "LK127, No07 Ngô Thị Nhậm, P.Hà Cầu, Hà Đông, Hà Nội",
        openingTime: "10:00",
        closingTime: "20:55",
        imageUrl: ImageStrings.letPizzaImage),
    RestaurantModel(
        restaurantID: "6",
        restaurantName: "The Pizza Company",
        address:
            "Tầng 2 Gian Hàng 271-272 Aeon Mall Hà Đông, P.Dương Nội, Hà Đông, Hà Nội",
        openingTime: "10:00",
        closingTime: "21:00",
        imageUrl: ImageStrings.thePizzaCompanyImage),
    RestaurantModel(
        restaurantID: "7",
        restaurantName: "Domino's Pizza",
        address:
            "SH02 Toà K1, The K Park, KĐT Văn Phú, P.Phú La, Hà Đông, Hà Nội",
        openingTime: "10:00",
        closingTime: "21:40",
        imageUrl: ImageStrings.dominoPizzaImage),
    RestaurantModel(
        restaurantID: "8",
        restaurantName: "BARATIE - Mỳ Ý, Pizza",
        address: "Số 12, Ngõ 18 Vạn Phúc, P.Vạn Phúc, Hà Đông, Hà Nội",
        openingTime: "10:00",
        closingTime: "21:00",
        imageUrl: ImageStrings.baratiePizzaImage),
    // // Nhà hàng Trà Sữa
    RestaurantModel(
        restaurantID: "9",
        restaurantName: "Trà Sữa Tocotoco - Chùa Láng",
        address: "97 Chùa Láng, P. Láng Thượng, Đống Đa, Hà Nội",
        openingTime: "09:30",
        closingTime: "22:00",
        imageUrl: ImageStrings.traSuaTocotocoImage),
    RestaurantModel(
        restaurantID: "10",
        restaurantName:
            "Trà Sữa Winggo - Trà Sữa Kem Trứng Nướng & Trà Hoa Quả",
        address: "158 Yên Hòa, Cầu Giấy, Hà Nội",
        openingTime: "09:00",
        closingTime: "21:00",
        imageUrl: ImageStrings.traSuaWinggoImage),
    RestaurantModel(
        restaurantID: "11",
        restaurantName: "Trà sữa Mixue",
        address: "Số 12 Phố Đồng Me, P. Mễ Trì, Nam Từ Liêm, Hà Nội",
        openingTime: "09:00",
        closingTime: "21:00",
        imageUrl: ImageStrings.traSuaMixueImage),
    RestaurantModel(
        restaurantID: "12",
        restaurantName: "The Alley - Trà Sữa Đài Loan",
        address: "48 Trần Phú, P. Mộ Lao, Hà Đông, Hà Nội",
        openingTime: "09:00",
        closingTime: "21:00",
        imageUrl: ImageStrings.traSuaTheAlleyImage),
    // Nhà hàng Phở
    RestaurantModel(
        restaurantID: "13",
        restaurantName: "Phở Lý Quốc Sư",
        address: "84 Cầu Bươu, X. Tân Triều, Thanh Trì, Hà Nội",
        openingTime: "06:00",
        closingTime: "22:00",
        imageUrl: ImageStrings.phoLyQuocSuImage),
    RestaurantModel(
        restaurantID: "14",
        restaurantName: "Hồng Ngọc - Phở Bò, Miến Trộn Ngan & Gà",
        address: "Ngõ 238 Ỷ La, P. Dương Nội, Hà Đông, Hà Nội",
        openingTime: "07:00",
        closingTime: "22:00",
        imageUrl: ImageStrings.phoHongNgocImage),
    RestaurantModel(
        restaurantID: "15",
        restaurantName: "Phở Thìn+ 13 Lò Đúc - Nguyễn Văn Lộc",
        address: "6 - LK6A Nguyễn Văn Lộc, P. Mộ Lao, Hà Đông, Hà Nội",
        openingTime: "08:00",
        closingTime: "22:00",
        imageUrl: ImageStrings.phoThinImage),
    // // Nhà hàng Bánh Mì
    RestaurantModel(
        restaurantID: "17",
        restaurantName: "Bánh Mì Dân Tổ - Bánh Mỳ - Lương Thế Vinh",
        address: "102 Ngõ 50 Lương Thế Vinh, P. Trung Văn, Nam Từ Liêm, Hà Nội",
        openingTime: "08:00",
        closingTime: "22:00",
        imageUrl: ImageStrings.banhMiDanToImage),
    RestaurantModel(
        restaurantID: "18",
        restaurantName: "Cột Điện Quán - Bánh Mì Chảo - 128 Quang Trung",
        address: "128 Quang Trung, P. Quang Trung, Hà Đông, Hà Nội",
        openingTime: "08:00",
        closingTime: "21:00",
        imageUrl: ImageStrings.banhMiChaoImage),
    RestaurantModel(
        restaurantID: "20",
        restaurantName: "Bánh Mì Chả Nóng Long Đỉnh - Nguyễn Tuân",
        address: "8A/172 Nguyễn Tuân, P. Thanh Xuân Trung, Thanh Xuân, Hà Nội",
        openingTime: "07:00",
        closingTime: "22:00",
        imageUrl: ImageStrings.banhMiChaNongImage),
    // // Nhà hàng Cà Phê
    RestaurantModel(
        restaurantID: "21",
        restaurantName: "Laika - Café - KĐT Văn Quán",
        address: "58 BT8 Văn Quán, P. Văn Quán, Hà Đông, Hà Nội",
        openingTime: "09:00",
        closingTime: "22:00",
        imageUrl: ImageStrings.caPheLaikaImage),
    RestaurantModel(
        restaurantID: "22",
        restaurantName: "The Coffee House - 38 Nguyễn Khuyến",
        address: "38 Nguyễn Khuyến, P. Văn Quán, Hà Đông, Hà Nội",
        openingTime: "09:00",
        closingTime: "22:00",
        imageUrl: ImageStrings.theCoffeeHouseImage),
    RestaurantModel(
        restaurantID: "23",
        restaurantName:
            "Highlands Coffee - Trà, Cà Phê & Bánh - 495 Nguyễn Trãi",
        address: "495 Nguyễn Trãi, P. Thanh Xuân Nam, Thanh Xuân, Hà Nội",
        openingTime: "09:00",
        closingTime: "22:00",
        imageUrl: ImageStrings.highlandsCoffeeImage),
    RestaurantModel(
        restaurantID: "24",
        restaurantName: "Starbucks Coffee - Royal City",
        address:
            "Sảnh A, Tòa R3 Royal City, 72A Nguyễn Trãi, P. Thượng Đình, Thanh Xuân, Hà Nội",
        openingTime: "09:00",
        closingTime: "22:00",
        imageUrl: ImageStrings.starbucksCoffeeImage),
    // // Nhà hàng Gà Rán
    RestaurantModel(
        restaurantID: "25",
        restaurantName: "Gà Rán KFC - Quang Trung Hà Đông",
        address: "484 Quang Trung, P. La Khê, Hà Đông, Hà Nội",
        openingTime: "10:00",
        closingTime: "22:00",
        imageUrl: ImageStrings.gaRanKFCImage),
    RestaurantModel(
        restaurantID: "26",
        restaurantName: "Gà Rán Popeyes - Quang Trung HN",
        address: "495 Quang Trung, P. Phú La, Hà Đông, Hà Nội",
        openingTime: "10:00",
        closingTime: "22:00",
        imageUrl: ImageStrings.gaRanPopeyesImage),
    RestaurantModel(
        restaurantID: "27",
        restaurantName: "GÀ RÁN & BURGER GONGFU CHICKEN - 521 Nguyễn Trãi",
        address: "521 Nguyễn Trãi, P. Thanh Xuân Nam, Thanh Xuân, Hà Nội",
        openingTime: "9:00",
        closingTime: "23:40",
        imageUrl: ImageStrings.gaRanGongfuImage),
    RestaurantModel(
        restaurantID: "28",
        restaurantName: "Texas Chicken - Trần Phú",
        address: "97A Đường Trần Phú, P.Văn Quán, Hà Đông, Hà Nội",
        openingTime: "9:00",
        closingTime: "22:00",
        imageUrl: ImageStrings.gaRanTexasImage),
    // Nhà hàng Bún Chả
    RestaurantModel(
        restaurantID: "29",
        restaurantName: "Bún Chả Kinh Kỳ - Nguyễn Văn Lộc",
        address: "176 Nguyễn Văn Lộc, P. Mỗ Lao, Hà Đông, Hà Nội",
        openingTime: "9:00",
        closingTime: "22:00",
        imageUrl: ImageStrings.bunChaKinhKyImage),
    RestaurantModel(
        restaurantID: "30",
        restaurantName: "Bún Chả Phương Anh - Ao Sen",
        address: "15a Ngõ 3 Ao Sen, Mộ Lao, Hà Đông, Hà Nội",
        openingTime: "10:00",
        closingTime: "22:00",
        imageUrl: ImageStrings.bunChaPhuongAnhImage),
    RestaurantModel(
        restaurantID: "31",
        restaurantName: "Bún Chả Sinh Từ - Nguyễn Văn Lộc",
        address:
            "KĐT Liền Kề 3C-6,7,8,9 Nguyễn Văn Lộc, KĐT Mộ Lao, P. Mộ Lao, Hà Đông, Hà Nội",
        openingTime: "8:00",
        closingTime: "23:00",
        imageUrl: ImageStrings.bunChaSinhTuImage),
    RestaurantModel(
        restaurantID: "32",
        restaurantName: "Bún Chả Obama - HD Mon City",
        address: "HD Mon City, TT 03-17, P. Mỹ Đình 2, Nam Từ Liêm, Hà Nội",
        openingTime: "9:00",
        closingTime: "22:00",
        imageUrl: ImageStrings.bunChaObamaImage),
  ];
}
