// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'brutalist_review.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetBrutalistReviewCollection on Isar {
  IsarCollection<BrutalistReview> get brutalistReviews => this.collection();
}

const BrutalistReviewSchema = CollectionSchema(
  name: r'BrutalistReview',
  id: 3332342336567740366,
  properties: {
    r'cowardiceDescription': PropertySchema(
      id: 0,
      name: r'cowardiceDescription',
      type: IsarType.string,
    ),
    r'cowardiceTag': PropertySchema(
      id: 1,
      name: r'cowardiceTag',
      type: IsarType.byte,
      enumMap: _BrutalistReviewcowardiceTagEnumValueMap,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'futureCostLost': PropertySchema(
      id: 3,
      name: r'futureCostLost',
      type: IsarType.double,
    ),
    r'highlight': PropertySchema(
      id: 4,
      name: r'highlight',
      type: IsarType.string,
    ),
    r'isCompleted': PropertySchema(
      id: 5,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'vent': PropertySchema(
      id: 6,
      name: r'vent',
      type: IsarType.string,
    )
  },
  estimateSize: _brutalistReviewEstimateSize,
  serialize: _brutalistReviewSerialize,
  deserialize: _brutalistReviewDeserialize,
  deserializeProp: _brutalistReviewDeserializeProp,
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
  getId: _brutalistReviewGetId,
  getLinks: _brutalistReviewGetLinks,
  attach: _brutalistReviewAttach,
  version: '3.1.0+1',
);

int _brutalistReviewEstimateSize(
  BrutalistReview object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.cowardiceDescription.length * 3;
  bytesCount += 3 + object.highlight.length * 3;
  bytesCount += 3 + object.vent.length * 3;
  return bytesCount;
}

void _brutalistReviewSerialize(
  BrutalistReview object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.cowardiceDescription);
  writer.writeByte(offsets[1], object.cowardiceTag.index);
  writer.writeDateTime(offsets[2], object.date);
  writer.writeDouble(offsets[3], object.futureCostLost);
  writer.writeString(offsets[4], object.highlight);
  writer.writeBool(offsets[5], object.isCompleted);
  writer.writeString(offsets[6], object.vent);
}

BrutalistReview _brutalistReviewDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = BrutalistReview();
  object.cowardiceDescription = reader.readString(offsets[0]);
  object.cowardiceTag = _BrutalistReviewcowardiceTagValueEnumMap[
          reader.readByteOrNull(offsets[1])] ??
      CowardiceTag.none;
  object.date = reader.readDateTime(offsets[2]);
  object.futureCostLost = reader.readDouble(offsets[3]);
  object.highlight = reader.readString(offsets[4]);
  object.id = id;
  object.isCompleted = reader.readBool(offsets[5]);
  object.vent = reader.readString(offsets[6]);
  return object;
}

P _brutalistReviewDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (_BrutalistReviewcowardiceTagValueEnumMap[
              reader.readByteOrNull(offset)] ??
          CowardiceTag.none) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readBool(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _BrutalistReviewcowardiceTagEnumValueMap = {
  'none': 0,
  'avoidance': 1,
  'dishonesty': 2,
  'mutedNeed': 3,
  'comfortSeeking': 4,
};
const _BrutalistReviewcowardiceTagValueEnumMap = {
  0: CowardiceTag.none,
  1: CowardiceTag.avoidance,
  2: CowardiceTag.dishonesty,
  3: CowardiceTag.mutedNeed,
  4: CowardiceTag.comfortSeeking,
};

Id _brutalistReviewGetId(BrutalistReview object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _brutalistReviewGetLinks(BrutalistReview object) {
  return [];
}

void _brutalistReviewAttach(
    IsarCollection<dynamic> col, Id id, BrutalistReview object) {
  object.id = id;
}

extension BrutalistReviewByIndex on IsarCollection<BrutalistReview> {
  Future<BrutalistReview?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  BrutalistReview? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<BrutalistReview?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<BrutalistReview?> getAllByDateSync(List<DateTime> dateValues) {
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

  Future<Id> putByDate(BrutalistReview object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(BrutalistReview object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<BrutalistReview> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(List<BrutalistReview> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension BrutalistReviewQueryWhereSort
    on QueryBuilder<BrutalistReview, BrutalistReview, QWhere> {
  QueryBuilder<BrutalistReview, BrutalistReview, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension BrutalistReviewQueryWhere
    on QueryBuilder<BrutalistReview, BrutalistReview, QWhereClause> {
  QueryBuilder<BrutalistReview, BrutalistReview, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterWhereClause> idBetween(
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

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterWhereClause> dateEqualTo(
      DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterWhereClause>
      dateNotEqualTo(DateTime date) {
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

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterWhereClause>
      dateGreaterThan(
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

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterWhereClause>
      dateLessThan(
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

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterWhereClause> dateBetween(
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

extension BrutalistReviewQueryFilter
    on QueryBuilder<BrutalistReview, BrutalistReview, QFilterCondition> {
  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      cowardiceDescriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cowardiceDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      cowardiceDescriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cowardiceDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      cowardiceDescriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cowardiceDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      cowardiceDescriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cowardiceDescription',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      cowardiceDescriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'cowardiceDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      cowardiceDescriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'cowardiceDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      cowardiceDescriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'cowardiceDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      cowardiceDescriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'cowardiceDescription',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      cowardiceDescriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cowardiceDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      cowardiceDescriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'cowardiceDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      cowardiceTagEqualTo(CowardiceTag value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'cowardiceTag',
        value: value,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      cowardiceTagGreaterThan(
    CowardiceTag value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'cowardiceTag',
        value: value,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      cowardiceTagLessThan(
    CowardiceTag value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'cowardiceTag',
        value: value,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      cowardiceTagBetween(
    CowardiceTag lower,
    CowardiceTag upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'cowardiceTag',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      dateGreaterThan(
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

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      dateLessThan(
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

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      dateBetween(
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

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      futureCostLostEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'futureCostLost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      futureCostLostGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'futureCostLost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      futureCostLostLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'futureCostLost',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      futureCostLostBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'futureCostLost',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      highlightEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'highlight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      highlightGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'highlight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      highlightLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'highlight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      highlightBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'highlight',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      highlightStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'highlight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      highlightEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'highlight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      highlightContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'highlight',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      highlightMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'highlight',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      highlightIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'highlight',
        value: '',
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      highlightIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'highlight',
        value: '',
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
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

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
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

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      isCompletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isCompleted',
        value: value,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      ventEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      ventGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'vent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      ventLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'vent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      ventBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'vent',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      ventStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'vent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      ventEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'vent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      ventContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'vent',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      ventMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'vent',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      ventIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'vent',
        value: '',
      ));
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterFilterCondition>
      ventIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'vent',
        value: '',
      ));
    });
  }
}

extension BrutalistReviewQueryObject
    on QueryBuilder<BrutalistReview, BrutalistReview, QFilterCondition> {}

extension BrutalistReviewQueryLinks
    on QueryBuilder<BrutalistReview, BrutalistReview, QFilterCondition> {}

extension BrutalistReviewQuerySortBy
    on QueryBuilder<BrutalistReview, BrutalistReview, QSortBy> {
  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      sortByCowardiceDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cowardiceDescription', Sort.asc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      sortByCowardiceDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cowardiceDescription', Sort.desc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      sortByCowardiceTag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cowardiceTag', Sort.asc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      sortByCowardiceTagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cowardiceTag', Sort.desc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      sortByFutureCostLost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'futureCostLost', Sort.asc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      sortByFutureCostLostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'futureCostLost', Sort.desc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      sortByHighlight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highlight', Sort.asc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      sortByHighlightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highlight', Sort.desc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy> sortByVent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vent', Sort.asc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      sortByVentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vent', Sort.desc);
    });
  }
}

extension BrutalistReviewQuerySortThenBy
    on QueryBuilder<BrutalistReview, BrutalistReview, QSortThenBy> {
  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      thenByCowardiceDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cowardiceDescription', Sort.asc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      thenByCowardiceDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cowardiceDescription', Sort.desc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      thenByCowardiceTag() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cowardiceTag', Sort.asc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      thenByCowardiceTagDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'cowardiceTag', Sort.desc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      thenByFutureCostLost() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'futureCostLost', Sort.asc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      thenByFutureCostLostDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'futureCostLost', Sort.desc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      thenByHighlight() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highlight', Sort.asc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      thenByHighlightDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'highlight', Sort.desc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy> thenByVent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vent', Sort.asc);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QAfterSortBy>
      thenByVentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'vent', Sort.desc);
    });
  }
}

extension BrutalistReviewQueryWhereDistinct
    on QueryBuilder<BrutalistReview, BrutalistReview, QDistinct> {
  QueryBuilder<BrutalistReview, BrutalistReview, QDistinct>
      distinctByCowardiceDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cowardiceDescription',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QDistinct>
      distinctByCowardiceTag() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'cowardiceTag');
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QDistinct>
      distinctByFutureCostLost() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'futureCostLost');
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QDistinct> distinctByHighlight(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'highlight', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QDistinct>
      distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<BrutalistReview, BrutalistReview, QDistinct> distinctByVent(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'vent', caseSensitive: caseSensitive);
    });
  }
}

extension BrutalistReviewQueryProperty
    on QueryBuilder<BrutalistReview, BrutalistReview, QQueryProperty> {
  QueryBuilder<BrutalistReview, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<BrutalistReview, String, QQueryOperations>
      cowardiceDescriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cowardiceDescription');
    });
  }

  QueryBuilder<BrutalistReview, CowardiceTag, QQueryOperations>
      cowardiceTagProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'cowardiceTag');
    });
  }

  QueryBuilder<BrutalistReview, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<BrutalistReview, double, QQueryOperations>
      futureCostLostProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'futureCostLost');
    });
  }

  QueryBuilder<BrutalistReview, String, QQueryOperations> highlightProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'highlight');
    });
  }

  QueryBuilder<BrutalistReview, bool, QQueryOperations> isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<BrutalistReview, String, QQueryOperations> ventProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'vent');
    });
  }
}
