enum USState {
  ALABAMA('AL', 'Alabama'),
  ALASKA('AK', 'Alaska'),
  ARIZONA('AZ', 'Arizona'),
  ARKANSAS('AR', 'Arkansas'),
  CALIFORNIA('CA', 'California'),
  COLORADO('CO', 'Colorado'),
  CONNECTICUT('CT', 'Connecticut'),
  DELAWARE('DE', 'Delaware'),
  FLORIDA('FL', 'Florida'),
  GEORGIA('GA', 'Georgia'),
  HAWAII('HI', 'Hawaii'),
  IDAHO('ID', 'Idaho'),
  ILLINOIS('IL', 'Illinois'),
  INDIANA('IN', 'Indiana'),
  IOWA('IA', 'Iowa'),
  KANSAS('KS', 'Kansas'),
  KENTUCKY('KY', 'Kentucky'),
  LOUISIANA('LA', 'Louisiana'),
  MAINE('ME', 'Maine'),
  MARYLAND('MD', 'Maryland'),
  MASSACHUSETTS('MA', 'Massachusetts'),
  MICHIGAN('MI', 'Michigan'),
  MINNESOTA('MN', 'Minnesota'),
  MISSISSIPPI('MS', 'Mississippi'),
  MISSOURI('MO', 'Missouri'),
  MONTANA('MT', 'Montana'),
  NEBRASKA('NE', 'Nebraska'),
  NEVADA('NV', 'Nevada'),
  NEW_HAMPSHIRE('NH', 'New Hampshire'),
  NEW_JERSEY('NJ', 'New Jersey'),
  NEW_MEXICO('NM', 'New Mexico'),
  NEW_YORK('NY', 'New York'),
  NORTH_CAROLINA('NC', 'North Carolina'),
  NORTH_DAKOTA('ND', 'North Dakota'),
  OHIO('OH', 'Ohio'),
  OKLAHOMA('OK', 'Oklahoma'),
  OREGON('OR', 'Oregon'),
  PENNSYLVANIA('PA', 'Pennsylvania'),
  RHODE_ISLAND('RI', 'Rhode Island'),
  SOUTH_CAROLINA('SC', 'South Carolina'),
  SOUTH_DAKOTA('SD', 'South Dakota'),
  TENNESSEE('TN', 'Tennessee'),
  TEXAS('TX', 'Texas'),
  UTAH('UT', 'Utah'),
  VERMONT('VT', 'Vermont'),
  VIRGINIA('VA', 'Virginia'),
  WASHINGTON('WA', 'Washington'),
  WEST_VIRGINIA('WV', 'West Virginia'),
  WISCONSIN('WI', 'Wisconsin'),
  WYOMING('WY', 'Wyoming'),
  
  // US Territories
  DISTRICT_OF_COLUMBIA('DC', 'District of Columbia'),
  PUERTO_RICO('PR', 'Puerto Rico'),
  US_VIRGIN_ISLANDS('VI', 'U.S. Virgin Islands'),
  AMERICAN_SAMOA('AS', 'American Samoa'),
  GUAM('GU', 'Guam'),
  NORTHERN_MARIANA_ISLANDS('MP', 'Northern Mariana Islands');

  const USState(this.code, this.fullName);

  final String code;
  final String fullName;

  // Static methods for easy lookup
  static USState? fromCode(String code) {
    try {
      return USState.values.firstWhere(
        (state) => state.code.toUpperCase() == code.toUpperCase()
      );
    } catch (e) {
      return null;
    }
  }

  static USState? fromName(String name) {
    try {
      return USState.values.firstWhere(
        (state) => state.fullName.toLowerCase() == name.toLowerCase()
      );
    } catch (e) {
      return null;
    }
  }

  static List<String> get allCodes => USState.values.map((state) => state.code).toList();
  
  static List<String> get allNames => USState.values.map((state) => state.fullName).toList();

  @override
  String toString() => code;
}

// Alternative simpler enum if you only need codes:
enum StateCode {
  AL, AK, AZ, AR, CA, CO, CT, DE, FL, GA,
  HI, ID, IL, IN, IA, KS, KY, LA, ME, MD,
  MA, MI, MN, MS, MO, MT, NE, NV, NH, NJ,
  NM, NY, NC, ND, OH, OK, OR, PA, RI, SC,
  SD, TN, TX, UT, VT, VA, WA, WV, WI, WY,
  DC, PR, VI, AS, GU, MP;

  String get displayName {
    switch (this) {
      case StateCode.AL: return 'Alabama';
      case StateCode.AK: return 'Alaska';
      case StateCode.AZ: return 'Arizona';
      case StateCode.AR: return 'Arkansas';
      case StateCode.CA: return 'California';
      case StateCode.CO: return 'Colorado';
      case StateCode.CT: return 'Connecticut';
      case StateCode.DE: return 'Delaware';
      case StateCode.FL: return 'Florida';
      case StateCode.GA: return 'Georgia';
      case StateCode.HI: return 'Hawaii';
      case StateCode.ID: return 'Idaho';
      case StateCode.IL: return 'Illinois';
      case StateCode.IN: return 'Indiana';
      case StateCode.IA: return 'Iowa';
      case StateCode.KS: return 'Kansas';
      case StateCode.KY: return 'Kentucky';
      case StateCode.LA: return 'Louisiana';
      case StateCode.ME: return 'Maine';
      case StateCode.MD: return 'Maryland';
      case StateCode.MA: return 'Massachusetts';
      case StateCode.MI: return 'Michigan';
      case StateCode.MN: return 'Minnesota';
      case StateCode.MS: return 'Mississippi';
      case StateCode.MO: return 'Missouri';
      case StateCode.MT: return 'Montana';
      case StateCode.NE: return 'Nebraska';
      case StateCode.NV: return 'Nevada';
      case StateCode.NH: return 'New Hampshire';
      case StateCode.NJ: return 'New Jersey';
      case StateCode.NM: return 'New Mexico';
      case StateCode.NY: return 'New York';
      case StateCode.NC: return 'North Carolina';
      case StateCode.ND: return 'North Dakota';
      case StateCode.OH: return 'Ohio';
      case StateCode.OK: return 'Oklahoma';
      case StateCode.OR: return 'Oregon';
      case StateCode.PA: return 'Pennsylvania';
      case StateCode.RI: return 'Rhode Island';
      case StateCode.SC: return 'South Carolina';
      case StateCode.SD: return 'South Dakota';
      case StateCode.TN: return 'Tennessee';
      case StateCode.TX: return 'Texas';
      case StateCode.UT: return 'Utah';
      case StateCode.VT: return 'Vermont';
      case StateCode.VA: return 'Virginia';
      case StateCode.WA: return 'Washington';
      case StateCode.WV: return 'West Virginia';
      case StateCode.WI: return 'Wisconsin';
      case StateCode.WY: return 'Wyoming';
      case StateCode.DC: return 'District of Columbia';
      case StateCode.PR: return 'Puerto Rico';
      case StateCode.VI: return 'U.S. Virgin Islands';
      case StateCode.AS: return 'American Samoa';
      case StateCode.GU: return 'Guam';
      case StateCode.MP: return 'Northern Mariana Islands';
    }
  }
}