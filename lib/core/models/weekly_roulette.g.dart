// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weekly_roulette.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWeeklyRouletteCollection on Isar {
  IsarCollection<WeeklyRoulette> get weeklyRoulettes => this.collection();
}

const WeeklyRouletteSchema = CollectionSchema(
  name: r'WeeklyRoulette',
  id: -1121546880017917677,
  properties: {
    r'assignedDate': PropertySchema(
      id: 0,
      name: r'assignedDate',
      type: IsarType.dateTime,
    ),
    r'category': PropertySchema(
      id: 1,
      name: r'category',
      type: IsarType.string,
    ),
    r'explored': PropertySchema(
      id: 2,
      name: r'explored',
      type: IsarType.bool,
    ),
    r'resourceUrl': PropertySchema(
      id: 3,
      name: r'resourceUrl',
      type: IsarType.string,
    ),
    r'summary': PropertySchema(
      id: 4,
      name: r'summary',
      type: IsarType.string,
    ),
    r'topicTitle': PropertySchema(
      id: 5,
      name: r'topicTitle',
      type: IsarType.string,
    ),
    r'userTakeaway': PropertySchema(
      id: 6,
      name: r'userTakeaway',
      type: IsarType.string,
    )
  },
  estimateSize: _weeklyRouletteEstimateSize,
  serialize: _weeklyRouletteSerialize,
  deserialize: _weeklyRouletteDeserialize,
  deserializeProp: _weeklyRouletteDeserializeProp,
  idName: r'id',
  indexes: {
    r'topicTitle': IndexSchema(
      id: 7380529699663480643,
      name: r'topicTitle',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'topicTitle',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _weeklyRouletteGetId,
  getLinks: _weeklyRouletteGetLinks,
  attach: _weeklyRouletteAttach,
  version: '3.1.0+1',
);

int _weeklyRouletteEstimateSize(
  WeeklyRoulette object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.category.length * 3;
  {
    final value = object.resourceUrl;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.summary.length * 3;
  bytesCount += 3 + object.topicTitle.length * 3;
  {
    final value = object.userTakeaway;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _weeklyRouletteSerialize(
  WeeklyRoulette object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.assignedDate);
  writer.writeString(offsets[1], object.category);
  writer.writeBool(offsets[2], object.explored);
  writer.writeString(offsets[3], object.resourceUrl);
  writer.writeString(offsets[4], object.summary);
  writer.writeString(offsets[5], object.topicTitle);
  writer.writeString(offsets[6], object.userTakeaway);
}

WeeklyRoulette _weeklyRouletteDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WeeklyRoulette();
  object.assignedDate = reader.readDateTime(offsets[0]);
  object.category = reader.readString(offsets[1]);
  object.explored = reader.readBool(offsets[2]);
  object.id = id;
  object.resourceUrl = reader.readStringOrNull(offsets[3]);
  object.summary = reader.readString(offsets[4]);
  object.topicTitle = reader.readString(offsets[5]);
  object.userTakeaway = reader.readStringOrNull(offsets[6]);
  return object;
}

P _weeklyRouletteDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTime(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readStringOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _weeklyRouletteGetId(WeeklyRoulette object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _weeklyRouletteGetLinks(WeeklyRoulette object) {
  return [];
}

void _weeklyRouletteAttach(
    IsarCollection<dynamic> col, Id id, WeeklyRoulette object) {
  object.id = id;
}

extension WeeklyRouletteQueryWhereSort
    on QueryBuilder<WeeklyRoulette, WeeklyRoulette, QWhere> {
  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WeeklyRouletteQueryWhere
    on QueryBuilder<WeeklyRoulette, WeeklyRoulette, QWhereClause> {
  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterWhereClause> idBetween(
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

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterWhereClause>
      topicTitleEqualTo(String topicTitle) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'topicTitle',
        value: [topicTitle],
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterWhereClause>
      topicTitleNotEqualTo(String topicTitle) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'topicTitle',
              lower: [],
              upper: [topicTitle],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'topicTitle',
              lower: [topicTitle],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'topicTitle',
              lower: [topicTitle],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'topicTitle',
              lower: [],
              upper: [topicTitle],
              includeUpper: false,
            ));
      }
    });
  }
}

extension WeeklyRouletteQueryFilter
    on QueryBuilder<WeeklyRoulette, WeeklyRoulette, QFilterCondition> {
  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      assignedDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'assignedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      assignedDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'assignedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      assignedDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'assignedDate',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      assignedDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'assignedDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'category',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      categoryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'category',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      categoryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'category',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'category',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      exploredEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'explored',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
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

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition> idBetween(
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

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      resourceUrlIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'resourceUrl',
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      resourceUrlIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'resourceUrl',
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      resourceUrlEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resourceUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      resourceUrlGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resourceUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      resourceUrlLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resourceUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      resourceUrlBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resourceUrl',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      resourceUrlStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'resourceUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      resourceUrlEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'resourceUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      resourceUrlContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'resourceUrl',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      resourceUrlMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'resourceUrl',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      resourceUrlIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resourceUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      resourceUrlIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'resourceUrl',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      summaryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      summaryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      summaryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      summaryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'summary',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      summaryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      summaryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      summaryContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'summary',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      summaryMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'summary',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      summaryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'summary',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      summaryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'summary',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      topicTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topicTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      topicTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'topicTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      topicTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'topicTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      topicTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'topicTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      topicTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'topicTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      topicTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'topicTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      topicTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'topicTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      topicTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'topicTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      topicTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'topicTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      topicTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'topicTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      userTakeawayIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'userTakeaway',
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      userTakeawayIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'userTakeaway',
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      userTakeawayEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userTakeaway',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      userTakeawayGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'userTakeaway',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      userTakeawayLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'userTakeaway',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      userTakeawayBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'userTakeaway',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      userTakeawayStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'userTakeaway',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      userTakeawayEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'userTakeaway',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      userTakeawayContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'userTakeaway',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      userTakeawayMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'userTakeaway',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      userTakeawayIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'userTakeaway',
        value: '',
      ));
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterFilterCondition>
      userTakeawayIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'userTakeaway',
        value: '',
      ));
    });
  }
}

extension WeeklyRouletteQueryObject
    on QueryBuilder<WeeklyRoulette, WeeklyRoulette, QFilterCondition> {}

extension WeeklyRouletteQueryLinks
    on QueryBuilder<WeeklyRoulette, WeeklyRoulette, QFilterCondition> {}

extension WeeklyRouletteQuerySortBy
    on QueryBuilder<WeeklyRoulette, WeeklyRoulette, QSortBy> {
  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      sortByAssignedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assignedDate', Sort.asc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      sortByAssignedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assignedDate', Sort.desc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy> sortByExplored() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'explored', Sort.asc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      sortByExploredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'explored', Sort.desc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      sortByResourceUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resourceUrl', Sort.asc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      sortByResourceUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resourceUrl', Sort.desc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy> sortBySummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.asc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      sortBySummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.desc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      sortByTopicTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topicTitle', Sort.asc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      sortByTopicTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topicTitle', Sort.desc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      sortByUserTakeaway() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userTakeaway', Sort.asc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      sortByUserTakeawayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userTakeaway', Sort.desc);
    });
  }
}

extension WeeklyRouletteQuerySortThenBy
    on QueryBuilder<WeeklyRoulette, WeeklyRoulette, QSortThenBy> {
  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      thenByAssignedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assignedDate', Sort.asc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      thenByAssignedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'assignedDate', Sort.desc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy> thenByExplored() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'explored', Sort.asc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      thenByExploredDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'explored', Sort.desc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      thenByResourceUrl() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resourceUrl', Sort.asc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      thenByResourceUrlDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resourceUrl', Sort.desc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy> thenBySummary() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.asc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      thenBySummaryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'summary', Sort.desc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      thenByTopicTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topicTitle', Sort.asc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      thenByTopicTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'topicTitle', Sort.desc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      thenByUserTakeaway() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userTakeaway', Sort.asc);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QAfterSortBy>
      thenByUserTakeawayDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'userTakeaway', Sort.desc);
    });
  }
}

extension WeeklyRouletteQueryWhereDistinct
    on QueryBuilder<WeeklyRoulette, WeeklyRoulette, QDistinct> {
  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QDistinct>
      distinctByAssignedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'assignedDate');
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QDistinct> distinctByCategory(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QDistinct> distinctByExplored() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'explored');
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QDistinct> distinctByResourceUrl(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resourceUrl', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QDistinct> distinctBySummary(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'summary', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QDistinct> distinctByTopicTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'topicTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WeeklyRoulette, WeeklyRoulette, QDistinct>
      distinctByUserTakeaway({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'userTakeaway', caseSensitive: caseSensitive);
    });
  }
}

extension WeeklyRouletteQueryProperty
    on QueryBuilder<WeeklyRoulette, WeeklyRoulette, QQueryProperty> {
  QueryBuilder<WeeklyRoulette, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WeeklyRoulette, DateTime, QQueryOperations>
      assignedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'assignedDate');
    });
  }

  QueryBuilder<WeeklyRoulette, String, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<WeeklyRoulette, bool, QQueryOperations> exploredProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'explored');
    });
  }

  QueryBuilder<WeeklyRoulette, String?, QQueryOperations>
      resourceUrlProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resourceUrl');
    });
  }

  QueryBuilder<WeeklyRoulette, String, QQueryOperations> summaryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'summary');
    });
  }

  QueryBuilder<WeeklyRoulette, String, QQueryOperations> topicTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'topicTitle');
    });
  }

  QueryBuilder<WeeklyRoulette, String?, QQueryOperations>
      userTakeawayProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'userTakeaway');
    });
  }
}
