// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'liar_goal.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetLiarGoalCollection on Isar {
  IsarCollection<LiarGoal> get liarGoals => this.collection();
}

const LiarGoalSchema = CollectionSchema(
  name: r'LiarGoal',
  id: -1865009048144744168,
  properties: {
    r'accountabilityContact': PropertySchema(
      id: 0,
      name: r'accountabilityContact',
      type: IsarType.string,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'lagHistory': PropertySchema(
      id: 2,
      name: r'lagHistory',
      type: IsarType.doubleList,
    ),
    r'lagMetricLabel': PropertySchema(
      id: 3,
      name: r'lagMetricLabel',
      type: IsarType.string,
    ),
    r'lagUnit': PropertySchema(
      id: 4,
      name: r'lagUnit',
      type: IsarType.string,
    ),
    r'leadHistory': PropertySchema(
      id: 5,
      name: r'leadHistory',
      type: IsarType.doubleList,
    ),
    r'leadMetricLabel': PropertySchema(
      id: 6,
      name: r'leadMetricLabel',
      type: IsarType.string,
    ),
    r'leadUnit': PropertySchema(
      id: 7,
      name: r'leadUnit',
      type: IsarType.string,
    ),
    r'liarsChartActive': PropertySchema(
      id: 8,
      name: r'liarsChartActive',
      type: IsarType.bool,
    ),
    r'title': PropertySchema(
      id: 9,
      name: r'title',
      type: IsarType.string,
    )
  },
  estimateSize: _liarGoalEstimateSize,
  serialize: _liarGoalSerialize,
  deserialize: _liarGoalDeserialize,
  deserializeProp: _liarGoalDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _liarGoalGetId,
  getLinks: _liarGoalGetLinks,
  attach: _liarGoalAttach,
  version: '3.1.0+1',
);

int _liarGoalEstimateSize(
  LiarGoal object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.accountabilityContact.length * 3;
  bytesCount += 3 + object.lagHistory.length * 8;
  bytesCount += 3 + object.lagMetricLabel.length * 3;
  bytesCount += 3 + object.lagUnit.length * 3;
  bytesCount += 3 + object.leadHistory.length * 8;
  bytesCount += 3 + object.leadMetricLabel.length * 3;
  bytesCount += 3 + object.leadUnit.length * 3;
  bytesCount += 3 + object.title.length * 3;
  return bytesCount;
}

void _liarGoalSerialize(
  LiarGoal object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.accountabilityContact);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeDoubleList(offsets[2], object.lagHistory);
  writer.writeString(offsets[3], object.lagMetricLabel);
  writer.writeString(offsets[4], object.lagUnit);
  writer.writeDoubleList(offsets[5], object.leadHistory);
  writer.writeString(offsets[6], object.leadMetricLabel);
  writer.writeString(offsets[7], object.leadUnit);
  writer.writeBool(offsets[8], object.liarsChartActive);
  writer.writeString(offsets[9], object.title);
}

LiarGoal _liarGoalDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = LiarGoal();
  object.accountabilityContact = reader.readString(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.lagHistory = reader.readDoubleList(offsets[2]) ?? [];
  object.lagMetricLabel = reader.readString(offsets[3]);
  object.lagUnit = reader.readString(offsets[4]);
  object.leadHistory = reader.readDoubleList(offsets[5]) ?? [];
  object.leadMetricLabel = reader.readString(offsets[6]);
  object.leadUnit = reader.readString(offsets[7]);
  object.liarsChartActive = reader.readBool(offsets[8]);
  object.title = reader.readString(offsets[9]);
  return object;
}

P _liarGoalDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDoubleList(offset) ?? []) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDoubleList(offset) ?? []) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _liarGoalGetId(LiarGoal object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _liarGoalGetLinks(LiarGoal object) {
  return [];
}

void _liarGoalAttach(IsarCollection<dynamic> col, Id id, LiarGoal object) {
  object.id = id;
}

extension LiarGoalQueryWhereSort on QueryBuilder<LiarGoal, LiarGoal, QWhere> {
  QueryBuilder<LiarGoal, LiarGoal, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension LiarGoalQueryWhere on QueryBuilder<LiarGoal, LiarGoal, QWhereClause> {
  QueryBuilder<LiarGoal, LiarGoal, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<LiarGoal, LiarGoal, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterWhereClause> idBetween(
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

extension LiarGoalQueryFilter
    on QueryBuilder<LiarGoal, LiarGoal, QFilterCondition> {
  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      accountabilityContactEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accountabilityContact',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      accountabilityContactGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'accountabilityContact',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      accountabilityContactLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'accountabilityContact',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      accountabilityContactBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'accountabilityContact',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      accountabilityContactStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'accountabilityContact',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      accountabilityContactEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'accountabilityContact',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      accountabilityContactContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'accountabilityContact',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      accountabilityContactMatches(String pattern,
          {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'accountabilityContact',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      accountabilityContactIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'accountabilityContact',
        value: '',
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      accountabilityContactIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'accountabilityContact',
        value: '',
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> createdAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> createdAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> createdAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'createdAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> idBetween(
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

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      lagHistoryElementEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lagHistory',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      lagHistoryElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lagHistory',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      lagHistoryElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lagHistory',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      lagHistoryElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lagHistory',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      lagHistoryLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lagHistory',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> lagHistoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lagHistory',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      lagHistoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lagHistory',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      lagHistoryLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lagHistory',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      lagHistoryLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lagHistory',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      lagHistoryLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'lagHistory',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> lagMetricLabelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lagMetricLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      lagMetricLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lagMetricLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      lagMetricLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lagMetricLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> lagMetricLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lagMetricLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      lagMetricLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lagMetricLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      lagMetricLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lagMetricLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      lagMetricLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lagMetricLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> lagMetricLabelMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lagMetricLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      lagMetricLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lagMetricLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      lagMetricLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lagMetricLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> lagUnitEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lagUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> lagUnitGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lagUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> lagUnitLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lagUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> lagUnitBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lagUnit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> lagUnitStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'lagUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> lagUnitEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'lagUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> lagUnitContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'lagUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> lagUnitMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'lagUnit',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> lagUnitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lagUnit',
        value: '',
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> lagUnitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'lagUnit',
        value: '',
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      leadHistoryElementEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'leadHistory',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      leadHistoryElementGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'leadHistory',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      leadHistoryElementLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'leadHistory',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      leadHistoryElementBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'leadHistory',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      leadHistoryLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'leadHistory',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> leadHistoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'leadHistory',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      leadHistoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'leadHistory',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      leadHistoryLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'leadHistory',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      leadHistoryLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'leadHistory',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      leadHistoryLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'leadHistory',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      leadMetricLabelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'leadMetricLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      leadMetricLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'leadMetricLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      leadMetricLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'leadMetricLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      leadMetricLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'leadMetricLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      leadMetricLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'leadMetricLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      leadMetricLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'leadMetricLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      leadMetricLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'leadMetricLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      leadMetricLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'leadMetricLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      leadMetricLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'leadMetricLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      leadMetricLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'leadMetricLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> leadUnitEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'leadUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> leadUnitGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'leadUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> leadUnitLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'leadUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> leadUnitBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'leadUnit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> leadUnitStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'leadUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> leadUnitEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'leadUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> leadUnitContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'leadUnit',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> leadUnitMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'leadUnit',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> leadUnitIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'leadUnit',
        value: '',
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> leadUnitIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'leadUnit',
        value: '',
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition>
      liarsChartActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'liarsChartActive',
        value: value,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> titleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> titleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> titleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> titleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> titleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> titleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> titleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> titleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterFilterCondition> titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }
}

extension LiarGoalQueryObject
    on QueryBuilder<LiarGoal, LiarGoal, QFilterCondition> {}

extension LiarGoalQueryLinks
    on QueryBuilder<LiarGoal, LiarGoal, QFilterCondition> {}

extension LiarGoalQuerySortBy on QueryBuilder<LiarGoal, LiarGoal, QSortBy> {
  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> sortByAccountabilityContact() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountabilityContact', Sort.asc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy>
      sortByAccountabilityContactDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountabilityContact', Sort.desc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> sortByLagMetricLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lagMetricLabel', Sort.asc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> sortByLagMetricLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lagMetricLabel', Sort.desc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> sortByLagUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lagUnit', Sort.asc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> sortByLagUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lagUnit', Sort.desc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> sortByLeadMetricLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leadMetricLabel', Sort.asc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> sortByLeadMetricLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leadMetricLabel', Sort.desc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> sortByLeadUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leadUnit', Sort.asc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> sortByLeadUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leadUnit', Sort.desc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> sortByLiarsChartActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'liarsChartActive', Sort.asc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> sortByLiarsChartActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'liarsChartActive', Sort.desc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension LiarGoalQuerySortThenBy
    on QueryBuilder<LiarGoal, LiarGoal, QSortThenBy> {
  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> thenByAccountabilityContact() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountabilityContact', Sort.asc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy>
      thenByAccountabilityContactDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'accountabilityContact', Sort.desc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> thenByLagMetricLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lagMetricLabel', Sort.asc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> thenByLagMetricLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lagMetricLabel', Sort.desc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> thenByLagUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lagUnit', Sort.asc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> thenByLagUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lagUnit', Sort.desc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> thenByLeadMetricLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leadMetricLabel', Sort.asc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> thenByLeadMetricLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leadMetricLabel', Sort.desc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> thenByLeadUnit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leadUnit', Sort.asc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> thenByLeadUnitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'leadUnit', Sort.desc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> thenByLiarsChartActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'liarsChartActive', Sort.asc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> thenByLiarsChartActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'liarsChartActive', Sort.desc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }
}

extension LiarGoalQueryWhereDistinct
    on QueryBuilder<LiarGoal, LiarGoal, QDistinct> {
  QueryBuilder<LiarGoal, LiarGoal, QDistinct> distinctByAccountabilityContact(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'accountabilityContact',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QDistinct> distinctByLagHistory() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lagHistory');
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QDistinct> distinctByLagMetricLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lagMetricLabel',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QDistinct> distinctByLagUnit(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lagUnit', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QDistinct> distinctByLeadHistory() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'leadHistory');
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QDistinct> distinctByLeadMetricLabel(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'leadMetricLabel',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QDistinct> distinctByLeadUnit(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'leadUnit', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QDistinct> distinctByLiarsChartActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'liarsChartActive');
    });
  }

  QueryBuilder<LiarGoal, LiarGoal, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }
}

extension LiarGoalQueryProperty
    on QueryBuilder<LiarGoal, LiarGoal, QQueryProperty> {
  QueryBuilder<LiarGoal, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<LiarGoal, String, QQueryOperations>
      accountabilityContactProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'accountabilityContact');
    });
  }

  QueryBuilder<LiarGoal, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<LiarGoal, List<double>, QQueryOperations> lagHistoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lagHistory');
    });
  }

  QueryBuilder<LiarGoal, String, QQueryOperations> lagMetricLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lagMetricLabel');
    });
  }

  QueryBuilder<LiarGoal, String, QQueryOperations> lagUnitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lagUnit');
    });
  }

  QueryBuilder<LiarGoal, List<double>, QQueryOperations> leadHistoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'leadHistory');
    });
  }

  QueryBuilder<LiarGoal, String, QQueryOperations> leadMetricLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'leadMetricLabel');
    });
  }

  QueryBuilder<LiarGoal, String, QQueryOperations> leadUnitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'leadUnit');
    });
  }

  QueryBuilder<LiarGoal, bool, QQueryOperations> liarsChartActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'liarsChartActive');
    });
  }

  QueryBuilder<LiarGoal, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }
}
