class DetailedLandslideReport {
  final String id;
  final String latitude;
  final String longitude;
  final String state;
  final String district;
  final String subdivisionOrTaluk;
  final String village;
  final String locationDetails;
  final String? landslideDate;
  final String landslideTime;
  final String? landslidePhotographs;
  final String landuseOrLandcover;
  final String materialInvolved;
  final String movementType;
  final String lengthInMeters;
  final String widthInMeters;
  final String heightInMeters;
  final String areaInSqMeters;
  final String depthInMeters;
  final String volumeInCubicMeters;
  final String runOutDistanceInMeters;
  final String movementRate;
  final String activity;
  final String distribution;
  final String style;
  final String failureMechanism;
  final String geomorphology;
  final String geology;
  final String structure;
  final String hydrologicalCondition;
  final String inducingFactor;
  final String impactOrDamage;
  final String geoScientificCauses;
  final String preliminaryRemedialMeasures;
  final String vulnerabilityCategory;
  final String otherInformation;
  final String status;
  final String livestockDead;
  final String livestockInjured;
  final String housesBuildingfullyaffected;
  final String housesBuildingpartialaffected;
  final String? damsBarragesCount;
  final String damsBarragesExtentOfDamage;
  final String roadsAffectedType;
  final String roadsAffectedExtentOfDamage;
  final String roadBlocked;
  final String roadBenchesAffected;
  final String railwayLineAffected;
  final String railwayLineBlockage;
  final String railwayBenchesAffected;
  final String powerInfrastructureAffected;
  final String othersAffected;
  final String historyDate;
  final String amountOfRainfall;
  final String durationOfRainfall;
  final String dateAndTimeRange;
  final String otherLandUse;
  final String datacreated;
  final String? dataupdated;
  final String? dataupdatedby;
  final String datacreatedby;
  final String dateTimeType;
  final String? landslidePhotograph1;
  final String? landslidePhotograph2;
  final String? landslidePhotograph3;
  final String? landslidePhotograph4;
  final String checkStatus;
  final String gsiUser;
  final String rejectedReason;
  final String reviewedDate;
  final String reviewedTime;
  final String peopleDead;
  final String peopleInjured;
  final String? landslideSize;
  final String? contactName;
  final String? contactAffiliation;
  final String? contactEmailId;
  final String? contactMobile;
  final String userType;
  final String source;
  final String uLat;
  final String uLong;
  final String? landslideCauses;
  final String geologicalCauses;
  final String morphologicalCauses;
  final String humanCauses;
  final String causesOtherInfo;
  final String weatheredMaterial;
  final String bedding;
  final String joint;
  final String rmr;
  final String exactDateInfo;
  final String? rainfallIntensity;
  final String slopeGeometry;
  final String drainage;
  final String retainingStructures;
  final String internalSlopeReinforcememt;
  final String remedialNotRequired;
  final String remedialNotSufficient;
  final String remedialOtherInfo;
  final String? idProject;
  final String? idLan;
  final String? classNumber;
  final String? classType;
  final String? geoAcc;
  final String? date;
  final String? dateAcc;
  final String realignment;
  final String toposheetNo;
  final String? oldSlideNo;
  final String? initiationYear;
  final String? slideNo;
  final String imageCaptions;
  final String damsBarragesName;

  DetailedLandslideReport({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.state,
    required this.district,
    required this.subdivisionOrTaluk,
    required this.village,
    required this.locationDetails,
    this.landslideDate,
    required this.landslideTime,
    this.landslidePhotographs,
    required this.landuseOrLandcover,
    required this.materialInvolved,
    required this.movementType,
    required this.lengthInMeters,
    required this.widthInMeters,
    required this.heightInMeters,
    required this.areaInSqMeters,
    required this.depthInMeters,
    required this.volumeInCubicMeters,
    required this.runOutDistanceInMeters,
    required this.movementRate,
    required this.activity,
    required this.distribution,
    required this.style,
    required this.failureMechanism,
    required this.geomorphology,
    required this.geology,
    required this.structure,
    required this.hydrologicalCondition,
    required this.inducingFactor,
    required this.impactOrDamage,
    required this.geoScientificCauses,
    required this.preliminaryRemedialMeasures,
    required this.vulnerabilityCategory,
    required this.otherInformation,
    required this.status,
    required this.livestockDead,
    required this.livestockInjured,
    required this.housesBuildingfullyaffected,
    required this.housesBuildingpartialaffected,
    this.damsBarragesCount,
    required this.damsBarragesExtentOfDamage,
    required this.roadsAffectedType,
    required this.roadsAffectedExtentOfDamage,
    required this.roadBlocked,
    required this.roadBenchesAffected,
    required this.railwayLineAffected,
    required this.railwayLineBlockage,
    required this.railwayBenchesAffected,
    required this.powerInfrastructureAffected,
    required this.othersAffected,
    required this.historyDate,
    required this.amountOfRainfall,
    required this.durationOfRainfall,
    required this.dateAndTimeRange,
    required this.otherLandUse,
    required this.datacreated,
    this.dataupdated,
    this.dataupdatedby,
    required this.datacreatedby,
    required this.dateTimeType,
    this.landslidePhotograph1,
    this.landslidePhotograph2,
    this.landslidePhotograph3,
    this.landslidePhotograph4,
    required this.checkStatus,
    required this.gsiUser,
    required this.rejectedReason,
    required this.reviewedDate,
    required this.reviewedTime,
    required this.peopleDead,
    required this.peopleInjured,
    this.landslideSize,
    this.contactName,
    this.contactAffiliation,
    this.contactEmailId,
    this.contactMobile,
    required this.userType,
    required this.source,
    required this.uLat,
    required this.uLong,
    this.landslideCauses,
    required this.geologicalCauses,
    required this.morphologicalCauses,
    required this.humanCauses,
    required this.causesOtherInfo,
    required this.weatheredMaterial,
    required this.bedding,
    required this.joint,
    required this.rmr,
    required this.exactDateInfo,
    this.rainfallIntensity,
    required this.slopeGeometry,
    required this.drainage,
    required this.retainingStructures,
    required this.internalSlopeReinforcememt,
    required this.remedialNotRequired,
    required this.remedialNotSufficient,
    required this.remedialOtherInfo,
    this.idProject,
    this.idLan,
    this.classNumber,
    this.classType,
    this.geoAcc,
    this.date,
    this.dateAcc,
    required this.realignment,
    required this.toposheetNo,
    this.oldSlideNo,
    this.initiationYear,
    this.slideNo,
    required this.imageCaptions,
    required this.damsBarragesName,
  });

  factory DetailedLandslideReport.fromJson(Map<String, dynamic> json) {
    return DetailedLandslideReport(
      id: json['ID']?.toString() ?? '',
      latitude: json['Latitude']?.toString() ?? '',
      longitude: json['Longitude']?.toString() ?? '',
      state: json['State']?.toString() ?? '',
      district: json['District']?.toString() ?? '',
      subdivisionOrTaluk: json['SubdivisionOrTaluk']?.toString() ?? '',
      village: json['Village']?.toString() ?? '',
      locationDetails: json['LocationDetails']?.toString() ?? '',
      landslideDate: json['LandslideDate']?.toString(),
      landslideTime: json['LandslideTime']?.toString() ?? '',
      landslidePhotographs: json['LandslidePhotographs']?.toString(),
      landuseOrLandcover: json['LanduseOrLandcover']?.toString() ?? '',
      materialInvolved: json['MaterialInvolved']?.toString() ?? '',
      movementType: json['MovementType']?.toString() ?? '',
      lengthInMeters: json['LengthInMeters']?.toString() ?? '',
      widthInMeters: json['WidthInMeters']?.toString() ?? '',
      heightInMeters: json['HeightInMeters']?.toString() ?? '',
      areaInSqMeters: json['AreaInSqMeters']?.toString() ?? '',
      depthInMeters: json['DepthInMeters']?.toString() ?? '',
      volumeInCubicMeters: json['VolumeInCubicMeters']?.toString() ?? '',
      runOutDistanceInMeters: json['RunOutDistanceInMeters']?.toString() ?? '',
      movementRate: json['MovementRate']?.toString() ?? '',
      activity: json['Activity']?.toString() ?? '',
      distribution: json['Distribution']?.toString() ?? '',
      style: json['Style']?.toString() ?? '',
      failureMechanism: json['FailureMechanism']?.toString() ?? '',
      geomorphology: json['Geomorphology']?.toString() ?? '',
      geology: json['Geology']?.toString() ?? '',
      structure: json['Structure']?.toString() ?? '',
      hydrologicalCondition: json['HydrologicalCondition']?.toString() ?? '',
      inducingFactor: json['InducingFactor']?.toString() ?? '',
      impactOrDamage: json['ImpactOrDamage']?.toString() ?? '',
      geoScientificCauses: json['GeoScientificCauses']?.toString() ?? '',
      preliminaryRemedialMeasures: json['PreliminaryRemedialMeasures']?.toString() ?? '',
      vulnerabilityCategory: json['VulnerabilityCategory']?.toString() ?? '',
      otherInformation: json['OtherInformation']?.toString() ?? '',
      status: json['Status']?.toString() ?? '',
      livestockDead: json['LivestockDead']?.toString() ?? '',
      livestockInjured: json['LivestockInjured']?.toString() ?? '',
      housesBuildingfullyaffected: json['HousesBuildingfullyaffected']?.toString() ?? '',
      housesBuildingpartialaffected: json['HousesBuildingpartialaffected']?.toString() ?? '',
      damsBarragesCount: json['DamsBarragesCount']?.toString(),
      damsBarragesExtentOfDamage: json['DamsBarragesExtentOfDamage']?.toString() ?? '',
      roadsAffectedType: json['RoadsAffectedType']?.toString() ?? '',
      roadsAffectedExtentOfDamage: json['RoadsAffectedExtentOfDamage']?.toString() ?? '',
      roadBlocked: json['RoadBlocked']?.toString() ?? '',
      roadBenchesAffected: json['RoadBenchesAffected']?.toString() ?? '',
      railwayLineAffected: json['RailwayLineAffected']?.toString() ?? '',
      railwayLineBlockage: json['RailwayLineBlockage']?.toString() ?? '',
      railwayBenchesAffected: json['RailwayBenchesAffected']?.toString() ?? '',
      powerInfrastructureAffected: json['PowerInfrastructureAffected']?.toString() ?? '',
      othersAffected: json['OthersAffected']?.toString() ?? '',
      historyDate: json['History_date']?.toString() ?? '',
      amountOfRainfall: json['Amount_of_rainfall']?.toString() ?? '',
      durationOfRainfall: json['Duration_of_rainfall']?.toString() ?? '',
      dateAndTimeRange: json['Date_and_time_Range']?.toString() ?? '',
      otherLandUse: json['OtherLandUse']?.toString() ?? '',
      datacreated: json['datacreated']?.toString() ?? '',
      dataupdated: json['dataupdated']?.toString(),
      dataupdatedby: json['dataupdatedby']?.toString(),
      datacreatedby: json['datacreatedby']?.toString() ?? '',
      dateTimeType: json['DateTimeType']?.toString() ?? '',
      landslidePhotograph1: json['LandslidePhotograph1']?.toString(),
      landslidePhotograph2: json['LandslidePhotograph2']?.toString(),
      landslidePhotograph3: json['LandslidePhotograph3']?.toString(),
      landslidePhotograph4: json['LandslidePhotograph4']?.toString(),
      checkStatus: json['check_Status']?.toString() ?? '',
      gsiUser: json['GSI_User']?.toString() ?? '',
      rejectedReason: json['Rejected_Reason']?.toString() ?? '',
      reviewedDate: json['Reviewed_Date']?.toString() ?? '',
      reviewedTime: json['Reviewed_Time']?.toString() ?? '',
      peopleDead: json['PeopleDead']?.toString() ?? '',
      peopleInjured: json['PeopleInjured']?.toString() ?? '',
      landslideSize: json['LandslideSize']?.toString(),
      contactName: json['ContactName']?.toString(),
      contactAffiliation: json['ContactAffiliation']?.toString(),
      contactEmailId: json['ContactEmailId']?.toString(),
      contactMobile: json['ContactMobile']?.toString(),
      userType: json['UserType']?.toString() ?? '',
      source: json['source']?.toString() ?? '',
      uLat: json['u_lat']?.toString() ?? '',
      uLong: json['u_long']?.toString() ?? '',
      landslideCauses: json['LandslideCauses']?.toString(),
      geologicalCauses: json['GeologicalCauses']?.toString() ?? '',
      morphologicalCauses: json['MorphologicalCauses']?.toString() ?? '',
      humanCauses: json['HumanCauses']?.toString() ?? '',
      causesOtherInfo: json['CausesOtherInfo']?.toString() ?? '',
      weatheredMaterial: json['WeatheredMaterial']?.toString() ?? '',
      bedding: json['Bedding']?.toString() ?? '',
      joint: json['Joint']?.toString() ?? '',
      rmr: json['RMR']?.toString() ?? '',
      exactDateInfo: json['ExactDateInfo']?.toString() ?? '',
      rainfallIntensity: json['RainfallIntensity']?.toString(),
      slopeGeometry: json['SlopeGeometry']?.toString() ?? '',
      drainage: json['Drainage']?.toString() ?? '',
      retainingStructures: json['RetainingStructures']?.toString() ?? '',
      internalSlopeReinforcememt: json['InternalSlopeReinforcememt']?.toString() ?? '',
      remedialNotRequired: json['RemedialNotRequired']?.toString() ?? '',
      remedialNotSufficient: json['RemedialNotSufficient']?.toString() ?? '',
      remedialOtherInfo: json['RemedialOtherInfo']?.toString() ?? '',
      idProject: json['ID_project']?.toString(),
      idLan: json['ID_lan']?.toString(),
      classNumber: json['class_number']?.toString(),
      classType: json['class_type']?.toString(),
      geoAcc: json['geo_acc']?.toString(),
      date: json['date']?.toString(),
      dateAcc: json['date_acc']?.toString(),
      realignment: json['Realignment']?.toString() ?? '',
      toposheetNo: json['Toposheet_No']?.toString() ?? '',
      oldSlideNo: json['OldSlide_No']?.toString(),
      initiationYear: json['Initiation_Year']?.toString(),
      slideNo: json['Slide_No']?.toString(),
      imageCaptions: json['ImageCaptions']?.toString() ?? '',
      damsBarragesName: json['DamsBarragesName']?.toString() ?? '',
    );
  }

  // Helper methods
  bool get isApproved => checkStatus.toLowerCase() == 'approved';
  bool get isRejected => checkStatus.toLowerCase() == 'rejected';
  bool get isPending => checkStatus.toLowerCase() == 'pending';
  
  bool get isGeoScientist => userType.toLowerCase() == 'geo-scientist';
  bool get isPublic => userType.toLowerCase() == 'public';

  String get formattedCoordinates => '$latitude, $longitude';
  
  List<String> get availablePhotographs {
    List<String> photos = [];
    if (landslidePhotographs != null && landslidePhotographs!.isNotEmpty) {
      photos.add(landslidePhotographs!);
    }
    if (landslidePhotograph1 != null && landslidePhotograph1!.isNotEmpty) {
      photos.add(landslidePhotograph1!);
    }
    if (landslidePhotograph2 != null && landslidePhotograph2!.isNotEmpty) {
      photos.add(landslidePhotograph2!);
    }
    if (landslidePhotograph3 != null && landslidePhotograph3!.isNotEmpty) {
      photos.add(landslidePhotograph3!);
    }
    if (landslidePhotograph4 != null && landslidePhotograph4!.isNotEmpty) {
      photos.add(landslidePhotograph4!);
    }
    return photos;
  }
}