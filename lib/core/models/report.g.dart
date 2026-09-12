// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetReportCollection on Isar {
  IsarCollection<Report> get reports => this.collection();
}

const ReportSchema = CollectionSchema(
  name: r'Report',
  id: 4107730612455750309,
  properties: {
    r'completedPeaks': PropertySchema(
      id: 0,
      name: r'completedPeaks',
      type: IsarType.long,
    ),
    r'generatedAt': PropertySchema(
      id: 1,
      name: r'generatedAt',
      type: IsarType.dateTime,
    ),
    r'mirrorSummary': PropertySchema(
      id: 2,
      name: r'mirrorSummary',
      type: IsarType.string,
    ),
    r'observedCalendarHours': PropertySchema(
      id: 3,
      name: r'observedCalendarHours',
      type: IsarType.double,
    ),
    r'observedFocusHours': PropertySchema(
      id: 4,
      name: r'observedFocusHours',
      type: IsarType.double,
    ),
    r'observedScreenTimeHours': PropertySchema(
      id: 5,
      name: r'observedScreenTimeHours',
      type: IsarType.double,
    ),
    r'periodEnd': PropertySchema(
      id: 6,
      name: r'periodEnd',
      type: IsarType.dateTime,
    ),
    r'periodStart': PropertySchema(
      id: 7,
      name: r'periodStart',
      type: IsarType.dateTime,
    ),
    r'plannedPeaks': PropertySchema(
      id: 8,
      name: r'plannedPeaks',
      type: IsarType.long,
    ),
    r'recommendedAction': PropertySchema(
      id: 9,
      name: r'recommendedAction',
      type: IsarType.string,
    ),
    r'rootCauseDiagnosis': PropertySchema(
      id: 10,
      name: r'rootCauseDiagnosis',
      type: IsarType.string,
    ),
    r'totalCapitalInvested': PropertySchema(
      id: 11,
      name: r'totalCapitalInvested',
      type: IsarType.double,
    ),
    r'totalOutflow': PropertySchema(
      id: 12,
      name: r'totalOutflow',
      type: IsarType.double,
    ),
    r'type': PropertySchema(
      id: 13,
      name: r'type',
      type: IsarType.byte,
      enumMap: _ReporttypeEnumValueMap,
    )
  },
  estimateSize: _reportEstimateSize,
  serialize: _reportSerialize,
  deserialize: _reportDeserialize,
  deserializeProp: _reportDeserializeProp,
  idName: r'id',
  indexes: {
    r'periodStart': IndexSchema(
      id: -7133903706047263368,
      name: r'periodStart',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'periodStart',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _reportGetId,
  getLinks: _reportGetLinks,
  attach: _reportAttach,
  version: '3.1.0+1',
);

int _reportEstimateSize(
  Report object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.mirrorSummary.length * 3;
  bytesCount += 3 + object.recommendedAction.length * 3;
  bytesCount += 3 + object.rootCauseDiagnosis.length * 3;
  return bytesCount;
}

void _reportSerialize(
  Report object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.completedPeaks);
  writer.writeDateTime(offsets[1], object.generatedAt);
  writer.writeString(offsets[2], object.mirrorSummary);
  writer.writeDouble(offsets[3], object.observedCalendarHours);
  writer.writeDouble(offsets[4], object.observedFocusHours);
  writer.writeDouble(offsets[5], object.observedScreenTimeHours);
  writer.writeDateTime(offsets[6], object.periodEnd);
  writer.writeDateTime(offsets[7], object.periodStart);
  writer.writeLong(offsets[8], object.plannedPeaks);
  writer.writeString(offsets[9], object.recommendedAction);
  writer.writeString(offsets[10], object.rootCauseDiagnosis);
  writer.writeDouble(offsets[11], object.totalCapitalInvested);
  writer.writeDouble(offsets[12], object.totalOutflow);
  writer.writeByte(offsets[13], object.type.index);
}

Report _reportDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Report();
  object.completedPeaks = reader.readLong(offsets[0]);
  object.generatedAt = reader.readDateTime(offsets[1]);
  object.id = id;
  object.mirrorSummary = reader.readString(offsets[2]);
  object.observedCalendarHours = reader.readDouble(offsets[3]);
  object.observedFocusHours = reader.readDouble(offsets[4]);
  object.observedScreenTimeHours = reader.readDouble(offsets[5]);
  object.periodEnd = reader.readDateTime(offsets[6]);
  object.periodStart = reader.readDateTime(offsets[7]);
  object.plannedPeaks = reader.readLong(offsets[8]);
  object.recommendedAction = reader.readString(offsets[9]);
  object.rootCauseDiagnosis = reader.readString(offsets[10]);
  object.totalCapitalInvested = reader.readDouble(offsets[11]);
  object.totalOutflow = reader.readDouble(offsets[12]);
  object.type = _ReporttypeValueEnumMap[reader.readByteOrNull(offsets[13])] ??
      ReportType.daily;
  return object;
}

P _reportDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    case 5:
      return (reader.readDouble(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readDateTime(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readString(offset)) as P;
    case 11:
      return (reader.readDouble(offset)) as P;
    case 12:
      return (reader.readDouble(offset)) as P;
    case 13:
      return (_ReporttypeValueEnumMap[reader.readByteOrNull(offset)] ??
          ReportType.daily) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _ReporttypeEnumValueMap = {
  'daily': 0,
  'weekly': 1,
  'monthly': 2,
};
const _ReporttypeValueEnumMap = {
  0: ReportType.daily,
  1: ReportType.weekly,
  2: ReportType.monthly,
};

Id _reportGetId(Report object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _reportGetLinks(Report object) {
  return [];
}

void _reportAttach(IsarCollection<dynamic> col, Id id, Report object) {
  object.id = id;
}

extension ReportQueryWhereSort on QueryBuilder<Report, Report, QWhere> {
  QueryBuilder<Report, Report, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<Report, Report, QAfterWhere> anyPeriodStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'periodStart'),
      );
    });
  }
}

extension ReportQueryWhere on QueryBuilder<Report, Report, QWhereClause> {
  QueryBuilder<Report, Report, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Report, Report, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Report, Report, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Report, Report, QAfterWhereClause> idBetween(
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

  QueryBuilder<Report, Report, QAfterWhereClause> periodStartEqualTo(
      DateTime periodStart) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'periodStart',
        value: [periodStart],
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterWhereClause> periodStartNotEqualTo(
      DateTime periodStart) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'periodStart',
              lower: [],
              upper: [periodStart],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'periodStart',
              lower: [periodStart],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'periodStart',
              lower: [periodStart],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'periodStart',
              lower: [],
              upper: [periodStart],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<Report, Report, QAfterWhereClause> periodStartGreaterThan(
    DateTime periodStart, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'periodStart',
        lower: [periodStart],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterWhereClause> periodStartLessThan(
    DateTime periodStart, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'periodStart',
        lower: [],
        upper: [periodStart],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterWhereClause> periodStartBetween(
    DateTime lowerPeriodStart,
    DateTime upperPeriodStart, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'periodStart',
        lower: [lowerPeriodStart],
        includeLower: includeLower,
        upper: [upperPeriodStart],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReportQueryFilter on QueryBuilder<Report, Report, QFilterCondition> {
  QueryBuilder<Report, Report, QAfterFilterCondition> completedPeaksEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedPeaks',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> completedPeaksGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedPeaks',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> completedPeaksLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedPeaks',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> completedPeaksBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedPeaks',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> generatedAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> generatedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> generatedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'generatedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> generatedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'generatedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Report, Report, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Report, Report, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Report, Report, QAfterFilterCondition> mirrorSummaryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mirrorSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> mirrorSummaryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'mirrorSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> mirrorSummaryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'mirrorSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> mirrorSummaryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'mirrorSummary',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> mirrorSummaryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'mirrorSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> mirrorSummaryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'mirrorSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> mirrorSummaryContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'mirrorSummary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> mirrorSummaryMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'mirrorSummary',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> mirrorSummaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'mirrorSummary',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      mirrorSummaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'mirrorSummary',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      observedCalendarHoursEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'observedCalendarHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      observedCalendarHoursGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'observedCalendarHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      observedCalendarHoursLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'observedCalendarHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      observedCalendarHoursBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'observedCalendarHours',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> observedFocusHoursEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'observedFocusHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      observedFocusHoursGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'observedFocusHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      observedFocusHoursLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'observedFocusHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> observedFocusHoursBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'observedFocusHours',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      observedScreenTimeHoursEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'observedScreenTimeHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      observedScreenTimeHoursGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'observedScreenTimeHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      observedScreenTimeHoursLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'observedScreenTimeHours',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      observedScreenTimeHoursBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'observedScreenTimeHours',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> periodEndEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'periodEnd',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> periodEndGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'periodEnd',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> periodEndLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'periodEnd',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> periodEndBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'periodEnd',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> periodStartEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'periodStart',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> periodStartGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'periodStart',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> periodStartLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'periodStart',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> periodStartBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'periodStart',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> plannedPeaksEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'plannedPeaks',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> plannedPeaksGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'plannedPeaks',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> plannedPeaksLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'plannedPeaks',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> plannedPeaksBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'plannedPeaks',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> recommendedActionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recommendedAction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      recommendedActionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'recommendedAction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> recommendedActionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'recommendedAction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> recommendedActionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'recommendedAction',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      recommendedActionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'recommendedAction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> recommendedActionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'recommendedAction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> recommendedActionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'recommendedAction',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> recommendedActionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'recommendedAction',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      recommendedActionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'recommendedAction',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      recommendedActionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'recommendedAction',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> rootCauseDiagnosisEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rootCauseDiagnosis',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      rootCauseDiagnosisGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rootCauseDiagnosis',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      rootCauseDiagnosisLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rootCauseDiagnosis',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> rootCauseDiagnosisBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rootCauseDiagnosis',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      rootCauseDiagnosisStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rootCauseDiagnosis',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      rootCauseDiagnosisEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rootCauseDiagnosis',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      rootCauseDiagnosisContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rootCauseDiagnosis',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> rootCauseDiagnosisMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rootCauseDiagnosis',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      rootCauseDiagnosisIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rootCauseDiagnosis',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      rootCauseDiagnosisIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rootCauseDiagnosis',
        value: '',
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      totalCapitalInvestedEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalCapitalInvested',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      totalCapitalInvestedGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalCapitalInvested',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      totalCapitalInvestedLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalCapitalInvested',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition>
      totalCapitalInvestedBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalCapitalInvested',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> totalOutflowEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalOutflow',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> totalOutflowGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalOutflow',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> totalOutflowLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalOutflow',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> totalOutflowBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalOutflow',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> typeEqualTo(
      ReportType value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> typeGreaterThan(
    ReportType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> typeLessThan(
    ReportType value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Report, Report, QAfterFilterCondition> typeBetween(
    ReportType lower,
    ReportType upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ReportQueryObject on QueryBuilder<Report, Report, QFilterCondition> {}

extension ReportQueryLinks on QueryBuilder<Report, Report, QFilterCondition> {}

extension ReportQuerySortBy on QueryBuilder<Report, Report, QSortBy> {
  QueryBuilder<Report, Report, QAfterSortBy> sortByCompletedPeaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedPeaks', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByCompletedPeaksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedPeaks', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByMirrorSummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mirrorSummary', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByMirrorSummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mirrorSummary', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByObservedCalendarHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observedCalendarHours', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByObservedCalendarHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observedCalendarHours', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByObservedFocusHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observedFocusHours', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByObservedFocusHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observedFocusHours', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByObservedScreenTimeHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observedScreenTimeHours', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy>
      sortByObservedScreenTimeHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observedScreenTimeHours', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByPeriodEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodEnd', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByPeriodEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodEnd', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByPeriodStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodStart', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByPeriodStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodStart', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByPlannedPeaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedPeaks', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByPlannedPeaksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedPeaks', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByRecommendedAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recommendedAction', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByRecommendedActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recommendedAction', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByRootCauseDiagnosis() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rootCauseDiagnosis', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByRootCauseDiagnosisDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rootCauseDiagnosis', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByTotalCapitalInvested() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCapitalInvested', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByTotalCapitalInvestedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCapitalInvested', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByTotalOutflow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalOutflow', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByTotalOutflowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalOutflow', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension ReportQuerySortThenBy on QueryBuilder<Report, Report, QSortThenBy> {
  QueryBuilder<Report, Report, QAfterSortBy> thenByCompletedPeaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedPeaks', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByCompletedPeaksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedPeaks', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByGeneratedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'generatedAt', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByMirrorSummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mirrorSummary', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByMirrorSummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'mirrorSummary', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByObservedCalendarHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observedCalendarHours', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByObservedCalendarHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observedCalendarHours', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByObservedFocusHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observedFocusHours', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByObservedFocusHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observedFocusHours', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByObservedScreenTimeHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observedScreenTimeHours', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy>
      thenByObservedScreenTimeHoursDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observedScreenTimeHours', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByPeriodEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodEnd', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByPeriodEndDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodEnd', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByPeriodStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodStart', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByPeriodStartDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'periodStart', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByPlannedPeaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedPeaks', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByPlannedPeaksDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'plannedPeaks', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByRecommendedAction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recommendedAction', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByRecommendedActionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'recommendedAction', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByRootCauseDiagnosis() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rootCauseDiagnosis', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByRootCauseDiagnosisDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rootCauseDiagnosis', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByTotalCapitalInvested() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCapitalInvested', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByTotalCapitalInvestedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalCapitalInvested', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByTotalOutflow() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalOutflow', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByTotalOutflowDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalOutflow', Sort.desc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Report, Report, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension ReportQueryWhereDistinct on QueryBuilder<Report, Report, QDistinct> {
  QueryBuilder<Report, Report, QDistinct> distinctByCompletedPeaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedPeaks');
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByGeneratedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'generatedAt');
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByMirrorSummary(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'mirrorSummary',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByObservedCalendarHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'observedCalendarHours');
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByObservedFocusHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'observedFocusHours');
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByObservedScreenTimeHours() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'observedScreenTimeHours');
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByPeriodEnd() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'periodEnd');
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByPeriodStart() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'periodStart');
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByPlannedPeaks() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'plannedPeaks');
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByRecommendedAction(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'recommendedAction',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByRootCauseDiagnosis(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rootCauseDiagnosis',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByTotalCapitalInvested() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalCapitalInvested');
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByTotalOutflow() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalOutflow');
    });
  }

  QueryBuilder<Report, Report, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension ReportQueryProperty on QueryBuilder<Report, Report, QQueryProperty> {
  QueryBuilder<Report, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Report, int, QQueryOperations> completedPeaksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedPeaks');
    });
  }

  QueryBuilder<Report, DateTime, QQueryOperations> generatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'generatedAt');
    });
  }

  QueryBuilder<Report, String, QQueryOperations> mirrorSummaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'mirrorSummary');
    });
  }

  QueryBuilder<Report, double, QQueryOperations>
      observedCalendarHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'observedCalendarHours');
    });
  }

  QueryBuilder<Report, double, QQueryOperations> observedFocusHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'observedFocusHours');
    });
  }

  QueryBuilder<Report, double, QQueryOperations>
      observedScreenTimeHoursProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'observedScreenTimeHours');
    });
  }

  QueryBuilder<Report, DateTime, QQueryOperations> periodEndProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'periodEnd');
    });
  }

  QueryBuilder<Report, DateTime, QQueryOperations> periodStartProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'periodStart');
    });
  }

  QueryBuilder<Report, int, QQueryOperations> plannedPeaksProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'plannedPeaks');
    });
  }

  QueryBuilder<Report, String, QQueryOperations> recommendedActionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'recommendedAction');
    });
  }

  QueryBuilder<Report, String, QQueryOperations> rootCauseDiagnosisProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rootCauseDiagnosis');
    });
  }

  QueryBuilder<Report, double, QQueryOperations>
      totalCapitalInvestedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalCapitalInvested');
    });
  }

  QueryBuilder<Report, double, QQueryOperations> totalOutflowProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalOutflow');
    });
  }

  QueryBuilder<Report, ReportType, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
