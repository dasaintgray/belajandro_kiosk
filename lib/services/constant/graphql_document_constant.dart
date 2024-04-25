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
