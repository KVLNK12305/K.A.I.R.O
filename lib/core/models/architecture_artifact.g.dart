// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'architecture_artifact.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetArchitectureArtifactCollection on Isar {
  IsarCollection<ArchitectureArtifact> get architectureArtifacts =>
      this.collection();
}

const ArchitectureArtifactSchema = CollectionSchema(
  name: r'ArchitectureArtifact',
  id: 8620127513297042873,
  properties: {
    r'architectureType': PropertySchema(
      id: 0,
      name: r'architectureType',
      type: IsarType.string,
    ),
    r'declaredEdges': PropertySchema(
      id: 1,
      name: r'declaredEdges',
      type: IsarType.stringList,
    ),
    r'declaredNodes': PropertySchema(
      id: 2,
      name: r'declaredNodes',
      type: IsarType.stringList,
    ),
    r'lastSyncedAt': PropertySchema(
      id: 3,
      name: r'lastSyncedAt',
      type: IsarType.dateTime,
    ),
    r'projectId': PropertySchema(
      id: 4,
      name: r'projectId',
      type: IsarType.long,
    ),
    r'projectTitle': PropertySchema(
      id: 5,
      name: r'projectTitle',
      type: IsarType.string,
    ),
    r'rawMermaid': PropertySchema(
      id: 6,
      name: r'rawMermaid',
      type: IsarType.string,
    ),
    r'sourcePath': PropertySchema(
      id: 7,
      name: r'sourcePath',
      type: IsarType.string,
    )
  },
  estimateSize: _architectureArtifactEstimateSize,
  serialize: _architectureArtifactSerialize,
  deserialize: _architectureArtifactDeserialize,
  deserializeProp: _architectureArtifactDeserializeProp,
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
  getId: _architectureArtifactGetId,
  getLinks: _architectureArtifactGetLinks,
  attach: _architectureArtifactAttach,
  version: '3.1.0+1',
);

int _architectureArtifactEstimateSize(
  ArchitectureArtifact object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.architectureType.length * 3;
  bytesCount += 3 + object.declaredEdges.length * 3;
  {
    for (var i = 0; i < object.declaredEdges.length; i++) {
      final value = object.declaredEdges[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.declaredNodes.length * 3;
  {
    for (var i = 0; i < object.declaredNodes.length; i++) {
      final value = object.declaredNodes[i];
      bytesCount += value.length * 3;
    }
  }
  bytesCount += 3 + object.projectTitle.length * 3;
  bytesCount += 3 + object.rawMermaid.length * 3;
  bytesCount += 3 + object.sourcePath.length * 3;
  return bytesCount;
}

void _architectureArtifactSerialize(
  ArchitectureArtifact object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.architectureType);
  writer.writeStringList(offsets[1], object.declaredEdges);
  writer.writeStringList(offsets[2], object.declaredNodes);
  writer.writeDateTime(offsets[3], object.lastSyncedAt);
  writer.writeLong(offsets[4], object.projectId);
  writer.writeString(offsets[5], object.projectTitle);
  writer.writeString(offsets[6], object.rawMermaid);
  writer.writeString(offsets[7], object.sourcePath);
}

ArchitectureArtifact _architectureArtifactDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ArchitectureArtifact();
  object.architectureType = reader.readString(offsets[0]);
  object.declaredEdges = reader.readStringList(offsets[1]) ?? [];
  object.declaredNodes = reader.readStringList(offsets[2]) ?? [];
  object.id = id;
  object.lastSyncedAt = reader.readDateTime(offsets[3]);
  object.projectId = reader.readLong(offsets[4]);
  object.projectTitle = reader.readString(offsets[5]);
  object.rawMermaid = reader.readString(offsets[6]);
  object.sourcePath = reader.readString(offsets[7]);
  return object;
}

P _architectureArtifactDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readStringList(offset) ?? []) as P;
    case 2:
      return (reader.readStringList(offset) ?? []) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _architectureArtifactGetId(ArchitectureArtifact object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _architectureArtifactGetLinks(
    ArchitectureArtifact object) {
  return [];
}

void _architectureArtifactAttach(
    IsarCollection<dynamic> col, Id id, ArchitectureArtifact object) {
  object.id = id;
}

extension ArchitectureArtifactQueryWhereSort
    on QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QWhere> {
  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterWhere>
      anyProjectId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'projectId'),
      );
    });
  }
}

extension ArchitectureArtifactQueryWhere
    on QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QWhereClause> {
  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterWhereClause>
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

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterWhereClause>
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

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterWhereClause>
      projectIdEqualTo(int projectId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'projectId',
        value: [projectId],
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterWhereClause>
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

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterWhereClause>
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

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterWhereClause>
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

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterWhereClause>
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

extension ArchitectureArtifactQueryFilter on QueryBuilder<ArchitectureArtifact,
    ArchitectureArtifact, QFilterCondition> {
  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> architectureTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'architectureType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> architectureTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'architectureType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> architectureTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'architectureType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> architectureTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'architectureType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> architectureTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'architectureType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> architectureTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'architectureType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
          QAfterFilterCondition>
      architectureTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'architectureType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
          QAfterFilterCondition>
      architectureTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'architectureType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> architectureTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'architectureType',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> architectureTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'architectureType',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredEdgesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'declaredEdges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredEdgesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'declaredEdges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredEdgesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'declaredEdges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredEdgesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'declaredEdges',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredEdgesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'declaredEdges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredEdgesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'declaredEdges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
          QAfterFilterCondition>
      declaredEdgesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'declaredEdges',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
          QAfterFilterCondition>
      declaredEdgesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'declaredEdges',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredEdgesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'declaredEdges',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredEdgesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'declaredEdges',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredEdgesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'declaredEdges',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredEdgesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'declaredEdges',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredEdgesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'declaredEdges',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredEdgesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'declaredEdges',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredEdgesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'declaredEdges',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredEdgesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'declaredEdges',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredNodesElementEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'declaredNodes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredNodesElementGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'declaredNodes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredNodesElementLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'declaredNodes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredNodesElementBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'declaredNodes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredNodesElementStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'declaredNodes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredNodesElementEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'declaredNodes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
          QAfterFilterCondition>
      declaredNodesElementContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'declaredNodes',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
          QAfterFilterCondition>
      declaredNodesElementMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'declaredNodes',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredNodesElementIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'declaredNodes',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredNodesElementIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'declaredNodes',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredNodesLengthEqualTo(int length) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'declaredNodes',
        length,
        true,
        length,
        true,
      );
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredNodesIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'declaredNodes',
        0,
        true,
        0,
        true,
      );
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredNodesIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'declaredNodes',
        0,
        false,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredNodesLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'declaredNodes',
        0,
        true,
        length,
        include,
      );
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredNodesLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'declaredNodes',
        length,
        include,
        999999,
        true,
      );
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> declaredNodesLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.listLength(
        r'declaredNodes',
        lower,
        includeLower,
        upper,
        includeUpper,
      );
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> idBetween(
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

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> lastSyncedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> lastSyncedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> lastSyncedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSyncedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> lastSyncedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSyncedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> projectIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'projectId',
        value: value,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> projectIdGreaterThan(
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

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> projectIdLessThan(
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

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> projectIdBetween(
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

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> projectTitleEqualTo(
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

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> projectTitleGreaterThan(
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

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> projectTitleLessThan(
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

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> projectTitleBetween(
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

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> projectTitleStartsWith(
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

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> projectTitleEndsWith(
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

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
          QAfterFilterCondition>
      projectTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'projectTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
          QAfterFilterCondition>
      projectTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'projectTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> projectTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'projectTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> projectTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'projectTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> rawMermaidEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawMermaid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> rawMermaidGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawMermaid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> rawMermaidLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawMermaid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> rawMermaidBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawMermaid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> rawMermaidStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawMermaid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> rawMermaidEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawMermaid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
          QAfterFilterCondition>
      rawMermaidContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawMermaid',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
          QAfterFilterCondition>
      rawMermaidMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawMermaid',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> rawMermaidIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawMermaid',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> rawMermaidIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawMermaid',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> sourcePathEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourcePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> sourcePathGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourcePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> sourcePathLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourcePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> sourcePathBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourcePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> sourcePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourcePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> sourcePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourcePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
          QAfterFilterCondition>
      sourcePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourcePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
          QAfterFilterCondition>
      sourcePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourcePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> sourcePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourcePath',
        value: '',
      ));
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact,
      QAfterFilterCondition> sourcePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourcePath',
        value: '',
      ));
    });
  }
}

extension ArchitectureArtifactQueryObject on QueryBuilder<ArchitectureArtifact,
    ArchitectureArtifact, QFilterCondition> {}

extension ArchitectureArtifactQueryLinks on QueryBuilder<ArchitectureArtifact,
    ArchitectureArtifact, QFilterCondition> {}

extension ArchitectureArtifactQuerySortBy
    on QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QSortBy> {
  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      sortByArchitectureType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'architectureType', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      sortByArchitectureTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'architectureType', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      sortByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      sortByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      sortByProjectId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectId', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      sortByProjectIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectId', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      sortByProjectTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectTitle', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      sortByProjectTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectTitle', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      sortByRawMermaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawMermaid', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      sortByRawMermaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawMermaid', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      sortBySourcePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourcePath', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      sortBySourcePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourcePath', Sort.desc);
    });
  }
}

extension ArchitectureArtifactQuerySortThenBy
    on QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QSortThenBy> {
  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      thenByArchitectureType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'architectureType', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      thenByArchitectureTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'architectureType', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      thenByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      thenByLastSyncedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSyncedAt', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      thenByProjectId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectId', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      thenByProjectIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectId', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      thenByProjectTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectTitle', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      thenByProjectTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'projectTitle', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      thenByRawMermaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawMermaid', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      thenByRawMermaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawMermaid', Sort.desc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      thenBySourcePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourcePath', Sort.asc);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QAfterSortBy>
      thenBySourcePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourcePath', Sort.desc);
    });
  }
}

extension ArchitectureArtifactQueryWhereDistinct
    on QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QDistinct> {
  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QDistinct>
      distinctByArchitectureType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'architectureType',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QDistinct>
      distinctByDeclaredEdges() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'declaredEdges');
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QDistinct>
      distinctByDeclaredNodes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'declaredNodes');
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QDistinct>
      distinctByLastSyncedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSyncedAt');
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QDistinct>
      distinctByProjectId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'projectId');
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QDistinct>
      distinctByProjectTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'projectTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QDistinct>
      distinctByRawMermaid({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawMermaid', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ArchitectureArtifact, ArchitectureArtifact, QDistinct>
      distinctBySourcePath({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourcePath', caseSensitive: caseSensitive);
    });
  }
}

extension ArchitectureArtifactQueryProperty on QueryBuilder<
    ArchitectureArtifact, ArchitectureArtifact, QQueryProperty> {
  QueryBuilder<ArchitectureArtifact, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ArchitectureArtifact, String, QQueryOperations>
      architectureTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'architectureType');
    });
  }

  QueryBuilder<ArchitectureArtifact, List<String>, QQueryOperations>
      declaredEdgesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'declaredEdges');
    });
  }

  QueryBuilder<ArchitectureArtifact, List<String>, QQueryOperations>
      declaredNodesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'declaredNodes');
    });
  }

  QueryBuilder<ArchitectureArtifact, DateTime, QQueryOperations>
      lastSyncedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSyncedAt');
    });
  }

  QueryBuilder<ArchitectureArtifact, int, QQueryOperations>
      projectIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'projectId');
    });
  }

  QueryBuilder<ArchitectureArtifact, String, QQueryOperations>
      projectTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'projectTitle');
    });
  }

  QueryBuilder<ArchitectureArtifact, String, QQueryOperations>
      rawMermaidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawMermaid');
    });
  }

  QueryBuilder<ArchitectureArtifact, String, QQueryOperations>
      sourcePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourcePath');
    });
  }
}
