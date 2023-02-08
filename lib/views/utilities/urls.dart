// ignore_for_file: constant_identifier_names

class Urls {
  //Base
  static const baseUrl = "https://mobidudes.com/SAK/musika/api/";
  static const imageUrl = "https://mobidudes.com/SAK/musika/";

  //Other Apis
  static const loginUrl = "${baseUrl}login";
  static const logoutUrl = "${baseUrl}user/logout";
  static const registerUrl = "${baseUrl}register";
  static const profileUrl = "${baseUrl}user/get-profile";
  static const updateProfileUrl = "${baseUrl}user/update-profile";
  static const getAddressUrl = "${baseUrl}user/get-address";
  static const addupadteAddressUrl = "${baseUrl}user/add-address";
  static const deleteupadteAddressUrl = "${baseUrl}user/delete-address";
  static const categoriesUrl = "${baseUrl}user/categories";
  static const homeapiUrl = "${baseUrl}user/home";
  static const vendorsUrl = "${baseUrl}user/get-vendor";
  static const vendorsProductUrl = "${baseUrl}user/get-vendor-product";
  static const productDetailUrl = "${baseUrl}user/productdetails";
  static const addToCartUrl = "${baseUrl}user/add-to-cart";
  static const getCartUrl = "${baseUrl}user/get-cart";
  static const deleteCartUrl = "${baseUrl}user/delete-from-cart";
  static const getWalletUrl = "${baseUrl}user/get-wallet";
  static const myOrderUrl = "${baseUrl}user/myorder";
  static const placeOrderUrl = "${baseUrl}user/order";
  static const reviewUrl = "${baseUrl}user/review";
  static const searchUrl = "${baseUrl}user/search";
  static const tncUrl = "${baseUrl}tnc";
  static const privacyPolicyUrl = "${baseUrl}privacy-policy";
}