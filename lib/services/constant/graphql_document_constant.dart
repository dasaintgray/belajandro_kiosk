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

  static String qryTranslation = r'''query getTranslation {
    menu: Translations {
      Id
      LanguageId
      code
      description
      translationText
      images
      type
    }
  }''';

  static String qryPaymentTypes = r'''query getPaymentType {
  PaymentTypes(where: {isActive: {_eq: true}}) {
    Id
    code
    description
  }
}
''';

  static String qryRoomType = r'''query getRoomTypes {
  vRoomTypes(where: {isActive: {_eq: true}}) {
    Id
    code
    LocationId
    description
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
}
''';

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
