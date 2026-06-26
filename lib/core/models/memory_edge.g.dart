// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'memory_edge.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetMemoryEdgeCollection on Isar {
  IsarCollection<MemoryEdge> get memoryEdges => this.collection();
}

const MemoryEdgeSchema = CollectionSchema(
  name: r'MemoryEdge',
  id: 2749767584170770699,
  properties: {
    r'createdAt': PropertySchema(
      id: 0,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'relationType': PropertySchema(
      id: 1,
      name: r'relationType',
      type: IsarType.string,
    ),
    r'sourceCollection': PropertySchema(
      id: 2,
      name: r'sourceCollection',
      type: IsarType.string,
    ),
    r'sourceId': PropertySchema(
      id: 3,
      name: r'sourceId',
      type: IsarType.long,
    ),
    r'sourceTitle': PropertySchema(
      id: 4,
      name: r'sourceTitle',
      type: IsarType.string,
    ),
    r'targetCollection': PropertySchema(
      id: 5,
      name: r'targetCollection',
      type: IsarType.string,
    ),
    r'targetId': PropertySchema(
      id: 6,
      name: r'targetId',
      type: IsarType.long,
    ),
    r'targetTitle': PropertySchema(
      id: 7,
      name: r'targetTitle',
      type: IsarType.string,
    )
  },
  estimateSize: _memoryEdgeEstimateSize,
  serialize: _memoryEdgeSerialize,
  deserialize: _memoryEdgeDeserialize,
  deserializeProp: _memoryEdgeDeserializeProp,
  idName: r'id',
  indexes: {
    r'sourceCollection': IndexSchema(
      id: -6677269880498022492,
      name: r'sourceCollection',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sourceCollection',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'sourceId': IndexSchema(
      id: 2155220942429093580,
      name: r'sourceId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sourceId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'targetCollection': IndexSchema(
      id: -4383689856359152590,
      name: r'targetCollection',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'targetCollection',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'targetId': IndexSchema(
      id: -7400732725972739031,
      name: r'targetId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'targetId',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'relationType': IndexSchema(
      id: -2445114756645216302,
      name: r'relationType',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'relationType',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _memoryEdgeGetId,
  getLinks: _memoryEdgeGetLinks,
  attach: _memoryEdgeAttach,
  version: '3.1.0+1',
);

int _memoryEdgeEstimateSize(
  MemoryEdge object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.relationType.length * 3;
  bytesCount += 3 + object.sourceCollection.length * 3;
  bytesCount += 3 + object.sourceTitle.length * 3;
  bytesCount += 3 + object.targetCollection.length * 3;
  bytesCount += 3 + object.targetTitle.length * 3;
  return bytesCount;
}

void _memoryEdgeSerialize(
  MemoryEdge object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDateTime(offsets[0], object.createdAt);
  writer.writeString(offsets[1], object.relationType);
  writer.writeString(offsets[2], object.sourceCollection);
  writer.writeLong(offsets[3], object.sourceId);
  writer.writeString(offsets[4], object.sourceTitle);
  writer.writeString(offsets[5], object.targetCollection);
  writer.writeLong(offsets[6], object.targetId);
  writer.writeString(offsets[7], object.targetTitle);
}

MemoryEdge _memoryEdgeDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = MemoryEdge(
    relationType: reader.readString(offsets[1]),
    sourceCollection: reader.readString(offsets[2]),
    sourceId: reader.readLong(offsets[3]),
    sourceTitle: reader.readString(offsets[4]),
    targetCollection: reader.readString(offsets[5]),
    targetId: reader.readLong(offsets[6]),
    targetTitle: reader.readString(offsets[7]),
  );
  object.createdAt = reader.readDateTime(offsets[0]);
  object.id = id;
  return object;
}

P _memoryEdgeDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _memoryEdgeGetId(MemoryEdge object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _memoryEdgeGetLinks(MemoryEdge object) {
  return [];
}

void _memoryEdgeAttach(IsarCollection<dynamic> col, Id id, MemoryEdge object) {
  object.id = id;
}

extension MemoryEdgeQueryWhereSort
    on QueryBuilder<MemoryEdge, MemoryEdge, QWhere> {
  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhere> anySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'sourceId'),
      );
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhere> anyTargetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'targetId'),
      );
    });
  }
}

extension MemoryEdgeQueryWhere
    on QueryBuilder<MemoryEdge, MemoryEdge, QWhereClause> {
  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause> idBetween(
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

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause>
      sourceCollectionEqualTo(String sourceCollection) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceCollection',
        value: [sourceCollection],
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause>
      sourceCollectionNotEqualTo(String sourceCollection) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceCollection',
              lower: [],
              upper: [sourceCollection],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceCollection',
              lower: [sourceCollection],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceCollection',
              lower: [sourceCollection],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceCollection',
              lower: [],
              upper: [sourceCollection],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause> sourceIdEqualTo(
      int sourceId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceId',
        value: [sourceId],
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause> sourceIdNotEqualTo(
      int sourceId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId',
              lower: [],
              upper: [sourceId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId',
              lower: [sourceId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId',
              lower: [sourceId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceId',
              lower: [],
              upper: [sourceId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause> sourceIdGreaterThan(
    int sourceId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sourceId',
        lower: [sourceId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause> sourceIdLessThan(
    int sourceId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sourceId',
        lower: [],
        upper: [sourceId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause> sourceIdBetween(
    int lowerSourceId,
    int upperSourceId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sourceId',
        lower: [lowerSourceId],
        includeLower: includeLower,
        upper: [upperSourceId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause>
      targetCollectionEqualTo(String targetCollection) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'targetCollection',
        value: [targetCollection],
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause>
      targetCollectionNotEqualTo(String targetCollection) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'targetCollection',
              lower: [],
              upper: [targetCollection],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'targetCollection',
              lower: [targetCollection],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'targetCollection',
              lower: [targetCollection],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'targetCollection',
              lower: [],
              upper: [targetCollection],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause> targetIdEqualTo(
      int targetId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'targetId',
        value: [targetId],
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause> targetIdNotEqualTo(
      int targetId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'targetId',
              lower: [],
              upper: [targetId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'targetId',
              lower: [targetId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'targetId',
              lower: [targetId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'targetId',
              lower: [],
              upper: [targetId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause> targetIdGreaterThan(
    int targetId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'targetId',
        lower: [targetId],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause> targetIdLessThan(
    int targetId, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'targetId',
        lower: [],
        upper: [targetId],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause> targetIdBetween(
    int lowerTargetId,
    int upperTargetId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'targetId',
        lower: [lowerTargetId],
        includeLower: includeLower,
        upper: [upperTargetId],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause> relationTypeEqualTo(
      String relationType) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'relationType',
        value: [relationType],
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterWhereClause>
      relationTypeNotEqualTo(String relationType) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'relationType',
              lower: [],
              upper: [relationType],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'relationType',
              lower: [relationType],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'relationType',
              lower: [relationType],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'relationType',
              lower: [],
              upper: [relationType],
              includeUpper: false,
            ));
      }
    });
  }
}

extension MemoryEdgeQueryFilter
    on QueryBuilder<MemoryEdge, MemoryEdge, QFilterCondition> {
  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition> createdAtEqualTo(
      DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'createdAt',
        value: value,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
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

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition> createdAtLessThan(
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

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition> createdAtBetween(
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

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition> idBetween(
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

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      relationTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      relationTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'relationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      relationTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'relationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      relationTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'relationType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      relationTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'relationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      relationTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'relationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      relationTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'relationType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      relationTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'relationType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      relationTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'relationType',
        value: '',
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      relationTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'relationType',
        value: '',
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceCollectionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceCollection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceCollectionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceCollection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceCollectionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceCollection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceCollectionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceCollection',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceCollectionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceCollection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceCollectionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceCollection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceCollectionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceCollection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceCollectionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceCollection',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceCollectionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceCollection',
        value: '',
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceCollectionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceCollection',
        value: '',
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition> sourceIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition> sourceIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceId',
        value: value,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition> sourceIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      sourceTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetCollectionEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetCollection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetCollectionGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetCollection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetCollectionLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetCollection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetCollectionBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetCollection',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetCollectionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'targetCollection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetCollectionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'targetCollection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetCollectionContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'targetCollection',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetCollectionMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'targetCollection',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetCollectionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetCollection',
        value: '',
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetCollectionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'targetCollection',
        value: '',
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition> targetIdEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetId',
        value: value,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetId',
        value: value,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition> targetIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetId',
        value: value,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition> targetIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'targetTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'targetTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'targetTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'targetTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterFilterCondition>
      targetTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'targetTitle',
        value: '',
      ));
    });
  }
}

extension MemoryEdgeQueryObject
    on QueryBuilder<MemoryEdge, MemoryEdge, QFilterCondition> {}

extension MemoryEdgeQueryLinks
    on QueryBuilder<MemoryEdge, MemoryEdge, QFilterCondition> {}

extension MemoryEdgeQuerySortBy
    on QueryBuilder<MemoryEdge, MemoryEdge, QSortBy> {
  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> sortByRelationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationType', Sort.asc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> sortByRelationTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationType', Sort.desc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> sortBySourceCollection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceCollection', Sort.asc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy>
      sortBySourceCollectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceCollection', Sort.desc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> sortBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> sortBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> sortBySourceTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceTitle', Sort.asc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> sortBySourceTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceTitle', Sort.desc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> sortByTargetCollection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetCollection', Sort.asc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy>
      sortByTargetCollectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetCollection', Sort.desc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> sortByTargetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetId', Sort.asc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> sortByTargetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetId', Sort.desc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> sortByTargetTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetTitle', Sort.asc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> sortByTargetTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetTitle', Sort.desc);
    });
  }
}

extension MemoryEdgeQuerySortThenBy
    on QueryBuilder<MemoryEdge, MemoryEdge, QSortThenBy> {
  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> thenByRelationType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationType', Sort.asc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> thenByRelationTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'relationType', Sort.desc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> thenBySourceCollection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceCollection', Sort.asc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy>
      thenBySourceCollectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceCollection', Sort.desc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> thenBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.asc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> thenBySourceIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceId', Sort.desc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> thenBySourceTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceTitle', Sort.asc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> thenBySourceTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceTitle', Sort.desc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> thenByTargetCollection() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetCollection', Sort.asc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy>
      thenByTargetCollectionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetCollection', Sort.desc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> thenByTargetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetId', Sort.asc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> thenByTargetIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetId', Sort.desc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> thenByTargetTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetTitle', Sort.asc);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QAfterSortBy> thenByTargetTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetTitle', Sort.desc);
    });
  }
}

extension MemoryEdgeQueryWhereDistinct
    on QueryBuilder<MemoryEdge, MemoryEdge, QDistinct> {
  QueryBuilder<MemoryEdge, MemoryEdge, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QDistinct> distinctByRelationType(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'relationType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QDistinct> distinctBySourceCollection(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceCollection',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QDistinct> distinctBySourceId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceId');
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QDistinct> distinctBySourceTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QDistinct> distinctByTargetCollection(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetCollection',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QDistinct> distinctByTargetId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetId');
    });
  }

  QueryBuilder<MemoryEdge, MemoryEdge, QDistinct> distinctByTargetTitle(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetTitle', caseSensitive: caseSensitive);
    });
  }
}

extension MemoryEdgeQueryProperty
    on QueryBuilder<MemoryEdge, MemoryEdge, QQueryProperty> {
  QueryBuilder<MemoryEdge, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<MemoryEdge, DateTime, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<MemoryEdge, String, QQueryOperations> relationTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'relationType');
    });
  }

  QueryBuilder<MemoryEdge, String, QQueryOperations>
      sourceCollectionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceCollection');
    });
  }

  QueryBuilder<MemoryEdge, int, QQueryOperations> sourceIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceId');
    });
  }

  QueryBuilder<MemoryEdge, String, QQueryOperations> sourceTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceTitle');
    });
  }

  QueryBuilder<MemoryEdge, String, QQueryOperations>
      targetCollectionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetCollection');
    });
  }

  QueryBuilder<MemoryEdge, int, QQueryOperations> targetIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetId');
    });
  }

  QueryBuilder<MemoryEdge, String, QQueryOperations> targetTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetTitle');
    });
  }
}
