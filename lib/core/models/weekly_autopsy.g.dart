// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_autopsy.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWeeklyAutopsyCollection on Isar {
  IsarCollection<WeeklyAutopsy> get weeklyAutopsys => this.collection();
}

const WeeklyAutopsySchema = CollectionSchema(
  name: r'WeeklyAutopsy',
  id: -3043607008082093630,
  properties: {
    r'aiRequiredPivot': PropertySchema(
      id: 0,
      name: r'aiRequiredPivot',
      type: IsarType.string,
    ),
    r'aiRootCause': PropertySchema(
      id: 1,
      name: r'aiRootCause',
      type: IsarType.string,
    ),
    r'aiVerdict': PropertySchema(
      id: 2,
      name: r'aiVerdict',
      type: IsarType.string,
    ),
    r'averageStressScore': PropertySchema(
      id: 3,
      name: r'averageStressScore',
      type: IsarType.double,
    ),
    r'createdAt': PropertySchema(
      id: 4,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'financeBurnRate': PropertySchema(
      id: 5,
      name: r'financeBurnRate',
      type: IsarType.double,
    ),
    r'githubPrCount': PropertySchema(
      id: 6,
      name: r'githubPrCount',
      type: IsarType.long,
    ),
    r'peakExecutionRate': PropertySchema(
      id: 7,
      name: r'peakExecutionRate',
      type: IsarType.double,
    ),
    r'powerScore': PropertySchema(
      id: 8,
      name: r'powerScore',
      type: IsarType.double,
    ),
    r'wakatimeTotalHours': PropertySchema(
      id: 9,
      name: r'wakatimeTotalHours',
      type: IsarType.double,
    ),
    r'weekEndDate': PropertySchema(
      id: 10,
      name: r'weekEndDate',
      type: IsarType.dateTime,
    ),
    r'weekStartDate': PropertySchema(
      id: 11,
      name: r'weekStartDate',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _weeklyAutopsyEstimateSize,
  serialize: _weeklyAutopsySerialize,
  deserialize: _weeklyAutopsyDeserialize,
  deserializeProp: _weeklyAutopsyDeserializeProp,
  idName: r'id',
  indexes: {
    r'weekStartDate': IndexSchema(
      id: 7906057668223877157,
      name: r'weekStartDate',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'weekStartDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _weeklyAutopsyGetId,
  getLinks: _weeklyAutopsyGetLinks,
  attach: _weeklyAutopsyAttach,
  version: '3.1.0+1',
);

int _weeklyAutopsyEstimateSize(
  WeeklyAutopsy object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.aiRequiredPivot.length * 3;
  bytesCount += 3 + object.aiRootCause.length * 3;
  bytesCount += 3 + object.aiVerdict.length * 3;
  return bytesCount;
}

void _weeklyAutopsySerialize(
  WeeklyAutopsy object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.aiRequiredPivot);
  writer.writeString(offsets[1], object.aiRootCause);
  writer.writeString(offsets[2], object.aiVerdict);
  writer.writeDouble(offsets[3], object.averageStressScore);
  writer.writeDateTime(offsets[4], object.createdAt);
  writer.writeDouble(offsets[5], object.financeBurnRate);
  writer.writeLong(offsets[6], object.githubPrCount);
  writer.writeDouble(offsets[7], object.peakExecutionRate);
  writer.writeDouble(offsets[8], object.powerScore);
  writer.writeDouble(offsets[9], object.wakatimeTotalHours);
  writer.writeDateTime(offsets[10], object.weekEndDate);
  writer.writeDateTime(offsets[11], object.weekStartDate);
}

WeeklyAutopsy _weeklyAutopsyDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WeeklyAutopsy();
  object.aiRequiredPivot = reader.readString(offsets[0]);
  object.aiRootCause = reader.readString(offsets[1]);
  object.aiVerdict = reader.readString(offsets[2]);
  object.averageStressScore = reader.readDouble(offsets[3]);
  object.createdAt = reader.readDateTime(offsets[4]);
  object.financeBurnRate = reader.readDouble(offsets[5]);
  object.githubPrCount = reader.readLong(offsets[6]);
  object.id = id;
  object.peakExecutionRate = reader.readDouble(offsets[7]);
  object.powerScore = reader.readDouble(offsets[8]);
  object.wakatimeTotalHours = reader.readDouble(offsets[9]);
  object.weekEndDate = reader.readDateTime(offsets[10]);
  object.weekStartDate = reader.readDateTime(offsets[11]);
  return object;
}

P _weeklyAutopsyDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDateTime(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readDouble(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _weeklyAutopsyGetId(WeeklyAutopsy object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _weeklyAutopsyGetLinks(WeeklyAutopsy object) {
  return [];
}

void _weeklyAutopsyAttach(
    IsarCollection<dynamic> col, Id id, WeeklyAutopsy object) {
  object.id = id;
}

extension WeeklyAutopsyByIndex on IsarCollection<WeeklyAutopsy> {
  Future<WeeklyAutopsy?> getByWeekStartDate(DateTime weekStartDate) {
    return getByIndex(r'weekStartDate', [weekStartDate]);
  }

  WeeklyAutopsy? getByWeekStartDateSync(DateTime weekStartDate) {
    return getByIndexSync(r'weekStartDate', [weekStartDate]);
  }

  Future<bool> deleteByWeekStartDate(DateTime weekStartDate) {
    return deleteByIndex(r'weekStartDate', [weekStartDate]);
  }

  bool deleteByWeekStartDateSync(DateTime weekStartDate) {
    return deleteByIndexSync(r'weekStartDate', [weekStartDate]);
  }

  Future<List<WeeklyAutopsy?>> getAllByWeekStartDate(
      List<DateTime> weekStartDateValues) {
    final values = weekStartDateValues.map((e) => [e]).toList();
    return getAllByIndex(r'weekStartDate', values);
  }

  List<WeeklyAutopsy?> getAllByWeekStartDateSync(
      List<DateTime> weekStartDateValues) {
    final values = weekStartDateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'weekStartDate', values);
  }

  Future<int> deleteAllByWeekStartDate(List<DateTime> weekStartDateValues) {
    final values = weekStartDateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'weekStartDate', values);
  }

  int deleteAllByWeekStartDateSync(List<DateTime> weekStartDateValues) {
    final values = weekStartDateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'weekStartDate', values);
  }

  Future<Id> putByWeekStartDate(WeeklyAutopsy object) {
    return putByIndex(r'weekStartDate', object);
  }

  Id putByWeekStartDateSync(WeeklyAutopsy object, {bool saveLinks = true}) {
    return putByIndexSync(r'weekStartDate', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByWeekStartDate(List<WeeklyAutopsy> objects) {
    return putAllByIndex(r'weekStartDate', objects);
  }

  List<Id> putAllByWeekStartDateSync(List<WeeklyAutopsy> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'weekStartDate', objects, saveLinks: saveLinks);
  }
}

extension WeeklyAutopsyQueryWhereSort
    on QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QWhere> {
  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterWhere> anyWeekStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'weekStartDate'),
      );
    });
  }
}

extension WeeklyAutopsyQueryWhere
    on QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QWhereClause> {
  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterWhereClause> idBetween(
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

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterWhereClause>
      weekStartDateEqualTo(DateTime weekStartDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'weekStartDate',
        value: [weekStartDate],
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterWhereClause>
      weekStartDateNotEqualTo(DateTime weekStartDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekStartDate',
              lower: [],
              upper: [weekStartDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekStartDate',
              lower: [weekStartDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekStartDate',
              lower: [weekStartDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'weekStartDate',
              lower: [],
              upper: [weekStartDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterWhereClause>
      weekStartDateGreaterThan(
    DateTime weekStartDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weekStartDate',
        lower: [weekStartDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterWhereClause>
      weekStartDateLessThan(
    DateTime weekStartDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weekStartDate',
        lower: [],
        upper: [weekStartDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterWhereClause>
      weekStartDateBetween(
    DateTime lowerWeekStartDate,
    DateTime upperWeekStartDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'weekStartDate',
        lower: [lowerWeekStartDate],
        includeLower: includeLower,
        upper: [upperWeekStartDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WeeklyAutopsyQueryFilter
    on QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QFilterCondition> {
  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiRequiredPivotEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiRequiredPivot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiRequiredPivotGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aiRequiredPivot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiRequiredPivotLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aiRequiredPivot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiRequiredPivotBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aiRequiredPivot',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiRequiredPivotStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'aiRequiredPivot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiRequiredPivotEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'aiRequiredPivot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiRequiredPivotContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'aiRequiredPivot',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiRequiredPivotMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'aiRequiredPivot',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiRequiredPivotIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiRequiredPivot',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiRequiredPivotIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'aiRequiredPivot',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiRootCauseEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiRootCause',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiRootCauseGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aiRootCause',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiRootCauseLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aiRootCause',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiRootCauseBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aiRootCause',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiRootCauseStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'aiRootCause',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiRootCauseEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'aiRootCause',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiRootCauseContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'aiRootCause',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiRootCauseMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'aiRootCause',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiRootCauseIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiRootCause',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiRootCauseIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'aiRootCause',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiVerdictEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiVerdict',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiVerdictGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'aiVerdict',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiVerdictLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'aiVerdict',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiVerdictBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'aiVerdict',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiVerdictStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'aiVerdict',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiVerdictEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'aiVerdict',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiVerdictContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'aiVerdict',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiVerdictMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'aiVerdict',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiVerdictIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'aiVerdict',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      aiVerdictIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'aiVerdict',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      averageStressScoreEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'averageStressScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      averageStressScoreGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'averageStressScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      averageStressScoreLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'averageStressScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      averageStressScoreBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'averageStressScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      createdAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      createdAtGreaterThan(
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

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      createdAtLessThan(
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

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      createdAtBetween(
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

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      financeBurnRateEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'financeBurnRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      financeBurnRateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'financeBurnRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      financeBurnRateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'financeBurnRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      financeBurnRateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'financeBurnRate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      githubPrCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'githubPrCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      githubPrCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'githubPrCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      githubPrCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'githubPrCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      githubPrCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'githubPrCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
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

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      peakExecutionRateEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peakExecutionRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      peakExecutionRateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'peakExecutionRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      peakExecutionRateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'peakExecutionRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      peakExecutionRateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'peakExecutionRate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      powerScoreEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'powerScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      powerScoreGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'powerScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      powerScoreLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'powerScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      powerScoreBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'powerScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      wakatimeTotalHoursEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wakatimeTotalHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      wakatimeTotalHoursGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wakatimeTotalHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      wakatimeTotalHoursLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wakatimeTotalHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      wakatimeTotalHoursBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wakatimeTotalHours',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      weekEndDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      weekEndDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      weekEndDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekEndDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      weekEndDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekEndDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      weekStartDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'weekStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      weekStartDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'weekStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      weekStartDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'weekStartDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterFilterCondition>
      weekStartDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'weekStartDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WeeklyAutopsyQueryObject
    on QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QFilterCondition> {}

extension WeeklyAutopsyQueryLinks
    on QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QFilterCondition> {}

extension WeeklyAutopsyQuerySortBy
    on QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QSortBy> {
  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      sortByAiRequiredPivot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiRequiredPivot', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      sortByAiRequiredPivotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiRequiredPivot', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy> sortByAiRootCause() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiRootCause', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      sortByAiRootCauseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiRootCause', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy> sortByAiVerdict() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiVerdict', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      sortByAiVerdictDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiVerdict', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      sortByAverageStressScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageStressScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      sortByAverageStressScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageStressScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      sortByFinanceBurnRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'financeBurnRate', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      sortByFinanceBurnRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'financeBurnRate', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      sortByGithubPrCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'githubPrCount', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      sortByGithubPrCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'githubPrCount', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      sortByPeakExecutionRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peakExecutionRate', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      sortByPeakExecutionRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peakExecutionRate', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy> sortByPowerScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'powerScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      sortByPowerScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'powerScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      sortByWakatimeTotalHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakatimeTotalHours', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      sortByWakatimeTotalHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakatimeTotalHours', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy> sortByWeekEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekEndDate', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      sortByWeekEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekEndDate', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      sortByWeekStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStartDate', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      sortByWeekStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStartDate', Sort.desc);
    });
  }
}

extension WeeklyAutopsyQuerySortThenBy
    on QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QSortThenBy> {
  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      thenByAiRequiredPivot() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiRequiredPivot', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      thenByAiRequiredPivotDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiRequiredPivot', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy> thenByAiRootCause() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiRootCause', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      thenByAiRootCauseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiRootCause', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy> thenByAiVerdict() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiVerdict', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      thenByAiVerdictDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'aiVerdict', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      thenByAverageStressScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageStressScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      thenByAverageStressScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'averageStressScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      thenByFinanceBurnRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'financeBurnRate', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      thenByFinanceBurnRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'financeBurnRate', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      thenByGithubPrCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'githubPrCount', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      thenByGithubPrCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'githubPrCount', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      thenByPeakExecutionRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peakExecutionRate', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      thenByPeakExecutionRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peakExecutionRate', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy> thenByPowerScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'powerScore', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      thenByPowerScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'powerScore', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      thenByWakatimeTotalHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakatimeTotalHours', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      thenByWakatimeTotalHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakatimeTotalHours', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy> thenByWeekEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekEndDate', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      thenByWeekEndDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekEndDate', Sort.desc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      thenByWeekStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStartDate', Sort.asc);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QAfterSortBy>
      thenByWeekStartDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'weekStartDate', Sort.desc);
    });
  }
}

extension WeeklyAutopsyQueryWhereDistinct
    on QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QDistinct> {
  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QDistinct>
      distinctByAiRequiredPivot({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aiRequiredPivot',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QDistinct> distinctByAiRootCause(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aiRootCause', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QDistinct> distinctByAiVerdict(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'aiVerdict', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QDistinct>
      distinctByAverageStressScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'averageStressScore');
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QDistinct>
      distinctByFinanceBurnRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'financeBurnRate');
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QDistinct>
      distinctByGithubPrCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'githubPrCount');
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QDistinct>
      distinctByPeakExecutionRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'peakExecutionRate');
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QDistinct> distinctByPowerScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'powerScore');
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QDistinct>
      distinctByWakatimeTotalHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wakatimeTotalHours');
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QDistinct>
      distinctByWeekEndDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekEndDate');
    });
  }

  QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QDistinct>
      distinctByWeekStartDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'weekStartDate');
    });
  }
}

extension WeeklyAutopsyQueryProperty
    on QueryBuilder<WeeklyAutopsy, WeeklyAutopsy, QQueryProperty> {
  QueryBuilder<WeeklyAutopsy, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WeeklyAutopsy, String, QQueryOperations>
      aiRequiredPivotProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aiRequiredPivot');
    });
  }

  QueryBuilder<WeeklyAutopsy, String, QQueryOperations> aiRootCauseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aiRootCause');
    });
  }

  QueryBuilder<WeeklyAutopsy, String, QQueryOperations> aiVerdictProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'aiVerdict');
    });
  }

  QueryBuilder<WeeklyAutopsy, double, QQueryOperations>
      averageStressScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'averageStressScore');
    });
  }

  QueryBuilder<WeeklyAutopsy, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<WeeklyAutopsy, double, QQueryOperations>
      financeBurnRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'financeBurnRate');
    });
  }

  QueryBuilder<WeeklyAutopsy, int, QQueryOperations> githubPrCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'githubPrCount');
    });
  }

  QueryBuilder<WeeklyAutopsy, double, QQueryOperations>
      peakExecutionRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'peakExecutionRate');
    });
  }

  QueryBuilder<WeeklyAutopsy, double, QQueryOperations> powerScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'powerScore');
    });
  }

  QueryBuilder<WeeklyAutopsy, double, QQueryOperations>
      wakatimeTotalHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wakatimeTotalHours');
    });
  }

  QueryBuilder<WeeklyAutopsy, DateTime, QQueryOperations>
      weekEndDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekEndDate');
    });
  }

  QueryBuilder<WeeklyAutopsy, DateTime, QQueryOperations>
      weekStartDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'weekStartDate');
    });
  }
}
