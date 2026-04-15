 class AppStrings {
  static const appName = "HN-mart";

// Preference Keys
  static const isLogIn = "isLogIn";
  static const dummyValue = "dummyValue";
  static const accessToken = "accessToken";
  static const businessLocations = "businessLocations";
  static const locationsList = "locationsList";
  static const paymentList = "paymentList";
  static const denominationList = "denominationList";
  static const permittedList = "permittedList";
  static const selectedAddress = "selectedAddress";
  static const selectedHub = "selectedHub";
  static const isCash = "isCash";
  static const cashId = "cashId";
  static const userName = "userName";
  static const qrCodeImage = "qrCodeImage";
  static const excelPath = "excelPath";
  static const isUpdate = "isUpdate";
  static const taxType = "taxType";
  static const isTax = "isTax";
  static const taxRate = "taxRate";

// Api URLs
  static const userLoginUrl = "api/login";
  static const getAllCategoryProductUrl =
      "api/getcategory?category_type=product";
  static const getCategoryProductListUrl = "api/getProductSuggestion";
  static const getScannedProductUrl = "api/products/list";
  static const orderHoldUrl = "api/admin/pos/holdorder";
  static const placeOrderUrl = "api/posSave";
  static const recallHoldOrderUrl =
      "api/pos/get-recent-transactions?status=draft";
  static const viewReceiptUrl = "api/pos/get-recent-transactions?status=final";
  static const recallHoldOrderDetailsUrl = "api/pos/";
  static const recallOrderUpdateUrl = "api/posupdate/";
  static const purchaseSellReportUrl = "api/reports/daily-report";
  static const cashDrawerRegisterUrl = "api/cash-register/create";
  static const cashDrawerCloseUrl = "api/cash-register/close";
  static const cashDrawerStatusUrl = "api/cash-register";
  static const cashDrawerDetailsUrl = "api/cash-register/show/";
  static const initialDataUrl = "api/getdata";
  static const excelDataUrl = "api/download/excel";
  static const stockTransferUrl = "api/stock-transfers";
  static const contactUrl = "api/contacts";
  static const contactSearchUrl = "api/contacts/customers?q=";
}
