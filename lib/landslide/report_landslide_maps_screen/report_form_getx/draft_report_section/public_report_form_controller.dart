import 'dart:convert';
import 'dart:io';
import 'package:bhooskhalann/user_profile/profile_controller.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bhooskhalann/services/api_service.dart';
import 'recent_report_screen/recent_reports_controller.dart';

class PublicLandslideReportController extends GetxController {

final ProfileController pc = Get.put(ProfileController());

  final formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  
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

    final rainfallAmountController = TextEditingController();
  var rainfallDurationValue = Rxn<String>();
  

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
  final otherRelevantInformation = TextEditingController();
  
  // Dropdown values - Main form
  var landslideOccurrenceValue = Rxn<String>();
  var howDoYouKnowValue = Rxn<String>();
  var whereDidLandslideOccurValue = Rxn<String>();
  var typeOfMaterialValue = Rxn<String>();
  var typeOfMovementValue = Rxn<String>();
  var landslideSize = Rxn<String>(); // New field for public form
  var whatInducedLandslideValue = Rxn<String>();
  
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
void onInit() {
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
      loadDraftData(args['draftData']);
    }
    // Check if this is a pending report being edited
    else if (args.containsKey('pendingReportId') && args.containsKey('pendingReportData')) {
      currentPendingReportId = args['pendingReportId']; // Add this property to controller
      isPendingEditMode.value = true; // Add this property to controller
      loadDraftData(args['pendingReportData']); // Reuse the same loading method
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
          
          String? state, district;
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
          _showLocationError('No results found');
        }
      } else {
        isLocationAutoPopulated.value = false;
        _showLocationError('API request failed');
      }
    }
  } catch (e) {
    isLocationAutoPopulated.value = false;
    _showLocationError(e.toString());
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

// Clean location names
String _cleanLocationName(String name) {
  return name
      .replaceAll(RegExp(r'\s+(District|Division|State|Taluk|Block)$', caseSensitive: false), '')
      .trim();
}

// Error handling methods
void _showLocationNotFound() {
  Get.snackbar(
    'Location Not Found',
    'Could not fetch location details. Please enter manually.',
    backgroundColor: Colors.orange,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
    duration: const Duration(seconds: 3),
  );
}

void _showLocationError(String error) {
  Get.snackbar(
    'Location Error',
    'Failed to get location: $error',
    backgroundColor: Colors.red,
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
    fetchLocationFromCoordinates();
  }

  // DRAFT MANAGEMENT METHODS
  void loadDraftData(Map<String, dynamic> draftData) {
    try {
      _loadTextControllers(draftData);
      _loadDropdownValues(draftData);
      loadCheckboxData(draftData);
      _loadDraftImages(draftData);
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

  void _loadDraftImages(Map<String, dynamic> draftData) {
    if (draftData['imageCount'] != null && draftData['imageCount'] > 0) {
      Get.snackbar(
        'Draft Images',
        'This draft had ${draftData['imageCount']} images. Please re-select images for submission.',
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
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
    if (draftData['otherRelevantInfo'] != null) otherRelevantInformation.text = draftData['otherRelevantInfo'];
  if (draftData['occurrenceDateRange'] != null) occurrenceDateRange.value = draftData['occurrenceDateRange'];
     if (draftData['rainfallAmount'] != null) rainfallAmountController.text = draftData['rainfallAmount'];
    

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
    typeOfMovementValue.value = draftData['typeOfMovement'];
    landslideSize.value = draftData['landslideSize'];
    whatInducedLandslideValue.value = draftData['whatInducedLandslide'];
    rainfallDurationValue.value = draftData['rainfallDuration'];
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
  
  Map<String, dynamic> collectFormData() {
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
             'rainfallAmount': rainfallAmountController.text,
      'rainfallDuration': rainfallDurationValue.value,
      
      // Occurrence data
      'landslideOccurrence': landslideOccurrenceValue.value,
      'date': dateController.text,
      'time': timeController.text,
      'howDoYouKnow': howDoYouKnowValue.value,
     'occurrenceDateRange': occurrenceDateRange.value,
      
      // Basic landslide data
      'whereDidLandslideOccur': whereDidLandslideOccurValue.value,
      'typeOfMaterial': typeOfMaterialValue.value,
      'typeOfMovement': typeOfMovementValue.value,
      'landslideSize': landslideSize.value,
      'whatInducedLandslide': whatInducedLandslideValue.value,
      'otherRelevantInfo': otherRelevantInformation.text,
      
      // Images metadata for draft
      'imageCount': selectedImages.length,
      'hasImages': selectedImages.isNotEmpty,
      
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
    final formData = collectFormData();
    final reportsController = Get.put(RecentReportsController());
  
    if (currentDraftId != null) {
      // Update existing draft with 'public' form type
      await reportsController.updateDraftReport(currentDraftId!, formData, 'public');
      Get.snackbar(
        'Success',
        'Public draft updated successfully',
        backgroundColor: const Color(0xFF1976D2),
        colorText: Colors.white,
      );
    } else {
      // Save new draft with 'public' form type
      final draftId = await reportsController.saveDraftReport(formData, 'public');
      currentDraftId = draftId;
      isDraftMode.value = true;
      Get.snackbar(
        'Success',
        'Public form saved as draft',
        backgroundColor: const Color(0xFF1976D2),
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.snackbar(
      'Error',
      'Failed to save public draft: $e',
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
        _validateImages(); // Clear any validation errors
        Get.snackbar(
          'Success',
          'Photo captured! Total images: ${selectedImages.length}',
          backgroundColor: const Color(0xFF1976D2),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error accessing camera: $e',
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
        // Check if adding these photos would exceed the limit (max 5 images)
        if (selectedImages.length + photos.length > 5) {
          final remaining = 5 - selectedImages.length;
          Get.snackbar(
            'Warning',
            'You can only select up to 5 images. Adding $remaining images.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
          selectedImages.addAll(photos.take(remaining).map((photo) => File(photo.path)));
        } else {
          selectedImages.addAll(photos.map((photo) => File(photo.path)));
        }
        
        _validateImages(); // Clear any validation errors
        Get.snackbar(
          'Success',
          '${photos.length} images selected! Total images: ${selectedImages.length}',
          backgroundColor: const Color(0xFF1976D2),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error accessing gallery: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  void removeImage(int index) {
    selectedImages.removeAt(index);
    _validateImages(); // Re-validate after removal
  }

  // IMAGE VALIDATION METHOD
  bool _validateImages() {
    if (selectedImages.isEmpty) {
      imageValidationError.value = 'At least one image is required';
      return false;
    } else {
      imageValidationError.value = '';
      return true;
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
            const Text('Images Required'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'At least one image is required to submit the landslide report.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Please:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text('• Use the CAMERA button to take photos'),
            const Text('• Use the GALLERY button to select existing photos'),
            const Text('• You can add up to 5 images'),
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
                  const Expanded(
                    child: Text(
                      'Good quality images help in better assessment of the landslide.',
                      style: TextStyle(fontSize: 14),
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
            child: const Text('OK'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              openCamera();
            },
            child: const Text('Take Photo'),
          ),
        ],
      ),
    );
  }

  // Show landslide size selection dialog
  void showLandslideSizeDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Select Landslide Size'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSizeOption('Small - (Less than 2 storey Building) < 6m'),
            _buildSizeOption('Medium - (Two to 5 storey Building) 6-15m'),
            _buildSizeOption('Large - (More than 5 storey Building) > 15m'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('CANCEL'),
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
      return '$fieldName is required';
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
      errorMessage += 'State is required\n';
      isValid = false;
    }
    
    if (districtController.text.trim().isEmpty) {
      errorMessage += 'District is required\n';
      isValid = false;
    }
    
    if (landslideOccurrenceValue.value == null) {
      errorMessage += 'Landslide occurrence is required\n';
      isValid = false;
    }
    
    if (whereDidLandslideOccurValue.value == null) {
      errorMessage += 'Landslide location type is required\n';
      isValid = false;
    }
    
    if (typeOfMaterialValue.value == null) {
      errorMessage += 'Type of material is required\n';
      isValid = false;
    }
    
    if (typeOfMovementValue.value == null) {
      errorMessage += 'Type of movement is required\n';
      isValid = false;
    }
    
    if (landslideSize.value == null) {
      errorMessage += 'Landslide size is required\n';
      isValid = false;
    }
    
    if (whatInducedLandslideValue.value == null) {
      errorMessage += 'What induced landslide is required\n';
      isValid = false;
    }
       if (whatInducedLandslideValue.value == 'Rainfall') {
      if (rainfallDurationValue.value == null) {
        errorMessage += 'Rainfall duration is required when trigger is rainfall\n';
        isValid = false;
      }
    }
    
    if (!isValid) {
      Get.snackbar(
        'Validation Error',
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
    int totalRequired = 8; // Total required fields for public form
    int completed = 0;
    List<String> missing = [];
    
    // Check each required field
    if (stateController.text.trim().isNotEmpty) completed++; else missing.add('State');
    if (districtController.text.trim().isNotEmpty) completed++; else missing.add('District');
    if (landslideOccurrenceValue.value != null) completed++; else missing.add('Landslide Occurrence');
    if (whereDidLandslideOccurValue.value != null) completed++; else missing.add('Location Type');
    if (typeOfMaterialValue.value != null) completed++; else missing.add('Material Type');
    if (typeOfMovementValue.value != null) completed++; else missing.add('Movement Type');
    if (landslideSize.value != null) completed++; else missing.add('Landslide Size');
    if (selectedImages.isNotEmpty) completed++; else missing.add('Images (At least 1)');
        if (whatInducedLandslideValue.value == 'Rainfall') {
      if (rainfallDurationValue.value != null) {
        completed++; // Duration is the main requirement
      } else {
        missing.add('Rainfall Duration');
      }
      totalRequired++; // Increase total required when rainfall is selected
    }
    
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
    'Success',
    'Public pending report updated successfully!',
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
        await ApiService.postLandslide('/Landslide/create/${mobile.value}/Public', [payload]);
        
        // If submission is successful and this was a draft, remove it from drafts
        if (currentDraftId != null) {
          final reportsController = Get.find<RecentReportsController>();
          await reportsController.moveDraftToSynced(currentDraftId!, payload);
        }
        
        _showSuccessDialog(isOnline: true);
        
      } catch (e) {
        // If API fails, treat as offline
        await _handleOfflineSubmission(payload);
        _showSuccessDialog(isOnline: false);
      }
    } else {
      // Offline submission
      await _handleOfflineSubmission(payload);
      _showSuccessDialog(isOnline: false);
    }
    
  } catch (e) {
    Get.snackbar(
      'Error',
      'Failed to process report: $e',
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
  
  // If this was a draft, remove it from drafts first
  if (currentDraftId != null) {
    await reportsController.deleteDraftReport(currentDraftId!);
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
              const Text(
                'Thankyou',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 16),
              
              // Subtitle
              Text(
                isOnline 
                  ? 'for filling out this proforma for the landslide nodal agency of India'
                  : 'for filling out this proforma for the landslide nodal agency of India',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              const SizedBox(height: 24),
              
              // GSI text
              const Text(
                'Geological Survey of India (GSI)',
                style: TextStyle(
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
                        'Report saved offline and will be submitted when internet is available.',
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
                  child: const Text(
                    'DONE',
                    style: TextStyle(
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
      "LanduseOrLandcover": whereDidLandslideOccurValue.value ?? "",
      "MaterialInvolved": typeOfMaterialValue.value ?? "",
      "MovementType": typeOfMovementValue.value ?? "",
      "LandslideSize": landslideSize.value ?? "",
      "InducingFactor": whatInducedLandslideValue.value ?? "",
      "ImpactOrDamage": buildImpactDamageString(),
      "OtherInformation": otherRelevantInformation.text.trim(),
      "Status": null,
      "LivestockDead": livestockDeadController.text.trim().isNotEmpty ? livestockDeadController.text.trim() : "0",
      "LivestockInjured": livestockInjuredController.text.trim().isNotEmpty ? livestockInjuredController.text.trim() : "0",
      "HousesBuildingfullyaffected": housesFullyController.text.trim().isNotEmpty ? housesFullyController.text.trim() : "0",
      "HousesBuildingpartialaffected": housesPartiallyController.text.trim().isNotEmpty ? housesPartiallyController.text.trim() : "0",
      "DamsBarragesCount": damsNameController.text.trim().isNotEmpty ? "1" : "0",
      "DamsBarragesExtentOfDamage": damsExtentValue.value ?? "",
      "RoadsAffectedType": roadTypeValue.value ?? "",
      "RoadsAffectedExtentOfDamage": roadExtentValue.value ?? "",
      "RoadBlocked": roadBlockageValue.value ?? "",
      "RoadBenchesAffected": roadBenchesExtentValue.value ?? "",
      "RailwayLineAffected": railwayDetailsController.text.trim(),
      "RailwayLineBlockage": railwayBlockageValue.value ?? "",
      "RailwayBenchesAffected": railwayBenchesExtentValue.value ?? "",
      "PowerInfrastructureAffected": powerExtentValue.value ?? "",
      "OthersAffected": otherDamageDetailsController.text.trim(),
      "Date_and_time_Range": occurrenceDateRange.value.trim(),
      "datacreatedby": mobile.value,
      "DateTimeType": landslideOccurrenceValue.value ?? "",
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
      "ExactDateInfo": howDoYouKnowValue.value ?? "",
            "Amount_of_rainfall": rainfallAmountController.text.trim().isNotEmpty ? rainfallAmountController.text.trim() : "0",
      "Duration_of_rainfall": rainfallDurationValue.value ?? "",
      "DamsBarragesName": damsNameController.text.trim(),
    };
  }

  // STRING BUILDER METHODS FOR API
  String buildImpactDamageString() {
    List<String> impacts = [];
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
      return 'No images selected (Required)';
    } else if (selectedImages.length == 1) {
      return '1 image selected';
    } else {
      return '${selectedImages.length} images selected';
    }
  }

  // Check if form can be submitted
  bool canSubmitForm() {
    return selectedImages.isNotEmpty && getValidationSummary()['completed'] >= 6; // At least 75% complete
  }

  // Get form completion status for UI
  String getFormCompletionText() {
    final summary = getValidationSummary();
    return '${summary['completed']}/${summary['totalRequired']} fields completed (${summary['percentage']}%)';
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
            Text('Form Status'),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Completion: ${summary['percentage']}%',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text('${summary['completed']} of ${summary['totalRequired']} required fields completed'),
              const SizedBox(height: 16),
              if (!summary['isComplete']) ...[
                const Text(
                  'Missing required fields:',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
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
                    const Expanded(
                      child: Text(
                        'You can save this as a draft and complete it later.',
                        style: TextStyle(fontSize: 14),
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
              child: const Text('Save as Draft'),
            ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
          if (summary['isComplete'])
            ElevatedButton(
              onPressed: () {
                Get.back();
                submitForm();
              },
              child: const Text('Submit Report'),
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
    otherRelevantInformation.dispose();
    affiliationController.dispose(); // Add this line
        rainfallAmountController.dispose();
    
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
  }
}