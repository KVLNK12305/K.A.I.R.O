// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gita_shloka.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetGitaShlokaCollection on Isar {
  IsarCollection<GitaShloka> get gitaShlokas => this.collection();
}

const GitaShlokaSchema = CollectionSchema(
  name: r'GitaShloka',
  id: -4621519433409578866,
  properties: {
    r'chapter': PropertySchema(
      id: 0,
      name: r'chapter',
      type: IsarType.long,
    ),
    r'hindiTranslation': PropertySchema(
      id: 1,
      name: r'hindiTranslation',
      type: IsarType.string,
    ),
    r'slok': PropertySchema(
      id: 2,
      name: r'slok',
      type: IsarType.string,
    ),
    r'translation': PropertySchema(
      id: 3,
      name: r'translation',
      type: IsarType.string,
    ),
    r'transliteration': PropertySchema(
      id: 4,
      name: r'transliteration',
      type: IsarType.string,
    ),
    r'verse': PropertySchema(
      id: 5,
      name: r'verse',
      type: IsarType.long,
    )
  },
  estimateSize: _gitaShlokaEstimateSize,
  serialize: _gitaShlokaSerialize,
  deserialize: _gitaShlokaDeserialize,
  deserializeProp: _gitaShlokaDeserializeProp,
  idName: r'id',
  indexes: {
    r'chapter': IndexSchema(
      id: 3334647619021962063,
      name: r'chapter',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'chapter',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _gitaShlokaGetId,
  getLinks: _gitaShlokaGetLinks,
  attach: _gitaShlokaAttach,
  version: '3.1.0+1',
);

int _gitaShlokaEstimateSize(
  GitaShloka object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.hindiTranslation.length * 3;
  bytesCount += 3 + object.slok.length * 3;
  bytesCount += 3 + object.translation.length * 3;
  bytesCount += 3 + object.transliteration.length * 3;
  return bytesCount;
}

void _gitaShlokaSerialize(
  GitaShloka object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.chapter);
  writer.writeString(offsets[1], object.hindiTranslation);
  writer.writeString(offsets[2], object.slok);
  writer.writeString(offsets[3], object.translation);
  writer.writeString(offsets[4], object.transliteration);
  writer.writeLong(offsets[5], object.verse);
}

GitaShloka _gitaShlokaDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = GitaShloka(
    chapter: reader.readLong(offsets[0]),
    hindiTranslation: reader.readString(offsets[1]),
    slok: reader.readString(offsets[2]),
    translation: reader.readString(offsets[3]),
    transliteration: reader.readString(offsets[4]),
    verse: reader.readLong(offsets[5]),
  );
  object.id = id;
  return object;
}

P _gitaShlokaDeserializeProp<P>(
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
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readString(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _gitaShlokaGetId(GitaShloka object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _gitaShlokaGetLinks(GitaShloka object) {
  return [];
}

void _gitaShlokaAttach(IsarCollection<dynamic> col, Id id, GitaShloka object) {
  object.id = id;
}

extension GitaShlokaQueryWhereSort
    on QueryBuilder<GitaShloka, GitaShloka, QWhere> {
  QueryBuilder<GitaShloka, GitaShloka, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterWhere> anyChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'chapter'),
      );
    });
  }
}

extension GitaShlokaQueryWhere
    on QueryBuilder<GitaShloka, GitaShloka, QWhereClause> {
  QueryBuilder<GitaShloka, GitaShloka, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<GitaShloka, GitaShloka, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterWhereClause> idBetween(
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

  QueryBuilder<GitaShloka, GitaShloka, QAfterWhereClause> chapterEqualTo(
      int chapter) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'chapter',
        value: [chapter],
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterWhereClause> chapterNotEqualTo(
      int chapter) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chapter',
              lower: [],
              upper: [chapter],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chapter',
              lower: [chapter],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chapter',
              lower: [chapter],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'chapter',
              lower: [],
              upper: [chapter],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterWhereClause> chapterGreaterThan(
    int chapter, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'chapter',
        lower: [chapter],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterWhereClause> chapterLessThan(
    int chapter, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'chapter',
        lower: [],
        upper: [chapter],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterWhereClause> chapterBetween(
    int lowerChapter,
    int upperChapter, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'chapter',
        lower: [lowerChapter],
        includeLower: includeLower,
        upper: [upperChapter],
        includeUpper: includeUpper,
      ));
    });
  }
}

extension GitaShlokaQueryFilter
    on QueryBuilder<GitaShloka, GitaShloka, QFilterCondition> {
  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> chapterEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'chapter',
        value: value,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      chapterGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'chapter',
        value: value,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> chapterLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'chapter',
        value: value,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> chapterBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'chapter',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      hindiTranslationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hindiTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      hindiTranslationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'hindiTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      hindiTranslationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'hindiTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      hindiTranslationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'hindiTranslation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      hindiTranslationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'hindiTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      hindiTranslationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'hindiTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      hindiTranslationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'hindiTranslation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      hindiTranslationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'hindiTranslation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      hindiTranslationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'hindiTranslation',
        value: '',
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      hindiTranslationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'hindiTranslation',
        value: '',
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> idBetween(
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

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> slokEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slok',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> slokGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'slok',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> slokLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'slok',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> slokBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'slok',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> slokStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'slok',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> slokEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'slok',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> slokContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'slok',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> slokMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'slok',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> slokIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'slok',
        value: '',
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> slokIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'slok',
        value: '',
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      translationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      translationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'translation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      translationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'translation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      translationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'translation',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      translationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'translation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      translationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'translation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      translationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'translation',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      translationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'translation',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      translationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'translation',
        value: '',
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      translationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'translation',
        value: '',
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      transliterationEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transliteration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      transliterationGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'transliteration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      transliterationLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'transliteration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      transliterationBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'transliteration',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      transliterationStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'transliteration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      transliterationEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'transliteration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      transliterationContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'transliteration',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      transliterationMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'transliteration',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      transliterationIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'transliteration',
        value: '',
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition>
      transliterationIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'transliteration',
        value: '',
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> verseEqualTo(
      int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'verse',
        value: value,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> verseGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'verse',
        value: value,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> verseLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'verse',
        value: value,
      ));
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterFilterCondition> verseBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'verse',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension GitaShlokaQueryObject
    on QueryBuilder<GitaShloka, GitaShloka, QFilterCondition> {}

extension GitaShlokaQueryLinks
    on QueryBuilder<GitaShloka, GitaShloka, QFilterCondition> {}

extension GitaShlokaQuerySortBy
    on QueryBuilder<GitaShloka, GitaShloka, QSortBy> {
  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> sortByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.asc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> sortByChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.desc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> sortByHindiTranslation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hindiTranslation', Sort.asc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy>
      sortByHindiTranslationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hindiTranslation', Sort.desc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> sortBySlok() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slok', Sort.asc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> sortBySlokDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slok', Sort.desc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> sortByTranslation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translation', Sort.asc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> sortByTranslationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translation', Sort.desc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> sortByTransliteration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transliteration', Sort.asc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy>
      sortByTransliterationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transliteration', Sort.desc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> sortByVerse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verse', Sort.asc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> sortByVerseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verse', Sort.desc);
    });
  }
}

extension GitaShlokaQuerySortThenBy
    on QueryBuilder<GitaShloka, GitaShloka, QSortThenBy> {
  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> thenByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.asc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> thenByChapterDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'chapter', Sort.desc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> thenByHindiTranslation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hindiTranslation', Sort.asc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy>
      thenByHindiTranslationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'hindiTranslation', Sort.desc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> thenBySlok() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slok', Sort.asc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> thenBySlokDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'slok', Sort.desc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> thenByTranslation() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translation', Sort.asc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> thenByTranslationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'translation', Sort.desc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> thenByTransliteration() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transliteration', Sort.asc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy>
      thenByTransliterationDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'transliteration', Sort.desc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> thenByVerse() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verse', Sort.asc);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QAfterSortBy> thenByVerseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'verse', Sort.desc);
    });
  }
}

extension GitaShlokaQueryWhereDistinct
    on QueryBuilder<GitaShloka, GitaShloka, QDistinct> {
  QueryBuilder<GitaShloka, GitaShloka, QDistinct> distinctByChapter() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'chapter');
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QDistinct> distinctByHindiTranslation(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'hindiTranslation',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QDistinct> distinctBySlok(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'slok', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QDistinct> distinctByTranslation(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'translation', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QDistinct> distinctByTransliteration(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'transliteration',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<GitaShloka, GitaShloka, QDistinct> distinctByVerse() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'verse');
    });
  }
}

extension GitaShlokaQueryProperty
    on QueryBuilder<GitaShloka, GitaShloka, QQueryProperty> {
  QueryBuilder<GitaShloka, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<GitaShloka, int, QQueryOperations> chapterProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'chapter');
    });
  }

  QueryBuilder<GitaShloka, String, QQueryOperations>
      hindiTranslationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'hindiTranslation');
    });
  }

  QueryBuilder<GitaShloka, String, QQueryOperations> slokProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'slok');
    });
  }

  QueryBuilder<GitaShloka, String, QQueryOperations> translationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'translation');
    });
  }

  QueryBuilder<GitaShloka, String, QQueryOperations> transliterationProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'transliteration');
    });
  }

  QueryBuilder<GitaShloka, int, QQueryOperations> verseProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'verse');
    });
  }
}
