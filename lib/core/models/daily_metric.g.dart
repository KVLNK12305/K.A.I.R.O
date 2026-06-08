// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_metric.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDailyMetricCollection on Isar {
  IsarCollection<DailyMetric> get dailyMetrics => this.collection();
}

const DailyMetricSchema = CollectionSchema(
  name: r'DailyMetric',
  id: 1371965153404182599,
  properties: {
    r'commitsMade': PropertySchema(
      id: 0,
      name: r'commitsMade',
      type: IsarType.long,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'expensesLogged': PropertySchema(
      id: 2,
      name: r'expensesLogged',
      type: IsarType.long,
    ),
    r'studyHours': PropertySchema(
      id: 3,
      name: r'studyHours',
      type: IsarType.long,
    )
  },
  estimateSize: _dailyMetricEstimateSize,
  serialize: _dailyMetricSerialize,
  deserialize: _dailyMetricDeserialize,
  deserializeProp: _dailyMetricDeserializeProp,
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
  getId: _dailyMetricGetId,
  getLinks: _dailyMetricGetLinks,
  attach: _dailyMetricAttach,
  version: '3.1.0+1',
);

int _dailyMetricEstimateSize(
  DailyMetric object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  return bytesCount;
}

void _dailyMetricSerialize(
  DailyMetric object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.commitsMade);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeLong(offsets[2], object.expensesLogged);
  writer.writeLong(offsets[3], object.studyHours);
}

DailyMetric _dailyMetricDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DailyMetric(
    commitsMade: reader.readLongOrNull(offsets[0]) ?? 0,
    date: reader.readDateTime(offsets[1]),
    expensesLogged: reader.readLongOrNull(offsets[2]) ?? 0,
    studyHours: reader.readLongOrNull(offsets[3]) ?? 0,
  );
  object.id = id;
  return object;
}

P _dailyMetricDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    case 3:
      return (reader.readLongOrNull(offset) ?? 0) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _dailyMetricGetId(DailyMetric object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _dailyMetricGetLinks(DailyMetric object) {
  return [];
}

void _dailyMetricAttach(
    IsarCollection<dynamic> col, Id id, DailyMetric object) {
  object.id = id;
}

extension DailyMetricByIndex on IsarCollection<DailyMetric> {
  Future<DailyMetric?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  DailyMetric? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<DailyMetric?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<DailyMetric?> getAllByDateSync(List<DateTime> dateValues) {
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

  Future<Id> putByDate(DailyMetric object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(DailyMetric object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<DailyMetric> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(List<DailyMetric> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension DailyMetricQueryWhereSort
    on QueryBuilder<DailyMetric, DailyMetric, QWhere> {
  QueryBuilder<DailyMetric, DailyMetric, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension DailyMetricQueryWhere
    on QueryBuilder<DailyMetric, DailyMetric, QWhereClause> {
  QueryBuilder<DailyMetric, DailyMetric, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<DailyMetric, DailyMetric, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterWhereClause> idBetween(
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

  QueryBuilder<DailyMetric, DailyMetric, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterWhereClause> dateNotEqualTo(
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

  QueryBuilder<DailyMetric, DailyMetric, QAfterWhereClause> dateGreaterThan(
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

  QueryBuilder<DailyMetric, DailyMetric, QAfterWhereClause> dateLessThan(
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

  QueryBuilder<DailyMetric, DailyMetric, QAfterWhereClause> dateBetween(
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

extension DailyMetricQueryFilter
    on QueryBuilder<DailyMetric, DailyMetric, QFilterCondition> {
  QueryBuilder<DailyMetric, DailyMetric, QAfterFilterCondition>
      commitsMadeEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'commitsMade',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterFilterCondition>
      commitsMadeGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'commitsMade',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterFilterCondition>
      commitsMadeLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'commitsMade',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterFilterCondition>
      commitsMadeBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'commitsMade',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterFilterCondition> dateEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterFilterCondition> dateGreaterThan(
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

  QueryBuilder<DailyMetric, DailyMetric, QAfterFilterCondition> dateLessThan(
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

  QueryBuilder<DailyMetric, DailyMetric, QAfterFilterCondition> dateBetween(
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

  QueryBuilder<DailyMetric, DailyMetric, QAfterFilterCondition>
      expensesLoggedEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expensesLogged',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterFilterCondition>
      expensesLoggedGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expensesLogged',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterFilterCondition>
      expensesLoggedLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expensesLogged',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterFilterCondition>
      expensesLoggedBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expensesLogged',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DailyMetric, DailyMetric, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DailyMetric, DailyMetric, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DailyMetric, DailyMetric, QAfterFilterCondition>
      studyHoursEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'studyHours',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterFilterCondition>
      studyHoursGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'studyHours',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterFilterCondition>
      studyHoursLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'studyHours',
        value: value,
      ));
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterFilterCondition>
      studyHoursBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'studyHours',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DailyMetricQueryObject
    on QueryBuilder<DailyMetric, DailyMetric, QFilterCondition> {}

extension DailyMetricQueryLinks
    on QueryBuilder<DailyMetric, DailyMetric, QFilterCondition> {}

extension DailyMetricQuerySortBy
    on QueryBuilder<DailyMetric, DailyMetric, QSortBy> {
  QueryBuilder<DailyMetric, DailyMetric, QAfterSortBy> sortByCommitsMade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commitsMade', Sort.asc);
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterSortBy> sortByCommitsMadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commitsMade', Sort.desc);
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterSortBy> sortByExpensesLogged() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expensesLogged', Sort.asc);
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterSortBy>
      sortByExpensesLoggedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expensesLogged', Sort.desc);
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterSortBy> sortByStudyHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'studyHours', Sort.asc);
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterSortBy> sortByStudyHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'studyHours', Sort.desc);
    });
  }
}

extension DailyMetricQuerySortThenBy
    on QueryBuilder<DailyMetric, DailyMetric, QSortThenBy> {
  QueryBuilder<DailyMetric, DailyMetric, QAfterSortBy> thenByCommitsMade() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commitsMade', Sort.asc);
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterSortBy> thenByCommitsMadeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'commitsMade', Sort.desc);
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterSortBy> thenByExpensesLogged() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expensesLogged', Sort.asc);
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterSortBy>
      thenByExpensesLoggedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expensesLogged', Sort.desc);
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterSortBy> thenByStudyHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'studyHours', Sort.asc);
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QAfterSortBy> thenByStudyHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'studyHours', Sort.desc);
    });
  }
}

extension DailyMetricQueryWhereDistinct
    on QueryBuilder<DailyMetric, DailyMetric, QDistinct> {
  QueryBuilder<DailyMetric, DailyMetric, QDistinct> distinctByCommitsMade() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'commitsMade');
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QDistinct> distinctByExpensesLogged() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expensesLogged');
    });
  }

  QueryBuilder<DailyMetric, DailyMetric, QDistinct> distinctByStudyHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'studyHours');
    });
  }
}

extension DailyMetricQueryProperty
    on QueryBuilder<DailyMetric, DailyMetric, QQueryProperty> {
  QueryBuilder<DailyMetric, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DailyMetric, int, QQueryOperations> commitsMadeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'commitsMade');
    });
  }

  QueryBuilder<DailyMetric, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<DailyMetric, int, QQueryOperations> expensesLoggedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expensesLogged');
    });
  }

  QueryBuilder<DailyMetric, int, QQueryOperations> studyHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'studyHours');
    });
  }
}
