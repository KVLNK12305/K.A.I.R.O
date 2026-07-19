// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decision_log.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetDecisionLogCollection on Isar {
  IsarCollection<DecisionLog> get decisionLogs => this.collection();
}

const DecisionLogSchema = CollectionSchema(
  name: r'DecisionLog',
  id: -3953042704646498711,
  properties: {
    r'actualOutcome': PropertySchema(
      id: 0,
      name: r'actualOutcome',
      type: IsarType.string,
    ),
    r'confidenceScore': PropertySchema(
      id: 1,
      name: r'confidenceScore',
      type: IsarType.long,
    ),
    r'contextDescription': PropertySchema(
      id: 2,
      name: r'contextDescription',
      type: IsarType.string,
    ),
    r'emotionalState': PropertySchema(
      id: 3,
      name: r'emotionalState',
      type: IsarType.string,
    ),
    r'expectedOutcome': PropertySchema(
      id: 4,
      name: r'expectedOutcome',
      type: IsarType.string,
    ),
    r'madeAt': PropertySchema(
      id: 5,
      name: r'madeAt',
      type: IsarType.dateTime,
    ),
    r'reviewDate': PropertySchema(
      id: 6,
      name: r'reviewDate',
      type: IsarType.dateTime,
    ),
    r'title': PropertySchema(
      id: 7,
      name: r'title',
      type: IsarType.string,
    ),
    r'verdict': PropertySchema(
      id: 8,
      name: r'verdict',
      type: IsarType.string,
    )
  },
  estimateSize: _decisionLogEstimateSize,
  serialize: _decisionLogSerialize,
  deserialize: _decisionLogDeserialize,
  deserializeProp: _decisionLogDeserializeProp,
  idName: r'id',
  indexes: {
    r'title': IndexSchema(
      id: -7636685945352118059,
      name: r'title',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'title',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'madeAt': IndexSchema(
      id: 4300068647207705130,
      name: r'madeAt',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'madeAt',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'reviewDate': IndexSchema(
      id: -4677418855940269689,
      name: r'reviewDate',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'reviewDate',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'verdict': IndexSchema(
      id: -3314688043692978907,
      name: r'verdict',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'verdict',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _decisionLogGetId,
  getLinks: _decisionLogGetLinks,
  attach: _decisionLogAttach,
  version: '3.1.0+1',
);

int _decisionLogEstimateSize(
  DecisionLog object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.actualOutcome.length * 3;
  bytesCount += 3 + object.contextDescription.length * 3;
  bytesCount += 3 + object.emotionalState.length * 3;
  bytesCount += 3 + object.expectedOutcome.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.verdict.length * 3;
  return bytesCount;
}

void _decisionLogSerialize(
  DecisionLog object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.actualOutcome);
  writer.writeLong(offsets[1], object.confidenceScore);
  writer.writeString(offsets[2], object.contextDescription);
  writer.writeString(offsets[3], object.emotionalState);
  writer.writeString(offsets[4], object.expectedOutcome);
  writer.writeDateTime(offsets[5], object.madeAt);
  writer.writeDateTime(offsets[6], object.reviewDate);
  writer.writeString(offsets[7], object.title);
  writer.writeString(offsets[8], object.verdict);
}

DecisionLog _decisionLogDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = DecisionLog();
  object.actualOutcome = reader.readString(offsets[0]);
  object.confidenceScore = reader.readLong(offsets[1]);
  object.contextDescription = reader.readString(offsets[2]);
  object.emotionalState = reader.readString(offsets[3]);
  object.expectedOutcome = reader.readString(offsets[4]);
  object.id = id;
  object.madeAt = reader.readDateTime(offsets[5]);
  object.reviewDate = reader.readDateTime(offsets[6]);
  object.title = reader.readString(offsets[7]);
  object.verdict = reader.readString(offsets[8]);
  return object;
}

P _decisionLogDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readDateTime(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _decisionLogGetId(DecisionLog object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _decisionLogGetLinks(DecisionLog object) {
  return [];
}

void _decisionLogAttach(
    IsarCollection<dynamic> col, Id id, DecisionLog object) {
  object.id = id;
}

extension DecisionLogQueryWhereSort
    on QueryBuilder<DecisionLog, DecisionLog, QWhere> {
  QueryBuilder<DecisionLog, DecisionLog, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhere> anyMadeAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'madeAt'),
      );
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhere> anyReviewDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'reviewDate'),
      );
    });
  }
}

extension DecisionLogQueryWhere
    on QueryBuilder<DecisionLog, DecisionLog, QWhereClause> {
  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> idBetween(
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

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> titleEqualTo(
      String title) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'title',
        value: [title],
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> titleNotEqualTo(
      String title) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [],
              upper: [title],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [title],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [title],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'title',
              lower: [],
              upper: [title],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> madeAtEqualTo(
      DateTime madeAt) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'madeAt',
        value: [madeAt],
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> madeAtNotEqualTo(
      DateTime madeAt) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'madeAt',
              lower: [],
              upper: [madeAt],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'madeAt',
              lower: [madeAt],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'madeAt',
              lower: [madeAt],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'madeAt',
              lower: [],
              upper: [madeAt],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> madeAtGreaterThan(
    DateTime madeAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'madeAt',
        lower: [madeAt],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> madeAtLessThan(
    DateTime madeAt, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'madeAt',
        lower: [],
        upper: [madeAt],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> madeAtBetween(
    DateTime lowerMadeAt,
    DateTime upperMadeAt, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'madeAt',
        lower: [lowerMadeAt],
        includeLower: includeLower,
        upper: [upperMadeAt],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> reviewDateEqualTo(
      DateTime reviewDate) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'reviewDate',
        value: [reviewDate],
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause>
      reviewDateNotEqualTo(DateTime reviewDate) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reviewDate',
              lower: [],
              upper: [reviewDate],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reviewDate',
              lower: [reviewDate],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reviewDate',
              lower: [reviewDate],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'reviewDate',
              lower: [],
              upper: [reviewDate],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause>
      reviewDateGreaterThan(
    DateTime reviewDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'reviewDate',
        lower: [reviewDate],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> reviewDateLessThan(
    DateTime reviewDate, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'reviewDate',
        lower: [],
        upper: [reviewDate],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> reviewDateBetween(
    DateTime lowerReviewDate,
    DateTime upperReviewDate, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'reviewDate',
        lower: [lowerReviewDate],
        includeLower: includeLower,
        upper: [upperReviewDate],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> verdictEqualTo(
      String verdict) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'verdict',
        value: [verdict],
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterWhereClause> verdictNotEqualTo(
      String verdict) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'verdict',
              lower: [],
              upper: [verdict],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'verdict',
              lower: [verdict],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'verdict',
              lower: [verdict],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'verdict',
              lower: [],
              upper: [verdict],
              includeUpper: false,
            ));
      }
    });
  }
}

extension DecisionLogQueryFilter
    on QueryBuilder<DecisionLog, DecisionLog, QFilterCondition> {
  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      actualOutcomeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actualOutcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      actualOutcomeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'actualOutcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      actualOutcomeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'actualOutcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      actualOutcomeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'actualOutcome',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      actualOutcomeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'actualOutcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      actualOutcomeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'actualOutcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      actualOutcomeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'actualOutcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      actualOutcomeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'actualOutcome',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      actualOutcomeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'actualOutcome',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      actualOutcomeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'actualOutcome',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      confidenceScoreEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'confidenceScore',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      confidenceScoreGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'confidenceScore',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      confidenceScoreLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'confidenceScore',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      confidenceScoreBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'confidenceScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      contextDescriptionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contextDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      contextDescriptionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contextDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      contextDescriptionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contextDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      contextDescriptionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contextDescription',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      contextDescriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contextDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      contextDescriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contextDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      contextDescriptionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contextDescription',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      contextDescriptionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contextDescription',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      contextDescriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contextDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      contextDescriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contextDescription',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      emotionalStateEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emotionalState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      emotionalStateGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'emotionalState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      emotionalStateLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'emotionalState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      emotionalStateBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'emotionalState',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      emotionalStateStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'emotionalState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      emotionalStateEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'emotionalState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      emotionalStateContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'emotionalState',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      emotionalStateMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'emotionalState',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      emotionalStateIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'emotionalState',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      emotionalStateIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'emotionalState',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      expectedOutcomeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expectedOutcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      expectedOutcomeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expectedOutcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      expectedOutcomeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expectedOutcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      expectedOutcomeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expectedOutcome',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      expectedOutcomeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'expectedOutcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      expectedOutcomeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'expectedOutcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      expectedOutcomeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'expectedOutcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      expectedOutcomeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'expectedOutcome',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      expectedOutcomeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expectedOutcome',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      expectedOutcomeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'expectedOutcome',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> idBetween(
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

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> madeAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'madeAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      madeAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'madeAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> madeAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'madeAt',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> madeAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'madeAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      reviewDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'reviewDate',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      reviewDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'reviewDate',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      reviewDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'reviewDate',
        value: value,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      reviewDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'reviewDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> titleEqualTo(
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

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      titleGreaterThan(
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

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> titleLessThan(
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

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> titleBetween(
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

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> titleStartsWith(
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

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> titleEndsWith(
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

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> titleContains(
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

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> titleMatches(
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

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> verdictEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verdict',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      verdictGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verdict',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> verdictLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verdict',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> verdictBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verdict',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      verdictStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'verdict',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> verdictEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'verdict',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> verdictContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'verdict',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition> verdictMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'verdict',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      verdictIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verdict',
        value: '',
      ));
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterFilterCondition>
      verdictIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'verdict',
        value: '',
      ));
    });
  }
}

extension DecisionLogQueryObject
    on QueryBuilder<DecisionLog, DecisionLog, QFilterCondition> {}

extension DecisionLogQueryLinks
    on QueryBuilder<DecisionLog, DecisionLog, QFilterCondition> {}

extension DecisionLogQuerySortBy
    on QueryBuilder<DecisionLog, DecisionLog, QSortBy> {
  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByActualOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualOutcome', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy>
      sortByActualOutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualOutcome', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByConfidenceScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidenceScore', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy>
      sortByConfidenceScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidenceScore', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy>
      sortByContextDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextDescription', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy>
      sortByContextDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextDescription', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByEmotionalState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionalState', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy>
      sortByEmotionalStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionalState', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByExpectedOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedOutcome', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy>
      sortByExpectedOutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedOutcome', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByMadeAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'madeAt', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByMadeAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'madeAt', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByReviewDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewDate', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByReviewDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewDate', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByVerdict() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verdict', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> sortByVerdictDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verdict', Sort.desc);
    });
  }
}

extension DecisionLogQuerySortThenBy
    on QueryBuilder<DecisionLog, DecisionLog, QSortThenBy> {
  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByActualOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualOutcome', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy>
      thenByActualOutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'actualOutcome', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByConfidenceScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidenceScore', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy>
      thenByConfidenceScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'confidenceScore', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy>
      thenByContextDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextDescription', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy>
      thenByContextDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextDescription', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByEmotionalState() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionalState', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy>
      thenByEmotionalStateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'emotionalState', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByExpectedOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedOutcome', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy>
      thenByExpectedOutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expectedOutcome', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByMadeAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'madeAt', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByMadeAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'madeAt', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByReviewDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewDate', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByReviewDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'reviewDate', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByVerdict() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verdict', Sort.asc);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QAfterSortBy> thenByVerdictDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verdict', Sort.desc);
    });
  }
}

extension DecisionLogQueryWhereDistinct
    on QueryBuilder<DecisionLog, DecisionLog, QDistinct> {
  QueryBuilder<DecisionLog, DecisionLog, QDistinct> distinctByActualOutcome(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'actualOutcome',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QDistinct>
      distinctByConfidenceScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'confidenceScore');
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QDistinct>
      distinctByContextDescription({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contextDescription',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QDistinct> distinctByEmotionalState(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'emotionalState',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QDistinct> distinctByExpectedOutcome(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expectedOutcome',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QDistinct> distinctByMadeAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'madeAt');
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QDistinct> distinctByReviewDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'reviewDate');
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<DecisionLog, DecisionLog, QDistinct> distinctByVerdict(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verdict', caseSensitive: caseSensitive);
    });
  }
}

extension DecisionLogQueryProperty
    on QueryBuilder<DecisionLog, DecisionLog, QQueryProperty> {
  QueryBuilder<DecisionLog, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<DecisionLog, String, QQueryOperations> actualOutcomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'actualOutcome');
    });
  }

  QueryBuilder<DecisionLog, int, QQueryOperations> confidenceScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'confidenceScore');
    });
  }

  QueryBuilder<DecisionLog, String, QQueryOperations>
      contextDescriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contextDescription');
    });
  }

  QueryBuilder<DecisionLog, String, QQueryOperations> emotionalStateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'emotionalState');
    });
  }

  QueryBuilder<DecisionLog, String, QQueryOperations>
      expectedOutcomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expectedOutcome');
    });
  }

  QueryBuilder<DecisionLog, DateTime, QQueryOperations> madeAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'madeAt');
    });
  }

  QueryBuilder<DecisionLog, DateTime, QQueryOperations> reviewDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'reviewDate');
    });
  }

  QueryBuilder<DecisionLog, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<DecisionLog, String, QQueryOperations> verdictProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verdict');
    });
  }
}
