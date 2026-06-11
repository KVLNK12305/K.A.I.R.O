// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'psychosomatic_scan.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPsychosomaticScanCollection on Isar {
  IsarCollection<PsychosomaticScan> get psychosomaticScans => this.collection();
}

const PsychosomaticScanSchema = CollectionSchema(
  name: r'PsychosomaticScan',
  id: 814732881193157451,
  properties: {
    r'breathDepth': PropertySchema(
      id: 0,
      name: r'breathDepth',
      type: IsarType.long,
    ),
    r'contextLabel': PropertySchema(
      id: 1,
      name: r'contextLabel',
      type: IsarType.string,
    ),
    r'date': PropertySchema(
      id: 2,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'energyLevel': PropertySchema(
      id: 3,
      name: r'energyLevel',
      type: IsarType.long,
    ),
    r'headStomachDisturbance': PropertySchema(
      id: 4,
      name: r'headStomachDisturbance',
      type: IsarType.long,
    ),
    r'jawClench': PropertySchema(
      id: 5,
      name: r'jawClench',
      type: IsarType.long,
    ),
    r'muscleTension': PropertySchema(
      id: 6,
      name: r'muscleTension',
      type: IsarType.long,
    ),
    r'posture': PropertySchema(
      id: 7,
      name: r'posture',
      type: IsarType.long,
    ),
    r'skinReaction': PropertySchema(
      id: 8,
      name: r'skinReaction',
      type: IsarType.long,
    ),
    r'stressScore': PropertySchema(
      id: 9,
      name: r'stressScore',
      type: IsarType.double,
    )
  },
  estimateSize: _psychosomaticScanEstimateSize,
  serialize: _psychosomaticScanSerialize,
  deserialize: _psychosomaticScanDeserialize,
  deserializeProp: _psychosomaticScanDeserializeProp,
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
  getId: _psychosomaticScanGetId,
  getLinks: _psychosomaticScanGetLinks,
  attach: _psychosomaticScanAttach,
  version: '3.1.0+1',
);

int _psychosomaticScanEstimateSize(
  PsychosomaticScan object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.contextLabel.length * 3;
  return bytesCount;
}

void _psychosomaticScanSerialize(
  PsychosomaticScan object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.breathDepth);
  writer.writeString(offsets[1], object.contextLabel);
  writer.writeDateTime(offsets[2], object.date);
  writer.writeLong(offsets[3], object.energyLevel);
  writer.writeLong(offsets[4], object.headStomachDisturbance);
  writer.writeLong(offsets[5], object.jawClench);
  writer.writeLong(offsets[6], object.muscleTension);
  writer.writeLong(offsets[7], object.posture);
  writer.writeLong(offsets[8], object.skinReaction);
  writer.writeDouble(offsets[9], object.stressScore);
}

PsychosomaticScan _psychosomaticScanDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PsychosomaticScan();
  object.breathDepth = reader.readLong(offsets[0]);
  object.contextLabel = reader.readString(offsets[1]);
  object.date = reader.readDateTime(offsets[2]);
  object.energyLevel = reader.readLong(offsets[3]);
  object.headStomachDisturbance = reader.readLong(offsets[4]);
  object.id = id;
  object.jawClench = reader.readLong(offsets[5]);
  object.muscleTension = reader.readLong(offsets[6]);
  object.posture = reader.readLong(offsets[7]);
  object.skinReaction = reader.readLong(offsets[8]);
  return object;
}

P _psychosomaticScanDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readLong(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _psychosomaticScanGetId(PsychosomaticScan object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _psychosomaticScanGetLinks(
    PsychosomaticScan object) {
  return [];
}

void _psychosomaticScanAttach(
    IsarCollection<dynamic> col, Id id, PsychosomaticScan object) {
  object.id = id;
}

extension PsychosomaticScanByIndex on IsarCollection<PsychosomaticScan> {
  Future<PsychosomaticScan?> getByDate(DateTime date) {
    return getByIndex(r'date', [date]);
  }

  PsychosomaticScan? getByDateSync(DateTime date) {
    return getByIndexSync(r'date', [date]);
  }

  Future<bool> deleteByDate(DateTime date) {
    return deleteByIndex(r'date', [date]);
  }

  bool deleteByDateSync(DateTime date) {
    return deleteByIndexSync(r'date', [date]);
  }

  Future<List<PsychosomaticScan?>> getAllByDate(List<DateTime> dateValues) {
    final values = dateValues.map((e) => [e]).toList();
    return getAllByIndex(r'date', values);
  }

  List<PsychosomaticScan?> getAllByDateSync(List<DateTime> dateValues) {
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

  Future<Id> putByDate(PsychosomaticScan object) {
    return putByIndex(r'date', object);
  }

  Id putByDateSync(PsychosomaticScan object, {bool saveLinks = true}) {
    return putByIndexSync(r'date', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByDate(List<PsychosomaticScan> objects) {
    return putAllByIndex(r'date', objects);
  }

  List<Id> putAllByDateSync(List<PsychosomaticScan> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'date', objects, saveLinks: saveLinks);
  }
}

extension PsychosomaticScanQueryWhereSort
    on QueryBuilder<PsychosomaticScan, PsychosomaticScan, QWhere> {
  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterWhere> anyDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'date'),
      );
    });
  }
}

extension PsychosomaticScanQueryWhere
    on QueryBuilder<PsychosomaticScan, PsychosomaticScan, QWhereClause> {
  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterWhereClause>
      idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterWhereClause>
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

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterWhereClause>
      idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterWhereClause>
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

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterWhereClause>
      dateEqualTo(DateTime date) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'date',
        value: [date],
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterWhereClause>
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

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterWhereClause>
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

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterWhereClause>
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

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterWhereClause>
      dateBetween(
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

extension PsychosomaticScanQueryFilter
    on QueryBuilder<PsychosomaticScan, PsychosomaticScan, QFilterCondition> {
  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      breathDepthEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'breathDepth',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      breathDepthGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'breathDepth',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      breathDepthLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'breathDepth',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      breathDepthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'breathDepth',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      contextLabelEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contextLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      contextLabelGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'contextLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      contextLabelLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'contextLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      contextLabelBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'contextLabel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      contextLabelStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'contextLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      contextLabelEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'contextLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      contextLabelContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'contextLabel',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      contextLabelMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'contextLabel',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      contextLabelIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'contextLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      contextLabelIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'contextLabel',
        value: '',
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      dateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
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

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
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

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
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

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      energyLevelEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'energyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      energyLevelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'energyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      energyLevelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'energyLevel',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      energyLevelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'energyLevel',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      headStomachDisturbanceEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'headStomachDisturbance',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      headStomachDisturbanceGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'headStomachDisturbance',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      headStomachDisturbanceLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'headStomachDisturbance',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      headStomachDisturbanceBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'headStomachDisturbance',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
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

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
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

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
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

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      jawClenchEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'jawClench',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      jawClenchGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'jawClench',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      jawClenchLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'jawClench',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      jawClenchBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'jawClench',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      muscleTensionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'muscleTension',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      muscleTensionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'muscleTension',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      muscleTensionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'muscleTension',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      muscleTensionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'muscleTension',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      postureEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'posture',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      postureGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'posture',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      postureLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'posture',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      postureBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'posture',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      skinReactionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'skinReaction',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      skinReactionGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'skinReaction',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      skinReactionLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'skinReaction',
        value: value,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      skinReactionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'skinReaction',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      stressScoreEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stressScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      stressScoreGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stressScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      stressScoreLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stressScore',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterFilterCondition>
      stressScoreBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stressScore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension PsychosomaticScanQueryObject
    on QueryBuilder<PsychosomaticScan, PsychosomaticScan, QFilterCondition> {}

extension PsychosomaticScanQueryLinks
    on QueryBuilder<PsychosomaticScan, PsychosomaticScan, QFilterCondition> {}

extension PsychosomaticScanQuerySortBy
    on QueryBuilder<PsychosomaticScan, PsychosomaticScan, QSortBy> {
  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      sortByBreathDepth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breathDepth', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      sortByBreathDepthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breathDepth', Sort.desc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      sortByContextLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextLabel', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      sortByContextLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextLabel', Sort.desc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      sortByEnergyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyLevel', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      sortByEnergyLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyLevel', Sort.desc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      sortByHeadStomachDisturbance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headStomachDisturbance', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      sortByHeadStomachDisturbanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headStomachDisturbance', Sort.desc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      sortByJawClench() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jawClench', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      sortByJawClenchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jawClench', Sort.desc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      sortByMuscleTension() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleTension', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      sortByMuscleTensionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleTension', Sort.desc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      sortByPosture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posture', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      sortByPostureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posture', Sort.desc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      sortBySkinReaction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skinReaction', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      sortBySkinReactionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skinReaction', Sort.desc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      sortByStressScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stressScore', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      sortByStressScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stressScore', Sort.desc);
    });
  }
}

extension PsychosomaticScanQuerySortThenBy
    on QueryBuilder<PsychosomaticScan, PsychosomaticScan, QSortThenBy> {
  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenByBreathDepth() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breathDepth', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenByBreathDepthDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'breathDepth', Sort.desc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenByContextLabel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextLabel', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenByContextLabelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'contextLabel', Sort.desc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenByEnergyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyLevel', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenByEnergyLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'energyLevel', Sort.desc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenByHeadStomachDisturbance() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headStomachDisturbance', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenByHeadStomachDisturbanceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'headStomachDisturbance', Sort.desc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenByJawClench() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jawClench', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenByJawClenchDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'jawClench', Sort.desc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenByMuscleTension() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleTension', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenByMuscleTensionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'muscleTension', Sort.desc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenByPosture() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posture', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenByPostureDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'posture', Sort.desc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenBySkinReaction() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skinReaction', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenBySkinReactionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'skinReaction', Sort.desc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenByStressScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stressScore', Sort.asc);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QAfterSortBy>
      thenByStressScoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stressScore', Sort.desc);
    });
  }
}

extension PsychosomaticScanQueryWhereDistinct
    on QueryBuilder<PsychosomaticScan, PsychosomaticScan, QDistinct> {
  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QDistinct>
      distinctByBreathDepth() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'breathDepth');
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QDistinct>
      distinctByContextLabel({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'contextLabel', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QDistinct>
      distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QDistinct>
      distinctByEnergyLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'energyLevel');
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QDistinct>
      distinctByHeadStomachDisturbance() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'headStomachDisturbance');
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QDistinct>
      distinctByJawClench() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'jawClench');
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QDistinct>
      distinctByMuscleTension() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'muscleTension');
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QDistinct>
      distinctByPosture() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'posture');
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QDistinct>
      distinctBySkinReaction() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'skinReaction');
    });
  }

  QueryBuilder<PsychosomaticScan, PsychosomaticScan, QDistinct>
      distinctByStressScore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stressScore');
    });
  }
}

extension PsychosomaticScanQueryProperty
    on QueryBuilder<PsychosomaticScan, PsychosomaticScan, QQueryProperty> {
  QueryBuilder<PsychosomaticScan, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PsychosomaticScan, int, QQueryOperations> breathDepthProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'breathDepth');
    });
  }

  QueryBuilder<PsychosomaticScan, String, QQueryOperations>
      contextLabelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'contextLabel');
    });
  }

  QueryBuilder<PsychosomaticScan, DateTime, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<PsychosomaticScan, int, QQueryOperations> energyLevelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'energyLevel');
    });
  }

  QueryBuilder<PsychosomaticScan, int, QQueryOperations>
      headStomachDisturbanceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'headStomachDisturbance');
    });
  }

  QueryBuilder<PsychosomaticScan, int, QQueryOperations> jawClenchProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'jawClench');
    });
  }

  QueryBuilder<PsychosomaticScan, int, QQueryOperations>
      muscleTensionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'muscleTension');
    });
  }

  QueryBuilder<PsychosomaticScan, int, QQueryOperations> postureProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'posture');
    });
  }

  QueryBuilder<PsychosomaticScan, int, QQueryOperations>
      skinReactionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'skinReaction');
    });
  }

  QueryBuilder<PsychosomaticScan, double, QQueryOperations>
      stressScoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stressScore');
    });
  }
}
