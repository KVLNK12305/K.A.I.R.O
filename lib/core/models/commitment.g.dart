// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'commitment.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetCommitmentCollection on Isar {
  IsarCollection<Commitment> get commitments => this.collection();
}

const CommitmentSchema = CollectionSchema(
  name: r'Commitment',
  id: 9008236611633959500,
  properties: {
    r'completedAt': PropertySchema(
      id: 0,
      name: r'completedAt',
      type: IsarType.dateTime,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'desiredOutcome': PropertySchema(
      id: 2,
      name: r'desiredOutcome',
      type: IsarType.string,
    ),
    r'failureConsequence': PropertySchema(
      id: 3,
      name: r'failureConsequence',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 4,
      name: r'status',
      type: IsarType.byte,
      enumMap: _CommitmentstatusEnumValueMap,
    ),
    r'targetDeadline': PropertySchema(
      id: 5,
      name: r'targetDeadline',
      type: IsarType.dateTime,
    ),
    r'title': PropertySchema(
      id: 6,
      name: r'title',
      type: IsarType.string,
    ),
    r'whyItMatters': PropertySchema(
      id: 7,
      name: r'whyItMatters',
      type: IsarType.string,
    )
  },
  estimateSize: _commitmentEstimateSize,
  serialize: _commitmentSerialize,
  deserialize: _commitmentDeserialize,
  deserializeProp: _commitmentDeserializeProp,
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
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _commitmentGetId,
  getLinks: _commitmentGetLinks,
  attach: _commitmentAttach,
  version: '3.1.0+1',
);

int _commitmentEstimateSize(
  Commitment object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.desiredOutcome.length * 3;
  bytesCount += 3 + object.failureConsequence.length * 3;
  bytesCount += 3 + object.title.length * 3;
  bytesCount += 3 + object.whyItMatters.length * 3;
  return bytesCount;
}

void _commitmentSerialize(
  Commitment object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.completedAt);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeString(offsets[2], object.desiredOutcome);
  writer.writeString(offsets[3], object.failureConsequence);
  writer.writeByte(offsets[4], object.status.index);
  writer.writeDateTime(offsets[5], object.targetDeadline);
  writer.writeString(offsets[6], object.title);
  writer.writeString(offsets[7], object.whyItMatters);
}

Commitment _commitmentDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Commitment();
  object.completedAt = reader.readDateTimeOrNull(offsets[0]);
  object.createdAt = reader.readDateTime(offsets[1]);
  object.desiredOutcome = reader.readString(offsets[2]);
  object.failureConsequence = reader.readString(offsets[3]);
  object.id = id;
  object.status =
      _CommitmentstatusValueEnumMap[reader.readByteOrNull(offsets[4])] ??
          CommitmentStatus.active;
  object.targetDeadline = reader.readDateTime(offsets[5]);
  object.title = reader.readString(offsets[6]);
  object.whyItMatters = reader.readString(offsets[7]);
  return object;
}

P _commitmentDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 1:
      return (reader.readDateTime(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (_CommitmentstatusValueEnumMap[reader.readByteOrNull(offset)] ??
          CommitmentStatus.active) as P;
    case 5:
      return (reader.readDateTime(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _CommitmentstatusEnumValueMap = {
  'active': 0,
  'paused': 1,
  'completed': 2,
  'archived': 3,
};
const _CommitmentstatusValueEnumMap = {
  0: CommitmentStatus.active,
  1: CommitmentStatus.paused,
  2: CommitmentStatus.completed,
  3: CommitmentStatus.archived,
};

Id _commitmentGetId(Commitment object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _commitmentGetLinks(Commitment object) {
  return [];
}

void _commitmentAttach(IsarCollection<dynamic> col, Id id, Commitment object) {
  object.id = id;
}

extension CommitmentQueryWhereSort
    on QueryBuilder<Commitment, Commitment, QWhere> {
  QueryBuilder<Commitment, Commitment, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension CommitmentQueryWhere
    on QueryBuilder<Commitment, Commitment, QWhereClause> {
  QueryBuilder<Commitment, Commitment, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Commitment, Commitment, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterWhereClause> idBetween(
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

  QueryBuilder<Commitment, Commitment, QAfterWhereClause> titleEqualTo(
      String title) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'title',
        value: [title],
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterWhereClause> titleNotEqualTo(
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
}

extension CommitmentQueryFilter
    on QueryBuilder<Commitment, Commitment, QFilterCondition> {
  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      completedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      completedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'completedAt',
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      completedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      completedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      completedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'completedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      completedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'completedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
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

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      desiredOutcomeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'desiredOutcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      desiredOutcomeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'desiredOutcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      desiredOutcomeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'desiredOutcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      desiredOutcomeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'desiredOutcome',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      desiredOutcomeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'desiredOutcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      desiredOutcomeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'desiredOutcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      desiredOutcomeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'desiredOutcome',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      desiredOutcomeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'desiredOutcome',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      desiredOutcomeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'desiredOutcome',
        value: '',
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      desiredOutcomeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'desiredOutcome',
        value: '',
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      failureConsequenceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'failureConsequence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      failureConsequenceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'failureConsequence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      failureConsequenceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'failureConsequence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      failureConsequenceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'failureConsequence',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      failureConsequenceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'failureConsequence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      failureConsequenceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'failureConsequence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      failureConsequenceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'failureConsequence',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      failureConsequenceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'failureConsequence',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      failureConsequenceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'failureConsequence',
        value: '',
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      failureConsequenceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'failureConsequence',
        value: '',
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition> idBetween(
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

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition> statusEqualTo(
      CommitmentStatus value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition> statusGreaterThan(
    CommitmentStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition> statusLessThan(
    CommitmentStatus value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition> statusBetween(
    CommitmentStatus lower,
    CommitmentStatus upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      targetDeadlineEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetDeadline',
        value: value,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      targetDeadlineGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetDeadline',
        value: value,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      targetDeadlineLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetDeadline',
        value: value,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      targetDeadlineBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetDeadline',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition> titleEqualTo(
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

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition> titleGreaterThan(
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

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition> titleLessThan(
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

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition> titleBetween(
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

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition> titleStartsWith(
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

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition> titleEndsWith(
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

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition> titleContains(
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

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition> titleMatches(
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

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition> titleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      titleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'title',
        value: '',
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      whyItMattersEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'whyItMatters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      whyItMattersGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'whyItMatters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      whyItMattersLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'whyItMatters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      whyItMattersBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'whyItMatters',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      whyItMattersStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'whyItMatters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      whyItMattersEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'whyItMatters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      whyItMattersContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'whyItMatters',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      whyItMattersMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'whyItMatters',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      whyItMattersIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'whyItMatters',
        value: '',
      ));
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterFilterCondition>
      whyItMattersIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'whyItMatters',
        value: '',
      ));
    });
  }
}

extension CommitmentQueryObject
    on QueryBuilder<Commitment, Commitment, QFilterCondition> {}

extension CommitmentQueryLinks
    on QueryBuilder<Commitment, Commitment, QFilterCondition> {}

extension CommitmentQuerySortBy
    on QueryBuilder<Commitment, Commitment, QSortBy> {
  QueryBuilder<Commitment, Commitment, QAfterSortBy> sortByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> sortByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> sortByDesiredOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'desiredOutcome', Sort.asc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy>
      sortByDesiredOutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'desiredOutcome', Sort.desc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy>
      sortByFailureConsequence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failureConsequence', Sort.asc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy>
      sortByFailureConsequenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failureConsequence', Sort.desc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> sortByTargetDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDeadline', Sort.asc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy>
      sortByTargetDeadlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDeadline', Sort.desc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> sortByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> sortByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> sortByWhyItMatters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whyItMatters', Sort.asc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> sortByWhyItMattersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whyItMatters', Sort.desc);
    });
  }
}

extension CommitmentQuerySortThenBy
    on QueryBuilder<Commitment, Commitment, QSortThenBy> {
  QueryBuilder<Commitment, Commitment, QAfterSortBy> thenByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.asc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> thenByCompletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedAt', Sort.desc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> thenByDesiredOutcome() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'desiredOutcome', Sort.asc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy>
      thenByDesiredOutcomeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'desiredOutcome', Sort.desc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy>
      thenByFailureConsequence() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failureConsequence', Sort.asc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy>
      thenByFailureConsequenceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'failureConsequence', Sort.desc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> thenByTargetDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDeadline', Sort.asc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy>
      thenByTargetDeadlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDeadline', Sort.desc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> thenByTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.asc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> thenByTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'title', Sort.desc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> thenByWhyItMatters() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whyItMatters', Sort.asc);
    });
  }

  QueryBuilder<Commitment, Commitment, QAfterSortBy> thenByWhyItMattersDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'whyItMatters', Sort.desc);
    });
  }
}

extension CommitmentQueryWhereDistinct
    on QueryBuilder<Commitment, Commitment, QDistinct> {
  QueryBuilder<Commitment, Commitment, QDistinct> distinctByCompletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedAt');
    });
  }

  QueryBuilder<Commitment, Commitment, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<Commitment, Commitment, QDistinct> distinctByDesiredOutcome(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'desiredOutcome',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Commitment, Commitment, QDistinct> distinctByFailureConsequence(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'failureConsequence',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Commitment, Commitment, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<Commitment, Commitment, QDistinct> distinctByTargetDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetDeadline');
    });
  }

  QueryBuilder<Commitment, Commitment, QDistinct> distinctByTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'title', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Commitment, Commitment, QDistinct> distinctByWhyItMatters(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'whyItMatters', caseSensitive: caseSensitive);
    });
  }
}

extension CommitmentQueryProperty
    on QueryBuilder<Commitment, Commitment, QQueryProperty> {
  QueryBuilder<Commitment, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Commitment, DateTime?, QQueryOperations> completedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedAt');
    });
  }

  QueryBuilder<Commitment, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<Commitment, String, QQueryOperations> desiredOutcomeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'desiredOutcome');
    });
  }

  QueryBuilder<Commitment, String, QQueryOperations>
      failureConsequenceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'failureConsequence');
    });
  }

  QueryBuilder<Commitment, CommitmentStatus, QQueryOperations>
      statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<Commitment, DateTime, QQueryOperations>
      targetDeadlineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetDeadline');
    });
  }

  QueryBuilder<Commitment, String, QQueryOperations> titleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'title');
    });
  }

  QueryBuilder<Commitment, String, QQueryOperations> whyItMattersProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'whyItMatters');
    });
  }
}
