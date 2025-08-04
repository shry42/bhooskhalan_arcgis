import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:bhooskhalann/services/api_service.dart';
import 'recent_report_screen/recent_reports_controller.dart';

class LandslideReportController extends GetxController {
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
  var imageCaptions = <TextEditingController>[].obs;
  var imageValidationError = ''.obs;

  // Add these after existing draft management properties
String? currentPendingReportId;
var isPendingEditMode = false.obs;

  var isLocationAutoPopulated = false.obs;
var selectedStateFromDropdown = Rxn<String>();
var selectedDistrictFromDropdown = Rxn<String>();
var isImpactSectionExpanded = false.obs;

Future<bool> _checkInternetConnection() async {
  final connectivityResult = await Connectivity().checkConnectivity();
  return connectivityResult != ConnectivityResult.none;
}

// Add these lists after your existing variables
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

  
  // Form controllers - Location Information
  late TextEditingController latitudeController;
  late TextEditingController longitudeController;
  final stateController = TextEditingController();
  final districtController = TextEditingController();
  final subdivisionController = TextEditingController();
  final villageController = TextEditingController();
  final locationDetailsController = TextEditingController();
  
  // Form controllers - Dimensions
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final areaController = TextEditingController();
  final depthController = TextEditingController();
  final volumeController = TextEditingController();
  final runoutDistanceController = TextEditingController();
  
  // Form controllers - Other fields
  final geologyController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  var occurrenceDateRange = ''.obs;
  final geomorphologyController = TextEditingController();
  final otherRelevantInformation = TextEditingController();
  // Rainfall specific controllers (add after other controllers)
final rainfallAmountController = TextEditingController();
var rainfallDurationValue = Rxn<String>(); // Changed to reactive variable for radio buttons
  
  // History dates management
  var historyDates = <String>[].obs;
  
  // Dynamic controllers for Structure
  var beddingControllers = <TextEditingController>[].obs;
  var jointsControllers = <TextEditingController>[].obs;
  var rmrControllers = <TextEditingController>[].obs;
  
  // Dropdown values - Main form
  var landslideOccurrenceValue = Rxn<String>();
  var howDoYouKnowValue = Rxn<String>();
  var whereDidLandslideOccurValue = Rxn<String>();
  var typeOfMaterialValue = Rxn<String>();
  var typeOfMovementValue = Rxn<String>();
  var rateOfMovementValue = Rxn<String>();
  var activityValue = Rxn<String>();
  var distributionValue = Rxn<String>();
  var styleValue = Rxn<String>();
  var failureMechanismValue = Rxn<String>();
  var hydrologicalConditionValue = Rxn<String>();
  var whatInducedLandslideValue = Rxn<String>();
  var alertCategory = Rxn<String>();
  
  // Structure checkboxes (mandatory only if slide material is Rock)
  var bedding = false.obs;
  var joints = false.obs;
  var rmr = false.obs;
  
  // Geo-Scientific Causes - Main categories
  var geologicalCauses = false.obs;
  var morphologicalCauses = false.obs;
  var humanCauses = false.obs;
  var otherCauses = false.obs;

  // Geological Causes sub-items
  var weakOrSensitiveMaterials = false.obs;
  var contrastInPermeability = false.obs;
  
  // Weathered materials dropdown (for Rock only)
  var weatheredMaterialsValue = Rxn<String>();
  
  // Additional geological causes (Rock only)
  var shearedJointedFissuredMaterials = false.obs;
  var adverselyOrientedDiscontinuity = false.obs;
  
  final geologicalOtherController = TextEditingController();
  
  // Morphological Causes sub-items
  var tectonicOrVolcanicUplift = false.obs;
  var glacialRebound = false.obs;
  var fluvialWaveGlacialErosion = false.obs;
  var subterraneanErosion = false.obs;
  var depositionLoading = false.obs;
  var vegetationRemoval = false.obs;
  var thawing = false.obs;
  
  // Additional morphological causes  
  var freezeThawWeathering = false.obs; // Rock only
  var shrinkSwellWeathering = false.obs; // Soil only
  
  final morphologicalOtherController = TextEditingController();
  
  // Human Causes sub-items
  var excavationOfSlope = false.obs;
  var loadingOfSlope = false.obs;
  var drawdown = false.obs;
  var deforestation = false.obs;
  var irrigation = false.obs;
  var mining = false.obs;
  var artificialVibration = false.obs;
  var waterLeakage = false.obs;
  final humanOtherController = TextEditingController();
  final otherCausesController = TextEditingController();
  
  // Impact/Damage - Main categories
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
  
  // Remedial Measures - Main categories
  var modificationOfSlopeGeometry = false.obs;
  var drainage = false.obs;
  var retainingStructures = false.obs;
  var internalSlopeReinforcement = false.obs;
  var remedialMeasuresNotRequired = false.obs;
  var remedialMeasuresNotAdequate = false.obs;
  var otherInformation = false.obs;
  
  // Modification of Slope Geometry sub-items
  var removingMaterial = false.obs;
  var addingMaterial = false.obs;
  var reducingGeneralSlopeAngle = false.obs;
  final slopeGeometryOtherController = TextEditingController();
  
  // Drainage sub-items
  var surfaceDrains = false.obs;
  var shallowDeepTrenchDrains = false.obs;
  var buttressCounterfortDrains = false.obs;
  var verticalSmallDiameterBoreholes = false.obs;
  var verticalLargeDiameterWells = false.obs;
  var subHorizontalBoreholes = false.obs;
  var drainageTunnels = false.obs;
  var vacuumDewatering = false.obs;
  var drainageBySiphoning = false.obs;
  var electroosmoticDewatering = false.obs;
  var vegetationPlanting = false.obs;
  final drainageOtherController = TextEditingController();
  
  // Retaining Structures sub-items
  var gravityRetainingWalls = false.obs;
  var cribBlockWalls = false.obs;
  var gabionWalls = false.obs;
  var passivePilesPiers = false.obs;
  var castInSituWalls = false.obs;
  var reinforcedEarthRetaining = false.obs;
  var buttressCounterforts = false.obs;
  
  // Additional retaining structures (Rock only)
  var retentionNets = false.obs;
  var rockfallAttenuationSystems = false.obs;
  var protectiveRockBlocks = false.obs;
  
  final retainingOtherController = TextEditingController();
  
  // Internal Slope Reinforcement sub-items
  var anchors = false.obs;
  var grouting = false.obs;
  
  // Additional internal reinforcement options based on material type
  var rockBolts = false.obs; // Rock only
  var micropiles = false.obs; // Soil only
  var soilNailing = false.obs; // Soil only
  var stoneLimeCementColumns = false.obs; // Soil only
  var heatTreatment = false.obs; // Soil only
  var freezing = false.obs; // Rock & Soil only
  var electroosmoticAnchors = false.obs; // Soil only
  var vegetationPlantingMechanical = false.obs; // Soil & Debris only
  
  final internalReinforcementOtherController = TextEditingController();
  
  // Remedial measures not adequate sub-items
  var shiftingOfVillage = false.obs;
  var evacuationOfInfrastructure = false.obs;
  var realignmentOfCommunicationCorridors = false.obs;
  var communicationCorridorType = Rxn<String>();
  final notAdequateOtherController = TextEditingController();
  
  // Other remedial measure controllers
  final remedialNotRequiredWhyController = TextEditingController();
  final otherInformationController = TextEditingController();

  // Helper methods to check material type for conditional UI
  bool isRockSelected() => typeOfMaterialValue.value == 'Rock';
  bool isSoilSelected() => typeOfMaterialValue.value == 'Soil';
  bool isDebrisSelected() => typeOfMaterialValue.value == 'Debris (mixture of Rock and Soil)';
  bool isSoilOrDebrisSelected() => isSoilSelected() || isDebrisSelected();
  bool isRockOrSoilSelected() => isRockSelected() || isSoilSelected();

  // Add these methods to your controller class

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

  // LIFECYCLE METHODS
@override
void onInit() {
  super.onInit();
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
        Future.delayed(const Duration(milliseconds: 500), () {
          fetchLocationFromCoordinates();
        });
      }
    }
  } else {
    // When args is null, just initialize empty controllers
    latitudeController = TextEditingController();
    longitudeController = TextEditingController();
  }
  // Setup dimension listeners for auto-calculation
  setupDimensionListeners();
}

  @override
  void onClose() {
    // Dispose all controllers
    _disposeAllControllers();
    super.onClose();
  }

  // AUTO-CALCULATION METHODS
void calculateArea() {
  try {
    if (lengthController.text.isNotEmpty && widthController.text.isNotEmpty) {
      double length = double.tryParse(lengthController.text) ?? 0;
      double width = double.tryParse(widthController.text) ?? 0;
      
      if (length > 0 && width > 0) {
        double area = length * width;
        // Format to 2 decimal places
        areaController.text = area.toStringAsFixed(2);
        // Recalculate volume when area changes
        calculateVolume();
      }
    }
  } catch (e) {
    print('Error calculating area: $e');
  }
}

void calculateVolume() {
  try {
    if (areaController.text.isNotEmpty && depthController.text.isNotEmpty) {
      double area = double.tryParse(areaController.text) ?? 0;
      double depth = double.tryParse(depthController.text) ?? 0;
      
      if (area > 0 && depth > 0) {
        double volume = area * depth;
        // Format to 2 decimal places
        volumeController.text = volume.toStringAsFixed(2);
      }
    }
  } catch (e) {
    print('Error calculating volume: $e');
  }
}

void setupDimensionListeners() {
  // Listen to length changes
  lengthController.addListener(() {
    calculateArea(); // This will also trigger volume calculation
  });
  
  // Listen to width changes
  widthController.addListener(() {
    calculateArea(); // This will also trigger volume calculation
  });
  
  // Listen to depth changes
  depthController.addListener(() {
    calculateVolume();
  });
  
  // Remove the height listener for volume since it's no longer needed
  // heightController.addListener(() {
  //   calculateVolume();
  // });
}

  // Enhanced version for Indian locations
// Replace your existing fetchLocationFromCoordinates method with this updated version
// Replace the existing fetchLocationFromCoordinates method (around line 180)
// Updated method using ArcGIS for better accuracy
// Updated method using Native Geocoding
// Updated method using ArcGIS API instead of native geocoding
// Updated method using Google Maps Geocoding API (Most Accurate)
// Simple dynamic location fetching without hardcoded values
// Simple dynamic location fetching without hardcoded values
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

// void _showLocationError(String error) {
//   Get.snackbar(
//     'Location Error',
//     'Failed to get location',
//     backgroundColor: Colors.red,
//     colorText: Colors.white,
//     snackPosition: SnackPosition.BOTTOM,
//     duration: const Duration(seconds: 3),
//   );
// }





  // SETUP METHODS
  void setCoordinates(double latitude, double longitude) {
    latitudeController.text = latitude.toStringAsFixed(7);
    longitudeController.text = longitude.toStringAsFixed(7);
    // Automatically fetch state and district from ArcGIS
    // fetchIndianStateDistrictFromArcGIS();
  }

  // DRAFT MANAGEMENT METHODS
  Future<void> loadDraftData(Map<String, dynamic> draftData) async {
    try {
      _loadTextControllers(draftData);
      _loadDropdownValues(draftData);
      _loadHistoryDates(draftData);
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
    try {
      // Clear existing images
      selectedImages.clear();
      for (var controller in imageCaptions) {
        controller.dispose();
      }
      imageCaptions.clear();
      
      // Load images from base64 data
      List<dynamic>? imagesData = draftData['images'];
      List<dynamic>? captionsData = draftData['imageCaptions'];
      
      if (imagesData != null && imagesData.isNotEmpty) {
        for (int i = 0; i < imagesData.length; i++) {
          try {
            String base64Image = imagesData[i];
            if (base64Image.isNotEmpty) {
              // Convert base64 to File object
              List<int> bytes = base64Decode(base64Image);
              String tempPath = '/tmp/draft_image_$i.jpg';
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

  void _loadTextControllers(Map<String, dynamic> draftData) {
    // Location controllers
    if (draftData['state'] != null) stateController.text = draftData['state'];
    if (draftData['district'] != null) districtController.text = draftData['district'];
    if (draftData['subdivision'] != null) subdivisionController.text = draftData['subdivision'];
    if (draftData['village'] != null) villageController.text = draftData['village'];
    if (draftData['locationDetails'] != null) locationDetailsController.text = draftData['locationDetails'];

    if (draftData['isLocationAutoPopulated'] == false) {
  isLocationAutoPopulated.value = false;
  selectedStateFromDropdown.value = draftData['state'];
  selectedDistrictFromDropdown.value = draftData['district'];
}
    
    // Dimension controllers
    if (draftData['length'] != null) lengthController.text = draftData['length'];
    if (draftData['width'] != null) widthController.text = draftData['width'];
    if (draftData['height'] != null) heightController.text = draftData['height'];
    if (draftData['area'] != null) areaController.text = draftData['area'];
    if (draftData['depth'] != null) depthController.text = draftData['depth'];
    if (draftData['volume'] != null) volumeController.text = draftData['volume'];
    if (draftData['runoutDistance'] != null) runoutDistanceController.text = draftData['runoutDistance'];
    
    // Other text controllers
    if (draftData['geology'] != null) geologyController.text = draftData['geology'];
    if (draftData['geomorphology'] != null) geomorphologyController.text = draftData['geomorphology'];
    if (draftData['otherRelevantInfo'] != null) otherRelevantInformation.text = draftData['otherRelevantInfo'];
if (draftData['occurrenceDateRange'] != null) occurrenceDateRange.value = draftData['occurrenceDateRange'];
    // Add these lines in _loadTextControllers method
// Add to _loadTextControllers method
if (draftData['rainfallAmount'] != null) rainfallAmountController.text = draftData['rainfallAmount'];

// Add to _loadDropdownValues method  
rainfallDurationValue.value = draftData['rainfallDuration'];
    
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
    rateOfMovementValue.value = draftData['rateOfMovement'];
    activityValue.value = draftData['activity'];
    distributionValue.value = draftData['distribution'];
    styleValue.value = draftData['style'];
    failureMechanismValue.value = draftData['failureMechanism'];
    hydrologicalConditionValue.value = draftData['hydrologicalCondition'];
    whatInducedLandslideValue.value = draftData['whatInducedLandslide'];
    alertCategory.value = draftData['alertCategory'];
  }

  void _loadHistoryDates(Map<String, dynamic> draftData) {
    if (draftData['historyDates'] != null) {
      historyDates.value = List<String>.from(draftData['historyDates']);
    }
  }
  
  void loadCheckboxData(Map<String, dynamic> draftData) {
    _loadStructureCheckboxes(draftData);
    _loadGeoScientificCauses(draftData);
    _loadImpactDamageData(draftData);
    _loadRemedialMeasuresData(draftData);
  }

  void _loadStructureCheckboxes(Map<String, dynamic> draftData) {
    bedding.value = draftData['bedding'] ?? false;
    joints.value = draftData['joints'] ?? false;
    rmr.value = draftData['rmr'] ?? false;
  }

  void _loadGeoScientificCauses(Map<String, dynamic> draftData) {
    // Main categories
    geologicalCauses.value = draftData['geologicalCauses'] ?? false;
    morphologicalCauses.value = draftData['morphologicalCauses'] ?? false;
    humanCauses.value = draftData['humanCauses'] ?? false;
    otherCauses.value = draftData['otherCauses'] ?? false;
    
    // Geological sub-items
    weakOrSensitiveMaterials.value = draftData['weakOrSensitiveMaterials'] ?? false;
    contrastInPermeability.value = draftData['contrastInPermeability'] ?? false;
    shearedJointedFissuredMaterials.value = draftData['shearedJointedFissuredMaterials'] ?? false;
    adverselyOrientedDiscontinuity.value = draftData['adverselyOrientedDiscontinuity'] ?? false;
    weatheredMaterialsValue.value = draftData['weatheredMaterials'];
    if (draftData['geologicalOther'] != null) geologicalOtherController.text = draftData['geologicalOther'];
    
    // Morphological sub-items
    tectonicOrVolcanicUplift.value = draftData['tectonicOrVolcanicUplift'] ?? false;
    glacialRebound.value = draftData['glacialRebound'] ?? false;
    fluvialWaveGlacialErosion.value = draftData['fluvialWaveGlacialErosion'] ?? false;
    subterraneanErosion.value = draftData['subterraneanErosion'] ?? false;
    depositionLoading.value = draftData['depositionLoading'] ?? false;
    vegetationRemoval.value = draftData['vegetationRemoval'] ?? false;
    thawing.value = draftData['thawing'] ?? false;
    freezeThawWeathering.value = draftData['freezeThawWeathering'] ?? false;
    shrinkSwellWeathering.value = draftData['shrinkSwellWeathering'] ?? false;
    if (draftData['morphologicalOther'] != null) morphologicalOtherController.text = draftData['morphologicalOther'];
    
    // Human causes sub-items
    excavationOfSlope.value = draftData['excavationOfSlope'] ?? false;
    loadingOfSlope.value = draftData['loadingOfSlope'] ?? false;
    drawdown.value = draftData['drawdown'] ?? false;
    deforestation.value = draftData['deforestation'] ?? false;
    irrigation.value = draftData['irrigation'] ?? false;
    mining.value = draftData['mining'] ?? false;
    artificialVibration.value = draftData['artificialVibration'] ?? false;
    waterLeakage.value = draftData['waterLeakage'] ?? false;
    if (draftData['humanOther'] != null) humanOtherController.text = draftData['humanOther'];
    if (draftData['otherCausesText'] != null) otherCausesController.text = draftData['otherCausesText'];
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

  void _loadRemedialMeasuresData(Map<String, dynamic> draftData) {
    // Main remedial measures
    modificationOfSlopeGeometry.value = draftData['modificationOfSlopeGeometry'] ?? false;
    drainage.value = draftData['drainage'] ?? false;
    retainingStructures.value = draftData['retainingStructures'] ?? false;
    internalSlopeReinforcement.value = draftData['internalSlopeReinforcement'] ?? false;
    remedialMeasuresNotRequired.value = draftData['remedialMeasuresNotRequired'] ?? false;
    remedialMeasuresNotAdequate.value = draftData['remedialMeasuresNotAdequate'] ?? false;
    otherInformation.value = draftData['otherInformationChecked'] ?? false;
    
    // Slope geometry sub-items
    removingMaterial.value = draftData['removingMaterial'] ?? false;
    addingMaterial.value = draftData['addingMaterial'] ?? false;
    reducingGeneralSlopeAngle.value = draftData['reducingGeneralSlopeAngle'] ?? false;
    if (draftData['slopeGeometryOther'] != null) slopeGeometryOtherController.text = draftData['slopeGeometryOther'];
    
    // Drainage sub-items
    surfaceDrains.value = draftData['surfaceDrains'] ?? false;
    shallowDeepTrenchDrains.value = draftData['shallowDeepTrenchDrains'] ?? false;
    buttressCounterfortDrains.value = draftData['buttressCounterfortDrains'] ?? false;
    verticalSmallDiameterBoreholes.value = draftData['verticalSmallDiameterBoreholes'] ?? false;
    verticalLargeDiameterWells.value = draftData['verticalLargeDiameterWells'] ?? false;
    subHorizontalBoreholes.value = draftData['subHorizontalBoreholes'] ?? false;
    drainageTunnels.value = draftData['drainageTunnels'] ?? false;
    vacuumDewatering.value = draftData['vacuumDewatering'] ?? false;
    drainageBySiphoning.value = draftData['drainageBySiphoning'] ?? false;
    electroosmoticDewatering.value = draftData['electroosmoticDewatering'] ?? false;
    vegetationPlanting.value = draftData['vegetationPlanting'] ?? false;
    if (draftData['drainageOther'] != null) drainageOtherController.text = draftData['drainageOther'];
    
    // Retaining structures sub-items
    gravityRetainingWalls.value = draftData['gravityRetainingWalls'] ?? false;
    cribBlockWalls.value = draftData['cribBlockWalls'] ?? false;
    gabionWalls.value = draftData['gabionWalls'] ?? false;
    passivePilesPiers.value = draftData['passivePilesPiers'] ?? false;
    castInSituWalls.value = draftData['castInSituWalls'] ?? false;
    reinforcedEarthRetaining.value = draftData['reinforcedEarthRetaining'] ?? false;
    buttressCounterforts.value = draftData['buttressCounterforts'] ?? false;
    retentionNets.value = draftData['retentionNets'] ?? false;
    rockfallAttenuationSystems.value = draftData['rockfallAttenuationSystems'] ?? false;
    protectiveRockBlocks.value = draftData['protectiveRockBlocks'] ?? false;
    if (draftData['retainingOther'] != null) retainingOtherController.text = draftData['retainingOther'];
    
    // Internal reinforcement sub-items
    anchors.value = draftData['anchors'] ?? false;
    grouting.value = draftData['grouting'] ?? false;
    rockBolts.value = draftData['rockBolts'] ?? false;
    micropiles.value = draftData['micropiles'] ?? false;
    soilNailing.value = draftData['soilNailing'] ?? false;
    stoneLimeCementColumns.value = draftData['stoneLimeCementColumns'] ?? false;
    heatTreatment.value = draftData['heatTreatment'] ?? false;
    freezing.value = draftData['freezing'] ?? false;
    electroosmoticAnchors.value = draftData['electroosmoticAnchors'] ?? false;
    vegetationPlantingMechanical.value = draftData['vegetationPlantingMechanical'] ?? false;
    if (draftData['internalReinforcementOther'] != null) internalReinforcementOtherController.text = draftData['internalReinforcementOther'];
    
    // Not adequate remedial measures
    shiftingOfVillage.value = draftData['shiftingOfVillage'] ?? false;
    evacuationOfInfrastructure.value = draftData['evacuationOfInfrastructure'] ?? false;
    realignmentOfCommunicationCorridors.value = draftData['realignmentOfCommunicationCorridors'] ?? false;
    communicationCorridorType.value = draftData['communicationCorridorType'];
    if (draftData['notAdequateOther'] != null) notAdequateOtherController.text = draftData['notAdequateOther'];
    
    // Other controllers
    if (draftData['remedialNotRequiredWhy'] != null) remedialNotRequiredWhyController.text = draftData['remedialNotRequiredWhy'];
    if (draftData['otherInformationText'] != null) otherInformationController.text = draftData['otherInformationText'];
  }
  
  Future<Map<String, dynamic>> collectFormData() async {
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
      // Add these lines in collectFormData method
'rainfallAmount': rainfallAmountController.text,
'rainfallDuration': rainfallDurationValue.value,
      
      // Dimensions
      'length': lengthController.text,
      'width': widthController.text,
      'height': heightController.text,
      'area': areaController.text,
      'depth': depthController.text,
      'volume': volumeController.text,
      'runoutDistance': runoutDistanceController.text,
      
      // Other characteristics
      'rateOfMovement': rateOfMovementValue.value,
      'activity': activityValue.value,
      'distribution': distributionValue.value,
      'style': styleValue.value,
      'failureMechanism': failureMechanismValue.value,
      'geology': geologyController.text,
      'geomorphology': geomorphologyController.text,
      'hydrologicalCondition': hydrologicalConditionValue.value,
      'whatInducedLandslide': whatInducedLandslideValue.value,
      'alertCategory': alertCategory.value,
      'otherRelevantInfo': otherRelevantInformation.text,
      
      // History
      'historyDates': historyDates.toList(),
      
      // Images data for draft - now includes actual images
      'imageCaptions': imageCaptions.map((controller) => controller.text).toList(),
      'imageCount': selectedImages.length,
      'hasImages': selectedImages.isNotEmpty,
      'images': await _convertImagesToBase64(),
      
      // Structure checkboxes
      'bedding': bedding.value,
      'joints': joints.value,
      'rmr': rmr.value,
      
      // Geo-Scientific Causes
      'geologicalCauses': geologicalCauses.value,
      'morphologicalCauses': morphologicalCauses.value,
      'humanCauses': humanCauses.value,
      'otherCauses': otherCauses.value,
      'weakOrSensitiveMaterials': weakOrSensitiveMaterials.value,
      'contrastInPermeability': contrastInPermeability.value,
      'geologicalOther': geologicalOtherController.text,
      'shearedJointedFissuredMaterials': shearedJointedFissuredMaterials.value,
      'adverselyOrientedDiscontinuity': adverselyOrientedDiscontinuity.value,
      'weatheredMaterials': weatheredMaterialsValue.value,
      
      // Morphological causes
      'tectonicOrVolcanicUplift': tectonicOrVolcanicUplift.value,
      'glacialRebound': glacialRebound.value,
      'fluvialWaveGlacialErosion': fluvialWaveGlacialErosion.value,
      'subterraneanErosion': subterraneanErosion.value,
      'depositionLoading': depositionLoading.value,
      'vegetationRemoval': vegetationRemoval.value,
      'thawing': thawing.value,
      'morphologicalOther': morphologicalOtherController.text,
      'freezeThawWeathering': freezeThawWeathering.value,
      'shrinkSwellWeathering': shrinkSwellWeathering.value,
      
      // Human causes
      'excavationOfSlope': excavationOfSlope.value,
      'loadingOfSlope': loadingOfSlope.value,
      'drawdown': drawdown.value,
      'deforestation': deforestation.value,
      'irrigation': irrigation.value,
      'mining': mining.value,
      'artificialVibration': artificialVibration.value,
      'waterLeakage': waterLeakage.value,
      'humanOther': humanOtherController.text,
      'otherCausesText': otherCausesController.text,
      
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
      
      // Remedial measures
      'modificationOfSlopeGeometry': modificationOfSlopeGeometry.value,
      'drainage': drainage.value,
      'retainingStructures': retainingStructures.value,
      'internalSlopeReinforcement': internalSlopeReinforcement.value,
      'remedialMeasuresNotRequired': remedialMeasuresNotRequired.value,
      'remedialMeasuresNotAdequate': remedialMeasuresNotAdequate.value,
      'otherInformationChecked': otherInformation.value,
      
      // Slope geometry
      'removingMaterial': removingMaterial.value,
      'addingMaterial': addingMaterial.value,
      'reducingGeneralSlopeAngle': reducingGeneralSlopeAngle.value,
      'slopeGeometryOther': slopeGeometryOtherController.text,
      
      // Drainage
      'surfaceDrains': surfaceDrains.value,
      'shallowDeepTrenchDrains': shallowDeepTrenchDrains.value,
      'buttressCounterfortDrains': buttressCounterfortDrains.value,
      'verticalSmallDiameterBoreholes': verticalSmallDiameterBoreholes.value,
      'verticalLargeDiameterWells': verticalLargeDiameterWells.value,
      'subHorizontalBoreholes': subHorizontalBoreholes.value,
      'drainageTunnels': drainageTunnels.value,
      'vacuumDewatering': vacuumDewatering.value,
      'drainageBySiphoning': drainageBySiphoning.value,
      'electroosmoticDewatering': electroosmoticDewatering.value,
      'vegetationPlanting': vegetationPlanting.value,
      'drainageOther': drainageOtherController.text,
      
      // Retaining structures
      'gravityRetainingWalls': gravityRetainingWalls.value,
      'cribBlockWalls': cribBlockWalls.value,
      'gabionWalls': gabionWalls.value,
      'passivePilesPiers': passivePilesPiers.value,
      'castInSituWalls': castInSituWalls.value,
      'reinforcedEarthRetaining': reinforcedEarthRetaining.value,
      'buttressCounterforts': buttressCounterforts.value,
      'retainingOther': retainingOtherController.text,
      'retentionNets': retentionNets.value,
      'rockfallAttenuationSystems': rockfallAttenuationSystems.value,
      'protectiveRockBlocks': protectiveRockBlocks.value,
      
      // Internal reinforcement
      'anchors': anchors.value,
      'grouting': grouting.value,
      'internalReinforcementOther': internalReinforcementOtherController.text,
      'rockBolts': rockBolts.value,
      'micropiles': micropiles.value,
      'soilNailing': soilNailing.value,
      'stoneLimeCementColumns': stoneLimeCementColumns.value,
      'heatTreatment': heatTreatment.value,
      'freezing': freezing.value,
      'electroosmoticAnchors': electroosmoticAnchors.value,
      'vegetationPlantingMechanical': vegetationPlantingMechanical.value,
      
      // Not adequate measures
      'shiftingOfVillage': shiftingOfVillage.value,
      'evacuationOfInfrastructure': evacuationOfInfrastructure.value,
      'realignmentOfCommunicationCorridors': realignmentOfCommunicationCorridors.value,
      'communicationCorridorType': communicationCorridorType.value,
      'notAdequateOther': notAdequateOtherController.text,
      
      // Other
      'remedialNotRequiredWhy': remedialNotRequiredWhyController.text,
      'otherInformationText': otherInformationController.text,
    };
  }
  
Future<void> saveDraft() async {
  try {
    final formData = await collectFormData();
    final reportsController = Get.put(RecentReportsController());
  
    if (currentDraftId != null) {
      // Update existing draft with 'expert' form type
      await reportsController.updateDraftReport(currentDraftId!, formData, 'expert');
      Get.snackbar(
        'Success',
        'Expert draft updated successfully',
        backgroundColor: const Color(0xFF1976D2),
        colorText: Colors.white,
      );
    } else {
      // Save new draft with 'expert' form type
      final draftId = await reportsController.saveDraftReport(formData, 'expert');
      currentDraftId = draftId;
      isDraftMode.value = true;
      Get.snackbar(
        'Success',
        'Expert form saved as draft',
        backgroundColor: const Color(0xFF1976D2),
        colorText: Colors.white,
      );
    }
  } catch (e) {
    Get.snackbar(
      'Error',
      'Failed to save expert draft: $e',
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
        imageCaptions.add(TextEditingController()); // Add caption controller
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
          // Add caption controllers for each new image
          for (int i = 0; i < remaining; i++) {
            imageCaptions.add(TextEditingController());
          }
        } else {
          selectedImages.addAll(photos.map((photo) => File(photo.path)));
          // Add caption controllers for each new image
          for (int i = 0; i < photos.length; i++) {
            imageCaptions.add(TextEditingController());
          }
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
    if (index < imageCaptions.length) {
      imageCaptions[index].dispose();
      imageCaptions.removeAt(index);
    }
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

  // HISTORY DATE METHODS
  Future<void> selectHistoryDate() async {
    final DateTime? picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now().subtract(const Duration(days: 1)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 1)),
      helpText: 'Select Historical Date',
      confirmText: 'ADD',
      cancelText: 'CANCEL',
    );
    
    if (picked != null) {
      final String formattedDate = "${picked.day.toString().padLeft(2, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.year}";
      
      if (!historyDates.contains(formattedDate)) {
        historyDates.add(formattedDate);
        // Sort dates in descending order (newest first)
        historyDates.sort((a, b) {
          DateTime dateA = parseDate(a);
          DateTime dateB = parseDate(b);
          return dateB.compareTo(dateA);
        });
      } else {
        Get.snackbar(
          'Warning',
          'This date is already added',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    }
  }
  
  DateTime parseDate(String dateString) {
    List<String> parts = dateString.split('-');
    return DateTime(
      int.parse(parts[2]), // year
      int.parse(parts[1]), // month
      int.parse(parts[0]), // day
    );
  }
  
  void removeHistoryDate(int index) {
    historyDates.removeAt(index);
  }

  // DYNAMIC FIELD METHODS
  void addBeddingField() {
    beddingControllers.add(TextEditingController());
  }
  
  void removeBeddingField(int index) {
    beddingControllers[index].dispose();
    beddingControllers.removeAt(index);
  }
  
  void addJointsField() {
    jointsControllers.add(TextEditingController());
  }
  
  void removeJointsField(int index) {
    jointsControllers[index].dispose();
    jointsControllers.removeAt(index);
  }
  
  void addRmrField() {
    rmrControllers.add(TextEditingController());
  }
  
  void removeRmrField(int index) {
    rmrControllers[index].dispose();
    rmrControllers.removeAt(index);
  }

  // VALIDATION METHODS
  String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
  
  String? validateNumber(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    if (double.tryParse(value) == null) {
      return '$fieldName must be a valid number';
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
    // Add this validation for rainfall fields
// Add this validation for rainfall fields
if (whatInducedLandslideValue.value == 'Rainfall') {
  // Note: Amount is optional based on "if known" in the label
  // Only duration is required
  if (rainfallDurationValue.value == null) {
    errorMessage += 'Rainfall duration is required when trigger is rainfall\n';
    isValid = false;
  }
}

    // Check if Structure is required (only for Rock)
    if (isRockSelected() && !bedding.value && !joints.value && !rmr.value) {
      errorMessage += 'Structure section is required for Rock material\n';
      isValid = false;
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
    
    if (lengthController.text.trim().isEmpty) {
      errorMessage += 'Length is required\n';
      isValid = false;
    }
    
    if (widthController.text.trim().isEmpty) {
      errorMessage += 'Width is required\n';
      isValid = false;
    }
    
    if (heightController.text.trim().isEmpty) {
      errorMessage += 'Height is required\n';
      isValid = false;
    }
    
    if (areaController.text.trim().isEmpty) {
      errorMessage += 'Area is required\n';
      isValid = false;
    }
    
    if (depthController.text.trim().isEmpty) {
      errorMessage += 'Depth is required\n';
      isValid = false;
    }
    
    if (volumeController.text.trim().isEmpty) {
      errorMessage += 'Volume is required\n';
      isValid = false;
    }
    
    if (activityValue.value == null) {
      errorMessage += 'Activity is required\n';
      isValid = false;
    }
    
    if (styleValue.value == null) {
      errorMessage += 'Style is required\n';
      isValid = false;
    }
    
    if (failureMechanismValue.value == null) {
      errorMessage += 'Failure mechanism is required\n';
      isValid = false;
    }
    
    if (whatInducedLandslideValue.value == null) {
      errorMessage += 'What induced landslide is required\n';
      isValid = false;
    }
    
    // Check geo-scientific causes - at least one is required
    if (!geologicalCauses.value && !morphologicalCauses.value && !humanCauses.value && !otherCauses.value) {
      errorMessage += 'At least one geo-scientific cause is required\n';
      isValid = false;
    }
    
    // Check remedial measures - at least one is required
    if (!modificationOfSlopeGeometry.value && !drainage.value && !retainingStructures.value && 
        !internalSlopeReinforcement.value && !remedialMeasuresNotRequired.value && 
        !remedialMeasuresNotAdequate.value && !otherInformation.value) {
      errorMessage += 'At least one remedial measure is required\n';
      isValid = false;
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
    int totalRequired = 18; // Total required fields
    int completed = 0;
    List<String> missing = [];
    
    // Check each required field
    if (stateController.text.trim().isNotEmpty) completed++; else missing.add('state'.tr);
    if (districtController.text.trim().isNotEmpty) completed++; else missing.add('district'.tr);
    if (landslideOccurrenceValue.value != null) completed++; else missing.add('landslide_occurrence'.tr);
    if (whereDidLandslideOccurValue.value != null) completed++; else missing.add('location_type'.tr);
    if (typeOfMaterialValue.value != null) completed++; else missing.add('material_type'.tr);
    if (typeOfMovementValue.value != null) completed++; else missing.add('movement_type'.tr);
    if (lengthController.text.trim().isNotEmpty) completed++; else missing.add('length'.tr);
    if (widthController.text.trim().isNotEmpty) completed++; else missing.add('width'.tr);
    if (heightController.text.trim().isNotEmpty) completed++; else missing.add('height'.tr);
    if (areaController.text.trim().isNotEmpty) completed++; else missing.add('area'.tr);
    if (depthController.text.trim().isNotEmpty) completed++; else missing.add('depth'.tr);
    if (volumeController.text.trim().isNotEmpty) completed++; else missing.add('volume'.tr);
    if (activityValue.value != null) completed++; else missing.add('activity'.tr);
    if (styleValue.value != null) completed++; else missing.add('style'.tr);
    if (failureMechanismValue.value != null) completed++; else missing.add('failure_mechanism'.tr);
    if (whatInducedLandslideValue.value != null) completed++; else missing.add('inducing_factor'.tr);
    if (selectedImages.isNotEmpty) completed++; else missing.add('images_at_least_one'.tr);
    
    // Add this check in getValidationSummary method
// Add this check in getValidationSummary method
if (whatInducedLandslideValue.value == 'Rainfall') {
  if (rainfallDurationValue.value != null) {
    completed++; // Duration is the main requirement
  } else {
    missing.add('rainfall_duration'.tr);
  }
  totalRequired++; // Increase total required when rainfall is selected
}
    // Check geo-scientific causes
    if (geologicalCauses.value || morphologicalCauses.value || humanCauses.value || otherCauses.value) {
      completed++;
    } else {
      missing.add('geo_scientific_causes'.tr);
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

  Future<List<String>> _convertImagesToBase64() async {
    List<String> base64Images = [];
    for (File image in selectedImages) {
      try {
        String base64Image = await imageToBase64(image);
        base64Images.add(base64Image);
      } catch (e) {
        print('Error converting image to base64: $e');
        base64Images.add(''); // Add empty string to maintain index alignment
      }
    }
    return base64Images;
  }

  // FORM SUBMISSION WITH ENHANCED IMAGE VALIDATION
// FORM SUBMISSION WITH OFFLINE SUPPORT
// FORM SUBMISSION WITH OFFLINE SUPPORT - Replace the existing submitForm() method
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
    
    // Get user data from SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final mobile = prefs.getString('mobile') ?? '';
    final userType = prefs.getString('userType') ?? '';
    
    if (token == null || mobile.isEmpty || userType.isEmpty) {
      Get.snackbar(
        'Error',
        'User authentication data not found. Please login again.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    
    // Convert first image to base64 (required)
    String landslidePhotographs = '';
    if (selectedImages.isNotEmpty) {
      landslidePhotographs = await imageToBase64(selectedImages.first);
    }
    
// Check if we're editing a pending report
if (currentPendingReportId != null && isPendingEditMode.value) {
  // Update the existing pending report instead of creating new one
  Map<String, dynamic> updatedPayload = await _buildApiPayload(mobile, userType, landslidePhotographs);
  
  final reportsController = Get.put(RecentReportsController());
  await reportsController.updatePendingReport(currentPendingReportId!, updatedPayload);
  
  Get.snackbar(
    'Success',
    'Expert pending report updated successfully!',
    backgroundColor: Colors.green,
    colorText: Colors.white,
    snackPosition: SnackPosition.BOTTOM,
  );
  
  Get.back(); // Go back to reports screen
  return;
}

    // Build the payload
    Map<String, dynamic> payload = await _buildApiPayload(mobile, userType, landslidePhotographs);
    
    if (hasInternet) {
      // Online submission
      try {
        await ApiService.postLandslide('/Landslide/create/$mobile/$userType', [payload]);
        
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
Future<void> _handleOfflineSubmission(Map<String, dynamic> payload) async {
  final reportsController = Get.put(RecentReportsController());
  
  // Add form type and title to payload
  payload['formType'] = 'expert';
  payload['title'] = 'Expert Landslide Report - ${payload['District'] ?? payload['State'] ?? 'Unknown Location'}';
  
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
                        'Expert report saved offline and will be submitted when internet is available.',
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
                    // Get.back(); // Go back to previous screen
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


  Future<Map<String, dynamic>> _buildApiPayload(String mobile, String userType, String landslidePhotographs) async {
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
      "LengthInMeters": lengthController.text.trim(),
      "WidthInMeters": widthController.text.trim(),
      "HeightInMeters": heightController.text.trim(),
      "AreaInSqMeters": areaController.text.trim(),
      "DepthInMeters": depthController.text.trim(),
      "VolumeInCubicMeters": volumeController.text.trim(),
      "RunOutDistanceInMeters": runoutDistanceController.text.trim().isNotEmpty ? runoutDistanceController.text.trim() : "0.0",
      "MovementRate": rateOfMovementValue.value ?? "",
      "Activity": activityValue.value ?? "",
      "Distribution": distributionValue.value ?? "",
      "Style": styleValue.value ?? "",
      "FailureMechanism": failureMechanismValue.value ?? "",
      "Geomorphology": geomorphologyController.text.trim(),
      "Geology": geologyController.text.trim(),
      "Structure": buildStructureString(),
      "HydrologicalCondition": hydrologicalConditionValue.value ?? "",
      "InducingFactor": whatInducedLandslideValue.value ?? "",
      "ImpactOrDamage": buildImpactDamageString(),
      "GeoScientificCauses": buildGeoScientificCausesString(),
      "PreliminaryRemedialMeasures": buildRemedialMeasuresString(),
      "VulnerabilityCategory": alertCategory.value ?? "",
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
      "History_date": historyDates.isNotEmpty ? historyDates.join(", ") : "NaN-NaN-NaN",
    "Amount_of_rainfall": rainfallAmountController.text.trim().isNotEmpty ? rainfallAmountController.text.trim() : "0",
"Duration_of_rainfall": rainfallDurationValue.value ?? "",
      "Date_and_time_Range": occurrenceDateRange.value.trim(),
      "OtherLandUse": "",
      "datacreatedby": mobile,
      "DateTimeType": landslideOccurrenceValue.value ?? "",
      "LandslidePhotograph1": landslidePhotograph1,
      "LandslidePhotograph2": landslidePhotograph2,
      "LandslidePhotograph3": landslidePhotograph3,
      "LandslidePhotograph4": landslidePhotograph4,
      "check_Status": "Pending",
      "GSI_User": null,
      "Rejected_Reason": null,
      "Reviewed_Date": null,
      "Reviewed_Time": null,
      "PeopleDead": peopleDeadController.text.trim().isNotEmpty ? peopleDeadController.text.trim() : "0",
      "PeopleInjured": peopleInjuredController.text.trim().isNotEmpty ? peopleInjuredController.text.trim() : "0",
      "LandslideSize": "",
      "ContactName": "",
      "ContactAffiliation": "",
      "ContactEmailId": "",
      "ContactMobile": mobile,
      "UserType": userType,
      "source": "webportal",
      "u_lat": null,
      "u_long": null,
      "LandslideCauses": null,
      "GeologicalCauses": buildGeologicalCausesString(),
      "MorphologicalCauses": buildMorphologicalCausesString(),
      "HumanCauses": buildHumanCausesString(),
      "CausesOtherInfo": otherCausesController.text.trim(),
      "WeatheredMaterial": weatheredMaterialsValue.value ?? "",
      "Bedding": buildBeddingString(),
      "Joint": buildJointsString(),
      "RMR": buildRmrString(),
      "ExactDateInfo": howDoYouKnowValue.value ?? "",
      "RainfallIntensity": null,
      "SlopeGeometry": buildSlopeGeometryString(),
      "Drainage": buildDrainageString(),
      "RetainingStructures": buildRetainingStructuresString(),
      "InternalSlopeReinforcememt": buildInternalReinforcementString(),
      "RemedialNotRequired": remedialNotRequiredWhyController.text.trim(),
      "RemedialNotSufficient": buildRemedialNotSufficientString(),
      "RemedialOtherInfo": otherInformationController.text.trim(),
      "ID_project": null,
      "ID_lan": null,
      "class_number": null,
      "class_type": null,
      "geo_acc": null,
      "date": null,
      "date_acc": null,
      "Realignment": communicationCorridorType.value ?? "",
      "Toposheet_No": "",
      "OldSlide_No": null,
      "Initiation_Year": null,
      "Slide_No": null,
      "ImageCaptions": null,
      "DamsBarragesName": damsNameController.text.trim(),
    };
  }

  // STRING BUILDER METHODS FOR API
  String buildStructureString() {
    List<String> structures = [];
    if (bedding.value) structures.add("Bedding");
    if (joints.value) structures.add("Joints");
    if (rmr.value) structures.add("RMR");
    return structures.join(", ");
  }
  
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
  
  String buildGeoScientificCausesString() {
    List<String> causes = [];
    if (geologicalCauses.value) causes.add("Geological Causes");
    if (morphologicalCauses.value) causes.add("Morphological Causes");
    if (humanCauses.value) causes.add("Human Causes");
    if (otherCauses.value) causes.add("Other Causes");
    return causes.join(", ");
  }
  
  String buildRemedialMeasuresString() {
    List<String> measures = [];
    if (modificationOfSlopeGeometry.value) measures.add("Modification of Slope Geometry");
    if (drainage.value) measures.add("Drainage");
    if (retainingStructures.value) measures.add("Retaining Structures");
    if (internalSlopeReinforcement.value) measures.add("Internal Slope Reinforcement");
    if (remedialMeasuresNotRequired.value) measures.add("Remedial measures not required");
    if (remedialMeasuresNotAdequate.value) measures.add("Remedial measures not adequately safeguard the slide");
    if (otherInformation.value) measures.add("Other Information");
    return measures.join(", ");
  }
  
  String buildGeologicalCausesString() {
    List<String> causes = [];
    if (weakOrSensitiveMaterials.value) causes.add("Weak or sensitive materials");
    if (weatheredMaterialsValue.value != null) causes.add("Weathered materials: ${weatheredMaterialsValue.value}");
    if (shearedJointedFissuredMaterials.value) causes.add("Sheared, jointed, or fissured materials");
    if (adverselyOrientedDiscontinuity.value) causes.add("Adversely oriented discontinuity");
    if (contrastInPermeability.value) causes.add("Contrast in permeability and/or stiffness of materials");
    if (geologicalOtherController.text.trim().isNotEmpty) causes.add(geologicalOtherController.text.trim());
    return causes.join(", ");
  }
  
  String buildMorphologicalCausesString() {
    List<String> causes = [];
    if (tectonicOrVolcanicUplift.value) causes.add("Tectonic or volcanic uplift");
    if (glacialRebound.value) causes.add("Glacial rebound");
    if (fluvialWaveGlacialErosion.value) causes.add("Fluvial, wave, or glacial erosion");
    if (subterraneanErosion.value) causes.add("Subterranean erosion");
    if (depositionLoading.value) causes.add("Deposition loading");
    if (vegetationRemoval.value) causes.add("Vegetation removal");
    if (thawing.value) causes.add("Thawing");
    if (freezeThawWeathering.value) causes.add("Freeze-and-thaw weathering");
    if (shrinkSwellWeathering.value) causes.add("Shrink-and-swell weathering");
    if (morphologicalOtherController.text.trim().isNotEmpty) causes.add(morphologicalOtherController.text.trim());
    return causes.join(", ");
  }
  
  String buildHumanCausesString() {
    List<String> causes = [];
    if (excavationOfSlope.value) causes.add("Excavation of slope");
    if (loadingOfSlope.value) causes.add("Loading of slope");
    if (drawdown.value) causes.add("Drawdown");
    if (deforestation.value) causes.add("Deforestation");
    if (irrigation.value) causes.add("Irrigation");
    if (mining.value) causes.add("Mining");
    if (artificialVibration.value) causes.add("Artificial vibration");
    if (waterLeakage.value) causes.add("Water leakage");
    if (humanOtherController.text.trim().isNotEmpty) causes.add(humanOtherController.text.trim());
    return causes.join(", ");
  }
  
  String buildBeddingString() {
    return beddingControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .join(", ");
  }
  
  String buildJointsString() {
    return jointsControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .join(", ");
  }
  
  String buildRmrString() {
    return rmrControllers
        .map((controller) => controller.text.trim())
        .where((text) => text.isNotEmpty)
        .join(", ");
  }
  
  String buildSlopeGeometryString() {
    List<String> items = [];
    if (removingMaterial.value) items.add("Removing material");
    if (addingMaterial.value) items.add("Adding material");
    if (reducingGeneralSlopeAngle.value) items.add("Reducing general slope angle");
    if (slopeGeometryOtherController.text.trim().isNotEmpty) items.add(slopeGeometryOtherController.text.trim());
    return items.join(", ");
  }
  
  String buildDrainageString() {
    List<String> items = [];
    if (surfaceDrains.value) items.add("Surface drains");
    if (shallowDeepTrenchDrains.value) items.add("Shallow or deep trench drains");
    if (buttressCounterfortDrains.value) items.add("Buttress counterfort drains");
    if (verticalSmallDiameterBoreholes.value) items.add("Vertical small diameter boreholes");
    if (verticalLargeDiameterWells.value) items.add("Vertical large diameter wells");
    if (subHorizontalBoreholes.value) items.add("Sub horizontal boreholes");
    if (drainageTunnels.value) items.add("Drainage tunnels");
    if (vacuumDewatering.value) items.add("Vacuum dewatering");
    if (drainageBySiphoning.value) items.add("Drainage by siphoning");
    if (electroosmoticDewatering.value) items.add("Electro-osmotic dewatering");
    if (vegetationPlanting.value) items.add("Vegetation planting");
    if (drainageOtherController.text.trim().isNotEmpty) items.add(drainageOtherController.text.trim());
    return items.join(", ");
  }
  
  String buildRetainingStructuresString() {
    List<String> items = [];
    if (gravityRetainingWalls.value) items.add("Gravity retaining walls");
    if (cribBlockWalls.value) items.add("Crib-block walls");
    if (gabionWalls.value) items.add("Gabion walls");
    if (passivePilesPiers.value) items.add("Passive piles, piers and caissons");
    if (castInSituWalls.value) items.add("Cast-in situ walls");
    if (reinforcedEarthRetaining.value) items.add("Reinforced earth retaining");
    if (buttressCounterforts.value) items.add("Buttress counterforts");
    if (retentionNets.value) items.add("Retention nets for rock slope faces");
    if (rockfallAttenuationSystems.value) items.add("Rockfall attenuation or stopping systems");
    if (protectiveRockBlocks.value) items.add("Protective rock/concrete blocks against erosion");
    if (retainingOtherController.text.trim().isNotEmpty) items.add(retainingOtherController.text.trim());
    return items.join(", ");
  }
  
  String buildInternalReinforcementString() {
    List<String> items = [];
    if (rockBolts.value) items.add("Rock bolts");
    if (micropiles.value) items.add("Micropiles");
    if (soilNailing.value) items.add("Soil nailing");
    if (anchors.value) items.add("Anchors");
    if (grouting.value) items.add("Grouting");
    if (stoneLimeCementColumns.value) items.add("Stone or lime/cement columns");
    if (heatTreatment.value) items.add("Heat treatment");
    if (freezing.value) items.add("Freezing");
    if (electroosmoticAnchors.value) items.add("Electroosmotic anchors");
    if (vegetationPlantingMechanical.value) items.add("Vegetation planting (root strength mechanical effect)");
    if (internalReinforcementOtherController.text.trim().isNotEmpty) items.add(internalReinforcementOtherController.text.trim());
    return items.join(", ");
  }
  
  String buildRemedialNotSufficientString() {
    List<String> items = [];
    if (shiftingOfVillage.value) items.add("Shifting of village");
    if (evacuationOfInfrastructure.value) items.add("Evacuation of infrastructure");
    if (realignmentOfCommunicationCorridors.value) items.add("Realignment of communication corridors");
    if (notAdequateOtherController.text.trim().isNotEmpty) items.add(notAdequateOtherController.text.trim());
    return items.join(", ");
  }

  // UTILITY METHODS FOR UI
  
  // Get image status for UI display
  String getImageStatusText() {
    if (selectedImages.isEmpty) {
      return 'no_images_selected_required'.tr;
    } else if (selectedImages.length == 1) {
      return 'one_image_selected'.tr;
    } else {
      return 'images_selected_count'.trParams({'count': '${selectedImages.length}'});
    }
  }

  // Get image status color
  Color getImageStatusColor() {
    return selectedImages.isEmpty ? Colors.red : Colors.green;
  }

  // Check if form can be submitted
  bool canSubmitForm() {
    return selectedImages.isNotEmpty && getValidationSummary()['completed'] >= 15; // At least 80% complete
  }

  // Get form completion status for UI
  String getFormCompletionText() {
    final summary = getValidationSummary();
    return '${summary['completed']} में से ${summary['totalRequired']} आवश्यक फ़ील्ड पूर्ण';
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
    lengthController.dispose();
    widthController.dispose();
    heightController.dispose();
    areaController.dispose();
    depthController.dispose();
    volumeController.dispose();
    runoutDistanceController.dispose();
    geologyController.dispose();
    dateController.dispose();
    timeController.dispose();
    geomorphologyController.dispose();
    otherRelevantInformation.dispose();
    
    // Dynamic controllers
    for (var controller in beddingControllers) {
      controller.dispose();
    }
    for (var controller in jointsControllers) {
      controller.dispose();
    }
    for (var controller in rmrControllers) {
      controller.dispose();
    }
    beddingControllers.clear();
    jointsControllers.clear();
    rmrControllers.clear();
    
    // Geo-scientific controllers
    geologicalOtherController.dispose();
    morphologicalOtherController.dispose();
    humanOtherController.dispose();
    otherCausesController.dispose();
    
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
    
    // Remedial controllers
    slopeGeometryOtherController.dispose();
    drainageOtherController.dispose();
    retainingOtherController.dispose();
    internalReinforcementOtherController.dispose();
    remedialNotRequiredWhyController.dispose();
    notAdequateOtherController.dispose();
    otherInformationController.dispose();

    rainfallAmountController.dispose();
    for (var controller in imageCaptions) {
      controller.dispose();
    }
    imageCaptions.clear();
  }

  // Add option constants for expert form
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

  static const List<String> typeOfMovementOptions = [
    'slide',
    'fall',
    'topple',
    'subsidence',
    'creep',
    'lateral_spread',
    'flow',
    'complex'
  ];

  static const List<String> rateOfMovementOptions = [
    'extremely_rapid',
    'very_rapid',
    'rapid',
    'moderate',
    'slow',
    'very_slow',
    'extremely_slow'
  ];

  static const List<String> activityOptions = [
    'active',
    'reactivated',
    'suspended',
    'dormant',
    'abandoned',
    'stabilised',
    'relict'
  ];

  static const List<String> distributionOptions = [
    'advancing',
    'retrogressive',
    'widening',
    'enlarging',
    'confined',
    'diminishing',
    'moving'
  ];

  static const List<String> styleOptions = [
    'successive',
    'multiple',
    'single',
    'composite'
  ];

  static const List<String> failureMechanismOptions = [
    'translational',
    'rotational',
    'planar',
    'wedge',
    'topple_mechanism'
  ];

  static const List<String> hydrologicalConditionOptions = [
    'dry',
    'damp',
    'wet',
    'dipping',
    'flowing'
  ];

  static const List<String> whatInducedLandslideOptions = [
    'rainfall',
    'earthquake',
    'man_made',
    'snow_melt',
    'vibration',
    'toe_erosion',
    'i_dont_know'
  ];

  static const List<String> rainfallDurationOptions = [
    'no_rainfall_day_landslide',
    'half_day_or_less',
    'whole_day',
    'few_days_less_week',
    'week_or_more',
    'i_dont_know'
  ];

  static const List<String> weatheringGradeOptions = [
    'w1_fresh',
    'w2_slightly_weathered',
    'w3_moderately_weathered',
    'w4_highly_weathered',
    'w5_completely_weathered'
  ];

  static const List<String> extentOptions = [
    'full',
    'partial'
  ];

  static const List<String> roadBlockageOptions = [
    'few_hours',
    'half_day',
    'one_day',
    'more_than_day',
    'no_blockage'
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

  // Helper method to get translated value for display
  String? getTranslatedValueForDisplay(String? englishKey, List<String> optionsList) {
    if (englishKey == null) return null;
    
    // If it's already a translated value, return it
    if (optionsList.any((key) => key.tr == englishKey)) {
      return englishKey;
    }
    
    // If it's an English key, return the translated value
    if (optionsList.contains(englishKey)) {
      return englishKey.tr;
    }
    
    return null;
  }

  // Helper method to get English key from translated value
  String? getEnglishKeyFromTranslatedValue(String? translatedValue, List<String> optionsList) {
    if (translatedValue == null) return null;
    
    // If it's already an English key, return it
    if (optionsList.contains(translatedValue)) {
      return translatedValue;
    }
    
    // If it's a translated value, find the English key
    for (String key in optionsList) {
      if (key.tr == translatedValue) {
        return key;
      }
    }
    
    // Try Hindi to English mapping
    return _findEnglishKeyFromHindiValue(translatedValue, optionsList);
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
      'सड़क के पास/सड़क पर': 'near_on_road',
      'नदी के बगल में': 'next_to_river',
      'बस्ती': 'settlement',
      'बागान': 'plantation',
      'वन क्षेत्र': 'forest_area',
      'खेती': 'cultivation',
      'बंजर भूमि': 'barren_land',
      'अन्य (विशिष्ट)': 'other_specify',
      
      // Material type options
      'चट्टान': 'rock',
      'मिट्टी': 'soil',
      'मलबा (चट्टान और मिट्टी का मिश्रण)': 'debris_mixture',
      
      // Extent options
      'पूर्ण': 'full',
      'आंशिक': 'partial',
      
      // Road type options
      'राज्य राजमार्ग': 'state_highway',
      'राष्ट्रीय राजमार्ग': 'national_highway',
      'स्थानीय': 'local',
      
      // Landslide size options
      'छोटा - (2 मंजिल से कम इमारत) < 6m': 'small_building',
      'मध्यम - (2 से 5 मंजिल इमारत) 6-15m': 'medium_building',
      'बड़ा - (5 मंजिल से अधिक इमारत) > 15m': 'large_building',
    };
    
    return hindiToEnglishMap[hindiValue];
  }
}