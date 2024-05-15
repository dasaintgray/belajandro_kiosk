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
  query getRoomTypes {
    vRoomTypes(where: {isActive: {_eq: true}}) {
      Id
      LocationId
      code
      description
      isActive
      rate
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
    query getRoomAvailable($agentID: Int!, $accommodationTypeID: Int!, $roomTypeID: Int!, $bed: Int!) {
      vRoomAvailable(where: {AgentId: {_eq: $agentID}, 
        _and: {AccommodationTypeId: {_eq: $accommodationTypeID}, 
        _and: {RoomTypeId: {_eq: $roomTypeID}, 
        _and: {isActive: {_eq: true}, 
        _and: {isHidden: {_eq: false}}}, bed: {_gte: $bed}}}}) {
        id
        code
        description
        rate
        lockCode
        bed
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
  static String mPeople =
      r'''mutation addContacts($fn: String!, $mi: String!, $ln: String!, $prefixID: Int!, $cdate: datetime!, $cby: String!) {
    insert_People(objects: {fName: $fn, mName: $mi, lName: $ln, PrefixId: $prefixID, SuffixId: 1, GenderId: 1, 
      NationalityId: 77, BloodTypeId: 1, CivilStatusId: 1, CountryId: 1, Discriminator: "Contact", 
      isBanned: false, 
      createdBy: $cby, createdDate: $cdate}) {
      affected_rows
      returning {
        Id
      }
    }
  }''';

  /// SUBSCRIPTION
  /// --------------------------------------------------------------------------
  static String sAvailableRooms = r'''
    subscription getRoomAvailable($agentID: Int!, $accommodationTypeID: Int!, $roomTypeID: Int!, $bed: Int!) {
      vRoomAvailable(where: {AgentId: {_eq: $agentID}, 
        _and: {AccommodationTypeId: {_eq: $accommodationTypeID}, 
        _and: {RoomTypeId: {_eq: $roomTypeID}, 
        _and: {isActive: {_eq: true}, 
        _and: {isHidden: {_eq: false}}}, bed: {_gte: $bed}}}}) {
        id
        code
        description
        rate
        lockCode
        bed
      }
    }
  ''';
}
