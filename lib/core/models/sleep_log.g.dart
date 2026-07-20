// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sleep_log.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetSleepLogCollection on Isar {
  IsarCollection<SleepLog> get sleepLogs => this.collection();
}

const SleepLogSchema = CollectionSchema(
  name: r'SleepLog',
  id: 7895731279694127521,
  properties: {
    r'bedTime': PropertySchema(
      id: 0,
      name: r'bedTime',
      type: IsarType.string,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'hoursSlept': PropertySchema(
      id: 2,
      name: r'hoursSlept',
      type: IsarType.double,
    ),
    r'notes': PropertySchema(
      id: 3,
      name: r'notes',
      type: IsarType.string,
    ),
    r'qualityRating': PropertySchema(
      id: 4,
      name: r'qualityRating',
      type: IsarType.long,
    ),
    r'wakeTime': PropertySchema(
      id: 5,
      name: r'wakeTime',
      type: IsarType.string,
    )
  },
  estimateSize: _sleepLogEstimateSize,
  serialize: _sleepLogSerialize,
  deserialize: _sleepLogDeserialize,
  deserializeProp: _sleepLogDeserializeProp,
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
  getId: _sleepLogGetId,
  getLinks: _sleepLogGetLinks,
  attach: _sleepLogAttach,
  version: '3.1.0+1',
);

int _sleepLogEstimateSize(
  SleepLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.bedTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.notes;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.wakeTime;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _sleepLogSerialize(
  SleepLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.bedTime);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeDouble(offsets[2], object.hoursSlept);
  writer.writeString(offsets[3], object.notes);
  writer.writeLong(offsets[4], object.qualityRating);
  writer.writeString(offsets[5], object.wakeTime);
}

SleepLog _sleepLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = SleepLog(
    bedTime: reader.readStringOrNull(offsets[0]),
    date: reader.readDateTime(offsets[1]),
    hoursSlept: reader.readDoubleOrNull(offsets[2]) ?? 7.0,
    notes: reader.readStringOrNull(offsets[3]),
    qualityRating: reader.readLongOrNull(offsets[4]) ?? 3,
    wakeTime: reader.readStringOrNull(offsets[5]),
  );
  object.id = id;
  return object;
}

P _sleepLogDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset) ?? 7.0) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readLongOrNull(offset) ?? 3) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _sleepLogGetId(SleepLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _sleepLogGetLinks(SleepLog object) {
  return [];
}

void _sleepLogAttach(IsarCollection<dynamic> col, Id id, SleepLog object) {
  object.id = id;
}

extension SleepLogByIndex on IsarCollection<SleepLog> {
  Future<SleepLog?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  SleepLog? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<SleepLog?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<SleepLog?> getAllByDateSync(List<DateTime> dateValues) {
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

  Future<Id> putByDate(SleepLog object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(SleepLog object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<SleepLog> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(List<SleepLog> objects, {bool saveLinks = true}) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension SleepLogQueryWhereSort on QueryBuilder<SleepLog, SleepLog, QWhere> {
  QueryBuilder<SleepLog, SleepLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension SleepLogQueryWhere on QueryBuilder<SleepLog, SleepLog, QWhereClause> {
  QueryBuilder<SleepLog, SleepLog, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<SleepLog, SleepLog, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterWhereClause> idBetween(
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

  QueryBuilder<SleepLog, SleepLog, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterWhereClause> dateNotEqualTo(
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

  QueryBuilder<SleepLog, SleepLog, QAfterWhereClause> dateGreaterThan(
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

  QueryBuilder<SleepLog, SleepLog, QAfterWhereClause> dateLessThan(
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

  QueryBuilder<SleepLog, SleepLog, QAfterWhereClause> dateBetween(
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

extension SleepLogQueryFilter
    on QueryBuilder<SleepLog, SleepLog, QFilterCondition> {
  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> bedTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'bedTime',
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> bedTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'bedTime',
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> bedTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bedTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> bedTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bedTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> bedTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bedTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> bedTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bedTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> bedTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'bedTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> bedTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'bedTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> bedTimeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'bedTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> bedTimeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'bedTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> bedTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bedTime',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> bedTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'bedTime',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> dateGreaterThan(
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

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> dateLessThan(
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

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> dateBetween(
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

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> hoursSleptEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hoursSlept',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> hoursSleptGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hoursSlept',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> hoursSleptLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hoursSlept',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> hoursSleptBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hoursSlept',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> idBetween(
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

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'notes',
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'notes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> qualityRatingEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qualityRating',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition>
      qualityRatingGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'qualityRating',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> qualityRatingLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'qualityRating',
        value: value,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> qualityRatingBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'qualityRating',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> wakeTimeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'wakeTime',
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> wakeTimeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'wakeTime',
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> wakeTimeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wakeTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> wakeTimeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wakeTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> wakeTimeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wakeTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> wakeTimeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wakeTime',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> wakeTimeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'wakeTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> wakeTimeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'wakeTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> wakeTimeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'wakeTime',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> wakeTimeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'wakeTime',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> wakeTimeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wakeTime',
        value: '',
      ));
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterFilterCondition> wakeTimeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'wakeTime',
        value: '',
      ));
    });
  }
}

extension SleepLogQueryObject
    on QueryBuilder<SleepLog, SleepLog, QFilterCondition> {}

extension SleepLogQueryLinks
    on QueryBuilder<SleepLog, SleepLog, QFilterCondition> {}

extension SleepLogQuerySortBy on QueryBuilder<SleepLog, SleepLog, QSortBy> {
  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByBedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedTime', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByBedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedTime', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByHoursSlept() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursSlept', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByHoursSleptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursSlept', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByQualityRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qualityRating', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByQualityRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qualityRating', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByWakeTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTime', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> sortByWakeTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTime', Sort.desc);
    });
  }
}

extension SleepLogQuerySortThenBy
    on QueryBuilder<SleepLog, SleepLog, QSortThenBy> {
  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByBedTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedTime', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByBedTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bedTime', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByHoursSlept() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursSlept', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByHoursSleptDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hoursSlept', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByQualityRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qualityRating', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByQualityRatingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qualityRating', Sort.desc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByWakeTime() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTime', Sort.asc);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QAfterSortBy> thenByWakeTimeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wakeTime', Sort.desc);
    });
  }
}

extension SleepLogQueryWhereDistinct
    on QueryBuilder<SleepLog, SleepLog, QDistinct> {
  QueryBuilder<SleepLog, SleepLog, QDistinct> distinctByBedTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bedTime', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<SleepLog, SleepLog, QDistinct> distinctByHoursSlept() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hoursSlept');
    });
  }

  QueryBuilder<SleepLog, SleepLog, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<SleepLog, SleepLog, QDistinct> distinctByQualityRating() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qualityRating');
    });
  }

  QueryBuilder<SleepLog, SleepLog, QDistinct> distinctByWakeTime(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wakeTime', caseSensitive: caseSensitive);
    });
  }
}

extension SleepLogQueryProperty
    on QueryBuilder<SleepLog, SleepLog, QQueryProperty> {
  QueryBuilder<SleepLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<SleepLog, String?, QQueryOperations> bedTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bedTime');
    });
  }

  QueryBuilder<SleepLog, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<SleepLog, double, QQueryOperations> hoursSleptProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hoursSlept');
    });
  }

  QueryBuilder<SleepLog, String?, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<SleepLog, int, QQueryOperations> qualityRatingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qualityRating');
    });
  }

  QueryBuilder<SleepLog, String?, QQueryOperations> wakeTimeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wakeTime');
    });
  }
}
