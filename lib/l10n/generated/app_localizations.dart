import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ta.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ta'),
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'BuildStock'**
  String get appName;

  /// No description provided for @businessNameDefault.
  ///
  /// In en, this message translates to:
  /// **'Vijay Balaji Agency'**
  String get businessNameDefault;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navSales.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get navSales;

  /// No description provided for @navPurchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get navPurchase;

  /// No description provided for @navLogBook.
  ///
  /// In en, this message translates to:
  /// **'Log Book'**
  String get navLogBook;

  /// No description provided for @navAccounts.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get navAccounts;

  /// No description provided for @navDayBook.
  ///
  /// In en, this message translates to:
  /// **'Day Book'**
  String get navDayBook;

  /// No description provided for @navProducts.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get navProducts;

  /// No description provided for @navInventory.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get navInventory;

  /// No description provided for @navStores.
  ///
  /// In en, this message translates to:
  /// **'Stores & Godowns'**
  String get navStores;

  /// No description provided for @navCustomers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get navCustomers;

  /// No description provided for @navSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get navSuppliers;

  /// No description provided for @navStaff.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get navStaff;

  /// No description provided for @navDrivers.
  ///
  /// In en, this message translates to:
  /// **'Drivers'**
  String get navDrivers;

  /// No description provided for @navSalary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get navSalary;

  /// No description provided for @navDeliveries.
  ///
  /// In en, this message translates to:
  /// **'Deliveries'**
  String get navDeliveries;

  /// No description provided for @navReports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get navReports;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @navMore.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get navMore;

  /// No description provided for @navSync.
  ///
  /// In en, this message translates to:
  /// **'Sync Center'**
  String get navSync;

  /// No description provided for @commonAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get commonAdd;

  /// No description provided for @commonEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get commonEdit;

  /// No description provided for @commonSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get commonSave;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @commonArchive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get commonArchive;

  /// No description provided for @commonSearch.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get commonSearch;

  /// No description provided for @commonFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter'**
  String get commonFilter;

  /// No description provided for @commonRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get commonRetry;

  /// No description provided for @commonDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get commonDone;

  /// No description provided for @commonNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get commonNext;

  /// No description provided for @commonBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get commonBack;

  /// No description provided for @commonClose.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get commonClose;

  /// No description provided for @commonTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get commonTotal;

  /// No description provided for @commonToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get commonToday;

  /// No description provided for @commonAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get commonAll;

  /// No description provided for @commonNone.
  ///
  /// In en, this message translates to:
  /// **'None'**
  String get commonNone;

  /// No description provided for @commonRequired.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get commonRequired;

  /// No description provided for @commonOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get commonOptional;

  /// No description provided for @commonStatus.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get commonStatus;

  /// No description provided for @commonDate.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get commonDate;

  /// No description provided for @commonAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get commonAmount;

  /// No description provided for @commonQuantity.
  ///
  /// In en, this message translates to:
  /// **'Quantity'**
  String get commonQuantity;

  /// No description provided for @commonRate.
  ///
  /// In en, this message translates to:
  /// **'Rate'**
  String get commonRate;

  /// No description provided for @commonNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get commonNotes;

  /// No description provided for @commonPhone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get commonPhone;

  /// No description provided for @commonAddress.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get commonAddress;

  /// No description provided for @commonName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get commonName;

  /// No description provided for @commonEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get commonEmail;

  /// No description provided for @commonActions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get commonActions;

  /// No description provided for @commonView.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get commonView;

  /// No description provided for @commonShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get commonShare;

  /// No description provided for @commonPrint.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get commonPrint;

  /// No description provided for @commonDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get commonDownload;

  /// No description provided for @commonPreview.
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get commonPreview;

  /// No description provided for @commonNoRecords.
  ///
  /// In en, this message translates to:
  /// **'No records yet'**
  String get commonNoRecords;

  /// No description provided for @commonNoResults.
  ///
  /// In en, this message translates to:
  /// **'No matching records'**
  String get commonNoResults;

  /// No description provided for @commonLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading…'**
  String get commonLoading;

  /// No description provided for @commonError.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get commonError;

  /// No description provided for @commonOfflineNote.
  ///
  /// In en, this message translates to:
  /// **'Saved on this device. It will sync when online.'**
  String get commonOfflineNote;

  /// No description provided for @commonSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get commonSynced;

  /// No description provided for @commonPending.
  ///
  /// In en, this message translates to:
  /// **'Pending sync'**
  String get commonPending;

  /// No description provided for @commonFailed.
  ///
  /// In en, this message translates to:
  /// **'Sync failed'**
  String get commonFailed;

  /// No description provided for @commonConflict.
  ///
  /// In en, this message translates to:
  /// **'Needs review'**
  String get commonConflict;

  /// No description provided for @commonWalkIn.
  ///
  /// In en, this message translates to:
  /// **'Walk-in customer'**
  String get commonWalkIn;

  /// No description provided for @commonPaise.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get commonPaise;

  /// No description provided for @dashboardTodaySales.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Sales'**
  String get dashboardTodaySales;

  /// No description provided for @dashboardTodayPurchases.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Purchases'**
  String get dashboardTodayPurchases;

  /// No description provided for @dashboardTodayExpenses.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Expenses'**
  String get dashboardTodayExpenses;

  /// No description provided for @dashboardReceivables.
  ///
  /// In en, this message translates to:
  /// **'Customer Outstanding'**
  String get dashboardReceivables;

  /// No description provided for @dashboardPayables.
  ///
  /// In en, this message translates to:
  /// **'Supplier Payable'**
  String get dashboardPayables;

  /// No description provided for @dashboardLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low Stock'**
  String get dashboardLowStock;

  /// No description provided for @dashboardPendingDeliveries.
  ///
  /// In en, this message translates to:
  /// **'Pending Deliveries'**
  String get dashboardPendingDeliveries;

  /// No description provided for @dashboardPendingSalaries.
  ///
  /// In en, this message translates to:
  /// **'Pending Salaries'**
  String get dashboardPendingSalaries;

  /// No description provided for @dashboardRecentInvoices.
  ///
  /// In en, this message translates to:
  /// **'Recent Invoices'**
  String get dashboardRecentInvoices;

  /// No description provided for @dashboardQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get dashboardQuickActions;

  /// No description provided for @dashboardEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'Your business starts here'**
  String get dashboardEmptyTitle;

  /// No description provided for @dashboardEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add your business profile, then create your first product and invoice. Nothing is pre-filled with sample data.'**
  String get dashboardEmptyBody;

  /// No description provided for @dashboardSetupBusiness.
  ///
  /// In en, this message translates to:
  /// **'Set up business profile'**
  String get dashboardSetupBusiness;

  /// No description provided for @dashboardSyncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get dashboardSyncNow;

  /// No description provided for @productTitle.
  ///
  /// In en, this message translates to:
  /// **'Products'**
  String get productTitle;

  /// No description provided for @productAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Product'**
  String get productAdd;

  /// No description provided for @productEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit Product'**
  String get productEdit;

  /// No description provided for @productName.
  ///
  /// In en, this message translates to:
  /// **'Product name'**
  String get productName;

  /// No description provided for @productSku.
  ///
  /// In en, this message translates to:
  /// **'SKU'**
  String get productSku;

  /// No description provided for @productBarcode.
  ///
  /// In en, this message translates to:
  /// **'Barcode'**
  String get productBarcode;

  /// No description provided for @productCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get productCategory;

  /// No description provided for @productBrand.
  ///
  /// In en, this message translates to:
  /// **'Brand'**
  String get productBrand;

  /// No description provided for @productUnit.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get productUnit;

  /// No description provided for @productHsn.
  ///
  /// In en, this message translates to:
  /// **'HSN code'**
  String get productHsn;

  /// No description provided for @productGst.
  ///
  /// In en, this message translates to:
  /// **'GST rate %'**
  String get productGst;

  /// No description provided for @productPurchasePrice.
  ///
  /// In en, this message translates to:
  /// **'Purchase price'**
  String get productPurchasePrice;

  /// No description provided for @productRetailPrice.
  ///
  /// In en, this message translates to:
  /// **'Retail price'**
  String get productRetailPrice;

  /// No description provided for @productWholesalePrice.
  ///
  /// In en, this message translates to:
  /// **'Wholesale price'**
  String get productWholesalePrice;

  /// No description provided for @productMinStock.
  ///
  /// In en, this message translates to:
  /// **'Minimum stock'**
  String get productMinStock;

  /// No description provided for @productDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get productDescription;

  /// No description provided for @productImage.
  ///
  /// In en, this message translates to:
  /// **'Product image'**
  String get productImage;

  /// No description provided for @productActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get productActive;

  /// No description provided for @productStock.
  ///
  /// In en, this message translates to:
  /// **'Stock'**
  String get productStock;

  /// No description provided for @productSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search name, SKU or barcode'**
  String get productSearchHint;

  /// No description provided for @productEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No products yet'**
  String get productEmptyTitle;

  /// No description provided for @productEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Add the materials you actually sell. Start with cement, sand, bricks or any custom item.'**
  String get productEmptyBody;

  /// No description provided for @productSaved.
  ///
  /// In en, this message translates to:
  /// **'Product saved'**
  String get productSaved;

  /// No description provided for @productDuplicateSku.
  ///
  /// In en, this message translates to:
  /// **'This SKU is already used by another product.'**
  String get productDuplicateSku;

  /// No description provided for @categoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoryTitle;

  /// No description provided for @brandTitle.
  ///
  /// In en, this message translates to:
  /// **'Brands'**
  String get brandTitle;

  /// No description provided for @unitTitle.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get unitTitle;

  /// No description provided for @inventoryTitle.
  ///
  /// In en, this message translates to:
  /// **'Inventory'**
  String get inventoryTitle;

  /// No description provided for @inventoryStockValue.
  ///
  /// In en, this message translates to:
  /// **'Stock value'**
  String get inventoryStockValue;

  /// No description provided for @inventoryLowStock.
  ///
  /// In en, this message translates to:
  /// **'Low stock'**
  String get inventoryLowStock;

  /// No description provided for @inventoryLedger.
  ///
  /// In en, this message translates to:
  /// **'Stock ledger'**
  String get inventoryLedger;

  /// No description provided for @inventoryAdjust.
  ///
  /// In en, this message translates to:
  /// **'Adjust stock'**
  String get inventoryAdjust;

  /// No description provided for @inventoryTransfer.
  ///
  /// In en, this message translates to:
  /// **'Transfer stock'**
  String get inventoryTransfer;

  /// No description provided for @inventoryOpening.
  ///
  /// In en, this message translates to:
  /// **'Opening stock'**
  String get inventoryOpening;

  /// No description provided for @inventoryLocation.
  ///
  /// In en, this message translates to:
  /// **'Store / Godown'**
  String get inventoryLocation;

  /// No description provided for @inventoryInStock.
  ///
  /// In en, this message translates to:
  /// **'In stock'**
  String get inventoryInStock;

  /// No description provided for @inventoryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No stock records'**
  String get inventoryEmptyTitle;

  /// No description provided for @inventoryEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Stock appears here after opening stock, purchases or sales.'**
  String get inventoryEmptyBody;

  /// No description provided for @inventoryAdjustmentSaved.
  ///
  /// In en, this message translates to:
  /// **'Stock adjustment recorded'**
  String get inventoryAdjustmentSaved;

  /// No description provided for @customerTitle.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customerTitle;

  /// No description provided for @customerAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get customerAdd;

  /// No description provided for @customerType.
  ///
  /// In en, this message translates to:
  /// **'Customer type'**
  String get customerType;

  /// No description provided for @customerOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get customerOutstanding;

  /// No description provided for @customerLedger.
  ///
  /// In en, this message translates to:
  /// **'Customer ledger'**
  String get customerLedger;

  /// No description provided for @customerCreditLimit.
  ///
  /// In en, this message translates to:
  /// **'Credit limit'**
  String get customerCreditLimit;

  /// No description provided for @customerGstin.
  ///
  /// In en, this message translates to:
  /// **'GSTIN'**
  String get customerGstin;

  /// No description provided for @customerOpeningBalance.
  ///
  /// In en, this message translates to:
  /// **'Opening balance'**
  String get customerOpeningBalance;

  /// No description provided for @supplierTitle.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get supplierTitle;

  /// No description provided for @supplierAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Supplier'**
  String get supplierAdd;

  /// No description provided for @supplierPayable.
  ///
  /// In en, this message translates to:
  /// **'Payable'**
  String get supplierPayable;

  /// No description provided for @supplierLedger.
  ///
  /// In en, this message translates to:
  /// **'Supplier ledger'**
  String get supplierLedger;

  /// No description provided for @storeTitle.
  ///
  /// In en, this message translates to:
  /// **'Stores & Godowns'**
  String get storeTitle;

  /// No description provided for @storeAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Store'**
  String get storeAdd;

  /// No description provided for @godownAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Godown'**
  String get godownAdd;

  /// No description provided for @storeManager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get storeManager;

  /// No description provided for @storeCode.
  ///
  /// In en, this message translates to:
  /// **'Store code'**
  String get storeCode;

  /// No description provided for @godownCapacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity'**
  String get godownCapacity;

  /// No description provided for @staffTitle.
  ///
  /// In en, this message translates to:
  /// **'Staff'**
  String get staffTitle;

  /// No description provided for @staffAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Staff'**
  String get staffAdd;

  /// No description provided for @staffCode.
  ///
  /// In en, this message translates to:
  /// **'Employee code'**
  String get staffCode;

  /// No description provided for @staffDesignation.
  ///
  /// In en, this message translates to:
  /// **'Designation'**
  String get staffDesignation;

  /// No description provided for @staffDepartment.
  ///
  /// In en, this message translates to:
  /// **'Department'**
  String get staffDepartment;

  /// No description provided for @staffJoiningDate.
  ///
  /// In en, this message translates to:
  /// **'Joining date'**
  String get staffJoiningDate;

  /// No description provided for @staffEmploymentType.
  ///
  /// In en, this message translates to:
  /// **'Employment type'**
  String get staffEmploymentType;

  /// No description provided for @staffSalaryType.
  ///
  /// In en, this message translates to:
  /// **'Salary type'**
  String get staffSalaryType;

  /// No description provided for @staffBasicSalary.
  ///
  /// In en, this message translates to:
  /// **'Basic salary'**
  String get staffBasicSalary;

  /// No description provided for @staffRole.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get staffRole;

  /// No description provided for @driverTitle.
  ///
  /// In en, this message translates to:
  /// **'Drivers'**
  String get driverTitle;

  /// No description provided for @driverAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Driver'**
  String get driverAdd;

  /// No description provided for @driverLicence.
  ///
  /// In en, this message translates to:
  /// **'Licence number'**
  String get driverLicence;

  /// No description provided for @driverLicenceExpiry.
  ///
  /// In en, this message translates to:
  /// **'Licence expiry'**
  String get driverLicenceExpiry;

  /// No description provided for @vehicleTitle.
  ///
  /// In en, this message translates to:
  /// **'Vehicles'**
  String get vehicleTitle;

  /// No description provided for @vehicleAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Vehicle'**
  String get vehicleAdd;

  /// No description provided for @vehicleRegistration.
  ///
  /// In en, this message translates to:
  /// **'Registration number'**
  String get vehicleRegistration;

  /// No description provided for @attendanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Attendance'**
  String get attendanceTitle;

  /// No description provided for @attendanceMark.
  ///
  /// In en, this message translates to:
  /// **'Mark attendance'**
  String get attendanceMark;

  /// No description provided for @attendancePresent.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get attendancePresent;

  /// No description provided for @attendanceAbsent.
  ///
  /// In en, this message translates to:
  /// **'Absent'**
  String get attendanceAbsent;

  /// No description provided for @attendanceHalfDay.
  ///
  /// In en, this message translates to:
  /// **'Half day'**
  String get attendanceHalfDay;

  /// No description provided for @attendancePaidLeave.
  ///
  /// In en, this message translates to:
  /// **'Paid leave'**
  String get attendancePaidLeave;

  /// No description provided for @attendanceUnpaidLeave.
  ///
  /// In en, this message translates to:
  /// **'Unpaid leave'**
  String get attendanceUnpaidLeave;

  /// No description provided for @salaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salaryTitle;

  /// No description provided for @salaryGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate salary'**
  String get salaryGenerate;

  /// No description provided for @salaryNet.
  ///
  /// In en, this message translates to:
  /// **'Net salary'**
  String get salaryNet;

  /// No description provided for @salaryPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get salaryPaid;

  /// No description provided for @salaryPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get salaryPending;

  /// No description provided for @salaryPay.
  ///
  /// In en, this message translates to:
  /// **'Record payment'**
  String get salaryPay;

  /// No description provided for @salaryPeriod.
  ///
  /// In en, this message translates to:
  /// **'Salary period'**
  String get salaryPeriod;

  /// No description provided for @deliveryTitle.
  ///
  /// In en, this message translates to:
  /// **'Deliveries'**
  String get deliveryTitle;

  /// No description provided for @deliveryAdd.
  ///
  /// In en, this message translates to:
  /// **'Create Delivery'**
  String get deliveryAdd;

  /// No description provided for @deliveryAssignDriver.
  ///
  /// In en, this message translates to:
  /// **'Assign driver'**
  String get deliveryAssignDriver;

  /// No description provided for @deliveryStatus.
  ///
  /// In en, this message translates to:
  /// **'Delivery status'**
  String get deliveryStatus;

  /// No description provided for @deliveryAddress.
  ///
  /// In en, this message translates to:
  /// **'Delivery address'**
  String get deliveryAddress;

  /// No description provided for @deliveryCharge.
  ///
  /// In en, this message translates to:
  /// **'Delivery charge'**
  String get deliveryCharge;

  /// No description provided for @deliveryProof.
  ///
  /// In en, this message translates to:
  /// **'Proof of delivery'**
  String get deliveryProof;

  /// No description provided for @deliveryEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No deliveries yet'**
  String get deliveryEmptyTitle;

  /// No description provided for @deliveryEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Create a delivery from a finalized invoice.'**
  String get deliveryEmptyBody;

  /// No description provided for @salesTitle.
  ///
  /// In en, this message translates to:
  /// **'Sales'**
  String get salesTitle;

  /// No description provided for @salesNewInvoice.
  ///
  /// In en, this message translates to:
  /// **'New Invoice'**
  String get salesNewInvoice;

  /// No description provided for @salesRetail.
  ///
  /// In en, this message translates to:
  /// **'Retail'**
  String get salesRetail;

  /// No description provided for @salesWholesale.
  ///
  /// In en, this message translates to:
  /// **'Wholesale'**
  String get salesWholesale;

  /// No description provided for @salesCart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get salesCart;

  /// No description provided for @salesEmptyCart.
  ///
  /// In en, this message translates to:
  /// **'Cart is empty'**
  String get salesEmptyCart;

  /// No description provided for @salesAddProducts.
  ///
  /// In en, this message translates to:
  /// **'Add products'**
  String get salesAddProducts;

  /// No description provided for @salesCheckout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get salesCheckout;

  /// No description provided for @salesCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get salesCustomer;

  /// No description provided for @salesAddCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add customer'**
  String get salesAddCustomer;

  /// No description provided for @salesGst.
  ///
  /// In en, this message translates to:
  /// **'GST invoice'**
  String get salesGst;

  /// No description provided for @salesDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get salesDiscount;

  /// No description provided for @salesSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get salesSubtotal;

  /// No description provided for @salesTaxable.
  ///
  /// In en, this message translates to:
  /// **'Taxable amount'**
  String get salesTaxable;

  /// No description provided for @salesCgst.
  ///
  /// In en, this message translates to:
  /// **'CGST'**
  String get salesCgst;

  /// No description provided for @salesSgst.
  ///
  /// In en, this message translates to:
  /// **'SGST'**
  String get salesSgst;

  /// No description provided for @salesIgst.
  ///
  /// In en, this message translates to:
  /// **'IGST'**
  String get salesIgst;

  /// No description provided for @salesGrandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get salesGrandTotal;

  /// No description provided for @salesAmountPaid.
  ///
  /// In en, this message translates to:
  /// **'Amount paid'**
  String get salesAmountPaid;

  /// No description provided for @salesBalanceDue.
  ///
  /// In en, this message translates to:
  /// **'Balance due'**
  String get salesBalanceDue;

  /// No description provided for @salesPaymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment method'**
  String get salesPaymentMethod;

  /// No description provided for @salesFinalize.
  ///
  /// In en, this message translates to:
  /// **'Finalize invoice'**
  String get salesFinalize;

  /// No description provided for @salesSaveDraft.
  ///
  /// In en, this message translates to:
  /// **'Save draft'**
  String get salesSaveDraft;

  /// No description provided for @salesInsufficientStock.
  ///
  /// In en, this message translates to:
  /// **'Insufficient stock'**
  String get salesInsufficientStock;

  /// No description provided for @salesInvoiceSaved.
  ///
  /// In en, this message translates to:
  /// **'Invoice saved'**
  String get salesInvoiceSaved;

  /// No description provided for @salesInvoiceFinalized.
  ///
  /// In en, this message translates to:
  /// **'Invoice finalized'**
  String get salesInvoiceFinalized;

  /// No description provided for @salesSelectProduct.
  ///
  /// In en, this message translates to:
  /// **'Select product'**
  String get salesSelectProduct;

  /// No description provided for @invoiceTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get invoiceTitle;

  /// No description provided for @invoiceHistory.
  ///
  /// In en, this message translates to:
  /// **'Invoice history'**
  String get invoiceHistory;

  /// No description provided for @invoiceNumber.
  ///
  /// In en, this message translates to:
  /// **'Bill No'**
  String get invoiceNumber;

  /// No description provided for @invoiceDate.
  ///
  /// In en, this message translates to:
  /// **'Invoice date'**
  String get invoiceDate;

  /// No description provided for @invoicePreview.
  ///
  /// In en, this message translates to:
  /// **'Invoice Preview'**
  String get invoicePreview;

  /// No description provided for @invoicePdf.
  ///
  /// In en, this message translates to:
  /// **'Download PDF'**
  String get invoicePdf;

  /// No description provided for @invoiceImage.
  ///
  /// In en, this message translates to:
  /// **'Download image'**
  String get invoiceImage;

  /// No description provided for @invoiceShare.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get invoiceShare;

  /// No description provided for @invoicePrint.
  ///
  /// In en, this message translates to:
  /// **'Print'**
  String get invoicePrint;

  /// No description provided for @invoiceThermal.
  ///
  /// In en, this message translates to:
  /// **'Thermal print'**
  String get invoiceThermal;

  /// No description provided for @invoiceNotFound.
  ///
  /// In en, this message translates to:
  /// **'Invoice not found'**
  String get invoiceNotFound;

  /// No description provided for @invoiceNotFoundBody.
  ///
  /// In en, this message translates to:
  /// **'This bill is not available on this device. Connect to the internet to retrieve it from the cloud.'**
  String get invoiceNotFoundBody;

  /// No description provided for @invoiceFinalizedLocked.
  ///
  /// In en, this message translates to:
  /// **'Finalized invoices cannot be edited. Use a return or cancellation.'**
  String get invoiceFinalizedLocked;

  /// No description provided for @invoiceCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel invoice'**
  String get invoiceCancel;

  /// No description provided for @invoiceSeller.
  ///
  /// In en, this message translates to:
  /// **'Seller'**
  String get invoiceSeller;

  /// No description provided for @invoiceBuyer.
  ///
  /// In en, this message translates to:
  /// **'Buyer'**
  String get invoiceBuyer;

  /// No description provided for @invoiceUpiQr.
  ///
  /// In en, this message translates to:
  /// **'Scan to pay with UPI'**
  String get invoiceUpiQr;

  /// No description provided for @invoiceReferenceQr.
  ///
  /// In en, this message translates to:
  /// **'Invoice reference QR'**
  String get invoiceReferenceQr;

  /// No description provided for @invoiceRecordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record payment'**
  String get invoiceRecordPayment;

  /// No description provided for @invoiceAmountInWords.
  ///
  /// In en, this message translates to:
  /// **'Amount in words'**
  String get invoiceAmountInWords;

  /// No description provided for @estimateTitle.
  ///
  /// In en, this message translates to:
  /// **'Estimates'**
  String get estimateTitle;

  /// No description provided for @estimateAdd.
  ///
  /// In en, this message translates to:
  /// **'New Estimate'**
  String get estimateAdd;

  /// No description provided for @estimateValidUntil.
  ///
  /// In en, this message translates to:
  /// **'Valid until'**
  String get estimateValidUntil;

  /// No description provided for @estimateConvert.
  ///
  /// In en, this message translates to:
  /// **'Convert to invoice'**
  String get estimateConvert;

  /// No description provided for @purchaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Purchases'**
  String get purchaseTitle;

  /// No description provided for @purchaseAdd.
  ///
  /// In en, this message translates to:
  /// **'New Purchase'**
  String get purchaseAdd;

  /// No description provided for @purchaseSupplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get purchaseSupplier;

  /// No description provided for @purchaseSupplierInvoice.
  ///
  /// In en, this message translates to:
  /// **'Supplier invoice no.'**
  String get purchaseSupplierInvoice;

  /// No description provided for @purchaseEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No purchases yet'**
  String get purchaseEmptyTitle;

  /// No description provided for @purchaseEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Record stock received from suppliers. Stock increases only through real purchase entries.'**
  String get purchaseEmptyBody;

  /// No description provided for @expenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenseTitle;

  /// No description provided for @expenseAdd.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get expenseAdd;

  /// No description provided for @expenseCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get expenseCategory;

  /// No description provided for @expenseDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get expenseDescription;

  /// No description provided for @accountsTitle.
  ///
  /// In en, this message translates to:
  /// **'Accounts'**
  String get accountsTitle;

  /// No description provided for @accountsCashBook.
  ///
  /// In en, this message translates to:
  /// **'Cash Book'**
  String get accountsCashBook;

  /// No description provided for @accountsBankBook.
  ///
  /// In en, this message translates to:
  /// **'Bank Book'**
  String get accountsBankBook;

  /// No description provided for @accountsDayBook.
  ///
  /// In en, this message translates to:
  /// **'Day Book'**
  String get accountsDayBook;

  /// No description provided for @accountsReceivables.
  ///
  /// In en, this message translates to:
  /// **'Receivables'**
  String get accountsReceivables;

  /// No description provided for @accountsPayables.
  ///
  /// In en, this message translates to:
  /// **'Payables'**
  String get accountsPayables;

  /// No description provided for @accountsIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get accountsIncome;

  /// No description provided for @reportsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reportsTitle;

  /// No description provided for @reportsSales.
  ///
  /// In en, this message translates to:
  /// **'Sales report'**
  String get reportsSales;

  /// No description provided for @reportsStock.
  ///
  /// In en, this message translates to:
  /// **'Stock report'**
  String get reportsStock;

  /// No description provided for @reportsOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding report'**
  String get reportsOutstanding;

  /// No description provided for @reportsGst.
  ///
  /// In en, this message translates to:
  /// **'GST report'**
  String get reportsGst;

  /// No description provided for @reportsExport.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get reportsExport;

  /// No description provided for @reportsDateRange.
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get reportsDateRange;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsBusinessProfile.
  ///
  /// In en, this message translates to:
  /// **'Business Profile'**
  String get settingsBusinessProfile;

  /// No description provided for @settingsAppearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearance;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsInvoice.
  ///
  /// In en, this message translates to:
  /// **'Invoice & Numbering'**
  String get settingsInvoice;

  /// No description provided for @settingsGst.
  ///
  /// In en, this message translates to:
  /// **'GST Configuration'**
  String get settingsGst;

  /// No description provided for @settingsUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI Configuration'**
  String get settingsUpi;

  /// No description provided for @settingsPrinter.
  ///
  /// In en, this message translates to:
  /// **'Printer'**
  String get settingsPrinter;

  /// No description provided for @settingsUsers.
  ///
  /// In en, this message translates to:
  /// **'Users & Permissions'**
  String get settingsUsers;

  /// No description provided for @settingsDevices.
  ///
  /// In en, this message translates to:
  /// **'Devices'**
  String get settingsDevices;

  /// No description provided for @settingsSync.
  ///
  /// In en, this message translates to:
  /// **'Synchronization'**
  String get settingsSync;

  /// No description provided for @settingsImages.
  ///
  /// In en, this message translates to:
  /// **'Image Hosting'**
  String get settingsImages;

  /// No description provided for @settingsBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get settingsBackup;

  /// No description provided for @settingsDataExport.
  ///
  /// In en, this message translates to:
  /// **'Data Export'**
  String get settingsDataExport;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @businessProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Business Profile'**
  String get businessProfileTitle;

  /// No description provided for @businessOwner.
  ///
  /// In en, this message translates to:
  /// **'Owner name'**
  String get businessOwner;

  /// No description provided for @businessAlternatePhone.
  ///
  /// In en, this message translates to:
  /// **'Alternate phone'**
  String get businessAlternatePhone;

  /// No description provided for @businessArea.
  ///
  /// In en, this message translates to:
  /// **'Area'**
  String get businessArea;

  /// No description provided for @businessCity.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get businessCity;

  /// No description provided for @businessDistrict.
  ///
  /// In en, this message translates to:
  /// **'District'**
  String get businessDistrict;

  /// No description provided for @businessState.
  ///
  /// In en, this message translates to:
  /// **'State'**
  String get businessState;

  /// No description provided for @businessPin.
  ///
  /// In en, this message translates to:
  /// **'PIN code'**
  String get businessPin;

  /// No description provided for @businessGstin.
  ///
  /// In en, this message translates to:
  /// **'GSTIN'**
  String get businessGstin;

  /// No description provided for @businessPan.
  ///
  /// In en, this message translates to:
  /// **'PAN'**
  String get businessPan;

  /// No description provided for @businessStateCode.
  ///
  /// In en, this message translates to:
  /// **'State code'**
  String get businessStateCode;

  /// No description provided for @businessLogo.
  ///
  /// In en, this message translates to:
  /// **'Logo'**
  String get businessLogo;

  /// No description provided for @businessSignature.
  ///
  /// In en, this message translates to:
  /// **'Authorized signature'**
  String get businessSignature;

  /// No description provided for @businessStamp.
  ///
  /// In en, this message translates to:
  /// **'Business stamp'**
  String get businessStamp;

  /// No description provided for @businessUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI ID'**
  String get businessUpi;

  /// No description provided for @businessBank.
  ///
  /// In en, this message translates to:
  /// **'Bank name'**
  String get businessBank;

  /// No description provided for @businessAccount.
  ///
  /// In en, this message translates to:
  /// **'Account number'**
  String get businessAccount;

  /// No description provided for @businessIfsc.
  ///
  /// In en, this message translates to:
  /// **'IFSC'**
  String get businessIfsc;

  /// No description provided for @businessOpeningDate.
  ///
  /// In en, this message translates to:
  /// **'Business opening date'**
  String get businessOpeningDate;

  /// No description provided for @businessDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get businessDescription;

  /// No description provided for @businessSetupTitle.
  ///
  /// In en, this message translates to:
  /// **'Set up Vijay Balaji Agency'**
  String get businessSetupTitle;

  /// No description provided for @businessSetupBody.
  ///
  /// In en, this message translates to:
  /// **'Enter your real business details. These values appear on invoices and can be changed later.'**
  String get businessSetupBody;

  /// No description provided for @authTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authTitle;

  /// No description provided for @authSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync uses Firebase Authentication. The app works fully offline without signing in.'**
  String get authSubtitle;

  /// No description provided for @authEmail.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get authEmail;

  /// No description provided for @authPassword.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get authPassword;

  /// No description provided for @authSignIn.
  ///
  /// In en, this message translates to:
  /// **'Sign in'**
  String get authSignIn;

  /// No description provided for @authSignUp.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get authSignUp;

  /// No description provided for @authSkip.
  ///
  /// In en, this message translates to:
  /// **'Continue offline'**
  String get authSkip;

  /// No description provided for @authSignOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get authSignOut;

  /// No description provided for @authError.
  ///
  /// In en, this message translates to:
  /// **'Sign-in failed'**
  String get authError;

  /// No description provided for @authLocalOnly.
  ///
  /// In en, this message translates to:
  /// **'Offline mode — data stays on this device'**
  String get authLocalOnly;

  /// No description provided for @authCloudReady.
  ///
  /// In en, this message translates to:
  /// **'Signed in'**
  String get authCloudReady;

  /// No description provided for @syncTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync Center'**
  String get syncTitle;

  /// No description provided for @syncPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get syncPending;

  /// No description provided for @syncSynced.
  ///
  /// In en, this message translates to:
  /// **'Synced'**
  String get syncSynced;

  /// No description provided for @syncFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get syncFailed;

  /// No description provided for @syncConflicts.
  ///
  /// In en, this message translates to:
  /// **'Conflicts'**
  String get syncConflicts;

  /// No description provided for @syncNow.
  ///
  /// In en, this message translates to:
  /// **'Sync now'**
  String get syncNow;

  /// No description provided for @syncLastSync.
  ///
  /// In en, this message translates to:
  /// **'Last sync'**
  String get syncLastSync;

  /// No description provided for @syncNever.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get syncNever;

  /// No description provided for @syncRetryAll.
  ///
  /// In en, this message translates to:
  /// **'Retry failed'**
  String get syncRetryAll;

  /// No description provided for @syncEmpty.
  ///
  /// In en, this message translates to:
  /// **'Everything is up to date'**
  String get syncEmpty;

  /// No description provided for @syncOffline.
  ///
  /// In en, this message translates to:
  /// **'Offline — changes are queued'**
  String get syncOffline;

  /// No description provided for @syncNotConfigured.
  ///
  /// In en, this message translates to:
  /// **'Cloud sync is not configured on this build'**
  String get syncNotConfigured;

  /// No description provided for @syncNotConfiguredBody.
  ///
  /// In en, this message translates to:
  /// **'Add your Firebase Android app and run flutterfire configure. Offline features keep working.'**
  String get syncNotConfiguredBody;

  /// No description provided for @syncConflictTitle.
  ///
  /// In en, this message translates to:
  /// **'Sync conflict'**
  String get syncConflictTitle;

  /// No description provided for @syncConflictBody.
  ///
  /// In en, this message translates to:
  /// **'This record changed on another device. Review both versions before choosing.'**
  String get syncConflictBody;

  /// No description provided for @comingSoon.
  ///
  /// In en, this message translates to:
  /// **'This module is being completed'**
  String get comingSoon;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageTamil.
  ///
  /// In en, this message translates to:
  /// **'Tamil'**
  String get languageTamil;

  /// No description provided for @validationRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get validationRequired;

  /// No description provided for @validationNumber.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid number'**
  String get validationNumber;

  /// No description provided for @validationPhone.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 10-digit phone number'**
  String get validationPhone;

  /// No description provided for @validationEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get validationEmail;

  /// No description provided for @validationGstin.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid 15-character GSTIN'**
  String get validationGstin;

  /// No description provided for @validationPositive.
  ///
  /// In en, this message translates to:
  /// **'Enter a value greater than zero'**
  String get validationPositive;

  /// No description provided for @validationNonNegative.
  ///
  /// In en, this message translates to:
  /// **'Enter zero or more'**
  String get validationNonNegative;

  /// No description provided for @billingRetail.
  ///
  /// In en, this message translates to:
  /// **'Retail'**
  String get billingRetail;

  /// No description provided for @billingWholesale.
  ///
  /// In en, this message translates to:
  /// **'Wholesale'**
  String get billingWholesale;

  /// No description provided for @paymentCash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get paymentCash;

  /// No description provided for @paymentUpi.
  ///
  /// In en, this message translates to:
  /// **'UPI'**
  String get paymentUpi;

  /// No description provided for @paymentBank.
  ///
  /// In en, this message translates to:
  /// **'Bank Transfer'**
  String get paymentBank;

  /// No description provided for @paymentCheque.
  ///
  /// In en, this message translates to:
  /// **'Cheque'**
  String get paymentCheque;

  /// No description provided for @paymentCredit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get paymentCredit;

  /// No description provided for @paymentOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get paymentOther;

  /// No description provided for @invoiceHeadingEstimate.
  ///
  /// In en, this message translates to:
  /// **'ESTIMATE'**
  String get invoiceHeadingEstimate;

  /// No description provided for @invoiceHeadingBill.
  ///
  /// In en, this message translates to:
  /// **'BILL'**
  String get invoiceHeadingBill;

  /// No description provided for @invoiceDealerLine.
  ///
  /// In en, this message translates to:
  /// **'DEALERS IN CEMENT, BRICKS, SAND, JELLY AND GRAVEL'**
  String get invoiceDealerLine;

  /// No description provided for @invoiceWholesaleLine.
  ///
  /// In en, this message translates to:
  /// **'AVAILABLE IN WHOLESALE AND RETAIL'**
  String get invoiceWholesaleLine;

  /// No description provided for @invoiceDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get invoiceDateLabel;

  /// No description provided for @invoiceBillNoLabel.
  ///
  /// In en, this message translates to:
  /// **'Bill No:'**
  String get invoiceBillNoLabel;

  /// No description provided for @invoiceSno.
  ///
  /// In en, this message translates to:
  /// **'S.No'**
  String get invoiceSno;

  /// No description provided for @invoiceDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get invoiceDescription;

  /// No description provided for @invoiceAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get invoiceAmount;

  /// No description provided for @invoiceSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get invoiceSubtotal;

  /// No description provided for @invoiceDiscount.
  ///
  /// In en, this message translates to:
  /// **'Discount'**
  String get invoiceDiscount;

  /// No description provided for @invoiceTaxable.
  ///
  /// In en, this message translates to:
  /// **'Taxable Amount'**
  String get invoiceTaxable;

  /// No description provided for @invoiceAmountPaid.
  ///
  /// In en, this message translates to:
  /// **'Amount Paid'**
  String get invoiceAmountPaid;

  /// No description provided for @invoiceBalanceDue.
  ///
  /// In en, this message translates to:
  /// **'Balance Due'**
  String get invoiceBalanceDue;

  /// No description provided for @invoicePaymentMode.
  ///
  /// In en, this message translates to:
  /// **'Payment Mode'**
  String get invoicePaymentMode;

  /// No description provided for @invoiceAuthorizedSignature.
  ///
  /// In en, this message translates to:
  /// **'Authorized Signature'**
  String get invoiceAuthorizedSignature;

  /// No description provided for @invoiceThankYou.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your business'**
  String get invoiceThankYou;

  /// No description provided for @invoiceGstinLabel.
  ///
  /// In en, this message translates to:
  /// **'GSTIN'**
  String get invoiceGstinLabel;

  /// No description provided for @invoicePhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Ph'**
  String get invoicePhoneLabel;

  /// No description provided for @invoiceTerms.
  ///
  /// In en, this message translates to:
  /// **'Goods once sold will not be taken back. Subject to Chennai jurisdiction.'**
  String get invoiceTerms;

  /// No description provided for @quantityUnit.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get quantityUnit;

  /// No description provided for @hsnShort.
  ///
  /// In en, this message translates to:
  /// **'HSN'**
  String get hsnShort;

  /// No description provided for @unitShort.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unitShort;

  /// No description provided for @dayBookEmpty.
  ///
  /// In en, this message translates to:
  /// **'No transactions for this period'**
  String get dayBookEmpty;

  /// No description provided for @logBookTitle.
  ///
  /// In en, this message translates to:
  /// **'Log Book'**
  String get logBookTitle;

  /// No description provided for @logBookEmpty.
  ///
  /// In en, this message translates to:
  /// **'No activity recorded yet'**
  String get logBookEmpty;

  /// No description provided for @errorDatabase.
  ///
  /// In en, this message translates to:
  /// **'Could not access the local database'**
  String get errorDatabase;

  /// No description provided for @errorSaveFailed.
  ///
  /// In en, this message translates to:
  /// **'Could not save. Please try again.'**
  String get errorSaveFailed;

  /// No description provided for @errorStock.
  ///
  /// In en, this message translates to:
  /// **'Stock could not be updated safely'**
  String get errorStock;

  /// No description provided for @errorPermission.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission for this action'**
  String get errorPermission;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @yes.
  ///
  /// In en, this message translates to:
  /// **'Yes'**
  String get yes;

  /// No description provided for @no.
  ///
  /// In en, this message translates to:
  /// **'No'**
  String get no;

  /// No description provided for @addNew.
  ///
  /// In en, this message translates to:
  /// **'Add new'**
  String get addNew;

  /// No description provided for @select.
  ///
  /// In en, this message translates to:
  /// **'Select'**
  String get select;

  /// No description provided for @from.
  ///
  /// In en, this message translates to:
  /// **'From'**
  String get from;

  /// No description provided for @to.
  ///
  /// In en, this message translates to:
  /// **'To'**
  String get to;

  /// No description provided for @apply.
  ///
  /// In en, this message translates to:
  /// **'Apply'**
  String get apply;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @showMore.
  ///
  /// In en, this message translates to:
  /// **'Show more'**
  String get showMore;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// No description provided for @records.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{No records} =1{1 record} other{{count} records}}'**
  String records(int count);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ta'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ta':
      return AppLocalizationsTa();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
