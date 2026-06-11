// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'crucible_state.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCrucibleStateCollection on Isar {
  IsarCollection<CrucibleState> get crucibleStates => this.collection();
}

const CrucibleStateSchema = CollectionSchema(
  name: r'CrucibleState',
  id: -7502763550366164905,
  properties: {
    r'commitment': PropertySchema(
      id: 0,
      name: r'commitment',
      type: IsarType.string,
    ),
    r'hoursRemaining': PropertySchema(
      id: 1,
      name: r'hoursRemaining',
      type: IsarType.long,
    ),
    r'isActive': PropertySchema(
      id: 2,
      name: r'isActive',
      type: IsarType.bool,
    ),
    r'isExpired': PropertySchema(
      id: 3,
      name: r'isExpired',
      type: IsarType.bool,
    ),
    r'proofText': PropertySchema(
      id: 4,
      name: r'proofText',
      type: IsarType.string,
    ),
    r'resolvedAt': PropertySchema(
      id: 5,
      name: r'resolvedAt',
      type: IsarType.dateTime,
    ),
    r'timesTriggered': PropertySchema(
      id: 6,
      name: r'timesTriggered',
      type: IsarType.long,
    ),
    r'triggeredAt': PropertySchema(
      id: 7,
      name: r'triggeredAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _crucibleStateEstimateSize,
  serialize: _crucibleStateSerialize,
  deserialize: _crucibleStateDeserialize,
  deserializeProp: _crucibleStateDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _crucibleStateGetId,
  getLinks: _crucibleStateGetLinks,
  attach: _crucibleStateAttach,
  version: '3.1.0+1',
);

int _crucibleStateEstimateSize(
  CrucibleState object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.commitment.length * 3;
  bytesCount += 3 + object.proofText.length * 3;
  return bytesCount;
}

void _crucibleStateSerialize(
  CrucibleState object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.commitment);
  writer.writeLong(offsets[1], object.hoursRemaining);
  writer.writeBool(offsets[2], object.isActive);
  writer.writeBool(offsets[3], object.isExpired);
  writer.writeString(offsets[4], object.proofText);
  writer.writeDateTime(offsets[5], object.resolvedAt);
  writer.writeLong(offsets[6], object.timesTriggered);
  writer.writeDateTime(offsets[7], object.triggeredAt);
}

CrucibleState _crucibleStateDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = CrucibleState();
  object.commitment = reader.readString(offsets[0]);
  object.id = id;
  object.isActive = reader.readBool(offsets[2]);
  object.proofText = reader.readString(offsets[4]);
  object.resolvedAt = reader.readDateTimeOrNull(offsets[5]);
  object.timesTriggered = reader.readLong(offsets[6]);
  object.triggeredAt = reader.readDateTimeOrNull(offsets[7]);
  return object;
}

P _crucibleStateDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readLong(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _crucibleStateGetId(CrucibleState object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _crucibleStateGetLinks(CrucibleState object) {
  return [];
}

void _crucibleStateAttach(
    IsarCollection<dynamic> col, Id id, CrucibleState object) {
  object.id = id;
}

extension CrucibleStateQueryWhereSort
    on QueryBuilder<CrucibleState, CrucibleState, QWhere> {
  QueryBuilder<CrucibleState, CrucibleState, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CrucibleStateQueryWhere
    on QueryBuilder<CrucibleState, CrucibleState, QWhereClause> {
  QueryBuilder<CrucibleState, CrucibleState, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CrucibleStateQueryFilter
    on QueryBuilder<CrucibleState, CrucibleState, QFilterCondition> {
  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      commitmentEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commitment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      commitmentGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'commitment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      commitmentLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'commitment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      commitmentBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'commitment',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      commitmentStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'commitment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      commitmentEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'commitment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      commitmentContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'commitment',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      commitmentMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'commitment',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      commitmentIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commitment',
        value: '',
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      commitmentIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'commitment',
        value: '',
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      hoursRemainingEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hoursRemaining',
        value: value,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      hoursRemainingGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hoursRemaining',
        value: value,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      hoursRemainingLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hoursRemaining',
        value: value,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      hoursRemainingBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hoursRemaining',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isActive',
        value: value,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      isExpiredEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isExpired',
        value: value,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      proofTextEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proofText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      proofTextGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'proofText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      proofTextLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'proofText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      proofTextBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'proofText',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      proofTextStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'proofText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      proofTextEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'proofText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      proofTextContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'proofText',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      proofTextMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'proofText',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      proofTextIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'proofText',
        value: '',
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      proofTextIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'proofText',
        value: '',
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      resolvedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'resolvedAt',
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      resolvedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'resolvedAt',
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      resolvedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resolvedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      resolvedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resolvedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      resolvedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resolvedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      resolvedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resolvedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      timesTriggeredEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timesTriggered',
        value: value,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      timesTriggeredGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timesTriggered',
        value: value,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      timesTriggeredLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timesTriggered',
        value: value,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      timesTriggeredBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timesTriggered',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      triggeredAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'triggeredAt',
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      triggeredAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'triggeredAt',
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      triggeredAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'triggeredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      triggeredAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'triggeredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      triggeredAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'triggeredAt',
        value: value,
      ));
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterFilterCondition>
      triggeredAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'triggeredAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension CrucibleStateQueryObject
    on QueryBuilder<CrucibleState, CrucibleState, QFilterCondition> {}

extension CrucibleStateQueryLinks
    on QueryBuilder<CrucibleState, CrucibleState, QFilterCondition> {}

extension CrucibleStateQuerySortBy
    on QueryBuilder<CrucibleState, CrucibleState, QSortBy> {
  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy> sortByCommitment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commitment', Sort.asc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy>
      sortByCommitmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commitment', Sort.desc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy>
      sortByHoursRemaining() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursRemaining', Sort.asc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy>
      sortByHoursRemainingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursRemaining', Sort.desc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy>
      sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy> sortByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpired', Sort.asc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy>
      sortByIsExpiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpired', Sort.desc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy> sortByProofText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proofText', Sort.asc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy>
      sortByProofTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proofText', Sort.desc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy> sortByResolvedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolvedAt', Sort.asc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy>
      sortByResolvedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolvedAt', Sort.desc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy>
      sortByTimesTriggered() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timesTriggered', Sort.asc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy>
      sortByTimesTriggeredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timesTriggered', Sort.desc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy> sortByTriggeredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggeredAt', Sort.asc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy>
      sortByTriggeredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggeredAt', Sort.desc);
    });
  }
}

extension CrucibleStateQuerySortThenBy
    on QueryBuilder<CrucibleState, CrucibleState, QSortThenBy> {
  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy> thenByCommitment() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commitment', Sort.asc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy>
      thenByCommitmentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commitment', Sort.desc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy>
      thenByHoursRemaining() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursRemaining', Sort.asc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy>
      thenByHoursRemainingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursRemaining', Sort.desc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy>
      thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy> thenByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpired', Sort.asc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy>
      thenByIsExpiredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isExpired', Sort.desc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy> thenByProofText() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proofText', Sort.asc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy>
      thenByProofTextDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'proofText', Sort.desc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy> thenByResolvedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolvedAt', Sort.asc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy>
      thenByResolvedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolvedAt', Sort.desc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy>
      thenByTimesTriggered() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timesTriggered', Sort.asc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy>
      thenByTimesTriggeredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timesTriggered', Sort.desc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy> thenByTriggeredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggeredAt', Sort.asc);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QAfterSortBy>
      thenByTriggeredAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'triggeredAt', Sort.desc);
    });
  }
}

extension CrucibleStateQueryWhereDistinct
    on QueryBuilder<CrucibleState, CrucibleState, QDistinct> {
  QueryBuilder<CrucibleState, CrucibleState, QDistinct> distinctByCommitment(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'commitment', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QDistinct>
      distinctByHoursRemaining() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hoursRemaining');
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QDistinct> distinctByIsExpired() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isExpired');
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QDistinct> distinctByProofText(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'proofText', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QDistinct> distinctByResolvedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resolvedAt');
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QDistinct>
      distinctByTimesTriggered() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timesTriggered');
    });
  }

  QueryBuilder<CrucibleState, CrucibleState, QDistinct>
      distinctByTriggeredAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'triggeredAt');
    });
  }
}

extension CrucibleStateQueryProperty
    on QueryBuilder<CrucibleState, CrucibleState, QQueryProperty> {
  QueryBuilder<CrucibleState, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<CrucibleState, String, QQueryOperations> commitmentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commitment');
    });
  }

  QueryBuilder<CrucibleState, int, QQueryOperations> hoursRemainingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hoursRemaining');
    });
  }

  QueryBuilder<CrucibleState, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<CrucibleState, bool, QQueryOperations> isExpiredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isExpired');
    });
  }

  QueryBuilder<CrucibleState, String, QQueryOperations> proofTextProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'proofText');
    });
  }

  QueryBuilder<CrucibleState, DateTime?, QQueryOperations>
      resolvedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resolvedAt');
    });
  }

  QueryBuilder<CrucibleState, int, QQueryOperations> timesTriggeredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timesTriggered');
    });
  }

  QueryBuilder<CrucibleState, DateTime?, QQueryOperations>
      triggeredAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'triggeredAt');
    });
  }
}
