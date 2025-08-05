import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:bhooskhalann/user_profile/profile_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bhooskhalann/services/api_service.dart';
import 'package:path_provider/path_provider.dart';
import 'recent_report_screen/recent_reports_controller.dart';

class PublicLandslideReportController extends GetxController {

final ProfileController pc = Get.put(ProfileController());

  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  var imageCaptions = <TextEditingController>[].obs;
  
  // Loading state
  var isLoading = false.obs;

  var selectedDateText = ''.obs;
  var selectedTimeText = ''.obs;
  
  // Draft management
  String? currentDraftId;
  var isDraftMode = false.obs;
  
  // Images with validation
  var selectedImages = <File>[].obs;
  var imageValidationError = ''.obs;
  
  // Contact Information from SharedPreferences
  var username = ''.obs;
  var email = ''.obs;
  var mobile = ''.obs;
  var affiliation = ''.obs;

// Add these after existing draft management properties
String? currentPendingReportId;
var isPendingEditMode = false.obs;

    // final rainfallAmountController = TextEditingController();
  // var rainfallDurationValue = Rxn<String>();
  
  // Form controllers - Location Information
  final affiliationController = TextEditingController();
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  final stateController = TextEditingController();
  final districtController = TextEditingController();
  final subdivisionController = TextEditingController();
  final villageController = TextEditingController();
  final locationDetailsController = TextEditingController();

  var isLocationAutoPopulated = false.obs;
var selectedStateFromDropdown = Rxn<String>();
var selectedDistrictFromDropdown = Rxn<String>();
var isLocationFetching = false.obs; // Flag to prevent duplicate location fetching

  // UI State variables
  var isImpactSectionExpanded = false.obs;


// Helper method to convert translated dropdown values back to English for API
String? translateToEnglish(String? translatedValue, String fieldType) {
  if (translatedValue == null) return null;
  
  // If the value is already an English key, convert it to the proper API format
  switch (fieldType) {
    case 'occurrence':
      if (translatedValue == 'exact_occurrence_date') return 'I know the EXACT occurrence date';
      if (translatedValue == 'approximate_occurrence_date') return 'I know the APPROXIMATE occurrence date';
      if (translatedValue == 'no_occurrence_date') return 'I DO NOT know the occurrence date';
      break;
      
    case 'source':
      if (translatedValue == 'i_observed_it') return 'I observed it';
      if (translatedValue == 'through_local') return 'Through a local';
      if (translatedValue == 'social_media') return 'Social media';
      if (translatedValue == 'news') return 'News';
      if (translatedValue == 'i_dont_know') return 'I don\'t know';
      break;
      
    case 'dateRange':
      if (translatedValue == 'last_3_days') return 'In the last 3 days';
      if (translatedValue == 'last_week') return 'In the last week';
      if (translatedValue == 'last_month') return 'In the last month';
      if (translatedValue == 'last_3_months') return 'In the last 3 months';
      if (translatedValue == 'last_year') return 'In the last year';
      if (translatedValue == 'older_than_year') return 'Older than a year';
      break;
      
    case 'locationType':
      if (translatedValue == 'near_on_road') return 'Near/onroad';
      if (translatedValue == 'next_to_river') return 'Next to river';
      if (translatedValue == 'settlement') return 'Settlement';
      if (translatedValue == 'plantation') return 'Plantation (tea,rubber .... etc.)';
      if (translatedValue == 'forest_area') return 'Forest Area';
      if (translatedValue == 'cultivation') return 'Cultivation';
      if (translatedValue == 'barren_land') return 'Barren Land';
      if (translatedValue == 'other_specify') return 'Other (Specify)';
      break;
      
    case 'material':
      if (translatedValue == 'rock') return 'Rock';
      if (translatedValue == 'soil') return 'Soil';
      if (translatedValue == 'debris_mixture') return 'Debris (mixture of Rock and Soil)';
      break;
      
    case 'roadType':
      if (translatedValue == 'state_highway') return 'State Highway';
      if (translatedValue == 'national_highway') return 'National Highway';
      if (translatedValue == 'local') return 'Local';
      break;
      
    case 'extent':
      if (translatedValue == 'full') return 'Full';
      if (translatedValue == 'partial') return 'Partial';
      break;
      
    case 'size':
      if (translatedValue == 'small_building') return 'Small - (Less than 2 storey Building) < 6m';
      if (translatedValue == 'medium_building') return 'Medium - (Two to 5 storey Building) 6-15m';
      if (translatedValue == 'large_building') return 'Large - (More than 5 storey Building) > 15m';
      break;
  }
  
  // If it's a translated value, try to find the English key and convert it
  // This handles cases where the value might still be in Hindi
  String? englishKey = _findEnglishKeyFromHindiValue(translatedValue, _getOptionsForFieldType(fieldType));
  if (englishKey != null) {
    return translateToEnglish(englishKey, fieldType);
  }
  
  return translatedValue; // Return as-is if no translation found
}

// Helper method to get options for a specific field type
List<String> _getOptionsForFieldType(String fieldType) {
  switch (fieldType) {
    case 'occurrence':
      return landslideOccurrenceOptions;
    case 'source':
      return howDoYouKnowOptions;
    case 'dateRange':
      return ['last_3_days', 'last_week', 'last_month', 'last_3_months', 'last_year', 'older_than_year'];
    case 'locationType':
      return whereDidLandslideOccurOptions;
    case 'material':
      return typeOfMaterialOptions;
    case 'roadType':
      return roadTypeOptions;
    case 'extent':
      return roadExtentOptions;
    case 'size':
      return landslideSizeOptions;
    default:
      return [];
  }
}


// Method to get translated occurrence options
List<String> getOccurrenceOptions() {
  return [
    'exact_occurrence_date'.tr,
    'approximate_occurrence_date'.tr,
    'no_occurrence_date'.tr,
  ];
}

// Method to get translated source options
List<String> getSourceOptions() {
  return [
    'i_observed_it'.tr,
    'through_local'.tr,
    'social_media'.tr,
    'news'.tr,
    'i_dont_know'.tr,
  ];
}

// Method to get translated date range options
List<String> getDateRangeOptions() {
  return [
    'last_3_days'.tr,
    'last_week'.tr,
    'last_month'.tr,
    'last_3_months'.tr,
    'last_year'.tr,
    'older_than_year'.tr,
  ];
}

// Method to get translated location type options
List<String> getLocationTypeOptions() {
  return [
    'near_on_road'.tr,
    'next_to_river'.tr,
    'settlement'.tr,
    'plantation'.tr,
    'forest_area'.tr,
    'cultivation'.tr,
    'barren_land'.tr,
    'other_specify'.tr,
  ];
}

// Method to get translated material type options
List<String> getMaterialTypeOptions() {
  return [
    'rock'.tr,
    'soil'.tr,
    'debris_mixture'.tr,
  ];
}

// Method to get translated road type options
List<String> getRoadTypeOptions() {
  return [
    'state_highway'.tr,
    'national_highway'.tr,
    'local'.tr,
  ];
}

// Method to get translated extent options
List<String> getExtentOptions() {
  return [
    'full'.tr,
    'partial'.tr,
  ];
}

// Method to get translated landslide size options
List<String> getLandslideSizeOptions() {
  return [
    'small_building'.tr,
    'medium_building'.tr,
    'large_building'.tr,
  ];
}


final List<String> indianStates = [
  'Andhra Pradesh', 'Arunachal Pradesh', 'Assam', 'Bihar', 'Chhattisgarh',
  'Goa', 'Gujarat', 'Haryana', 'Himachal Pradesh', 'Jharkhand', 'Karnataka',
  'Kerala', 'Madhya Pradesh', 'Maharashtra', 'Manipur', 'Meghalaya', 'Mizoram',
  'Nagaland', 'Odisha', 'Punjab', 'Rajasthan', 'Sikkim', 'Tamil Nadu',
  'Telangana', 'Tripura', 'Uttar Pradesh', 'Uttarakhand', 'West Bengal',
  'Andaman and Nicobar Islands', 'Chandigarh', 'Dadra and Nagar Haveli and Daman and Diu',
  'Delhi', 'Jammu and Kashmir', 'Ladakh', 'Lakshadweep', 'Puducherry'
];

// State-wise districts mapping (all Indian states & UTs)
final Map<String, List<String>> stateDistrictsMap = {
  'Andhra Pradesh': [
    'Anantapur', 'Chittoor', 'East Godavari', 'Guntur', 'Krishna',
    'Kurnool', 'Nellore', 'Prakasam', 'Srikakulam', 'Visakhapatnam',
    'Vizianagaram', 'West Godavari', 'YSR Kadapa'
  ],
  'Arunachal Pradesh': [
    'Anjaw', 'Changlang', 'Dibang Valley', 'East Kameng', 'East Siang',
    'Kamle', 'Kra Daadi', 'Kurung Kumey', 'Lepa Rada', 'Lohit', 'Longding',
    'Lower Dibang Valley', 'Lower Siang', 'Lower Subansiri', 'Namsai',
    'Pakke Kessang', 'Papum Pare', 'Shi Yomi', 'Siang', 'Tawang',
    'Tirap', 'Upper Siang', 'Upper Subansiri', 'West Kameng', 'West Siang'
  ],
  'Assam': [
    'Baksa', 'Barpeta', 'Biswanath', 'Bongaigaon', 'Cachar', 'Charaideo',
    'Chirang', 'Darrang', 'Dhemaji', 'Dhubri', 'Dibrugarh', 'Goalpara',
    'Golaghat', 'Hailakandi', 'Hojai', 'Jorhat', 'Kamrup', 'Kamrup Metropolitan',
    'Karbi Anglong', 'Karimganj', 'Kokrajhar', 'Lakhimpur', 'Majuli',
    'Morigaon', 'Nagaon', 'Nalbari', 'Dima Hasao', 'Sivasagar', 'Sonitpur',
    'South Salmara-Mankachar', 'Tinsukia', 'Udalguri', 'West Karbi Anglong'
  ],
  'Bihar': [
    'Araria', 'Arwal', 'Aurangabad', 'Banka', 'Begusarai', 'Bhagalpur',
    'Bhojpur', 'Buxar', 'Darbhanga', 'East Champaran', 'Gaya', 'Gopalganj',
    'Jamui', 'Jehanabad', 'Kaimur', 'Katihar', 'Khagaria', 'Kishanganj',
    'Lakhisarai', 'Madhepura', 'Madhubani', 'Munger', 'Muzaffarpur',
    'Nalanda', 'Nawada', 'Patna', 'Purnia', 'Rohtas', 'Saharsa', 'Samastipur',
    'Saran', 'Sheikhpura', 'Sheohar', 'Sitamarhi', 'Siwan', 'Supaul',
    'Vaishali', 'West Champaran'
  ],
  'Chhattisgarh': [
    'Balod', 'Baloda Bazar', 'Balrampur', 'Bastar', 'Bemetara', 'Bijapur',
    'Bilaspur', 'Dantewada', 'Dhamtari', 'Durg', 'Gariaband', 'Gaurela-Pendra-Marwahi',
    'Janjgir-Champa', 'Jashpur', 'Kabirdham', 'Kanker', 'Kondagaon',
    'Korba', 'Koriya', 'Mahasamund', 'Mungeli', 'Narayanpur', 'Raigarh',
    'Raipur', 'Rajnandgaon', 'Sukma', 'Surajpur', 'Surguja'
  ],
  'Goa': [
    'North Goa', 'South Goa'
  ],
  'Gujarat': [
    'Ahmedabad', 'Amreli', 'Anand', 'Aravalli', 'Banaskantha', 'Bharuch',
    'Bhavnagar', 'Botad', 'Chhota Udaipur', 'Dahod', 'Dang', 'Devbhumi Dwarka',
    'Gandhinagar', 'Gir Somnath', 'Jamnagar', 'Junagadh', 'Kheda', 'Kutch',
    'Mahisagar', 'Mehsana', 'Morbi', 'Narmada', 'Navsari', 'Panchmahal',
    'Patan', 'Porbandar', 'Rajkot', 'Sabarkantha', 'Surat', 'Surendranagar',
    'Tapi', 'Vadodara', 'Valsad'
  ],
  'Haryana': [
    'Ambala', 'Bhiwani', 'Charkhi Dadri', 'Faridabad', 'Fatehabad',
    'Gurugram', 'Hisar', 'Jhajjar', 'Jind', 'Kaithal', 'Karnal', 'Kurukshetra',
    'Mahendragarh', 'Nuh', 'Palwal', 'Panchkula', 'Panipat', 'Rewari',
    'Rohtak', 'Sirsa', 'Sonipat', 'Yamunanagar'
  ],
  'Himachal Pradesh': [
    'Bilaspur', 'Chamba', 'Hamirpur', 'Kangra', 'Kinnaur', 'Kullu',
    'Lahaul and Spiti', 'Mandi', 'Shimla', 'Sirmaur', 'Solan', 'Una'
  ],
  'Jharkhand': [
    'Bokaro', 'Chatra', 'Deoghar', 'Dhanbad', 'Dumka', 'East Singhbhum',
    'Garhwa', 'Giridih', 'Godda', 'Gumla', 'Hazaribagh', 'Jamtara',
    'Khunti', 'Koderma', 'Latehar', 'Lohardaga', 'Pakur', 'Palamu', 'Ramgarh',
    'Ranchi', 'Sahebganj', 'Seraikela Kharsawan', 'Simdega', 'West Singhbhum'
  ],
  'Karnataka': [
    'Bagalkot', 'Ballari', 'Belagavi', 'Bengaluru Rural', 'Bengaluru Urban',
    'Bidar', 'Chamarajanagar', 'Chikkaballapur', 'Chikkamagaluru', 'Chitradurga',
    'Dakshina Kannada', 'Davangere', 'Dharwad', 'Gadag', 'Hassan', 'Haveri',
    'Kalaburagi', 'Kodagu', 'Kolar', 'Koppal', 'Mandya', 'Mysuru', 'Raichur',
    'Ramanagara', 'Shivamogga', 'Tumakuru', 'Udupi', 'Uttara Kannada', 'Vijayapura', 'Yadgir'
  ],
  'Kerala': [
    'Alappuzha', 'Ernakulam', 'Idukki', 'Kannur', 'Kasaragod', 'Kollam',
    'Kottayam', 'Kozhikode', 'Malappuram', 'Palakkad', 'Pathanamthitta',
    'Thiruvananthapuram', 'Thrissur', 'Wayanad'
  ],
  'Madhya Pradesh': [
    'Agar Malwa', 'Alirajpur', 'Anuppur', 'Ashoknagar', 'Balaghat', 'Barwani',
    'Betul', 'Bhind', 'Bhopal', 'Burhanpur', 'Chhatarpur', 'Chhindwara',
    'Damoh', 'Datia', 'Dewas', 'Dhar', 'Dindori', 'Guna', 'Gwalior', 'Harda',
    'Hoshangabad', 'Indore', 'Jabalpur', 'Jhabua', 'Katni', 'Khandwa',
    'Khargone', 'Mandla', 'Mandsaur', 'Morena', 'Narsinghpur', 'Neemuch',
    'Panna', 'Raisen', 'Rajgarh', 'Ratlam', 'Rewa', 'Sagar', 'Satna',
    'Sehore', 'Seoni', 'Shahdol', 'Shajapur', 'Sheopur', 'Shivpuri',
    'Sidhi', 'Singrauli', 'Tikamgarh', 'Ujjain', 'Umaria', 'Vidisha'
  ],
  'Maharashtra': [
    'Ahmednagar', 'Akola', 'Amravati', 'Aurangabad', 'Beed', 'Bhandara',
    'Buldhana', 'Chandrapur', 'Dhule', 'Gadchiroli', 'Gondia', 'Hingoli',
    'Jalgaon', 'Jalna', 'Kolhapur', 'Latur', 'Mumbai City', 'Mumbai Suburban',
    'Nagpur', 'Nanded', 'Nandurbar', 'Nashik', 'Osmanabad', 'Palghar',
    'Parbhani', 'Pune', 'Raigad', 'Ratnagiri', 'Sangli', 'Satara', 'Sindhudurg',
    'Solapur', 'Thane', 'Wardha', 'Washim', 'Yavatmal'
  ],
  'Manipur': [
    'Bishnupur', 'Chandel', 'Churachandpur', 'Imphal East', 'Imphal West',
    'Jiribam', 'Kakching', 'Kamjong', 'Kangpokpi', 'Noney', 'Pherzawl',
    'Senapati', 'Tamenglong', 'Tengnoupal', 'Thoubal', 'Ukhrul'
  ],
  'Meghalaya': [
    'East Garo Hills', 'East Jaintia Hills', 'East Khasi Hills', 'North Garo Hills',
    'Ri-Bhoi', 'South Garo Hills', 'South West Garo Hills', 'South West Khasi Hills',
    'West Garo Hills', 'West Jaintia Hills', 'West Khasi Hills'
  ],
  'Mizoram': [
    'Aizawl', 'Champhai', 'Hnahthial', 'Khawzawl', 'Kolasib', 'Lawngtlai',
    'Lunglei', 'Mamit', 'Saiha', 'Saitual', 'Serchhip'
  ],
  'Nagaland': [
    'Chümoukedima', 'Dimapur', 'Kiphire', 'Kohima', 'Longleng', 'Mokokchung',
    'Mon', 'Niuland', 'Peren', 'Phek', 'Shamator', 'Tseminyu', 'Tuensang', 'Wokha', 'Zünheboto'
  ],
  'Odisha': [
    'Angul', 'Balangir', 'Balasore', 'Bargarh', 'Bhadrak', 'Boudh', 'Cuttack',
    'Deogarh', 'Dhenkanal', 'Gajapati', 'Ganjam', 'Jagatsinghpur', 'Jajpur',
    'Jharsuguda', 'Kalahandi', 'Kandhamal', 'Kendrapara', 'Kendujhar',
    'Khordha', 'Koraput', 'Malkangiri', 'Mayurbhanj', 'Nabarangpur', 'Nayagarh',
    'Nuapada', 'Puri', 'Rayagada', 'Sambalpur', 'Subarnapur', 'Sundargarh'
  ],
  'Punjab': [
    'Amritsar', 'Barnala', 'Bathinda', 'Faridkot', 'Fatehgarh Sahib', 'Fazilka',
    'Ferozepur', 'Gurdaspur', 'Hoshiarpur', 'Jalandhar', 'Kapurthala', 'Ludhiana',
    'Malerkotla', 'Mansa', 'Moga', 'Mohali', 'Muktsar', 'Pathankot', 'Patiala',
    'Rupnagar', 'Sangrur', 'Shaheed Bhagat Singh Nagar', 'Tarn Taran'
  ],
  'Rajasthan': [
    'Ajmer', 'Alwar', 'Banswara', 'Baran', 'Barmer', 'Bharatpur', 'Bhilwara',
    'Bikaner', 'Bundi', 'Chittorgarh', 'Churu', 'Dausa', 'Dholpur', 'Dungarpur',
    'Hanumangarh', 'Jaipur', 'Jaisalmer', 'Jalore', 'Jhalawar', 'Jhunjhunu',
    'Jodhpur', 'Karauli', 'Kota', 'Nagaur', 'Pali', 'Pratapgarh', 'Rajsamand',
    'Sawai Madhopur', 'Sikar', 'Sirohi', 'Sri Ganganagar', 'Tonk', 'Udaipur'
  ],
  'Sikkim': [
    'East Sikkim', 'North Sikkim', 'South Sikkim', 'West Sikkim'
  ],
  'Tamil Nadu': [
    'Ariyalur', 'Chengalpattu', 'Chennai', 'Coimbatore', 'Cuddalore', 'Dharmapuri',
    'Dindigul', 'Erode', 'Kallakurichi', 'Kanchipuram', 'Kanyakumari', 'Karur',
    'Krishnagiri', 'Madurai', 'Mayiladuthurai', 'Nagapattinam', 'Namakkal',
    'Nilgiris', 'Perambalur', 'Pudukkottai', 'Ramanathapuram', 'Ranipet',
    'Salem', 'Sivaganga', 'Tenkasi', 'Thanjavur', 'Theni', 'Thoothukudi',
    'Tiruchirappalli', 'Tirunelveli', 'Tirupathur', 'Tiruppur', 'Tiruvallur',
    'Tiruvannamalai', 'Tiruvarur', 'Vellore', 'Viluppuram', 'Virudhunagar'
  ],
  'Telangana': [
    'Adilabad', 'Bhadradri Kothagudem', 'Hyderabad', 'Jagtial', 'Jangaon',
    'Jayashankar Bhupalpally', 'Jogulamba Gadwal', 'Kamareddy', 'Karimnagar',
    'Khammam', 'Komaram Bheem', 'Mahabubabad', 'Mahabubnagar', 'Mancherial',
    'Medak', 'Medchal–Malkajgiri', 'Mulugu', 'Nagarkurnool', 'Nalgonda',
    'Narayanpet', 'Nirmal', 'Nizamabad', 'Peddapalli', 'Rajanna Sircilla',
    'Ranga Reddy', 'Sangareddy', 'Siddipet', 'Suryapet', 'Vikarabad', 'Wanaparthy',
    'Warangal Rural', 'Warangal Urban', 'Yadadri Bhuvanagiri'
  ],
  'Tripura': [
    'Dhalai', 'Gomati', 'Khowai', 'North Tripura', 'Sepahijala', 'South Tripura',
    'Unakoti', 'West Tripura'
  ],
  'Uttar Pradesh': [
    'Agra', 'Aligarh', 'Ambedkar Nagar', 'Amethi', 'Amroha', 'Auraiya', 'Ayodhya',
    'Azamgarh', 'Baghpat', 'Bahraich', 'Ballia', 'Balrampur', 'Banda', 'Barabanki',
    'Bareilly', 'Basti', 'Bijnor', 'Bulandshahr', 'Chandauli', 'Chitrakoot',
    'Deoria', 'Etah', 'Etawah', 'Farrukhabad', 'Fatehpur', 'Firozabad', 'Gautam Buddha Nagar',
    'Ghaziabad', 'Ghazipur', 'Gonda', 'Gorakhpur', 'Hamirpur', 'Hapur', 'Hardoi',
    'Hathras', 'Jalaun', 'Jaunpur', 'Jhansi', 'Kannauj', 'Kanpur Dehat', 'Kanpur Nagar',
    'Kasganj', 'Kaushambi', 'Kheri', 'Kushinagar', 'Lalitpur', 'Lucknow', 'Maharajganj',
    'Mahoba', 'Mainpuri', 'Mathura', 'Mau', 'Meerut', 'Mirzapur', 'Moradabad', 'Muzaffarnagar',
    'Pilibhit', 'Pratapgarh', 'Prayagraj', 'Raebareli', 'Rampur', 'Saharanpur', 'Sambhal',
    'Sant Kabir Nagar', 'Shahjahanpur', 'Shamli', 'Shravasti', 'Siddharthnagar', 'Sitapur',
    'Sonbhadra', 'Sultanpur', 'Unnao', 'Varanasi'
  ],
  'Uttarakhand': [
    'Almora', 'Bageshwar', 'Chamoli', 'Champawat', 'Dehradun', 'Haridwar',
    'Nainital', 'Pauri Garhwal', 'Pithoragarh', 'Rudraprayag', 'Tehri Garhwal',
    'Udham Singh Nagar', 'Uttarkashi'
  ],
  'West Bengal': [
    'Alipurduar', 'Bankura', 'Birbhum', 'Cooch Behar', 'Dakshin Dinajpur',
    'Darjeeling', 'Hooghly', 'Howrah', 'Jalpaiguri', 'Jhargram', 'Kalimpong',
    'Kolkata', 'Malda', 'Murshidabad', 'Nadia', 'North 24 Parganas', 'Paschim Bardhaman',
    'Paschim Medinipur', 'Purba Bardhaman', 'Purba Medinipur', 'Purulia', 'South 24 Parganas',
    'Uttar Dinajpur'
  ],

  // Union Territories:
  'Andaman and Nicobar Islands': ['Nicobar', 'North and Middle Andaman', 'South Andaman'],
  'Chandigarh': ['Chandigarh'],
  'Dadra and Nagar Haveli and Daman and Diu': ['Daman', 'Diu', 'Dadra and Nagar Haveli'],
  'Delhi': ['Central Delhi', 'East Delhi', 'New Delhi', 'North Delhi', 'North East Delhi',
            'North West Delhi', 'Shahdara', 'South Delhi', 'South East Delhi', 'South West Delhi', 'West Delhi'],
  'Jammu and Kashmir': [
    'Anantnag', 'Bandipora', 'Baramulla', 'Budgam', 'Doda', 'Ganderbal', 'Jammu',
    'Kathua', 'Kishtwar', 'Kulgam', 'Kupwara', 'Poonch', 'Pulwama', 'Rajouri',
    'Ramban', 'Reasi', 'Samba', 'Shopian', 'Srinagar', 'Udhampur'
  ],
  'Ladakh': ['Kargil', 'Leh'],
  'Lakshadweep': ['Agatti', 'Amini', 'Andrott', 'Bangaram', 'Bitra', 'Chetlat',
                  'Kadmat', 'Kalpeni', 'Kavaratti', 'Kilthan', 'Minicoy'],
  'Puducherry': ['Karaikal', 'Mahe', 'Puducherry', 'Yanam']
};

 
  
  // Form controllers - Other fields
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  var occurrenceDateRange = ''.obs;
  // final otherRelevantInformation = TextEditingController();
  
  // Dropdown values - Main form
  var landslideOccurrenceValue = Rxn<String>();
  var howDoYouKnowValue = Rxn<String>();
  var whereDidLandslideOccurValue = Rxn<String>();
  var typeOfMaterialValue = Rxn<String>();
  // var typeOfMovementValue = Rxn<String>();
  var landslideSize = Rxn<String>(); // New field for public form
  // var whatInducedLandslideValue = Rxn<String>();
  
  // Impact/Damage - Same as original form
  var peopleAffected = false.obs;
  var livestockAffected = false.obs;
  var housesBuildingAffected = false.obs;
  var damsBarragesAffected = false.obs;
  var roadsAffected = false.obs;
  var roadsBlocked = false.obs;
  var roadBenchesDamaged = false.obs;
  var railwayLineAffected = false.obs;
  var railwayBlocked = false.obs;
  var railwayBenchesDamaged = false.obs;
  var powerInfrastructureAffected = false.obs;
  var damagesToAgriculturalForestLand = false.obs;
  var other = false.obs;
  var noDamages = false.obs;
  var iDontKnow = false.obs;
  
  // Impact/Damage detail controllers
  final peopleDeadController = TextEditingController();
  final peopleInjuredController = TextEditingController();
  final livestockDeadController = TextEditingController();
  final livestockInjuredController = TextEditingController();
  final housesFullyController = TextEditingController();
  final housesPartiallyController = TextEditingController();
  final damsNameController = TextEditingController();
  var damsExtentValue = Rxn<String>();
  var roadTypeValue = Rxn<String>();
  var roadExtentValue = Rxn<String>();
  var roadBlockageValue = Rxn<String>();
  var roadBenchesExtentValue = Rxn<String>();
  final railwayDetailsController = TextEditingController();
  var railwayBlockageValue = Rxn<String>();
  var railwayBenchesExtentValue = Rxn<String>();
  var powerExtentValue = Rxn<String>();
  final otherDamageDetailsController = TextEditingController();

  Future<bool> _checkInternetConnection() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

  // LIFECYCLE METHODS
@override
  Future<void> onInit() async {
  super.onInit();
  _loadUserData();
  
  // Initialize with coordinates from arguments or parameters
  final args = Get.arguments as Map<String, dynamic>?;
  if (args != null) {
    latitudeController = TextEditingController(
      text: args['latitude']?.toStringAsFixed(7) ?? '',
    );
    longitudeController = TextEditingController(
      text: args['longitude']?.toStringAsFixed(7) ?? '',
    );
    
    // Check if this is a draft being loaded
    if (args.containsKey('draftId') && args.containsKey('draftData')) {
      currentDraftId = args['draftId'];
      isDraftMode.value = true;
              await loadDraftData(args['draftData']);
    }
    // Check if this is a pending report being edited
    else if (args.containsKey('pendingReportId') && args.containsKey('pendingReportData')) {
      currentPendingReportId = args['pendingReportId']; // Add this property to controller
      isPendingEditMode.value = true; // Add this property to controller
      await loadDraftData(args['pendingReportData']); // Reuse the same loading method
    } else {
      // If not a draft/pending and we have coordinates, fetch location
      if (args['latitude'] != null && args['longitude'] != null) {
        fetchLocationFromCoordinates();
      }
    }
  } else {
    // When args is null, just initialize empty controllers
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();
  }
}

  void onStateSelected(String? selectedState) {
  selectedStateFromDropdown.value = selectedState;
  selectedDistrictFromDropdown.value = null; // Reset district when state changes
  
  if (selectedState != null) {
    stateController.text = selectedState;
  }
}

void onDistrictSelected(String? selectedDistrict) {
  selectedDistrictFromDropdown.value = selectedDistrict;
  
  if (selectedDistrict != null) {
    districtController.text = selectedDistrict;
  }
}

List<String> getDistrictsForState(String? state) {
  return stateDistrictsMap[state] ?? [];
}
  
  @override
  void onClose() {
    // Dispose all controllers
    _disposeAllControllers();
    super.onClose();
  }

  // Load user data from SharedPreferences
  Future<void> _loadUserData() async {
    pc.fetchUserProfile();
    final prefs = await SharedPreferences.getInstance();
    username.value = prefs.getString('username') ?? 'not_available'.tr;
    email.value = prefs.getString('email') ?? 'not_available'.tr;
    mobile.value = prefs.getString('mobile') ?? 'not_available'.tr;
  }

// Replace the fetchIndianStateDistrictFromArcGIS method with this
Future<void> fetchLocationFromCoordinates() async {
  // Prevent duplicate calls
  if (isLocationFetching.value) {
    print('⚠️ Location fetching already in progress, skipping duplicate call');
    return;
  }
  
  isLocationFetching.value = true;
  
  try {
    if (latitudeController.text.isNotEmpty && longitudeController.text.isNotEmpty) {
      final double lat = double.parse(latitudeController.text);
      final double lng = double.parse(longitudeController.text);
      
      print('🔍 Fetching location for: $lat, $lng using Google Maps API');
      
      const String apiKey = 'AIzaSyDqsbgwAMnmxWdIFkcjPIHak9UvLPCXp_4';
      
      final String url = 'https://maps.googleapis.com/maps/api/geocode/json'
          '?latlng=$lat,$lng'
          '&key=$apiKey'
          '&language=en'
          '&region=IN';
      
      final response = await http.get(Uri.parse(url));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('📍 Raw Google API response: ${json.encode(data)}');
        
        if (data['status'] == 'OK' && data['results'] != null && data['results'].isNotEmpty) {
          
          String? state, district, subdivision, village;
          List<String> populatedFields = [];
          
          // Parse all results to find best components
          for (var result in data['results']) {
            final components = result['address_components'] as List;
            
            for (var component in components) {
              final types = component['types'] as List;
              final longName = component['long_name'] as String;
              
              // Extract STATE
              if (types.contains('administrative_area_level_1') && state == null) {
                state = _cleanLocationName(longName);
              }
              
              // Extract DISTRICT (smart fallback with Presidency Division handling)
              if (district == null) {
                // Priority 1: Use administrative_area_level_3 if it's a proper district
                if (types.contains('administrative_area_level_3') && !_isDivision(longName)) {
                  district = _cleanLocationName(longName);
                }
                // Priority 2: Use locality if it seems like a district
                else if (types.contains('locality') && _seemsLikeDistrict(longName)) {
                  district = _cleanLocationName(longName);
                }
                // Priority 3: Use administrative_area_level_2 only if not a division
                else if (types.contains('administrative_area_level_2') && !_isDivision(longName)) {
                  district = _cleanLocationName(longName);
                }
              }
              
              // Extract SUBDIVISION/TALUK
              if (subdivision == null) {
                // Look for sublocality_level_1 or administrative_area_level_4
                if (types.contains('sublocality_level_1') || types.contains('administrative_area_level_4')) {
                  subdivision = _cleanLocationName(longName);
                }
                // Fallback to sublocality if it seems like a subdivision
                else if (types.contains('sublocality') && _seemsLikeSubdivision(longName)) {
                  subdivision = _cleanLocationName(longName);
                }
              }
              
              // Extract VILLAGE
              if (village == null) {
                // Look for sublocality_level_2 or sublocality_level_3
                if (types.contains('sublocality_level_2') || types.contains('sublocality_level_3')) {
                  village = _cleanLocationName(longName);
                }
                // Fallback to premise or neighborhood if it seems like a village
                else if ((types.contains('premise') || types.contains('neighborhood')) && _seemsLikeVillage(longName)) {
                  village = _cleanLocationName(longName);
                }
              }
            }
          }
          
          // Set found values
          bool populated = false;
          
          if (state != null && state.isNotEmpty) {
            stateController.text = state;
            populatedFields.add('State: $state');
            populated = true;
            print('✅ State set: $state');
          }
          
          if (district != null && district.isNotEmpty) {
            districtController.text = district;
            populatedFields.add('District: $district');
            populated = true;
            print('✅ District set: $district');
          }
          
          if (subdivision != null && subdivision.isNotEmpty) {
            subdivisionController.text = subdivision;
            populatedFields.add('Subdivision/Taluk: $subdivision');
            populated = true;
            print('✅ Subdivision/Taluk set: $subdivision');
          }
          
          if (village != null && village.isNotEmpty) {
            villageController.text = village;
            populatedFields.add('Village: $village');
            populated = true;
            print('✅ Village set: $village');
          }
          
          if (populated) {
            isLocationAutoPopulated.value = true;
            Get.snackbar(
              'Location Found',
              populatedFields.join('\n'),
              backgroundColor: Colors.green,
              colorText: Colors.white,
              snackPosition: SnackPosition.BOTTOM,
              duration: const Duration(seconds: 4),
            );
          } else {
            isLocationAutoPopulated.value = false;
            _showLocationNotFound();
          }
        } else {
          isLocationAutoPopulated.value = false;
          // _showLocationError('No results found');
        }
      } else {
        isLocationAutoPopulated.value = false;
        // _showLocationError('API request failed');
      }
    }
  } catch (e) {
    isLocationAutoPopulated.value = false;
    // _showLocationError(e.toString());
  } finally {
    // Reset the flag to allow future calls
    isLocationFetching.value = false;
  }
}

// Check if name is an administrative division
bool _isDivision(String name) {
  String lower = name.toLowerCase();
  return lower.contains('division') || lower.contains('presidency') || 
         lower.contains('region') || lower.contains('zone');
}

// Check if name seems like a district
bool _seemsLikeDistrict(String name) {
  String lower = name.toLowerCase();
  return lower.contains('district') || lower.contains('parganas') || 
         (lower.contains('north') || lower.contains('south') || 
          lower.contains('east') || lower.contains('west')) &&
         !lower.contains('ward') && !lower.contains('road');
}

// Check if name seems like a subdivision/taluk
bool _seemsLikeSubdivision(String name) {
  String lower = name.toLowerCase();
  return lower.contains('taluk') || lower.contains('tehsil') || lower.contains('subdivision') ||
         lower.contains('block') || lower.contains('mandal') || lower.contains('tahsil') ||
         (lower.length > 3 && lower.length < 15 && !lower.contains('ward') && !lower.contains('road'));
}

// Check if name seems like a village
bool _seemsLikeVillage(String name) {
  String lower = name.toLowerCase();
  return lower.contains('village') || lower.contains('gram') || lower.contains('gaon') ||
         lower.contains('pur') || lower.contains('nagar') || lower.contains('colony') ||
         (lower.length > 2 && lower.length < 12 && !lower.contains('ward') && !lower.contains('road'));
}

// Clean location names
String _cleanLocationName(String name) {
  return name
      .replaceAll(RegExp(r'\s+(District|Division|State|Taluk|Block)$', caseSensitive: false), '')
      .trim();
}

// Error handling methods
void _showLocationNotFound() {
  Get.snackbar(
    'location_not_found'.tr,
    'could_not_fetch_location'.tr,
    backgroundColor: Colors.orange,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 3),
  );
}


  // SETUP METHODS
  void setCoordinates(double latitude, double longitude) {
    latitudeController.text = latitude.toStringAsFixed(7);
    longitudeController.text = longitude.toStringAsFixed(7);
    // Automatically fetch state and district from ArcGIS
    // Only fetch if not already fetching
    if (!isLocationFetching.value) {
      fetchLocationFromCoordinates();
    }
  }

  // DRAFT MANAGEMENT METHODS
  Future<void> loadDraftData(Map<String, dynamic> draftData) async {
    try {
      _loadTextControllers(draftData);
      _loadDropdownValues(draftData);
      loadCheckboxData(draftData);
      await _loadDraftImages(draftData);
    } catch (e) {
      print('Error loading draft data: $e');
      Get.snackbar(
        'Warning',
        'Some draft data could not be loaded',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _loadDraftImages(Map<String, dynamic> draftData) async {
    // Check for images in the draft data
    List<dynamic>? imagesData = draftData['images'];
    int imageCount = draftData['imageCount'] ?? 0;
    
    if ((imagesData != null && imagesData.isNotEmpty) || imageCount > 0) {
      // Load images from draft data
      await loadImagesFromDraft(draftData);
      
      Get.snackbar(
        'Draft Images Loaded',
        '${selectedImages.length} images loaded from draft',
        backgroundColor: Colors.green,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _loadTextControllers(Map<String, dynamic> draftData) {
    // Location controllers
    if (draftData['state'] != null) stateController.text = draftData['state'];
    if (draftData['district'] != null) districtController.text = draftData['district'];
    if (draftData['subdivision'] != null) subdivisionController.text = draftData['subdivision'];
    if (draftData['village'] != null) villageController.text = draftData['village'];
    if (draftData['locationDetails'] != null) locationDetailsController.text = draftData['locationDetails'];
    // if (draftData['otherRelevantInfo'] != null) otherRelevantInformation.text = draftData['otherRelevantInfo'];
  if (draftData['occurrenceDateRange'] != null) occurrenceDateRange.value = draftData['occurrenceDateRange'];
    //  if (draftData['rainfallAmount'] != null) rainfallAmountController.text = draftData['rainfallAmount'];
    

      if (draftData['isLocationAutoPopulated'] == false) {
    isLocationAutoPopulated.value = false;
    selectedStateFromDropdown.value = draftData['state'];
    selectedDistrictFromDropdown.value = draftData['district'];
  }

  // Add this line for affiliation
  if (draftData['affiliation'] != null) {
    affiliationController.text = draftData['affiliation'];
    affiliation.value = draftData['affiliation'];
  }

    // Date and time
    if (draftData['date'] != null) {
      dateController.text = draftData['date'];
      selectedDateText.value = draftData['date'];
    }
    if (draftData['time'] != null) {
      timeController.text = draftData['time'];
      selectedTimeText.value = draftData['time'];
    }
  }

  void _loadDropdownValues(Map<String, dynamic> draftData) {
    landslideOccurrenceValue.value = draftData['landslideOccurrence'];
    howDoYouKnowValue.value = draftData['howDoYouKnow'];
    whereDidLandslideOccurValue.value = draftData['whereDidLandslideOccur'];
    typeOfMaterialValue.value = draftData['typeOfMaterial'];
    // typeOfMovementValue.value = draftData['typeOfMovement'];
    landslideSize.value = draftData['landslideSize'];
    // whatInducedLandslideValue.value = draftData['whatInducedLandslide'];
    // rainfallDurationValue.value = draftData['rainfallDuration'];
  }
  
  void loadCheckboxData(Map<String, dynamic> draftData) {
    _loadImpactDamageData(draftData);
  }

  void _loadImpactDamageData(Map<String, dynamic> draftData) {
    // Impact/Damage checkboxes
    peopleAffected.value = draftData['peopleAffected'] ?? false;
    livestockAffected.value = draftData['livestockAffected'] ?? false;
    housesBuildingAffected.value = draftData['housesBuildingAffected'] ?? false;
    damsBarragesAffected.value = draftData['damsBarragesAffected'] ?? false;
    roadsAffected.value = draftData['roadsAffected'] ?? false;
    roadsBlocked.value = draftData['roadsBlocked'] ?? false;
    roadBenchesDamaged.value = draftData['roadBenchesDamaged'] ?? false;
    railwayLineAffected.value = draftData['railwayLineAffected'] ?? false;
    railwayBlocked.value = draftData['railwayBlocked'] ?? false;
    railwayBenchesDamaged.value = draftData['railwayBenchesDamaged'] ?? false;
    powerInfrastructureAffected.value = draftData['powerInfrastructureAffected'] ?? false;
    damagesToAgriculturalForestLand.value = draftData['damagesToAgriculturalForestLand'] ?? false;
    other.value = draftData['other'] ?? false;
    noDamages.value = draftData['noDamages'] ?? false;
    iDontKnow.value = draftData['iDontKnow'] ?? false;
    
    // Load damage detail controllers
    if (draftData['peopleDead'] != null) peopleDeadController.text = draftData['peopleDead'];
    if (draftData['peopleInjured'] != null) peopleInjuredController.text = draftData['peopleInjured'];
    if (draftData['livestockDead'] != null) livestockDeadController.text = draftData['livestockDead'];
    if (draftData['livestockInjured'] != null) livestockInjuredController.text = draftData['livestockInjured'];
    if (draftData['housesFullyAffected'] != null) housesFullyController.text = draftData['housesFullyAffected'];
    if (draftData['housesPartiallyAffected'] != null) housesPartiallyController.text = draftData['housesPartiallyAffected'];
    if (draftData['damsName'] != null) damsNameController.text = draftData['damsName'];
    if (draftData['railwayDetails'] != null) railwayDetailsController.text = draftData['railwayDetails'];
    if (draftData['otherDamageDetails'] != null) otherDamageDetailsController.text = draftData['otherDamageDetails'];
    
    // Load damage dropdowns
    damsExtentValue.value = draftData['damsExtent'];
    roadTypeValue.value = draftData['roadType'];
    roadExtentValue.value = draftData['roadExtent'];
    roadBlockageValue.value = draftData['roadBlockage'];
    roadBenchesExtentValue.value = draftData['roadBenchesExtent'];
    railwayBlockageValue.value = draftData['railwayBlockage'];
    railwayBenchesExtentValue.value = draftData['railwayBenchesExtent'];
    powerExtentValue.value = draftData['powerExtent'];
  }
  
  Future<Map<String, dynamic>> collectFormData() async {
    // Convert images to base64 for storage
    List<String> imageBase64List = [];
    List<String> imageCaptionsList = [];
    
    for (int i = 0; i < selectedImages.length; i++) {
      try {
        String base64Image = await imageToBase64(selectedImages[i]);
        imageBase64List.add(base64Image);
        imageCaptionsList.add(imageCaptions[i].text);
      } catch (e) {
        print('Error converting image $i to base64: $e');
        // Add empty string to maintain index alignment
        imageBase64List.add('');
        imageCaptionsList.add(imageCaptions[i].text);
      }
    }
    
    return {
      // Location data
      'latitude': latitudeController.text,
      'longitude': longitudeController.text,
      'state': stateController.text,
      'district': districtController.text,
      'subdivision': subdivisionController.text,
      'village': villageController.text,
      'locationDetails': locationDetailsController.text,

       'isLocationAutoPopulated': isLocationAutoPopulated.value,
            //  'rainfallAmount': rainfallAmountController.text,
      // 'rainfallDuration': rainfallDurationValue.value,
      
      // Occurrence data
      'landslideOccurrence': _getEnglishValueForAPI(landslideOccurrenceValue.value, landslideOccurrenceOptions),
      'date': dateController.text,
      'time': timeController.text,
      'howDoYouKnow': _getEnglishValueForAPI(howDoYouKnowValue.value, howDoYouKnowOptions),
     'occurrenceDateRange': occurrenceDateRange.value,
     'imageCaptions': imageCaptionsList,
      
      // Basic landslide data
      'whereDidLandslideOccur': _getEnglishValueForAPI(whereDidLandslideOccurValue.value, whereDidLandslideOccurOptions),
      'typeOfMaterial': _getEnglishValueForAPI(typeOfMaterialValue.value, typeOfMaterialOptions),
      // 'typeOfMovement': typeOfMovementValue.value,
      'landslideSize': landslideSize.value,
      // 'whatInducedLandslide': whatInducedLandslideValue.value,
      // 'otherRelevantInfo': otherRelevantInformation.text,
      
      // Images data for draft - now includes actual images
      'imageCount': selectedImages.length,
      'hasImages': selectedImages.isNotEmpty,
      'images': imageBase64List, // Store actual images as base64
      
      // Impact/Damage
      'peopleAffected': peopleAffected.value,
      'livestockAffected': livestockAffected.value,
      'housesBuildingAffected': housesBuildingAffected.value,
      'damsBarragesAffected': damsBarragesAffected.value,
      'roadsAffected': roadsAffected.value,
      'roadsBlocked': roadsBlocked.value,
      'roadBenchesDamaged': roadBenchesDamaged.value,
      'railwayLineAffected': railwayLineAffected.value,
      'railwayBlocked': railwayBlocked.value,
      'railwayBenchesDamaged': railwayBenchesDamaged.value,
      'powerInfrastructureAffected': powerInfrastructureAffected.value,
      'damagesToAgriculturalForestLand': damagesToAgriculturalForestLand.value,
      'other': other.value,
      'noDamages': noDamages.value,
      'iDontKnow': iDontKnow.value,
      
      // Damage details
      'peopleDead': peopleDeadController.text,
      'peopleInjured': peopleInjuredController.text,
      'livestockDead': livestockDeadController.text,
      'livestockInjured': livestockInjuredController.text,
      'housesFullyAffected': housesFullyController.text,
      'housesPartiallyAffected': housesPartiallyController.text,
      'damsName': damsNameController.text,
      'damsExtent': damsExtentValue.value,
      'roadType': roadTypeValue.value,
      'roadExtent': roadExtentValue.value,
      'roadBlockage': roadBlockageValue.value,
      'roadBenchesExtent': roadBenchesExtentValue.value,
      'railwayDetails': railwayDetailsController.text,
      'railwayBlockage': railwayBlockageValue.value,
      'railwayBenchesExtent': railwayBenchesExtentValue.value,
      'powerExtent': powerExtentValue.value,
      'otherDamageDetails': otherDamageDetailsController.text,
      
      // Contact information
      'username': username.value,
      'email': email.value,
      'mobile': mobile.value,
       'affiliation': affiliationController.text,
    };
  }
  
Future<void> saveDraft() async {
  try {
    final formData = await collectFormData();
    final reportsController = Get.put(RecentReportsController());
  
    if (currentDraftId != null) {
      // Update existing draft with 'public' form type
      await reportsController.updateDraftReport(currentDraftId!, formData, 'public');
      Get.snackbar(
        'success'.tr,
        'public_draft_updated'.tr,
        backgroundColor: const Color(0xFF1976D2),
        colorText: Colors.white,
      );
    } else {
      // Save new draft with 'public' form type
      final draftId = await reportsController.saveDraftReport(formData, 'public');
      currentDraftId = draftId;
      isDraftMode.value = true;
      Get.snackbar(
        'success'.tr,
        'public_form_saved_draft'.tr,
        backgroundColor: const Color(0xFF1976D2),
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.snackbar(
      'error'.tr,
      '${'failed_save_draft'.tr}: $e',
      backgroundColor: Colors.red,
      colorText: Colors.white,
    );
  }
}


  // IMAGE HANDLING METHODS WITH VALIDATION
Future<void> openCamera() async {
  try {
    final XFile? photo = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 85,
    );
    
    if (photo != null) {
      selectedImages.add(File(photo.path));
      imageCaptions.add(TextEditingController());
      _validateImages();
      Get.snackbar(
        'success'.tr,
        '${'photo_captured'.tr} ${selectedImages.length}',
        backgroundColor: const Color(0xFF1976D2),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  } catch (e) {
    Get.snackbar(
      'error'.tr,
      '${'error_accessing_camera'.tr} $e',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}

Future<void> openGallery() async {
  try {
    final List<XFile> photos = await _picker.pickMultiImage(
      maxWidth: 1800,
      maxHeight: 1800,
      imageQuality: 85,
    );
    
    if (photos.isNotEmpty) {
      if (selectedImages.length + photos.length > 5) {
        final remaining = 5 - selectedImages.length;
        Get.snackbar(
          'warning'.tr,
          '${'warning_max_5_images'.tr} $remaining ${'remaining_images'.tr}',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
        selectedImages.addAll(photos.take(remaining).map((photo) => File(photo.path)));
        for (int i = 0; i < remaining; i++) {
          imageCaptions.add(TextEditingController());
        }
      } else {
        selectedImages.addAll(photos.map((photo) => File(photo.path)));
        for (int i = 0; i < photos.length; i++) {
          imageCaptions.add(TextEditingController());
        }
      }
      
      _validateImages();
      Get.snackbar(
        'success'.tr,
        '${photos.length} ${'images_selected_gallery'.tr} ${selectedImages.length}',
        backgroundColor: const Color(0xFF1976D2),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  } catch (e) {
    Get.snackbar(
      'error'.tr,
      '${'error_accessing_gallery'.tr} $e',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}



  void removeImage(int index) {
    selectedImages.removeAt(index);
    // Dispose and remove the corresponding caption controller
  imageCaptions[index].dispose();
  imageCaptions.removeAt(index);
    _validateImages(); // Re-validate after removal
  }

  // IMAGE VALIDATION METHOD
bool _validateImages() {
  if (selectedImages.isEmpty) {
    imageValidationError.value = 'at_least_one_image_required'.tr;
    return false;
  } else {
    imageValidationError.value = '';
    return true;
  }
}

  // Load images from draft data
  Future<void> loadImagesFromDraft(Map<String, dynamic> formData) async {
    try {
      // Clear existing images
      selectedImages.clear();
      for (var controller in imageCaptions) {
        controller.dispose();
      }
      imageCaptions.clear();
      
      // Load images from base64 data
      List<dynamic>? imagesData = formData['images'];
      List<dynamic>? captionsData = formData['imageCaptions'];
      
      if (imagesData != null && imagesData.isNotEmpty) {
        // Get temporary directory for proper file storage
        final tempDir = await getTemporaryDirectory();
        
        for (int i = 0; i < imagesData.length; i++) {
          try {
            String base64Image = imagesData[i];
            if (base64Image.isNotEmpty) {
              // Convert base64 to File object
              List<int> bytes = base64Decode(base64Image);
              String tempPath = '${tempDir.path}/draft_image_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
              File tempFile = File(tempPath);
              await tempFile.writeAsBytes(bytes);
              
              selectedImages.add(tempFile);
              
              // Add caption controller
              TextEditingController captionController = TextEditingController();
              if (captionsData != null && i < captionsData.length) {
                captionController.text = captionsData[i] ?? '';
              }
              imageCaptions.add(captionController);
            }
          } catch (e) {
            print('Error loading image $i from draft: $e');
          }
        }
      }
      
      _validateImages();
    } catch (e) {
      print('Error loading images from draft: $e');
    }
  }

  // Enhanced validation to show image requirement prominently
void showImageRequirementDialog() {
  Get.dialog(
    AlertDialog(
      title: Row(
        children: [
          Icon(Icons.camera_alt, color: Colors.red, size: 24),
          const SizedBox(width: 8),
          Text('images_required'.tr),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'at_least_one_image_required'.tr,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Text(
            'please_action'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('• ${'use_camera_button'.tr}'),
          Text('• ${'use_gallery_button'.tr}'),
          Text('• ${'up_to_5_images'.tr}'),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info, color: Colors.blue.shade700, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'good_quality_images_help'.tr,
                    style: const TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('ok'.tr),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            openCamera();
          },
          child: Text('take_photo'.tr),
        ),
      ],
    ),
  );
}

  // Show landslide size selection dialog
void showLandslideSizeDialog() {
  Get.dialog(
    AlertDialog(
      title: Text('select_landslide_size_title'.tr),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildSizeOption('small_building'.tr),
          _buildSizeOption('medium_building'.tr),
          _buildSizeOption('large_building'.tr),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('cancel'.tr),
        ),
      ],
    ),
  );
}

  // Show landslide size info dialog
  void showLandslideSizeInfoDialog() {
    Get.dialog(
      AlertDialog(
        title: Row(
          children: [
            Icon(Icons.info, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            Text('size_categories'.tr),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• ${'small_size_desc'.tr}'),
            Text('• ${'medium_size_desc'.tr}'),
            Text('• ${'large_size_desc'.tr}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('ok'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeOption(String size) {
    return ListTile(
      title: Text(size),
      onTap: () {
        landslideSize.value = size;
        Get.back();
      },
    );
  }

  // DATE AND TIME METHODS
  Future<void> selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      final formattedDate = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      dateController.text = formattedDate;
      selectedDateText.value = formattedDate;
    }
  }

  Future<void> selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: Get.context!,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      final formattedTime = "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      timeController.text = formattedTime;
      selectedTimeText.value = formattedTime;
    }
  }

  // VALIDATION METHODS
String? validateRequired(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) {
    return '$fieldName ${'is_required'.tr}';
  }
  return null;
}
  
bool validateForm() {
  bool isValid = true;
  String errorMessage = '';
  
  // Check image requirement FIRST
  if (!_validateImages()) {
    showImageRequirementDialog();
    return false;
  }
  
  // Check required fields
  if (stateController.text.trim().isEmpty) {
    errorMessage += '${'state_required'.tr}\n';
    isValid = false;
  }
  
  if (districtController.text.trim().isEmpty) {
    errorMessage += '${'district_required'.tr}\n';
    isValid = false;
  }
  
  if (landslideOccurrenceValue.value == null) {
    errorMessage += '${'landslide_occurrence_required'.tr}\n';
    isValid = false;
  }
  
  if (!isValid) {
    Get.snackbar(
      'validation_error'.tr,
      errorMessage.trim(),
      backgroundColor: Colors.red,
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
      snackPosition: SnackPosition.BOTTOM,
    );
  }
  
  return isValid;
}

  // Get validation summary for UI display
Map<String, dynamic> getValidationSummary() {
  int totalRequired = 4; // Total required fields for public form
  int completed = 0;
  List<String> missing = [];
  
  // Check each required field
  if (stateController.text.trim().isNotEmpty) completed++; else missing.add('state'.tr);
  if (districtController.text.trim().isNotEmpty) completed++; else missing.add('district'.tr);
  if (landslideOccurrenceValue.value != null) completed++; else missing.add('landslide_occurrence_required'.tr);

  if (selectedImages.isNotEmpty) completed++; else missing.add('images_required_error'.tr);
  
  return {
    'totalRequired': totalRequired,
    'completed': completed,
    'percentage': ((completed / totalRequired) * 100).round(),
    'missing': missing,
    'isComplete': completed == totalRequired,
  };
}


  // API HELPER METHODS
  String formatDateForAPI(String displayDate) {
    if (displayDate.isEmpty) return "";
    
    try {
      List<String> parts = displayDate.split('/');
      if (parts.length == 3) {
        String day = parts[0];
        String month = parts[1];
        String year = parts[2];
        return "${year}-${month.padLeft(2, '0')}-${day.padLeft(2, '0')}T00:00:00";
      }
    } catch (e) {
      print("Error formatting date: $e");
    }
    return "";
  }

  String formatTimeForAPI(String displayTime) {
    if (displayTime.isEmpty) return "";
    
    try {
      if (displayTime.contains(':') && displayTime.split(':').length == 2) {
        return "$displayTime:00";
      }
    } catch (e) {
      print("Error formatting time: $e");
    }
    return "";
  }

  Future<String> imageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    return base64Encode(imageBytes);
  }

  // FORM SUBMISSION WITH ENHANCED IMAGE VALIDATION
// FORM SUBMISSION WITH OFFLINE SUPPORT
Future<void> submitForm() async {
  // First validate images with enhanced UI feedback
  if (selectedImages.isEmpty) {
    showImageRequirementDialog();
    return;
  }
  
  if (!validateForm()) return;
  
  try {
    isLoading.value = true;
    
    // Check internet connectivity
    bool hasInternet = await _checkInternetConnection();
    
    // Convert first image to base64 (required)
    String landslidePhotographs = '';
    if (selectedImages.isNotEmpty) {
      landslidePhotographs = await imageToBase64(selectedImages.first);
    }
    
// Check if we're editing a pending report
if (currentPendingReportId != null && isPendingEditMode.value) {
  // Update the existing pending report instead of creating new one
  Map<String, dynamic> updatedPayload = await _buildApiPayload(landslidePhotographs);
  
  final reportsController = Get.put(RecentReportsController());
  await reportsController.updatePendingReport(currentPendingReportId!, updatedPayload);
  
      Get.snackbar(
        'success'.tr,
        'public_pending_report_updated'.tr,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
  
  Get.back(); // Go back to reports screen
  return;
}

    // Build the payload
    Map<String, dynamic> payload = await _buildApiPayload(landslidePhotographs);
    
    if (hasInternet) {
      // Online submission
      try {
        // Debug: Print the payload being sent
        print('🔍 DEBUG: Sending payload to API:');
        print('Payload: ${jsonEncode(payload)}');
        
        // Debug: Check for null or empty values that might cause issues
        print('🔍 DEBUG: Checking for potential issues:');
        payload.forEach((key, value) {
          if (value == null || value == 'null' || value == '') {
            print('⚠️  WARNING: Field "$key" has value: "$value"');
          }
        });
        
        await ApiService.postLandslide('/Landslide/create/${mobile.value}/Public', [payload]);
        
        // Handle successful submission
        final reportsController = Get.put(RecentReportsController());
        
        if (currentDraftId != null) {
          // If this was an existing draft, update its status to submitted
          await reportsController.updateDraftSubmissionStatus(currentDraftId!, 'submitted');
        } else {
          // If this was a new submission, save it to draft section with submitted status
          final completeFormData = await _buildCompleteFormData();
          completeFormData['title'] = 'Public Landslide Report - ${completeFormData['district'] ?? completeFormData['state'] ?? 'Unknown Location'}';
          completeFormData['submissionStatus'] = 'submitted';
          completeFormData['createdAt'] = DateTime.now().toIso8601String();
          completeFormData['updatedAt'] = DateTime.now().toIso8601String();
          
          await reportsController.saveDraftReport(completeFormData, 'public');
        }
        
        _showSuccessDialog(isOnline: true);
        
      } catch (e) {
        // If API fails, save to draft section with pending status
        final reportsController = Get.put(RecentReportsController());
        
        if (currentDraftId != null) {
          // If this was an existing draft, update its status to pending
          await reportsController.updateDraftSubmissionStatus(currentDraftId!, 'pending');
        } else {
          // If this was a new submission, save it to draft section with pending status
          final completeFormData = await _buildCompleteFormData();
          completeFormData['title'] = 'Public Landslide Report - ${completeFormData['district'] ?? completeFormData['state'] ?? 'Unknown Location'}';
          completeFormData['submissionStatus'] = 'pending';
          completeFormData['createdAt'] = DateTime.now().toIso8601String();
          completeFormData['updatedAt'] = DateTime.now().toIso8601String();
          
          await reportsController.saveDraftReport(completeFormData, 'public');
        }
        
        _showSuccessDialog(isOnline: false);
      }
    } else {
      // Offline submission
      await _handleOfflineSubmission(payload);
      _showSuccessDialog(isOnline: false);
    }
    
  } catch (e) {
Get.snackbar(
      'error'.tr,
      '${'failed_to_process_report'.tr}: $e',
      backgroundColor: Colors.red,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
    );
  } finally {
    isLoading.value = false;
  }
}

// Handle offline submission
// Replace the existing _handleOfflineSubmission method
Future<void> _handleOfflineSubmission(Map<String, dynamic> payload) async {
  final reportsController = Get.put(RecentReportsController());
  
  // Add form type and title to payload
  payload['formType'] = 'public';
  payload['title'] = 'Public Landslide Report - ${payload['District'] ?? payload['State'] ?? 'Unknown Location'}';
  
  // If this was a draft, update its status to pending instead of deleting
  if (currentDraftId != null) {
    await reportsController.updateDraftSubmissionStatus(currentDraftId!, 'pending');
  }
  
  // Add to "To Be Synced" queue
  await reportsController.addToBeSyncedReport(payload);
}


// Show success dialog
void _showSuccessDialog({required bool isOnline}) {
  Get.dialog(
    WillPopScope(
      onWillPop: () async => false, // Prevent back button
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Green checkmark icon
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 50,
                ),
              ),
              const SizedBox(height: 24),
              
              // Thank you text
              Text(
                'thankyou'.tr,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              
              // Subtitle
              Text(
                'filling_proforma_message'.tr,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              
              // GSI text
              Text(
                'geological_survey_india'.tr,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              
              if (!isOnline) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.wifi_off, color: Colors.orange.shade700, size: 24),
                      const SizedBox(height: 8),
                      Text(
                        'report_saved_offline'.tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              
              const SizedBox(height: 32),
              
              // DONE button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Get.back(); // Close dialog
                    Get.back(); // Go back to previous screen
                  },
                  child: Text(
                    'done'.tr,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    barrierDismissible: false,
  );
}


// Build complete form data for storage (what user sees)
Future<Map<String, dynamic>> _buildCompleteFormData() async {
  // Convert images to base64 for storage
  List<String> base64Images = [];
  for (File imageFile in selectedImages) {
    String base64Image = await imageToBase64(imageFile);
    base64Images.add(base64Image);
  }
  
  return {
    // Location Information
    "latitude": latitudeController.text.trim(),
    "longitude": longitudeController.text.trim(),
    "state": stateController.text.trim(),
    "district": districtController.text.trim(),
    "subdivision": subdivisionController.text.trim(),
    "village": villageController.text.trim(),
    "locationDetails": locationDetailsController.text.trim(),
    "isLocationAutoPopulated": isLocationAutoPopulated.value,
    
    // Date and Time
    "date": dateController.text.trim(),
    "time": timeController.text.trim(),
    "landslideOccurrence": landslideOccurrenceValue.value,
    "howDoYouKnow": howDoYouKnowValue.value,
    "occurrenceDateRange": occurrenceDateRange.value.trim(),
    
    // Images
    "images": base64Images,
    "imageCaptions": imageCaptions.map((controller) => controller.text).toList(),
    "imageCount": selectedImages.length,
    "hasImages": selectedImages.isNotEmpty,
    
    // Landslide Details
    "whereDidLandslideOccur": whereDidLandslideOccurValue.value,
    "typeOfMaterial": typeOfMaterialValue.value,
    "landslideSize": landslideSize.value,
    
    // Impact and Damage
    "peopleAffected": peopleAffected.value,
    "livestockAffected": livestockAffected.value,
    "housesBuildingAffected": housesBuildingAffected.value,
    "damsBarragesAffected": damsBarragesAffected.value,
    "roadsAffected": roadsAffected.value,
    "roadsBlocked": roadsBlocked.value,
    "roadBenchesDamaged": roadBenchesDamaged.value,
    "railwayLineAffected": railwayLineAffected.value,
    "railwayBlocked": railwayBlocked.value,
    "railwayBenchesDamaged": railwayBenchesDamaged.value,
    "powerInfrastructureAffected": powerInfrastructureAffected.value,
    "damagesToAgriculturalForestLand": damagesToAgriculturalForestLand.value,
    "other": other.value,
    "noDamages": noDamages.value,
    "iDontKnow": iDontKnow.value,
    
    // Damage Details
    "peopleDead": peopleDeadController.text.trim(),
    "peopleInjured": peopleInjuredController.text.trim(),
    "livestockDead": livestockDeadController.text.trim(),
    "livestockInjured": livestockInjuredController.text.trim(),
    "housesFullyAffected": housesFullyController.text.trim(),
    "housesPartiallyAffected": housesPartiallyController.text.trim(),
    "damsName": damsNameController.text.trim(),
    "damsExtent": damsExtentValue.value,
    "roadType": roadTypeValue.value,
    "roadExtent": roadExtentValue.value,
    "roadBlockage": roadBlockageValue.value,
    "roadBenchesExtent": roadBenchesExtentValue.value,
    "railwayDetails": railwayDetailsController.text.trim(),
    "railwayBlockage": railwayBlockageValue.value,
    "railwayBenchesExtent": railwayBenchesExtentValue.value,
    "powerExtent": powerExtentValue.value,
    "otherDamageDetails": otherDamageDetailsController.text.trim(),
    
    // User Information
    "username": username.value,
    "email": email.value,
    "mobile": mobile.value,
    "affiliation": affiliationController.text.trim(),
    
    // Form Type
    "formType": "public",
    "userType": "Public",
  };
}

// Update the _buildApiPayload method to convert translated values to English
Future<Map<String, dynamic>> _buildApiPayload(String landslidePhotographs) async {
  // Convert additional images to base64 if they exist
  String? landslidePhotograph1;
  String? landslidePhotograph2;
  String? landslidePhotograph3;
  String? landslidePhotograph4;
  
  if (selectedImages.length > 1) {
    landslidePhotograph1 = await imageToBase64(selectedImages[1]);
  }
  if (selectedImages.length > 2) {
    landslidePhotograph2 = await imageToBase64(selectedImages[2]);
  }
  if (selectedImages.length > 3) {
    landslidePhotograph3 = await imageToBase64(selectedImages[3]);
  }
  if (selectedImages.length > 4) {
    landslidePhotograph4 = await imageToBase64(selectedImages[4]);
  }
  
  return {
    "Latitude": latitudeController.text.trim(),
    "Longitude": longitudeController.text.trim(),
    "State": stateController.text.trim(),
    "District": districtController.text.trim(),
    "SubdivisionOrTaluk": subdivisionController.text.trim(),
    "Village": villageController.text.trim(),
    "LocationDetails": locationDetailsController.text.trim(),
    "LandslideDate": dateController.text.trim().isNotEmpty ? formatDateForAPI(dateController.text.trim()) : null,
    "LandslideTime": timeController.text.trim().isNotEmpty ? formatTimeForAPI(timeController.text.trim()) : null,
    "LandslidePhotographs": landslidePhotographs,
    "LanduseOrLandcover": translateToEnglish(whereDidLandslideOccurValue.value, 'locationType') ?? "",
    "MaterialInvolved": translateToEnglish(typeOfMaterialValue.value, 'material') ?? "",
    "LandslideSize": translateToEnglish(landslideSize.value, 'size') ?? "",
    "ImpactOrDamage": buildImpactDamageString(),
    "Status": null,
    "LivestockDead": livestockDeadController.text.trim().isNotEmpty ? livestockDeadController.text.trim() : "0",
    "LivestockInjured": livestockInjuredController.text.trim().isNotEmpty ? livestockInjuredController.text.trim() : "0",
    "HousesBuildingfullyaffected": housesFullyController.text.trim().isNotEmpty ? housesFullyController.text.trim() : "0",
    "HousesBuildingpartialaffected": housesPartiallyController.text.trim().isNotEmpty ? housesPartiallyController.text.trim() : "0",
    "DamsBarragesCount": damsNameController.text.trim().isNotEmpty ? "1" : "0",
    "DamsBarragesExtentOfDamage": translateToEnglish(damsExtentValue.value, 'extent') ?? "",
    "RoadsAffectedType": translateToEnglish(roadTypeValue.value, 'roadType') ?? "",
    "RoadsAffectedExtentOfDamage": translateToEnglish(roadExtentValue.value, 'extent') ?? "",
    "RoadBlocked": translateToEnglish(roadBlockageValue.value, 'extent') ?? "",
    "RoadBenchesAffected": translateToEnglish(roadBenchesExtentValue.value, 'extent') ?? "",
    "RailwayLineAffected": railwayDetailsController.text.trim(),
    "RailwayLineBlockage": translateToEnglish(railwayBlockageValue.value, 'extent') ?? "",
    "RailwayBenchesAffected": translateToEnglish(railwayBenchesExtentValue.value, 'extent') ?? "",
    "PowerInfrastructureAffected": translateToEnglish(powerExtentValue.value, 'extent') ?? "",
    "OthersAffected": otherDamageDetailsController.text.trim(),
    "Date_and_time_Range": translateToEnglish(occurrenceDateRange.value.trim(), 'dateRange'),
    "datacreatedby": mobile.value,
    "DateTimeType": translateToEnglish(landslideOccurrenceValue.value, 'occurrence') ?? "",
    "LandslidePhotograph1": landslidePhotograph1,
    "LandslidePhotograph2": landslidePhotograph2,
    "LandslidePhotograph3": landslidePhotograph3,
    "LandslidePhotograph4": landslidePhotograph4,
    "check_Status": "Pending",
    "PeopleDead": peopleDeadController.text.trim().isNotEmpty ? peopleDeadController.text.trim() : "0",
    "PeopleInjured": peopleInjuredController.text.trim().isNotEmpty ? peopleInjuredController.text.trim() : "0",
    "ContactName": username.value,
    "ContactAffiliation": affiliationController.text.trim(),
    "ContactEmailId": email.value,
    "ContactMobile": mobile.value,
    "UserType": "Public",
    "source": "webportal",
    "ExactDateInfo": translateToEnglish(howDoYouKnowValue.value, 'source') ?? "",
    "DamsBarragesName": damsNameController.text.trim(),
  };
}

  // STRING BUILDER METHODS FOR API
String buildImpactDamageString() {
  List<String> impacts = [];
  
  // Store the English keys for API, but display translated values in UI
  if (peopleAffected.value) impacts.add("People affected");
  if (livestockAffected.value) impacts.add("Livestock affected");
  if (housesBuildingAffected.value) impacts.add("Houses and buildings affected");
  if (damsBarragesAffected.value) impacts.add("Dams / Barrages affected");
  if (roadsAffected.value) impacts.add("Roads affected");
  if (roadsBlocked.value) impacts.add("Roads blocked");
  if (roadBenchesDamaged.value) impacts.add("Road benches damaged");
  if (railwayLineAffected.value) impacts.add("Railway line affected");
  if (railwayBlocked.value) impacts.add("Railway blocked");
  if (railwayBenchesDamaged.value) impacts.add("Railway benches damaged");
  if (powerInfrastructureAffected.value) impacts.add("Power infrastructure and telecommunication affected");
  if (damagesToAgriculturalForestLand.value) impacts.add("Damages to Agriculture/Barren/Forest");
  if (other.value) impacts.add("Other");
  if (noDamages.value) impacts.add("No damages");
  if (iDontKnow.value) impacts.add("I don't know");
  
  return impacts.join(", ");
}

  // UTILITY METHODS FOR UI
  
  // Get image status for UI display
String getImageStatusText() {
  if (selectedImages.isEmpty) {
    return 'no_images_selected'.tr;
  } else if (selectedImages.length == 1) {
    return 'image_selected_single'.tr;
  } else {
    return '${selectedImages.length} ${'images_selected_multiple'.tr}';
  }
}

  // Check if form can be submitted
  bool canSubmitForm() {
    return selectedImages.isNotEmpty && getValidationSummary()['completed'] >= 3; // At least 75% complete
  }

  // Get form completion status for UI
String getFormCompletionText() {
  final summary = getValidationSummary();
  return '${summary['completed']} of ${summary['totalRequired']} required fields completed';
}

  // Show validation summary dialog
void showValidationSummary() {
  final summary = getValidationSummary();
  Get.dialog(
    AlertDialog(
      title: Row(
        children: [
          Icon(
            summary['isComplete'] ? Icons.check_circle : Icons.warning,
            color: summary['isComplete'] ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 8),
          Text('form_status'.tr),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'पूर्णता: ${summary['percentage']}%',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('${summary['completed']} में से ${summary['totalRequired']} आवश्यक फ़ील्ड पूर्ण'),
            const SizedBox(height: 16),
            if (!summary['isComplete']) ...[
              Text(
                'missing_required_fields'.tr,
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 8),
              ...summary['missing'].map((field) => Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 4),
                child: Row(
                  children: [
                    const Icon(Icons.circle, size: 6, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(child: Text(field)),
                  ],
                ),
              )),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info, color: Colors.blue.shade700),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'save_as_draft_info'.tr,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        if (!summary['isComplete'])
          TextButton(
            onPressed: () {
              Get.back();
              saveDraft();
            },
            child: Text('save_as_draft'.tr),
          ),
        TextButton(
          onPressed: () => Get.back(),
          child: Text('close'.tr),
        ),
        if (summary['isComplete'])
          ElevatedButton(
            onPressed: () {
              Get.back();
              submitForm();
            },
            child: Text('submit_report'.tr),
          ),
      ],
    ),
  );
}

  // CLEANUP METHODS
  void _disposeAllControllers() {
    // Basic controllers
    latitudeController.dispose();
    longitudeController.dispose();
    stateController.dispose();
    districtController.dispose();
    subdivisionController.dispose();
    villageController.dispose();
    locationDetailsController.dispose();
    dateController.dispose();
    timeController.dispose();
    // otherRelevantInformation.dispose();
    affiliationController.dispose(); // Add this line
        // rainfallAmountController.dispose();
    
    // Impact controllers
    peopleDeadController.dispose();
    peopleInjuredController.dispose();
    livestockDeadController.dispose();
    livestockInjuredController.dispose();
    housesFullyController.dispose();
    housesPartiallyController.dispose();
    damsNameController.dispose();
    railwayDetailsController.dispose();
    otherDamageDetailsController.dispose();
    for (var controller in imageCaptions) {
  controller.dispose();
}
imageCaptions.clear();
  }

  // Add option constants for public form
  static const List<String> landslideOccurrenceOptions = [
    'exact_occurrence_date',
    'approximate_occurrence_date', 
    'no_occurrence_date'
  ];

  static const List<String> howDoYouKnowOptions = [
    'i_observed_it',
    'through_local',
    'social_media',
    'news',
    'i_dont_know',
  ];

  static const List<String> whereDidLandslideOccurOptions = [
    'near_on_road',
    'next_to_river',
    'settlement',
    'plantation',
    'forest_area',
    'cultivation',
    'barren_land',
    'other_specify'
  ];

  static const List<String> typeOfMaterialOptions = [
    'rock',
    'soil',
    'debris_mixture'
  ];

  static const List<String> roadTypeOptions = [
    'state_highway',
    'national_highway',
    'local'
  ];

  static const List<String> roadExtentOptions = [
    'full',
    'partial'
  ];

  static const List<String> landslideSizeOptions = [
    'small_building',
    'medium_building',
    'large_building'
  ];

  // Helper method to get English value for API submission
  String? _getEnglishValueForAPI(String? currentValue, List<String> optionKeys) {
    if (currentValue == null) return null;
    
    // If it's already an English key, return it
    if (optionKeys.contains(currentValue)) {
      return currentValue;
    }
    
    // If it's a translated value, find the English key
    for (String key in optionKeys) {
      if (key.tr == currentValue) {
        return key;
      }
    }
    
    // Try Hindi to English mapping
    String? englishKey = _findEnglishKeyFromHindiValue(currentValue, optionKeys);
    return englishKey;
  }

  // Helper method to find English key from Hindi value
  String? _findEnglishKeyFromHindiValue(String? hindiValue, List<String> optionKeys) {
    if (hindiValue == null) return null;
    
    // Create a static mapping of Hindi values to English keys
    Map<String, String> hindiToEnglishMap = {
      // Landslide occurrence options
      'मुझे सटीक घटना तिथि पता है': 'exact_occurrence_date',
      'मुझे अनुमानित घटना तिथि पता है': 'approximate_occurrence_date',
      'मुझे घटना की तारीख नहीं पता': 'no_occurrence_date',
      
      // How do you know options
      'मैंने इसे देखा': 'i_observed_it',
      'स्थानीय व्यक्ति के माध्यम से': 'through_local',
      'सोशल मीडिया': 'social_media',
      'समाचार': 'news',
      'मुझे नहीं पता': 'i_dont_know',
      
      // Where did landslide occur options
      'सड़क के निकट/पर': 'near_on_road',
      'नदी के पास': 'next_to_river',
      'बस्ती': 'settlement',
      'बागान (चाय, रबर .... आदि)': 'plantation',
      'वन क्षेत्र': 'forest_area',
      'खेती': 'cultivation',
      'बंजर भूमि': 'barren_land',
      'अन्य (निर्दिष्ट करें)': 'other_specify',
      
      // Material type options
      'चट्टान': 'rock',
      'मिट्टी': 'soil',
      'मलबा (चट्टान और मिट्टी का मिश्रण)': 'debris_mixture',
    };
    
    // Return the English key for the Hindi value
    return hindiToEnglishMap[hindiValue];
  }

  // Helper method to get translated value for display
  String? getTranslatedValueForDisplay(String? storedValue, List<String> optionKeys) {
    if (storedValue == null) return null;
    
    // If stored value is already a translation key, translate it
    if (optionKeys.contains(storedValue)) {
      return storedValue.tr;
    }
    
    // If stored value is Hindi text, find the corresponding English key and translate it
    String? englishKey = _findEnglishKeyFromHindiValue(storedValue, optionKeys);
    if (englishKey != null) {
      return englishKey.tr;
    }
    
    // If stored value is already translated text, return as is
    return storedValue;
  }

  // Helper method to get English key from translated value
  String? getEnglishKeyFromTranslatedValue(String? translatedValue, List<String> optionKeys) {
    if (translatedValue == null) return null;
    
    // If the value is already an English key, return it
    if (optionKeys.contains(translatedValue)) {
      return translatedValue;
    }
    
    // Find the English key for the translated value
    for (String key in optionKeys) {
      if (key.tr == translatedValue) {
        return key;
      }
    }
    
    return null;
  }
}