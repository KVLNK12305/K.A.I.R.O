// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'raw_financial_transaction.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetRawFinancialTransactionCollection on Isar {
  IsarCollection<RawFinancialTransaction> get rawFinancialTransactions =>
      this.collection();
}

const RawFinancialTransactionSchema = CollectionSchema(
  name: r'RawFinancialTransaction',
  id: 4029167950303230722,
  properties: {
    r'amount': PropertySchema(
      id: 0,
      name: r'amount',
      type: IsarType.double,
    ),
    r'currency': PropertySchema(
      id: 1,
      name: r'currency',
      type: IsarType.string,
    ),
    r'fingerprint': PropertySchema(
      id: 2,
      name: r'fingerprint',
      type: IsarType.string,
    ),
    r'ingestedAt': PropertySchema(
      id: 3,
      name: r'ingestedAt',
      type: IsarType.dateTime,
    ),
    r'isResolved': PropertySchema(
      id: 4,
      name: r'isResolved',
      type: IsarType.bool,
    ),
    r'paymentMethod': PropertySchema(
      id: 5,
      name: r'paymentMethod',
      type: IsarType.string,
    ),
    r'rawBody': PropertySchema(
      id: 6,
      name: r'rawBody',
      type: IsarType.string,
    ),
    r'rawMerchant': PropertySchema(
      id: 7,
      name: r'rawMerchant',
      type: IsarType.string,
    ),
    r'rawPayload': PropertySchema(
      id: 8,
      name: r'rawPayload',
      type: IsarType.string,
    ),
    r'rawTitle': PropertySchema(
      id: 9,
      name: r'rawTitle',
      type: IsarType.string,
    ),
    r'referenceNumber': PropertySchema(
      id: 10,
      name: r'referenceNumber',
      type: IsarType.string,
    ),
    r'resolvedFinancialEventId': PropertySchema(
      id: 11,
      name: r'resolvedFinancialEventId',
      type: IsarType.long,
    ),
    r'source': PropertySchema(
      id: 12,
      name: r'source',
      type: IsarType.string,
    ),
    r'sourceAccountHint': PropertySchema(
      id: 13,
      name: r'sourceAccountHint',
      type: IsarType.string,
    ),
    r'sourceTransactionId': PropertySchema(
      id: 14,
      name: r'sourceTransactionId',
      type: IsarType.string,
    ),
    r'timestamp': PropertySchema(
      id: 15,
      name: r'timestamp',
      type: IsarType.dateTime,
    )
  },
  estimateSize: _rawFinancialTransactionEstimateSize,
  serialize: _rawFinancialTransactionSerialize,
  deserialize: _rawFinancialTransactionDeserialize,
  deserializeProp: _rawFinancialTransactionDeserializeProp,
  idName: r'id',
  indexes: {
    r'source': IndexSchema(
      id: -836881197531269605,
      name: r'source',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'source',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'sourceTransactionId': IndexSchema(
      id: 3451458545021410290,
      name: r'sourceTransactionId',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'sourceTransactionId',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'fingerprint': IndexSchema(
      id: -8135929981755050833,
      name: r'fingerprint',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'fingerprint',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'timestamp': IndexSchema(
      id: 1852253767416892198,
      name: r'timestamp',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'timestamp',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'referenceNumber': IndexSchema(
      id: -1505394869653403563,
      name: r'referenceNumber',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'referenceNumber',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _rawFinancialTransactionGetId,
  getLinks: _rawFinancialTransactionGetLinks,
  attach: _rawFinancialTransactionAttach,
  version: '3.1.0+1',
);

int _rawFinancialTransactionEstimateSize(
  RawFinancialTransaction object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.currency.length * 3;
  bytesCount += 3 + object.fingerprint.length * 3;
  bytesCount += 3 + object.paymentMethod.length * 3;
  bytesCount += 3 + object.rawBody.length * 3;
  bytesCount += 3 + object.rawMerchant.length * 3;
  bytesCount += 3 + object.rawPayload.length * 3;
  bytesCount += 3 + object.rawTitle.length * 3;
  {
    final value = object.referenceNumber;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  bytesCount += 3 + object.source.length * 3;
  {
    final value = object.sourceAccountHint;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.sourceTransactionId;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _rawFinancialTransactionSerialize(
  RawFinancialTransaction object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.amount);
  writer.writeString(offsets[1], object.currency);
  writer.writeString(offsets[2], object.fingerprint);
  writer.writeDateTime(offsets[3], object.ingestedAt);
  writer.writeBool(offsets[4], object.isResolved);
  writer.writeString(offsets[5], object.paymentMethod);
  writer.writeString(offsets[6], object.rawBody);
  writer.writeString(offsets[7], object.rawMerchant);
  writer.writeString(offsets[8], object.rawPayload);
  writer.writeString(offsets[9], object.rawTitle);
  writer.writeString(offsets[10], object.referenceNumber);
  writer.writeLong(offsets[11], object.resolvedFinancialEventId);
  writer.writeString(offsets[12], object.source);
  writer.writeString(offsets[13], object.sourceAccountHint);
  writer.writeString(offsets[14], object.sourceTransactionId);
  writer.writeDateTime(offsets[15], object.timestamp);
}

RawFinancialTransaction _rawFinancialTransactionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = RawFinancialTransaction();
  object.amount = reader.readDouble(offsets[0]);
  object.currency = reader.readString(offsets[1]);
  object.fingerprint = reader.readString(offsets[2]);
  object.id = id;
  object.ingestedAt = reader.readDateTime(offsets[3]);
  object.isResolved = reader.readBool(offsets[4]);
  object.paymentMethod = reader.readString(offsets[5]);
  object.rawBody = reader.readString(offsets[6]);
  object.rawMerchant = reader.readString(offsets[7]);
  object.rawPayload = reader.readString(offsets[8]);
  object.rawTitle = reader.readString(offsets[9]);
  object.referenceNumber = reader.readStringOrNull(offsets[10]);
  object.resolvedFinancialEventId = reader.readLongOrNull(offsets[11]);
  object.source = reader.readString(offsets[12]);
  object.sourceAccountHint = reader.readStringOrNull(offsets[13]);
  object.sourceTransactionId = reader.readStringOrNull(offsets[14]);
  object.timestamp = reader.readDateTime(offsets[15]);
  return object;
}

P _rawFinancialTransactionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readString(offset)) as P;
    case 3:
      return (reader.readDateTime(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readString(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readString(offset)) as P;
    case 10:
      return (reader.readStringOrNull(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (reader.readString(offset)) as P;
    case 13:
      return (reader.readStringOrNull(offset)) as P;
    case 14:
      return (reader.readStringOrNull(offset)) as P;
    case 15:
      return (reader.readDateTime(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _rawFinancialTransactionGetId(RawFinancialTransaction object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _rawFinancialTransactionGetLinks(
    RawFinancialTransaction object) {
  return [];
}

void _rawFinancialTransactionAttach(
    IsarCollection<dynamic> col, Id id, RawFinancialTransaction object) {
  object.id = id;
}

extension RawFinancialTransactionQueryWhereSort
    on QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QWhere> {
  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterWhere>
      anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterWhere>
      anyTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'timestamp'),
      );
    });
  }
}

extension RawFinancialTransactionQueryWhere on QueryBuilder<
    RawFinancialTransaction, RawFinancialTransaction, QWhereClause> {
  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterWhereClause> idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterWhereClause> idLessThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterWhereClause> idBetween(
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

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterWhereClause> sourceEqualTo(String source) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'source',
        value: [source],
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterWhereClause> sourceNotEqualTo(String source) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source',
              lower: [],
              upper: [source],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source',
              lower: [source],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source',
              lower: [source],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'source',
              lower: [],
              upper: [source],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterWhereClause> sourceTransactionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceTransactionId',
        value: [null],
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterWhereClause> sourceTransactionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'sourceTransactionId',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterWhereClause>
      sourceTransactionIdEqualTo(String? sourceTransactionId) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'sourceTransactionId',
        value: [sourceTransactionId],
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterWhereClause>
      sourceTransactionIdNotEqualTo(String? sourceTransactionId) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceTransactionId',
              lower: [],
              upper: [sourceTransactionId],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceTransactionId',
              lower: [sourceTransactionId],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceTransactionId',
              lower: [sourceTransactionId],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'sourceTransactionId',
              lower: [],
              upper: [sourceTransactionId],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterWhereClause> fingerprintEqualTo(String fingerprint) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'fingerprint',
        value: [fingerprint],
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterWhereClause> fingerprintNotEqualTo(String fingerprint) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fingerprint',
              lower: [],
              upper: [fingerprint],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fingerprint',
              lower: [fingerprint],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fingerprint',
              lower: [fingerprint],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'fingerprint',
              lower: [],
              upper: [fingerprint],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterWhereClause> timestampEqualTo(DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'timestamp',
        value: [timestamp],
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterWhereClause> timestampNotEqualTo(DateTime timestamp) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [timestamp],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'timestamp',
              lower: [],
              upper: [timestamp],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterWhereClause> timestampGreaterThan(
    DateTime timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [timestamp],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterWhereClause> timestampLessThan(
    DateTime timestamp, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [],
        upper: [timestamp],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterWhereClause> timestampBetween(
    DateTime lowerTimestamp,
    DateTime upperTimestamp, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'timestamp',
        lower: [lowerTimestamp],
        includeLower: includeLower,
        upper: [upperTimestamp],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterWhereClause> referenceNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'referenceNumber',
        value: [null],
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterWhereClause> referenceNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'referenceNumber',
        lower: [null],
        includeLower: false,
        upper: [],
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterWhereClause> referenceNumberEqualTo(String? referenceNumber) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'referenceNumber',
        value: [referenceNumber],
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterWhereClause> referenceNumberNotEqualTo(String? referenceNumber) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'referenceNumber',
              lower: [],
              upper: [referenceNumber],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'referenceNumber',
              lower: [referenceNumber],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'referenceNumber',
              lower: [referenceNumber],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'referenceNumber',
              lower: [],
              upper: [referenceNumber],
              includeUpper: false,
            ));
      }
    });
  }
}

extension RawFinancialTransactionQueryFilter on QueryBuilder<
    RawFinancialTransaction, RawFinancialTransaction, QFilterCondition> {
  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> amountEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> amountGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> amountLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'amount',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> amountBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'amount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> currencyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> currencyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> currencyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> currencyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'currency',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> currencyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> currencyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      currencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'currency',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      currencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'currency',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> currencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> currencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'currency',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> fingerprintEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fingerprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> fingerprintGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fingerprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> fingerprintLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fingerprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> fingerprintBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fingerprint',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> fingerprintStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'fingerprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> fingerprintEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'fingerprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      fingerprintContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'fingerprint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      fingerprintMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'fingerprint',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> fingerprintIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fingerprint',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> fingerprintIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'fingerprint',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
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

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
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

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
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

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> ingestedAtEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ingestedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> ingestedAtGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ingestedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> ingestedAtLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ingestedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> ingestedAtBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ingestedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> isResolvedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isResolved',
        value: value,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> paymentMethodEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> paymentMethodGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> paymentMethodLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> paymentMethodBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'paymentMethod',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> paymentMethodStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> paymentMethodEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      paymentMethodContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'paymentMethod',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      paymentMethodMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'paymentMethod',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> paymentMethodIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'paymentMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> paymentMethodIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'paymentMethod',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawBodyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawBody',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawBodyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawBody',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawBodyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawBody',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawBodyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawBody',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawBodyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawBody',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawBodyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawBody',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      rawBodyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawBody',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      rawBodyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawBody',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawBodyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawBody',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawBodyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawBody',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawMerchantEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawMerchant',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawMerchantGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawMerchant',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawMerchantLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawMerchant',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawMerchantBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawMerchant',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawMerchantStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawMerchant',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawMerchantEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawMerchant',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      rawMerchantContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawMerchant',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      rawMerchantMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawMerchant',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawMerchantIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawMerchant',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawMerchantIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawMerchant',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawPayloadEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawPayload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawPayloadGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawPayload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawPayloadLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawPayload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawPayloadBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawPayload',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawPayloadStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawPayload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawPayloadEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawPayload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      rawPayloadContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawPayload',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      rawPayloadMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawPayload',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawPayloadIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawPayload',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawPayloadIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawPayload',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawTitleEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawTitleGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'rawTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawTitleLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'rawTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawTitleBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'rawTitle',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawTitleStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'rawTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawTitleEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'rawTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      rawTitleContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'rawTitle',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      rawTitleMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'rawTitle',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawTitleIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'rawTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> rawTitleIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'rawTitle',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> referenceNumberIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'referenceNumber',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> referenceNumberIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'referenceNumber',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> referenceNumberEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'referenceNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> referenceNumberGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'referenceNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> referenceNumberLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'referenceNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> referenceNumberBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'referenceNumber',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> referenceNumberStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'referenceNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> referenceNumberEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'referenceNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      referenceNumberContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'referenceNumber',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      referenceNumberMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'referenceNumber',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> referenceNumberIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'referenceNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> referenceNumberIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'referenceNumber',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> resolvedFinancialEventIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'resolvedFinancialEventId',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> resolvedFinancialEventIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'resolvedFinancialEventId',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> resolvedFinancialEventIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'resolvedFinancialEventId',
        value: value,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> resolvedFinancialEventIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'resolvedFinancialEventId',
        value: value,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> resolvedFinancialEventIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'resolvedFinancialEventId',
        value: value,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> resolvedFinancialEventIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'resolvedFinancialEventId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'source',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      sourceContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'source',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      sourceMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'source',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'source',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceAccountHintIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sourceAccountHint',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceAccountHintIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sourceAccountHint',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceAccountHintEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceAccountHint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceAccountHintGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceAccountHint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceAccountHintLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceAccountHint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceAccountHintBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceAccountHint',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceAccountHintStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceAccountHint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceAccountHintEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceAccountHint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      sourceAccountHintContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceAccountHint',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      sourceAccountHintMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceAccountHint',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceAccountHintIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceAccountHint',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceAccountHintIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceAccountHint',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceTransactionIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'sourceTransactionId',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceTransactionIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'sourceTransactionId',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceTransactionIdEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceTransactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceTransactionIdGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'sourceTransactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceTransactionIdLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'sourceTransactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceTransactionIdBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'sourceTransactionId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceTransactionIdStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'sourceTransactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceTransactionIdEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'sourceTransactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      sourceTransactionIdContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'sourceTransactionId',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
          QAfterFilterCondition>
      sourceTransactionIdMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'sourceTransactionId',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceTransactionIdIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'sourceTransactionId',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> sourceTransactionIdIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'sourceTransactionId',
        value: '',
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> timestampEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> timestampGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> timestampLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'timestamp',
        value: value,
      ));
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction,
      QAfterFilterCondition> timestampBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'timestamp',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension RawFinancialTransactionQueryObject on QueryBuilder<
    RawFinancialTransaction, RawFinancialTransaction, QFilterCondition> {}

extension RawFinancialTransactionQueryLinks on QueryBuilder<
    RawFinancialTransaction, RawFinancialTransaction, QFilterCondition> {}

extension RawFinancialTransactionQuerySortBy
    on QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QSortBy> {
  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByFingerprint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fingerprint', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByFingerprintDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fingerprint', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByIngestedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingestedAt', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByIngestedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingestedAt', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByIsResolved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isResolved', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByIsResolvedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isResolved', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByRawBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawBody', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByRawBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawBody', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByRawMerchant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawMerchant', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByRawMerchantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawMerchant', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByRawPayload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawPayload', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByRawPayloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawPayload', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByRawTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawTitle', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByRawTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawTitle', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByReferenceNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceNumber', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByReferenceNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceNumber', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByResolvedFinancialEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolvedFinancialEventId', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByResolvedFinancialEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolvedFinancialEventId', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortBySourceAccountHint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceAccountHint', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortBySourceAccountHintDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceAccountHint', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortBySourceTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceTransactionId', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortBySourceTransactionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceTransactionId', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      sortByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension RawFinancialTransactionQuerySortThenBy on QueryBuilder<
    RawFinancialTransaction, RawFinancialTransaction, QSortThenBy> {
  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByAmountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'amount', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByCurrency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByCurrencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currency', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByFingerprint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fingerprint', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByFingerprintDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fingerprint', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByIngestedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingestedAt', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByIngestedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ingestedAt', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByIsResolved() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isResolved', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByIsResolvedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isResolved', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByPaymentMethod() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByPaymentMethodDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'paymentMethod', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByRawBody() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawBody', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByRawBodyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawBody', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByRawMerchant() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawMerchant', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByRawMerchantDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawMerchant', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByRawPayload() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawPayload', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByRawPayloadDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawPayload', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByRawTitle() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawTitle', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByRawTitleDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'rawTitle', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByReferenceNumber() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceNumber', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByReferenceNumberDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'referenceNumber', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByResolvedFinancialEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolvedFinancialEventId', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByResolvedFinancialEventIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'resolvedFinancialEventId', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenBySource() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenBySourceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'source', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenBySourceAccountHint() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceAccountHint', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenBySourceAccountHintDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceAccountHint', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenBySourceTransactionId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceTransactionId', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenBySourceTransactionIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'sourceTransactionId', Sort.desc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.asc);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QAfterSortBy>
      thenByTimestampDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timestamp', Sort.desc);
    });
  }
}

extension RawFinancialTransactionQueryWhereDistinct on QueryBuilder<
    RawFinancialTransaction, RawFinancialTransaction, QDistinct> {
  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QDistinct>
      distinctByAmount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'amount');
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QDistinct>
      distinctByCurrency({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currency', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QDistinct>
      distinctByFingerprint({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fingerprint', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QDistinct>
      distinctByIngestedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ingestedAt');
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QDistinct>
      distinctByIsResolved() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isResolved');
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QDistinct>
      distinctByPaymentMethod({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'paymentMethod',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QDistinct>
      distinctByRawBody({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawBody', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QDistinct>
      distinctByRawMerchant({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawMerchant', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QDistinct>
      distinctByRawPayload({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawPayload', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QDistinct>
      distinctByRawTitle({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'rawTitle', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QDistinct>
      distinctByReferenceNumber({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'referenceNumber',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QDistinct>
      distinctByResolvedFinancialEventId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'resolvedFinancialEventId');
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QDistinct>
      distinctBySource({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'source', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QDistinct>
      distinctBySourceAccountHint({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceAccountHint',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QDistinct>
      distinctBySourceTransactionId({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'sourceTransactionId',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<RawFinancialTransaction, RawFinancialTransaction, QDistinct>
      distinctByTimestamp() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timestamp');
    });
  }
}

extension RawFinancialTransactionQueryProperty on QueryBuilder<
    RawFinancialTransaction, RawFinancialTransaction, QQueryProperty> {
  QueryBuilder<RawFinancialTransaction, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<RawFinancialTransaction, double, QQueryOperations>
      amountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'amount');
    });
  }

  QueryBuilder<RawFinancialTransaction, String, QQueryOperations>
      currencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currency');
    });
  }

  QueryBuilder<RawFinancialTransaction, String, QQueryOperations>
      fingerprintProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fingerprint');
    });
  }

  QueryBuilder<RawFinancialTransaction, DateTime, QQueryOperations>
      ingestedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ingestedAt');
    });
  }

  QueryBuilder<RawFinancialTransaction, bool, QQueryOperations>
      isResolvedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isResolved');
    });
  }

  QueryBuilder<RawFinancialTransaction, String, QQueryOperations>
      paymentMethodProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'paymentMethod');
    });
  }

  QueryBuilder<RawFinancialTransaction, String, QQueryOperations>
      rawBodyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawBody');
    });
  }

  QueryBuilder<RawFinancialTransaction, String, QQueryOperations>
      rawMerchantProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawMerchant');
    });
  }

  QueryBuilder<RawFinancialTransaction, String, QQueryOperations>
      rawPayloadProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawPayload');
    });
  }

  QueryBuilder<RawFinancialTransaction, String, QQueryOperations>
      rawTitleProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'rawTitle');
    });
  }

  QueryBuilder<RawFinancialTransaction, String?, QQueryOperations>
      referenceNumberProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'referenceNumber');
    });
  }

  QueryBuilder<RawFinancialTransaction, int?, QQueryOperations>
      resolvedFinancialEventIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'resolvedFinancialEventId');
    });
  }

  QueryBuilder<RawFinancialTransaction, String, QQueryOperations>
      sourceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'source');
    });
  }

  QueryBuilder<RawFinancialTransaction, String?, QQueryOperations>
      sourceAccountHintProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceAccountHint');
    });
  }

  QueryBuilder<RawFinancialTransaction, String?, QQueryOperations>
      sourceTransactionIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'sourceTransactionId');
    });
  }

  QueryBuilder<RawFinancialTransaction, DateTime, QQueryOperations>
      timestampProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timestamp');
    });
  }
}
