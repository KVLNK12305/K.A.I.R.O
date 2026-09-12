// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_plan.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyPlanCollection on Isar {
  IsarCollection<DailyPlan> get dailyPlans => this.collection();
}

const DailyPlanSchema = CollectionSchema(
  name: r'DailyPlan',
  id: 9074873586170206523,
  properties: {
    r'date': PropertySchema(
      id: 0,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'nonNegotiableNote': PropertySchema(
      id: 1,
      name: r'nonNegotiableNote',
      type: IsarType.string,
    ),
    r'peak1Completed': PropertySchema(
      id: 2,
      name: r'peak1Completed',
      type: IsarType.bool,
    ),
    r'peak1DurationMinutes': PropertySchema(
      id: 3,
      name: r'peak1DurationMinutes',
      type: IsarType.long,
    ),
    r'peak1Outcome': PropertySchema(
      id: 4,
      name: r'peak1Outcome',
      type: IsarType.string,
    ),
    r'peak1Title': PropertySchema(
      id: 5,
      name: r'peak1Title',
      type: IsarType.string,
    ),
    r'peak2Completed': PropertySchema(
      id: 6,
      name: r'peak2Completed',
      type: IsarType.bool,
    ),
    r'peak2DurationMinutes': PropertySchema(
      id: 7,
      name: r'peak2DurationMinutes',
      type: IsarType.long,
    ),
    r'peak2Outcome': PropertySchema(
      id: 8,
      name: r'peak2Outcome',
      type: IsarType.string,
    ),
    r'peak2Title': PropertySchema(
      id: 9,
      name: r'peak2Title',
      type: IsarType.string,
    ),
    r'plannedAt': PropertySchema(
      id: 10,
      name: r'plannedAt',
      type: IsarType.dateTime,
    ),
    r'reviewedAt': PropertySchema(
      id: 11,
      name: r'reviewedAt',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _dailyPlanEstimateSize,
  serialize: _dailyPlanSerialize,
  deserialize: _dailyPlanDeserialize,
  deserializeProp: _dailyPlanDeserializeProp,
  idName: r'id',
  indexes: {
    r'date': IndexSchema(
      id: -7552997827385218417,
      name: r'date',
      unique: true,
      replace: true,
      properties: [
        IndexPropertySchema(
          name: r'date',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _dailyPlanGetId,
  getLinks: _dailyPlanGetLinks,
  attach: _dailyPlanAttach,
  version: '3.1.0+1',
);

int _dailyPlanEstimateSize(
  DailyPlan object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.nonNegotiableNote;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.peak1Outcome.length * 3;
  bytesCount += 3 + object.peak1Title.length * 3;
  bytesCount += 3 + object.peak2Outcome.length * 3;
  bytesCount += 3 + object.peak2Title.length * 3;
  return bytesCount;
}

void _dailyPlanSerialize(
  DailyPlan object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.date);
  writer.writeString(offsets[1], object.nonNegotiableNote);
  writer.writeBool(offsets[2], object.peak1Completed);
  writer.writeLong(offsets[3], object.peak1DurationMinutes);
  writer.writeString(offsets[4], object.peak1Outcome);
  writer.writeString(offsets[5], object.peak1Title);
  writer.writeBool(offsets[6], object.peak2Completed);
  writer.writeLong(offsets[7], object.peak2DurationMinutes);
  writer.writeString(offsets[8], object.peak2Outcome);
  writer.writeString(offsets[9], object.peak2Title);
  writer.writeDateTime(offsets[10], object.plannedAt);
  writer.writeDateTime(offsets[11], object.reviewedAt);
}

DailyPlan _dailyPlanDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyPlan();
  object.date = reader.readDateTime(offsets[0]);
  object.id = id;
  object.nonNegotiableNote = reader.readStringOrNull(offsets[1]);
  object.peak1Completed = reader.readBool(offsets[2]);
  object.peak1DurationMinutes = reader.readLong(offsets[3]);
  object.peak1Outcome = reader.readString(offsets[4]);
  object.peak1Title = reader.readString(offsets[5]);
  object.peak2Completed = reader.readBool(offsets[6]);
  object.peak2DurationMinutes = reader.readLong(offsets[7]);
  object.peak2Outcome = reader.readString(offsets[8]);
  object.peak2Title = reader.readString(offsets[9]);
  object.plannedAt = reader.readDateTime(offsets[10]);
  object.reviewedAt = reader.readDateTimeOrNull(offsets[11]);
  return object;
}

P _dailyPlanDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readBool(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readDateTime(offset)) as P;
    case 11:
      return (reader.readDateTimeOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyPlanGetId(DailyPlan object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyPlanGetLinks(DailyPlan object) {
  return [];
}

void _dailyPlanAttach(IsarCollection<dynamic> col, Id id, DailyPlan object) {
  object.id = id;
}

extension DailyPlanByIndex on IsarCollection<DailyPlan> {
  Future<DailyPlan?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  DailyPlan? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<DailyPlan?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<DailyPlan?> getAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'date', values);
  }

  Future<int> deleteAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'date', values);
  }

  int deleteAllByDateSync(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'date', values);
  }

  Future<Id> putByDate(DailyPlan object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(DailyPlan object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<DailyPlan> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(List<DailyPlan> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension DailyPlanQueryWhereSort
    on QueryBuilder<DailyPlan, DailyPlan, QWhere> {
  QueryBuilder<DailyPlan, DailyPlan, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension DailyPlanQueryWhere
    on QueryBuilder<DailyPlan, DailyPlan, QWhereClause> {
  QueryBuilder<DailyPlan, DailyPlan, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<DailyPlan, DailyPlan, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterWhereClause> idBetween(
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

  QueryBuilder<DailyPlan, DailyPlan, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterWhereClause> dateNotEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [date],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'date',
              lower: [],
              upper: [date],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterWhereClause> dateGreaterThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [date],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterWhereClause> dateLessThan(
    DateTime date, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [],
        upper: [date],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterWhereClause> dateBetween(
    DateTime lowerDate,
    DateTime upperDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'date',
        lower: [lowerDate],
        includeLower: includeLower,
        upper: [upperDate],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyPlanQueryFilter
    on QueryBuilder<DailyPlan, DailyPlan, QFilterCondition> {
  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> dateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> dateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> dateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      nonNegotiableNoteIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nonNegotiableNote',
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      nonNegotiableNoteIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nonNegotiableNote',
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      nonNegotiableNoteEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nonNegotiableNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      nonNegotiableNoteGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nonNegotiableNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      nonNegotiableNoteLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nonNegotiableNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      nonNegotiableNoteBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nonNegotiableNote',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      nonNegotiableNoteStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'nonNegotiableNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      nonNegotiableNoteEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'nonNegotiableNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      nonNegotiableNoteContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'nonNegotiableNote',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      nonNegotiableNoteMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'nonNegotiableNote',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      nonNegotiableNoteIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nonNegotiableNote',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      nonNegotiableNoteIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'nonNegotiableNote',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak1CompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peak1Completed',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak1DurationMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peak1DurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak1DurationMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'peak1DurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak1DurationMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'peak1DurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak1DurationMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'peak1DurationMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> peak1OutcomeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peak1Outcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak1OutcomeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'peak1Outcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak1OutcomeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'peak1Outcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> peak1OutcomeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'peak1Outcome',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak1OutcomeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'peak1Outcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak1OutcomeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'peak1Outcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak1OutcomeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'peak1Outcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> peak1OutcomeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'peak1Outcome',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak1OutcomeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peak1Outcome',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak1OutcomeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'peak1Outcome',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> peak1TitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peak1Title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak1TitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'peak1Title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> peak1TitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'peak1Title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> peak1TitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'peak1Title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak1TitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'peak1Title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> peak1TitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'peak1Title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> peak1TitleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'peak1Title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> peak1TitleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'peak1Title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak1TitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peak1Title',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak1TitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'peak1Title',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak2CompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peak2Completed',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak2DurationMinutesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peak2DurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak2DurationMinutesGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'peak2DurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak2DurationMinutesLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'peak2DurationMinutes',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak2DurationMinutesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'peak2DurationMinutes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> peak2OutcomeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peak2Outcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak2OutcomeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'peak2Outcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak2OutcomeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'peak2Outcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> peak2OutcomeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'peak2Outcome',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak2OutcomeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'peak2Outcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak2OutcomeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'peak2Outcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak2OutcomeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'peak2Outcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> peak2OutcomeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'peak2Outcome',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak2OutcomeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peak2Outcome',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak2OutcomeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'peak2Outcome',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> peak2TitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peak2Title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak2TitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'peak2Title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> peak2TitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'peak2Title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> peak2TitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'peak2Title',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak2TitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'peak2Title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> peak2TitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'peak2Title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> peak2TitleContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'peak2Title',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> peak2TitleMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'peak2Title',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak2TitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'peak2Title',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      peak2TitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'peak2Title',
        value: '',
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> plannedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plannedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      plannedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'plannedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> plannedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'plannedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> plannedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'plannedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> reviewedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'reviewedAt',
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      reviewedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'reviewedAt',
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> reviewedAtEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reviewedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition>
      reviewedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reviewedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> reviewedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reviewedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterFilterCondition> reviewedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reviewedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyPlanQueryObject
    on QueryBuilder<DailyPlan, DailyPlan, QFilterCondition> {}

extension DailyPlanQueryLinks
    on QueryBuilder<DailyPlan, DailyPlan, QFilterCondition> {}

extension DailyPlanQuerySortBy on QueryBuilder<DailyPlan, DailyPlan, QSortBy> {
  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> sortByNonNegotiableNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nonNegotiableNote', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy>
      sortByNonNegotiableNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nonNegotiableNote', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> sortByPeak1Completed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak1Completed', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> sortByPeak1CompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak1Completed', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy>
      sortByPeak1DurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak1DurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy>
      sortByPeak1DurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak1DurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> sortByPeak1Outcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak1Outcome', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> sortByPeak1OutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak1Outcome', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> sortByPeak1Title() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak1Title', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> sortByPeak1TitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak1Title', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> sortByPeak2Completed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak2Completed', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> sortByPeak2CompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak2Completed', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy>
      sortByPeak2DurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak2DurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy>
      sortByPeak2DurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak2DurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> sortByPeak2Outcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak2Outcome', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> sortByPeak2OutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak2Outcome', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> sortByPeak2Title() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak2Title', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> sortByPeak2TitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak2Title', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> sortByPlannedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedAt', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> sortByPlannedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedAt', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> sortByReviewedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewedAt', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> sortByReviewedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewedAt', Sort.desc);
    });
  }
}

extension DailyPlanQuerySortThenBy
    on QueryBuilder<DailyPlan, DailyPlan, QSortThenBy> {
  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenByNonNegotiableNote() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nonNegotiableNote', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy>
      thenByNonNegotiableNoteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nonNegotiableNote', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenByPeak1Completed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak1Completed', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenByPeak1CompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak1Completed', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy>
      thenByPeak1DurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak1DurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy>
      thenByPeak1DurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak1DurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenByPeak1Outcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak1Outcome', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenByPeak1OutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak1Outcome', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenByPeak1Title() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak1Title', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenByPeak1TitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak1Title', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenByPeak2Completed() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak2Completed', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenByPeak2CompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak2Completed', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy>
      thenByPeak2DurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak2DurationMinutes', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy>
      thenByPeak2DurationMinutesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak2DurationMinutes', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenByPeak2Outcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak2Outcome', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenByPeak2OutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak2Outcome', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenByPeak2Title() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak2Title', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenByPeak2TitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'peak2Title', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenByPlannedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedAt', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenByPlannedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedAt', Sort.desc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenByReviewedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewedAt', Sort.asc);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QAfterSortBy> thenByReviewedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewedAt', Sort.desc);
    });
  }
}

extension DailyPlanQueryWhereDistinct
    on QueryBuilder<DailyPlan, DailyPlan, QDistinct> {
  QueryBuilder<DailyPlan, DailyPlan, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QDistinct> distinctByNonNegotiableNote(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nonNegotiableNote',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QDistinct> distinctByPeak1Completed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'peak1Completed');
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QDistinct>
      distinctByPeak1DurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'peak1DurationMinutes');
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QDistinct> distinctByPeak1Outcome(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'peak1Outcome', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QDistinct> distinctByPeak1Title(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'peak1Title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QDistinct> distinctByPeak2Completed() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'peak2Completed');
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QDistinct>
      distinctByPeak2DurationMinutes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'peak2DurationMinutes');
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QDistinct> distinctByPeak2Outcome(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'peak2Outcome', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QDistinct> distinctByPeak2Title(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'peak2Title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QDistinct> distinctByPlannedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plannedAt');
    });
  }

  QueryBuilder<DailyPlan, DailyPlan, QDistinct> distinctByReviewedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reviewedAt');
    });
  }
}

extension DailyPlanQueryProperty
    on QueryBuilder<DailyPlan, DailyPlan, QQueryProperty> {
  QueryBuilder<DailyPlan, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyPlan, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DailyPlan, String?, QQueryOperations>
      nonNegotiableNoteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nonNegotiableNote');
    });
  }

  QueryBuilder<DailyPlan, bool, QQueryOperations> peak1CompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'peak1Completed');
    });
  }

  QueryBuilder<DailyPlan, int, QQueryOperations>
      peak1DurationMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'peak1DurationMinutes');
    });
  }

  QueryBuilder<DailyPlan, String, QQueryOperations> peak1OutcomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'peak1Outcome');
    });
  }

  QueryBuilder<DailyPlan, String, QQueryOperations> peak1TitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'peak1Title');
    });
  }

  QueryBuilder<DailyPlan, bool, QQueryOperations> peak2CompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'peak2Completed');
    });
  }

  QueryBuilder<DailyPlan, int, QQueryOperations>
      peak2DurationMinutesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'peak2DurationMinutes');
    });
  }

  QueryBuilder<DailyPlan, String, QQueryOperations> peak2OutcomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'peak2Outcome');
    });
  }

  QueryBuilder<DailyPlan, String, QQueryOperations> peak2TitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'peak2Title');
    });
  }

  QueryBuilder<DailyPlan, DateTime, QQueryOperations> plannedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plannedAt');
    });
  }

  QueryBuilder<DailyPlan, DateTime?, QQueryOperations> reviewedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reviewedAt');
    });
  }
}
