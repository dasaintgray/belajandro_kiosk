class GQLData {
  GQLData._();

  /// QUERY
  /// --------------------------------------------------------------------------
  static const String qrySettings = r'''query getSettings @cached {
  Settings(order_by: {Id: asc}) {
    code
    value
    description
  }
}
''';

  static String settingsAndTranslation = r'''
  query @cached {
    Settings(order_by: {Id: asc}) {
      code
      value
      description
    }
    Translations {
      Id
      LanguageId
      code
      description
      translationText
      images
      type
    }
  }
  ''';

  static String qryTranslation = r'''
  query getTranslation {
    menu: Translations(where: {isActive: {_eq: true}}) {
      Id
      LanguageId
      code
      description
      translationText
      images
      type
    }
  }
  ''';

  static String qryPaymentTypes = r'''
    query getPaymentType {
      PaymentTypes(where: {isActive: {_eq: true}, _and: {code: {_neq: "AR"}}}) {
        Id
        code
        description
      }
    }''';

  static String qryRoomType = r'''
  query getRoomTypes {
    vRoomTypes(where: {isActive: {_eq: true}}) {
      Id
      code
      LocationId
      description
    }
  }
  ''';

  static String qRoomType = r'''
  query getRoomTypes($agentID: Int!) {
    vRoomTypes {
      Id
      code
      LocationId
      description
      available: vrtrs_aggregate(where: {AgentId: {_eq: $agentID}, isActive: {_eq: true}, isHidden: {_eq: false}}) {
        total: aggregate {
          count(distinct: true)
        }
      }
    }
  }
  ''';

  static String qTerminalDenominations = r'''
  query getDenominations($terminalID: Int!) {
    salapi: TerminalDenominations(where: {TerminalId: {_eq: $terminalID}}) {
      Id
      TerminalId
      p20
      p50
      p100
      p200
      p500
      p1000
      total
      totalQty
      tranDate
    }
  }
  ''';

  static String qryAvailableRooms = r'''
	query getRoomAvailable($AgentTypdID: Int!, $roomTypeID: Int!) {
    vRoomAvailable(where: {isActive: {_eq: true}, isHidden: {_eq: false}, AgentId: {_eq: $AgentTypdID}, RoomTypeId: {_eq: $roomTypeID}}) {
      Id
      code
      description
      rate
      lockCode
      bed
      RoomTypeId
      roomType
    }
  }
  ''';

  static String qryLanguages = r'''query getLanguages @cached {
    Languages(where: {isActive: {_eq: true}}) {
      Id
      code
      description
      disclaimer
      flag
      }
    }''';

  static String qrySeriesDetails = r'''
  query getSeriesDetails($moduleID: Int!) {
    SeriesDetails(where: {ModuleId: {_eq: $moduleID}, isActive: {_eq: true}}, limit: 1) {
      Id
      SeriesId
      docNo
      description
      LocationId
      ModuleId
      isActive
      tranDate
    }
  }
  ''';

  static String qPrefix = r'''
  query getPrefix {
    Prefixes {
      Id
      description
      }
    }''';

  /// MUTATION
  /// --------------------------------------------------------------------------
  ///
  static String mPeople = r'''
  mutation addContacts($fn: String!, $mi: String!, $ln: String!, $prefixID: Int!, $cdate: datetime!, 
    $cby: String!, $mobileNo: String!, $email: String!, $code: String!) {
    insert_People(objects: {fName: $fn, mName: $mi, lName: $ln, PrefixId: $prefixID, SuffixId: 1, 
      GenderId: 1, NationalityId: 77, BloodTypeId: 1, CivilStatusId: 1, CountryId: 1, Discriminator: "Contact", 
      isBanned: false, createdBy: $cby, createdDate: $cdate, mobileNo: $mobileNo, email: $email, code: $code}) {
      affected_rows
      returning {
        Id
      }
    }
  }
  ''';

  static String mPhotoes = r'''
  mutation addPhotoes($contactID: Int!, $photo: String!, $createdBy: String!, $createdDate: datetime!) {
    insert_ContactPhotoes(objects: {ContactId: $contactID, photo: $photo, 
      isActive: true, createdBy: $createdBy, createdDate: $createdDate}) {
      affected_rows
    }
  }''';

  static String mUpdateSeriesDetails = r'''
  mutation updateSeriesDetails($isActive: Boolean!, $modifiedBy: String!, 
    $modifiedDate: datetime!, $reservationDate: datetime!, $tranDate: datetime!, $seriesID: Int!) {
    update_SeriesDetails(_set: {isActive: $isActive, modifiedBy: $modifiedBy, modifiedDate: $modifiedDate, 
      reservationDate: $reservationDate, tranDate: $tranDate}, 
      where: {Id: {_eq: $seriesID}}) {
      affected_rows
    }
  }
  ''';

  /// SUBSCRIPTION
  /// --------------------------------------------------------------------------
  static String sAvailableRooms = r'''
  subscription subsRoomAvailable($AgentTypdID: Int!, $roomTypeID: Int!) {
    vRoomAvailable(where: {isActive: {_eq: true}, isHidden: {_eq: false}, AgentId: {_eq: $AgentTypdID}, RoomTypeId: {_eq: $roomTypeID}}) {
      Id
      code
      description
      rate
      lockCode
      bed
      RoomTypeId
      roomType
    }
  }
  ''';
}
