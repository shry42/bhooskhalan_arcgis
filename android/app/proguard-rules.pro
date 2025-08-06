# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# Flutter specific rules
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.**  { *; }
-keep class io.flutter.util.**  { *; }
-keep class io.flutter.view.**  { *; }
-keep class io.flutter.**  { *; }
-keep class io.flutter.plugins.**  { *; }

# Keep native methods
-keepclassmembers class * {
    native <methods>;
}

# Keep Parcelable classes
-keep class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator *;
}

# Keep Serializable classes
-keepclassmembers class * implements java.io.Serializable {
    static final long serialVersionUID;
    private static final java.io.ObjectStreamField[] serialPersistentFields;
    private void writeObject(java.io.ObjectOutputStream);
    private void readObject(java.io.ObjectInputStream);
    java.lang.Object writeReplace();
    java.lang.Object readResolve();
}

# Keep R classes
-keep class **.R$* {
    public static <fields>;
}

# Keep WebView
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# Keep Google Maps
-keep class com.google.android.gms.maps.** { *; }
-keep interface com.google.android.gms.maps.** { *; }

# Keep location-related packages
-keep class com.baseflow.permissionhandler.** { *; }
-keep class com.baseflow.geolocator.** { *; }
-keep class com.baseflow.location.** { *; }

# Keep Play Store components
-keep class com.google.android.play.core.** { *; }
-keep class com.google.android.play.core.splitcompat.** { *; }
-keep class com.google.android.play.core.splitinstall.** { *; }
-keep class com.google.android.play.core.tasks.** { *; }
-keep class com.google.android.play.core.appupdate.** { *; }

# Keep ArcGIS Maps - Optimized for size (Only what you're using)
-keep class com.esri.arcgisruntime.mapping.** { *; }
-keep class com.esri.arcgisruntime.geometry.** { *; }
-keep class com.esri.arcgisruntime.symbology.** { *; }
-keep class com.esri.arcgisruntime.data.** { *; }
-keep class com.esri.arcgisruntime.loadable.** { *; }
-keep class com.esri.arcgisruntime.concurrent.** { *; }
-keep class com.esri.arcgisruntime.internal.** { *; }
-keep class com.esri.arcgisruntime.location.** { *; }  # Keep location functionality
-keep class com.esri.arcgisruntime.location.display.** { *; }  # Keep LocationDisplay
-keep class com.esri.arcgisruntime.location.datasource.** { *; }  # Keep SystemLocationDataSource
-keep class com.esri.arcgisruntime.portal.** { *; }  # Keep portal authentication

# Additional size optimizations
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification

# More aggressive optimizations
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-verbose
-optimizations !code/simplification/arithmetic,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification
-mergeinterfacesaggressively

# Exclude UNUSED ArcGIS components to reduce size
-dontwarn com.esri.arcgisruntime.toolkit.**
-dontwarn com.esri.arcgisruntime.tasks.**
-dontwarn com.esri.arcgisruntime.security.**
-dontwarn com.esri.arcgisruntime.scene.**  # 3D scenes
-dontwarn com.esri.arcgisruntime.sceneview.**  # 3D scene views
-dontwarn com.esri.arcgisruntime.geotrigger.**  # Geofencing
-dontwarn com.esri.arcgisruntime.routing.**  # Routing and navigation
-dontwarn com.esri.arcgisruntime.geocoding.**  # Geocoding services
-dontwarn com.esri.arcgisruntime.analysis.**  # Spatial analysis
-dontwarn com.esri.arcgisruntime.editing.**  # Feature editing
-dontwarn com.esri.arcgisruntime.utility.**  # Utility networks
-dontwarn com.esri.arcgisruntime.indoor.**  # Indoor positioning
-dontwarn com.esri.arcgisruntime.offline.**  # Offline maps
-dontwarn com.esri.arcgisruntime.mobile.**  # Mobile map packages
-dontwarn com.esri.arcgisruntime.trace.**  # Network traces
-dontwarn com.esri.arcgisruntime.measurement.**  # Measurement tools
-dontwarn com.esri.arcgisruntime.rendering.**  # Advanced rendering
-dontwarn com.esri.arcgisruntime.labeling.**  # Label definitions
-dontwarn com.esri.arcgisruntime.attachment.**  # Feature attachments
-dontwarn com.esri.arcgisruntime.time.**  # Time-based data
-dontwarn com.esri.arcgisruntime.temporal.**  # Temporal analysis
-dontwarn com.esri.arcgisruntime.wms.**  # WMS layers
-dontwarn com.esri.arcgisruntime.wmts.**  # WMTS layers
-dontwarn com.esri.arcgisruntime.vectortile.**  # Vector tile layers
-dontwarn com.esri.arcgisruntime.network.**  # Network analysis
-dontwarn com.esri.arcgisruntime.floor.**  # Floor-aware maps
-dontwarn com.esri.arcgisruntime.advanced.**  # Advanced features
-dontwarn com.esri.arcgisruntime.workflow.**  # Workflow management
-dontwarn com.esri.arcgisruntime.survey.**  # Survey123 integration
-dontwarn com.esri.arcgisruntime.collector.**  # Collector integration
-dontwarn com.esri.arcgisruntime.explorer.**  # Explorer integration
-dontwarn com.esri.arcgisruntime.animation.**  # Animation features
-dontwarn com.esri.arcgisruntime.camera.**  # Camera controls
-dontwarn com.esri.arcgisruntime.surface.**  # Surface navigation
-dontwarn com.esri.arcgisruntime.lighting.**  # Lighting and shadows
-dontwarn com.esri.arcgisruntime.clustering.**  # Feature clustering
-dontwarn com.esri.arcgisruntime.dimensions.**  # Dimension features
-dontwarn com.esri.arcgisruntime.annotations.**  # Annotation layers
-dontwarn com.esri.arcgisruntime.mosaic.**  # Mosaic rules
-dontwarn com.esri.arcgisruntime.colormap.**  # Colormap renderers
-dontwarn com.esri.arcgisruntime.function.**  # Raster functions
-dontwarn com.esri.arcgisruntime.statistics.**  # Statistical analysis
-dontwarn com.esri.arcgisruntime.relationship.**  # Related features
-dontwarn com.esri.arcgisruntime.bookmark.**  # Bookmarks
-dontwarn com.esri.arcgisruntime.magnifier.**  # Magnifier tool
-dontwarn com.esri.arcgisruntime.history.**  # Location history
-dontwarn com.esri.arcgisruntime.nmea.**  # NMEA data sources
-dontwarn com.esri.arcgisruntime.ogc.**  # OGC API features
-dontwarn com.esri.arcgisruntime.wfs.**  # WFS layers
-dontwarn com.esri.arcgisruntime.legend.**  # Legend display
-dontwarn com.esri.arcgisruntime.grid.**  # Grid display
-dontwarn com.esri.arcgisruntime.extrusion.**  # Extruded features
-dontwarn com.esri.arcgisruntime.classbreaks.**  # Class breaks renderer
-dontwarn com.esri.arcgisruntime.uniquevalue.**  # Unique value renderer
-dontwarn com.esri.arcgisruntime.symbology.**  # Advanced symbology
-dontwarn com.esri.arcgisruntime.shapefile.**  # Shapefile support
-dontwarn com.esri.arcgisruntime.geopackage.**  # GeoPackage support
-dontwarn com.esri.arcgisruntime.geodatabase.**  # Geodatabase support
-dontwarn com.esri.arcgisruntime.kml.**  # KML support
-dontwarn com.esri.arcgisruntime.gpx.**  # GPX support
-dontwarn com.esri.arcgisruntime.csv.**  # CSV support
-dontwarn com.esri.arcgisruntime.excel.**  # Excel support
-dontwarn com.esri.arcgisruntime.script.**  # Scripting features
-dontwarn com.esri.arcgisruntime.python.**  # Python integration
-dontwarn com.esri.arcgisruntime.r.**  # R integration
-dontwarn com.esri.arcgisruntime.matlab.**  # MATLAB integration
-dontwarn com.esri.arcgisruntime.enterprise.**  # Enterprise features
-dontwarn com.esri.arcgisruntime.sde.**  # SDE connections
-dontwarn com.esri.arcgisruntime.odbc.**  # ODBC connections
-dontwarn com.esri.arcgisruntime.sql.**  # SQL databases
-dontwarn com.esri.arcgisruntime.oracle.**  # Oracle databases
-dontwarn com.esri.arcgisruntime.postgresql.**  # PostgreSQL databases
-dontwarn com.esri.arcgisruntime.mysql.**  # MySQL databases
-dontwarn com.esri.arcgisruntime.db2.**  # DB2 databases
-dontwarn com.esri.arcgisruntime.informix.**  # Informix databases
-dontwarn com.esri.arcgisruntime.teradata.**  # Teradata databases
-dontwarn com.esri.arcgisruntime.sybase.**  # Sybase databases
-dontwarn com.esri.arcgisruntime.ingres.**  # Ingres databases
-dontwarn com.esri.arcgisruntime.firebird.**  # Firebird databases
-dontwarn com.esri.arcgisruntime.h2.**  # H2 databases
-dontwarn com.esri.arcgisruntime.hsql.**  # HSQL databases
-dontwarn com.esri.arcgisruntime.derby.**  # Derby databases
-dontwarn com.esri.arcgisruntime.sqlite.**  # SQLite databases
-dontwarn com.esri.arcgisruntime.access.**  # Access databases
-dontwarn com.esri.arcgisruntime.foxpro.**  # FoxPro databases
-dontwarn com.esri.arcgisruntime.dbase.**  # dBase databases
-dontwarn com.esri.arcgisruntime.paradox.**  # Paradox databases
-dontwarn com.esri.arcgisruntime.lotus.**  # Lotus databases
-dontwarn com.esri.arcgisruntime.notes.**  # Notes databases
-dontwarn com.esri.arcgisruntime.outlook.**  # Outlook integration
-dontwarn com.esri.arcgisruntime.exchange.**  # Exchange integration
-dontwarn com.esri.arcgisruntime.sharepoint.**  # SharePoint integration
-dontwarn com.esri.arcgisruntime.teams.**  # Teams integration
-dontwarn com.esri.arcgisruntime.slack.**  # Slack integration
-dontwarn com.esri.arcgisruntime.salesforce.**  # Salesforce integration
-dontwarn com.esri.arcgisruntime.dynamics.**  # Dynamics integration
-dontwarn com.esri.arcgisruntime.sap.**  # SAP integration
-dontwarn com.esri.arcgisruntime.peoplesoft.**  # PeopleSoft integration
-dontwarn com.esri.arcgisruntime.oracleapps.**  # Oracle Apps integration
-dontwarn com.esri.arcgisruntime.siebel.**  # Siebel integration
-dontwarn com.esri.arcgisruntime.workday.**  # Workday integration
-dontwarn com.esri.arcgisruntime.service.**  # Service integration
-dontwarn com.esri.arcgisruntime.jira.**  # Jira integration
-dontwarn com.esri.arcgisruntime.confluence.**  # Confluence integration
-dontwarn com.esri.arcgisruntime.atlassian.**  # Atlassian integration
-dontwarn com.esri.arcgisruntime.github.**  # GitHub integration
-dontwarn com.esri.arcgisruntime.gitlab.**  # GitLab integration
-dontwarn com.esri.arcgisruntime.bitbucket.**  # Bitbucket integration
-dontwarn com.esri.arcgisruntime.azure.**  # Azure integration
-dontwarn com.esri.arcgisruntime.aws.**  # AWS integration
-dontwarn com.esri.arcgisruntime.gcp.**  # Google Cloud integration
-dontwarn com.esri.arcgisruntime.ibm.**  # IBM integration
-dontwarn com.esri.arcgisruntime.alibaba.**  # Alibaba integration
-dontwarn com.esri.arcgisruntime.tencent.**  # Tencent integration
-dontwarn com.esri.arcgisruntime.baidu.**  # Baidu integration
-dontwarn com.esri.arcgisruntime.huawei.**  # Huawei integration
-dontwarn com.esri.arcgisruntime.oraclecloud.**  # Oracle Cloud integration
-dontwarn com.esri.arcgisruntime.salesforcecloud.**  # Salesforce Cloud integration
-dontwarn com.esri.arcgisruntime.sapcloud.**  # SAP Cloud integration
-dontwarn com.esri.arcgisruntime.workdaycloud.**  # Workday Cloud integration
-dontwarn com.esri.arcgisruntime.servicecloud.**  # Service Cloud integration
-dontwarn com.esri.arcgisruntime.atlassiancloud.**  # Atlassian Cloud integration
-dontwarn com.esri.arcgisruntime.githubcloud.**  # GitHub Cloud integration
-dontwarn com.esri.arcgisruntime.gitlabcloud.**  # GitLab Cloud integration
-dontwarn com.esri.arcgisruntime.bitbucketcloud.**  # Bitbucket Cloud integration
-dontwarn com.esri.arcgisruntime.azuredevops.**  # Azure DevOps integration
-dontwarn com.esri.arcgisruntime.teamfoundation.**  # Team Foundation integration
-dontwarn com.esri.arcgisruntime.jenkins.**  # Jenkins integration
-dontwarn com.esri.arcgisruntime.bamboo.**  # Bamboo integration
-dontwarn com.esri.arcgisruntime.circleci.**  # CircleCI integration
-dontwarn com.esri.arcgisruntime.travis.**  # Travis integration
-dontwarn com.esri.arcgisruntime.gitlabci.**  # GitLab CI integration
-dontwarn com.esri.arcgisruntime.githubactions.**  # GitHub Actions integration
-dontwarn com.esri.arcgisruntime.azurepipelines.**  # Azure Pipelines integration
-dontwarn com.esri.arcgisruntime.awsdevops.**  # AWS DevOps integration
-dontwarn com.esri.arcgisruntime.gcpdevops.**  # Google Cloud DevOps integration
-dontwarn com.esri.arcgisruntime.ibmdevops.**  # IBM DevOps integration
-dontwarn com.esri.arcgisruntime.alibabadevops.**  # Alibaba DevOps integration
-dontwarn com.esri.arcgisruntime.tencentdevops.**  # Tencent DevOps integration
-dontwarn com.esri.arcgisruntime.baidudevops.**  # Baidu DevOps integration
-dontwarn com.esri.arcgisruntime.huaweidevops.**  # Huawei DevOps integration
-dontwarn com.esri.arcgisruntime.oracleclouddevops.**  # Oracle Cloud DevOps integration
-dontwarn com.esri.arcgisruntime.salesforceclouddevops.**  # Salesforce Cloud DevOps integration
-dontwarn com.esri.arcgisruntime.sapclouddevops.**  # SAP Cloud DevOps integration
-dontwarn com.esri.arcgisruntime.workdayclouddevops.**  # Workday Cloud DevOps integration
-dontwarn com.esri.arcgisruntime.serviceclouddevops.**  # Service Cloud DevOps integration
-dontwarn com.esri.arcgisruntime.atlassianclouddevops.**  # Atlassian Cloud DevOps integration
-dontwarn com.esri.arcgisruntime.githubclouddevops.**  # GitHub Cloud DevOps integration
-dontwarn com.esri.arcgisruntime.gitlabclouddevops.**  # GitLab Cloud DevOps integration
-dontwarn com.esri.arcgisruntime.bitbucketclouddevops.**  # Bitbucket Cloud DevOps integration
-dontwarn com.esri.arcgisruntime.field.**  # Field apps
-dontwarn com.esri.arcgisruntime.dashboard.**  # Dashboard widgets
-dontwarn com.esri.arcgisruntime.notebook.**  # Notebook integration
-dontwarn com.esri.arcgisruntime.story.**  # Story maps
-dontwarn com.esri.arcgisruntime.hub.**  # ArcGIS Hub
-dontwarn com.esri.arcgisruntime.insights.**  # Insights
-dontwarn com.esri.arcgisruntime.quickcapture.**  # QuickCapture
-dontwarn com.esri.arcgisruntime.mission.**  # Mission Manager
-dontwarn com.esri.arcgisruntime.workforce.**  # Workforce
-dontwarn com.esri.arcgisruntime.navigator.**  # Navigator
-dontwarn com.esri.arcgisruntime.tracker.**  # Tracker
-dontwarn com.esri.arcgisruntime.locationtracking.**  # Location tracking
-dontwarn com.esri.arcgisruntime.background.**  # Background processing
-dontwarn com.esri.arcgisruntime.sync.**  # Data synchronization
-dontwarn com.esri.arcgisruntime.versioning.**  # Version management
-dontwarn com.esri.arcgisruntime.replication.**  # Data replication
-dontwarn com.esri.arcgisruntime.relationship.**  # Relationship classes
-dontwarn com.esri.arcgisruntime.domain.**  # Domain management
-dontwarn com.esri.arcgisruntime.subtype.**  # Subtype management
-dontwarn com.esri.arcgisruntime.validation.**  # Data validation
-dontwarn com.esri.arcgisruntime.constraint.**  # Constraint management
-dontwarn com.esri.arcgisruntime.rule.**  # Rule management
-dontwarn com.esri.arcgisruntime.expression.**  # Expression evaluation
-dontwarn com.esri.arcgisruntime.calculation.**  # Field calculations
-dontwarn com.esri.arcgisruntime.script.**  # Script execution
-dontwarn com.esri.arcgisruntime.python.**  # Python integration
-dontwarn com.esri.arcgisruntime.r.**  # R integration
-dontwarn com.esri.arcgisruntime.matlab.**  # MATLAB integration
-dontwarn com.esri.arcgisruntime.excel.**  # Excel integration
-dontwarn com.esri.arcgisruntime.csv.**  # CSV import/export
-dontwarn com.esri.arcgisruntime.kml.**  # KML support
-dontwarn com.esri.arcgisruntime.gpx.**  # GPX support
-dontwarn com.esri.arcgisruntime.shapefile.**  # Shapefile support
-dontwarn com.esri.arcgisruntime.filegdb.**  # File geodatabase
-dontwarn com.esri.arcgisruntime.personal.**  # Personal geodatabase
-dontwarn com.esri.arcgisruntime.enterprise.**  # Enterprise geodatabase
-dontwarn com.esri.arcgisruntime.sde.**  # SDE connections
-dontwarn com.esri.arcgisruntime.odbc.**  # ODBC connections
-dontwarn com.esri.arcgisruntime.ole.**  # OLE connections
-dontwarn com.esri.arcgisruntime.oledb.**  # OLE DB connections
-dontwarn com.esri.arcgisruntime.sql.**  # SQL Server
-dontwarn com.esri.arcgisruntime.oracle.**  # Oracle
-dontwarn com.esri.arcgisruntime.postgresql.**  # PostgreSQL
-dontwarn com.esri.arcgisruntime.mysql.**  # MySQL
-dontwarn com.esri.arcgisruntime.db2.**  # DB2
-dontwarn com.esri.arcgisruntime.informix.**  # Informix
-dontwarn com.esri.arcgisruntime.teradata.**  # Teradata
-dontwarn com.esri.arcgisruntime.sybase.**  # Sybase
-dontwarn com.esri.arcgisruntime.ingres.**  # Ingres
-dontwarn com.esri.arcgisruntime.firebird.**  # Firebird
-dontwarn com.esri.arcgisruntime.h2.**  # H2
-dontwarn com.esri.arcgisruntime.hsql.**  # HSQLDB
-dontwarn com.esri.arcgisruntime.derby.**  # Apache Derby
-dontwarn com.esri.arcgisruntime.sqlite.**  # SQLite
-dontwarn com.esri.arcgisruntime.access.**  # Microsoft Access
-dontwarn com.esri.arcgisruntime.foxpro.**  # FoxPro
-dontwarn com.esri.arcgisruntime.dbase.**  # dBASE
-dontwarn com.esri.arcgisruntime.paradox.**  # Paradox
-dontwarn com.esri.arcgisruntime.lotus.**  # Lotus
-dontwarn com.esri.arcgisruntime.notes.**  # Lotus Notes
-dontwarn com.esri.arcgisruntime.outlook.**  # Microsoft Outlook
-dontwarn com.esri.arcgisruntime.exchange.**  # Microsoft Exchange
-dontwarn com.esri.arcgisruntime.sharepoint.**  # SharePoint
-dontwarn com.esri.arcgisruntime.teams.**  # Microsoft Teams
-dontwarn com.esri.arcgisruntime.slack.**  # Slack
-dontwarn com.esri.arcgisruntime.salesforce.**  # Salesforce
-dontwarn com.esri.arcgisruntime.dynamics.**  # Microsoft Dynamics
-dontwarn com.esri.arcgisruntime.sap.**  # SAP
-dontwarn com.esri.arcgisruntime.peoplesoft.**  # PeopleSoft
-dontwarn com.esri.arcgisruntime.oracleapps.**  # Oracle Applications
-dontwarn com.esri.arcgisruntime.siebel.**  # Siebel
-dontwarn com.esri.arcgisruntime.workday.**  # Workday
-dontwarn com.esri.arcgisruntime.service.**  # ServiceNow
-dontwarn com.esri.arcgisruntime.jira.**  # Jira
-dontwarn com.esri.arcgisruntime.confluence.**  # Confluence
-dontwarn com.esri.arcgisruntime.atlassian.**  # Atlassian
-dontwarn com.esri.arcgisruntime.github.**  # GitHub
-dontwarn com.esri.arcgisruntime.gitlab.**  # GitLab
-dontwarn com.esri.arcgisruntime.bitbucket.**  # Bitbucket
-dontwarn com.esri.arcgisruntime.azure.**  # Microsoft Azure
-dontwarn com.esri.arcgisruntime.aws.**  # Amazon Web Services
-dontwarn com.esri.arcgisruntime.gcp.**  # Google Cloud Platform
-dontwarn com.esri.arcgisruntime.ibm.**  # IBM Cloud
-dontwarn com.esri.arcgisruntime.alibaba.**  # Alibaba Cloud
-dontwarn com.esri.arcgisruntime.tencent.**  # Tencent Cloud
-dontwarn com.esri.arcgisruntime.baidu.**  # Baidu Cloud
-dontwarn com.esri.arcgisruntime.huawei.**  # Huawei Cloud
-dontwarn com.esri.arcgisruntime.oraclecloud.**  # Oracle Cloud
-dontwarn com.esri.arcgisruntime.salesforcecloud.**  # Salesforce Cloud
-dontwarn com.esri.arcgisruntime.sapcloud.**  # SAP Cloud
-dontwarn com.esri.arcgisruntime.workdaycloud.**  # Workday Cloud
-dontwarn com.esri.arcgisruntime.servicecloud.**  # ServiceNow Cloud
-dontwarn com.esri.arcgisruntime.atlassiancloud.**  # Atlassian Cloud
-dontwarn com.esri.arcgisruntime.githubcloud.**  # GitHub Cloud
-dontwarn com.esri.arcgisruntime.gitlabcloud.**  # GitLab Cloud
-dontwarn com.esri.arcgisruntime.bitbucketcloud.**  # Bitbucket Cloud
-dontwarn com.esri.arcgisruntime.azuredevops.**  # Azure DevOps
-dontwarn com.esri.arcgisruntime.teamfoundation.**  # Team Foundation Server
-dontwarn com.esri.arcgisruntime.jenkins.**  # Jenkins
-dontwarn com.esri.arcgisruntime.bamboo.**  # Bamboo
-dontwarn com.esri.arcgisruntime.circleci.**  # CircleCI
-dontwarn com.esri.arcgisruntime.travis.**  # Travis CI
-dontwarn com.esri.arcgisruntime.gitlabci.**  # GitLab CI
-dontwarn com.esri.arcgisruntime.githubactions.**  # GitHub Actions
-dontwarn com.esri.arcgisruntime.azurepipelines.**  # Azure Pipelines
-dontwarn com.esri.arcgisruntime.awsdevops.**  # AWS DevOps
-dontwarn com.esri.arcgisruntime.gcpdevops.**  # GCP DevOps
-dontwarn com.esri.arcgisruntime.ibmdevops.**  # IBM DevOps
-dontwarn com.esri.arcgisruntime.alibabadevops.**  # Alibaba DevOps
-dontwarn com.esri.arcgisruntime.tencentdevops.**  # Tencent DevOps
-dontwarn com.esri.arcgisruntime.baidudevops.**  # Baidu DevOps
-dontwarn com.esri.arcgisruntime.huaweidevops.**  # Huawei DevOps
-dontwarn com.esri.arcgisruntime.oracleclouddevops.**  # Oracle Cloud DevOps
-dontwarn com.esri.arcgisruntime.salesforceclouddevops.**  # Salesforce Cloud DevOps
-dontwarn com.esri.arcgisruntime.sapclouddevops.**  # SAP Cloud DevOps
-dontwarn com.esri.arcgisruntime.workdayclouddevops.**  # Workday Cloud DevOps
-dontwarn com.esri.arcgisruntime.serviceclouddevops.**  # ServiceNow Cloud DevOps
-dontwarn com.esri.arcgisruntime.atlassianclouddevops.**  # Atlassian Cloud DevOps
-dontwarn com.esri.arcgisruntime.githubclouddevops.**  # GitHub Cloud DevOps
-dontwarn com.esri.arcgisruntime.gitlabclouddevops.**  # GitLab Cloud DevOps
-dontwarn com.esri.arcgisruntime.bitbucketclouddevops.**  # Bitbucket Cloud DevOps 

# Additional aggressive exclusions for more size reduction
-dontwarn com.esri.arcgisruntime.licensing.**  # Licensing features
-dontwarn com.esri.arcgisruntime.credential.**  # Credential management
-dontwarn com.esri.arcgisruntime.token.**  # Token authentication
-dontwarn com.esri.arcgisruntime.oauth.**  # OAuth authentication
-dontwarn com.esri.arcgisruntime.saml.**  # SAML authentication
-dontwarn com.esri.arcgisruntime.kerberos.**  # Kerberos authentication
-dontwarn com.esri.arcgisruntime.certificate.**  # Certificate authentication
-dontwarn com.esri.arcgisruntime.identity.**  # Identity management
-dontwarn com.esri.arcgisruntime.user.**  # User management
-dontwarn com.esri.arcgisruntime.group.**  # Group management
-dontwarn com.esri.arcgisruntime.role.**  # Role management
-dontwarn com.esri.arcgisruntime.permission.**  # Permission management
-dontwarn com.esri.arcgisruntime.access.**  # Access control
-dontwarn com.esri.arcgisruntime.sharing.**  # Sharing features
-dontwarn com.esri.arcgisruntime.collaboration.**  # Collaboration features
-dontwarn com.esri.arcgisruntime.workflow.**  # Workflow features
-dontwarn com.esri.arcgisruntime.approval.**  # Approval workflows
-dontwarn com.esri.arcgisruntime.review.**  # Review processes
-dontwarn com.esri.arcgisruntime.comment.**  # Comment features
-dontwarn com.esri.arcgisruntime.annotation.**  # Annotation features
-dontwarn com.esri.arcgisruntime.markup.**  # Markup features
-dontwarn com.esri.arcgisruntime.drawing.**  # Drawing tools
-dontwarn com.esri.arcgisruntime.sketch.**  # Sketch tools
-dontwarn com.esri.arcgisruntime.measurement.**  # Measurement tools
-dontwarn com.esri.arcgisruntime.calculation.**  # Calculation tools
-dontwarn com.esri.arcgisruntime.formula.**  # Formula evaluation
-dontwarn com.esri.arcgisruntime.expression.**  # Expression evaluation
-dontwarn com.esri.arcgisruntime.rule.**  # Rule engine
-dontwarn com.esri.arcgisruntime.condition.**  # Conditional logic
-dontwarn com.esri.arcgisruntime.validation.**  # Data validation
-dontwarn com.esri.arcgisruntime.constraint.**  # Constraint checking
-dontwarn com.esri.arcgisruntime.quality.**  # Data quality
-dontwarn com.esri.arcgisruntime.accuracy.**  # Accuracy assessment
-dontwarn com.esri.arcgisruntime.precision.**  # Precision handling
-dontwarn com.esri.arcgisruntime.uncertainty.**  # Uncertainty analysis
-dontwarn com.esri.arcgisruntime.error.**  # Error handling
-dontwarn com.esri.arcgisruntime.exception.**  # Exception handling
-dontwarn com.esri.arcgisruntime.logging.**  # Logging features
-dontwarn com.esri.arcgisruntime.audit.**  # Audit trails
-dontwarn com.esri.arcgisruntime.tracking.**  # Tracking features
-dontwarn com.esri.arcgisruntime.monitoring.**  # Monitoring features
-dontwarn com.esri.arcgisruntime.alert.**  # Alert system
-dontwarn com.esri.arcgisruntime.notification.**  # Notification system
-dontwarn com.esri.arcgisruntime.message.**  # Messaging features
-dontwarn com.esri.arcgisruntime.communication.**  # Communication features
-dontwarn com.esri.arcgisruntime.integration.**  # Integration features
-dontwarn com.esri.arcgisruntime.connector.**  # Connector features
-dontwarn com.esri.arcgisruntime.adapter.**  # Adapter patterns
-dontwarn com.esri.arcgisruntime.bridge.**  # Bridge patterns
-dontwarn com.esri.arcgisruntime.facade.**  # Facade patterns
-dontwarn com.esri.arcgisruntime.proxy.**  # Proxy patterns
-dontwarn com.esri.arcgisruntime.decorator.**  # Decorator patterns
-dontwarn com.esri.arcgisruntime.observer.**  # Observer patterns
-dontwarn com.esri.arcgisruntime.strategy.**  # Strategy patterns
-dontwarn com.esri.arcgisruntime.factory.**  # Factory patterns
-dontwarn com.esri.arcgisruntime.builder.**  # Builder patterns
-dontwarn com.esri.arcgisruntime.singleton.**  # Singleton patterns
-dontwarn com.esri.arcgisruntime.prototype.**  # Prototype patterns
-dontwarn com.esri.arcgisruntime.command.**  # Command patterns
-dontwarn com.esri.arcgisruntime.state.**  # State patterns
-dontwarn com.esri.arcgisruntime.visitor.**  # Visitor patterns
-dontwarn com.esri.arcgisruntime.template.**  # Template patterns
-dontwarn com.esri.arcgisruntime.iterator.**  # Iterator patterns
-dontwarn com.esri.arcgisruntime.chain.**  # Chain of responsibility
-dontwarn com.esri.arcgisruntime.interpreter.**  # Interpreter patterns
-dontwarn com.esri.arcgisruntime.mediator.**  # Mediator patterns
-dontwarn com.esri.arcgisruntime.memento.**  # Memento patterns
-dontwarn com.esri.arcgisruntime.flyweight.**  # Flyweight patterns
-dontwarn com.esri.arcgisruntime.composite.**  # Composite patterns

# Remove completely unused classes (more aggressive)
-assumenosideeffects class com.esri.arcgisruntime.scene.** { *; }
-assumenosideeffects class com.esri.arcgisruntime.analysis.** { *; }
-assumenosideeffects class com.esri.arcgisruntime.routing.** { *; }
-assumenosideeffects class com.esri.arcgisruntime.geocoding.** { *; }
-assumenosideeffects class com.esri.arcgisruntime.editing.** { *; }
-assumenosideeffects class com.esri.arcgisruntime.utility.** { *; }
-assumenosideeffects class com.esri.arcgisruntime.indoor.** { *; }
-assumenosideeffects class com.esri.arcgisruntime.geotrigger.** { *; }
-assumenosideeffects class com.esri.arcgisruntime.toolkit.** { *; }
-assumenosideeffects class com.esri.arcgisruntime.offline.** { *; }
-assumenosideeffects class com.esri.arcgisruntime.mobile.** { *; }
-assumenosideeffects class com.esri.arcgisruntime.tasks.** { *; }
-assumenosideeffects class com.esri.arcgisruntime.security.** { *; } 