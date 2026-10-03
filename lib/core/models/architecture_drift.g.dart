// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'architecture_drift.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetArchitectureDriftCollection on Isar {
  IsarCollection<ArchitectureDrift> get architectureDrifts => this.collection();
}

const ArchitectureDriftSchema = CollectionSchema(
  name: r'ArchitectureDrift',
  id: -4613768010456829320,
  properties: {
    r'classification': PropertySchema(
      id: 0,
      name: r'classification',
      type: IsarType.string,
    ),
    r'detectedAt': PropertySchema(
      id: 1,
      name: r'detectedAt',
      type: IsarType.dateTime,
    ),
    r'expected': PropertySchema(
      id: 2,
      name: r'expected',
      type: IsarType.string,
    ),
    r'isAcknowledged': PropertySchema(
      id: 3,
      name: r'isAcknowledged',
      type: IsarType.bool,
    ),
    r'missing': PropertySchema(
      id: 4,
      name: r'missing',
      type: IsarType.string,
    ),
    r'notes': PropertySchema(
      id: 5,
      name: r'notes',
      type: IsarType.string,
    ),
    r'observed': PropertySchema(
      id: 6,
      name: r'observed',
      type: IsarType.string,
    ),
    r'projectId': PropertySchema(
      id: 7,
      name: r'projectId',
      type: IsarType.long,
    ),
    r'projectTitle': PropertySchema(
      id: 8,
      name: r'projectTitle',
      type: IsarType.string,
    )
  },
  estimateSize: _architectureDriftEstimateSize,
  serialize: _architectureDriftSerialize,
  deserialize: _architectureDriftDeserialize,
  deserializeProp: _architectureDriftDeserializeProp,
  idName: r'id',
  indexes: {
    r'projectId': IndexSchema(
      id: 3305656282123791113,
      name: r'projectId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'projectId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _architectureDriftGetId,
  getLinks: _architectureDriftGetLinks,
  attach: _architectureDriftAttach,
  version: '3.1.0+1',
);

int _architectureDriftEstimateSize(
  ArchitectureDrift object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.classification.length * 3;
  bytesCount += 3 + object.expected.length * 3;
  bytesCount += 3 + object.missing.length * 3;
  bytesCount += 3 + object.notes.length * 3;
  bytesCount += 3 + object.observed.length * 3;
  bytesCount += 3 + object.projectTitle.length * 3;
  return bytesCount;
}

void _architectureDriftSerialize(
  ArchitectureDrift object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.classification);
  writer.writeDateTime(offsets[1], object.detectedAt);
  writer.writeString(offsets[2], object.expected);
  writer.writeBool(offsets[3], object.isAcknowledged);
  writer.writeString(offsets[4], object.missing);
  writer.writeString(offsets[5], object.notes);
  writer.writeString(offsets[6], object.observed);
  writer.writeLong(offsets[7], object.projectId);
  writer.writeString(offsets[8], object.projectTitle);
}

ArchitectureDrift _architectureDriftDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ArchitectureDrift();
  object.classification = reader.readString(offsets[0]);
  object.detectedAt = reader.readDateTime(offsets[1]);
  object.expected = reader.readString(offsets[2]);
  object.id = id;
  object.isAcknowledged = reader.readBool(offsets[3]);
  object.missing = reader.readString(offsets[4]);
  object.notes = reader.readString(offsets[5]);
  object.observed = reader.readString(offsets[6]);
  object.projectId = reader.readLong(offsets[7]);
  object.projectTitle = reader.readString(offsets[8]);
  return object;
}

P _architectureDriftDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readBool(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _architectureDriftGetId(ArchitectureDrift object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _architectureDriftGetLinks(
    ArchitectureDrift object) {
  return [];
}

void _architectureDriftAttach(
    IsarCollection<dynamic> col, Id id, ArchitectureDrift object) {
  object.id = id;
}

extension ArchitectureDriftQueryWhereSort
    on QueryBuilder<ArchitectureDrift, ArchitectureDrift, QWhere> {
  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterWhere>
      anyProjectId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'projectId'),
      );
    });
  }
}

extension ArchitectureDriftQueryWhere
    on QueryBuilder<ArchitectureDrift, ArchitectureDrift, QWhereClause> {
  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterWhereClause>
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

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterWhereClause>
      idBetween(
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

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterWhereClause>
      projectIdEqualTo(int projectId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'projectId',
        value: [projectId],
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterWhereClause>
      projectIdNotEqualTo(int projectId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'projectId',
              lower: [],
              upper: [projectId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'projectId',
              lower: [projectId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'projectId',
              lower: [projectId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'projectId',
              lower: [],
              upper: [projectId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterWhereClause>
      projectIdGreaterThan(
    int projectId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'projectId',
        lower: [projectId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterWhereClause>
      projectIdLessThan(
    int projectId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'projectId',
        lower: [],
        upper: [projectId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterWhereClause>
      projectIdBetween(
    int lowerProjectId,
    int upperProjectId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'projectId',
        lower: [lowerProjectId],
        includeLower: includeLower,
        upper: [upperProjectId],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension ArchitectureDriftQueryFilter
    on QueryBuilder<ArchitectureDrift, ArchitectureDrift, QFilterCondition> {
  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      classificationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'classification',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      classificationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'classification',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      classificationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'classification',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      classificationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'classification',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      classificationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'classification',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      classificationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'classification',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      classificationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'classification',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      classificationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'classification',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      classificationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'classification',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      classificationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'classification',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      detectedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'detectedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      detectedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'detectedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      detectedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'detectedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      detectedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'detectedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      expectedEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expected',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      expectedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'expected',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      expectedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'expected',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      expectedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'expected',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      expectedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'expected',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      expectedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'expected',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      expectedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'expected',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      expectedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'expected',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      expectedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'expected',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      expectedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'expected',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
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

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
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

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
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

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      isAcknowledgedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isAcknowledged',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      missingEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'missing',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      missingGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'missing',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      missingLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'missing',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      missingBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'missing',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      missingStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'missing',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      missingEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'missing',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      missingContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'missing',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      missingMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'missing',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      missingIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'missing',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      missingIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'missing',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      notesEqualTo(
    String value, {
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

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      notesGreaterThan(
    String value, {
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

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      notesLessThan(
    String value, {
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

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      notesBetween(
    String lower,
    String upper, {
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

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      notesStartsWith(
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

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      notesEndsWith(
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

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      notesContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'notes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      notesMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'notes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      notesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      notesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'notes',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      observedEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'observed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      observedGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'observed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      observedLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'observed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      observedBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'observed',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      observedStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'observed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      observedEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'observed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      observedContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'observed',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      observedMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'observed',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      observedIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'observed',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      observedIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'observed',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      projectIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'projectId',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      projectIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'projectId',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      projectIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'projectId',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      projectIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'projectId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      projectTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'projectTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      projectTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'projectTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      projectTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'projectTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      projectTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'projectTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      projectTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'projectTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      projectTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'projectTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      projectTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'projectTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      projectTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'projectTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      projectTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'projectTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterFilterCondition>
      projectTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'projectTitle',
        value: '',
      ));
    });
  }
}

extension ArchitectureDriftQueryObject
    on QueryBuilder<ArchitectureDrift, ArchitectureDrift, QFilterCondition> {}

extension ArchitectureDriftQueryLinks
    on QueryBuilder<ArchitectureDrift, ArchitectureDrift, QFilterCondition> {}

extension ArchitectureDriftQuerySortBy
    on QueryBuilder<ArchitectureDrift, ArchitectureDrift, QSortBy> {
  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      sortByClassification() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'classification', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      sortByClassificationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'classification', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      sortByDetectedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detectedAt', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      sortByDetectedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detectedAt', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      sortByExpected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expected', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      sortByExpectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expected', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      sortByIsAcknowledged() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAcknowledged', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      sortByIsAcknowledgedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAcknowledged', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      sortByMissing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missing', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      sortByMissingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missing', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      sortByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      sortByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      sortByObserved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observed', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      sortByObservedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observed', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      sortByProjectId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectId', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      sortByProjectIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectId', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      sortByProjectTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectTitle', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      sortByProjectTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectTitle', Sort.desc);
    });
  }
}

extension ArchitectureDriftQuerySortThenBy
    on QueryBuilder<ArchitectureDrift, ArchitectureDrift, QSortThenBy> {
  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      thenByClassification() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'classification', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      thenByClassificationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'classification', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      thenByDetectedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detectedAt', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      thenByDetectedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'detectedAt', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      thenByExpected() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expected', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      thenByExpectedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'expected', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      thenByIsAcknowledged() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAcknowledged', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      thenByIsAcknowledgedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isAcknowledged', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      thenByMissing() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missing', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      thenByMissingDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'missing', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      thenByNotes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      thenByNotesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'notes', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      thenByObserved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observed', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      thenByObservedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'observed', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      thenByProjectId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectId', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      thenByProjectIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectId', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      thenByProjectTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectTitle', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QAfterSortBy>
      thenByProjectTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectTitle', Sort.desc);
    });
  }
}

extension ArchitectureDriftQueryWhereDistinct
    on QueryBuilder<ArchitectureDrift, ArchitectureDrift, QDistinct> {
  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QDistinct>
      distinctByClassification({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'classification',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QDistinct>
      distinctByDetectedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'detectedAt');
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QDistinct>
      distinctByExpected({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'expected', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QDistinct>
      distinctByIsAcknowledged() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isAcknowledged');
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QDistinct>
      distinctByMissing({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'missing', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QDistinct> distinctByNotes(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'notes', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QDistinct>
      distinctByObserved({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'observed', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QDistinct>
      distinctByProjectId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'projectId');
    });
  }

  QueryBuilder<ArchitectureDrift, ArchitectureDrift, QDistinct>
      distinctByProjectTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'projectTitle', caseSensitive: caseSensitive);
    });
  }
}

extension ArchitectureDriftQueryProperty
    on QueryBuilder<ArchitectureDrift, ArchitectureDrift, QQueryProperty> {
  QueryBuilder<ArchitectureDrift, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ArchitectureDrift, String, QQueryOperations>
      classificationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'classification');
    });
  }

  QueryBuilder<ArchitectureDrift, DateTime, QQueryOperations>
      detectedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'detectedAt');
    });
  }

  QueryBuilder<ArchitectureDrift, String, QQueryOperations> expectedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'expected');
    });
  }

  QueryBuilder<ArchitectureDrift, bool, QQueryOperations>
      isAcknowledgedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isAcknowledged');
    });
  }

  QueryBuilder<ArchitectureDrift, String, QQueryOperations> missingProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'missing');
    });
  }

  QueryBuilder<ArchitectureDrift, String, QQueryOperations> notesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'notes');
    });
  }

  QueryBuilder<ArchitectureDrift, String, QQueryOperations> observedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'observed');
    });
  }

  QueryBuilder<ArchitectureDrift, int, QQueryOperations> projectIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'projectId');
    });
  }

  QueryBuilder<ArchitectureDrift, String, QQueryOperations>
      projectTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'projectTitle');
    });
  }
}
