// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_pomodoro.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetPomodoroIsarCollection on Isar {
  IsarCollection<PomodoroIsar> get pomodoroIsars => this.collection();
}

const PomodoroIsarSchema = CollectionSchema(
  name: r'PomodoroIsar',
  id: -2642426908413478604,
  properties: {
    r'completedCycles': PropertySchema(
      id: 0,
      name: r'completedCycles',
      type: IsarType.long,
    ),
    r'createdAt': PropertySchema(
      id: 1,
      name: r'createdAt',
      type: IsarType.dateTime,
    ),
    r'currentPhaseIndex': PropertySchema(
      id: 2,
      name: r'currentPhaseIndex',
      type: IsarType.long,
    ),
    r'habitId': PropertySchema(id: 3, name: r'habitId', type: IsarType.long),
    r'isActive': PropertySchema(id: 4, name: r'isActive', type: IsarType.bool),
    r'lastUpdatedAt': PropertySchema(
      id: 5,
      name: r'lastUpdatedAt',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(id: 6, name: r'name', type: IsarType.string),
    r'remainingSeconds': PropertySchema(
      id: 7,
      name: r'remainingSeconds',
      type: IsarType.long,
    ),
    r'session': PropertySchema(id: 8, name: r'session', type: IsarType.long),
    r'timeLongBreak': PropertySchema(
      id: 9,
      name: r'timeLongBreak',
      type: IsarType.long,
    ),
    r'timePomodoro': PropertySchema(
      id: 10,
      name: r'timePomodoro',
      type: IsarType.long,
    ),
    r'timeSortBreak': PropertySchema(
      id: 11,
      name: r'timeSortBreak',
      type: IsarType.long,
    ),
  },

  estimateSize: _pomodoroIsarEstimateSize,
  serialize: _pomodoroIsarSerialize,
  deserialize: _pomodoroIsarDeserialize,
  deserializeProp: _pomodoroIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _pomodoroIsarGetId,
  getLinks: _pomodoroIsarGetLinks,
  attach: _pomodoroIsarAttach,
  version: '3.3.0',
);

int _pomodoroIsarEstimateSize(
  PomodoroIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _pomodoroIsarSerialize(
  PomodoroIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.completedCycles);
  writer.writeDateTime(offsets[1], object.createdAt);
  writer.writeLong(offsets[2], object.currentPhaseIndex);
  writer.writeLong(offsets[3], object.habitId);
  writer.writeBool(offsets[4], object.isActive);
  writer.writeDateTime(offsets[5], object.lastUpdatedAt);
  writer.writeString(offsets[6], object.name);
  writer.writeLong(offsets[7], object.remainingSeconds);
  writer.writeLong(offsets[8], object.session);
  writer.writeLong(offsets[9], object.timeLongBreak);
  writer.writeLong(offsets[10], object.timePomodoro);
  writer.writeLong(offsets[11], object.timeSortBreak);
}

PomodoroIsar _pomodoroIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = PomodoroIsar();
  object.completedCycles = reader.readLong(offsets[0]);
  object.createdAt = reader.readDateTimeOrNull(offsets[1]);
  object.currentPhaseIndex = reader.readLong(offsets[2]);
  object.habitId = reader.readLongOrNull(offsets[3]);
  object.id = id;
  object.isActive = reader.readBool(offsets[4]);
  object.lastUpdatedAt = reader.readDateTimeOrNull(offsets[5]);
  object.name = reader.readString(offsets[6]);
  object.remainingSeconds = reader.readLong(offsets[7]);
  object.session = reader.readLong(offsets[8]);
  object.timeLongBreak = reader.readLong(offsets[9]);
  object.timePomodoro = reader.readLong(offsets[10]);
  object.timeSortBreak = reader.readLong(offsets[11]);
  return object;
}

P _pomodoroIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readLongOrNull(offset)) as P;
    case 4:
      return (reader.readBool(offset)) as P;
    case 5:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    case 8:
      return (reader.readLong(offset)) as P;
    case 9:
      return (reader.readLong(offset)) as P;
    case 10:
      return (reader.readLong(offset)) as P;
    case 11:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _pomodoroIsarGetId(PomodoroIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _pomodoroIsarGetLinks(PomodoroIsar object) {
  return [];
}

void _pomodoroIsarAttach(
  IsarCollection<dynamic> col,
  Id id,
  PomodoroIsar object,
) {
  object.id = id;
}

extension PomodoroIsarQueryWhereSort
    on QueryBuilder<PomodoroIsar, PomodoroIsar, QWhere> {
  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension PomodoroIsarQueryWhere
    on QueryBuilder<PomodoroIsar, PomodoroIsar, QWhereClause> {
  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterWhereClause> idNotEqualTo(
    Id id,
  ) {
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

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.between(
          lower: lowerId,
          includeLower: includeLower,
          upper: upperId,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PomodoroIsarQueryFilter
    on QueryBuilder<PomodoroIsar, PomodoroIsar, QFilterCondition> {
  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  completedCyclesEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'completedCycles', value: value),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  completedCyclesGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'completedCycles',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  completedCyclesLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'completedCycles',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  completedCyclesBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'completedCycles',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  createdAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'createdAt'),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  createdAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'createdAt'),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  createdAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'createdAt', value: value),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  createdAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  createdAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'createdAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  createdAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'createdAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  currentPhaseIndexEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'currentPhaseIndex', value: value),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  currentPhaseIndexGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'currentPhaseIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  currentPhaseIndexLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'currentPhaseIndex',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  currentPhaseIndexBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'currentPhaseIndex',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  habitIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'habitId'),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  habitIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'habitId'),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  habitIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'habitId', value: value),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  habitIdGreaterThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'habitId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  habitIdLessThan(int? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'habitId',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  habitIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'habitId',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'id',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'id',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  isActiveEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isActive', value: value),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  lastUpdatedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastUpdatedAt'),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  lastUpdatedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastUpdatedAt'),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  lastUpdatedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastUpdatedAt', value: value),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  lastUpdatedAtGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastUpdatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  lastUpdatedAtLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastUpdatedAt',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  lastUpdatedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastUpdatedAt',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition> nameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  nameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition> nameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition> nameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'name',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  nameStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition> nameContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'name',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition> nameMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'name',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  remainingSecondsEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'remainingSeconds', value: value),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  remainingSecondsGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'remainingSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  remainingSecondsLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'remainingSeconds',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  remainingSecondsBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'remainingSeconds',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  sessionEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'session', value: value),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  sessionGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'session',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  sessionLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'session',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  sessionBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'session',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  timeLongBreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timeLongBreak', value: value),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  timeLongBreakGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'timeLongBreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  timeLongBreakLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'timeLongBreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  timeLongBreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'timeLongBreak',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  timePomodoroEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timePomodoro', value: value),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  timePomodoroGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'timePomodoro',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  timePomodoroLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'timePomodoro',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  timePomodoroBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'timePomodoro',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  timeSortBreakEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timeSortBreak', value: value),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  timeSortBreakGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'timeSortBreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  timeSortBreakLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'timeSortBreak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterFilterCondition>
  timeSortBreakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'timeSortBreak',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension PomodoroIsarQueryObject
    on QueryBuilder<PomodoroIsar, PomodoroIsar, QFilterCondition> {}

extension PomodoroIsarQueryLinks
    on QueryBuilder<PomodoroIsar, PomodoroIsar, QFilterCondition> {}

extension PomodoroIsarQuerySortBy
    on QueryBuilder<PomodoroIsar, PomodoroIsar, QSortBy> {
  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy>
  sortByCompletedCycles() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedCycles', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy>
  sortByCompletedCyclesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedCycles', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> sortByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> sortByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy>
  sortByCurrentPhaseIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPhaseIndex', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy>
  sortByCurrentPhaseIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPhaseIndex', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> sortByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> sortByHabitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> sortByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> sortByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> sortByLastUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy>
  sortByLastUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy>
  sortByRemainingSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingSeconds', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy>
  sortByRemainingSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingSeconds', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> sortBySession() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'session', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> sortBySessionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'session', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> sortByTimeLongBreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeLongBreak', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy>
  sortByTimeLongBreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeLongBreak', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> sortByTimePomodoro() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timePomodoro', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy>
  sortByTimePomodoroDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timePomodoro', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> sortByTimeSortBreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSortBreak', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy>
  sortByTimeSortBreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSortBreak', Sort.desc);
    });
  }
}

extension PomodoroIsarQuerySortThenBy
    on QueryBuilder<PomodoroIsar, PomodoroIsar, QSortThenBy> {
  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy>
  thenByCompletedCycles() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedCycles', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy>
  thenByCompletedCyclesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'completedCycles', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> thenByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> thenByCreatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'createdAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy>
  thenByCurrentPhaseIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPhaseIndex', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy>
  thenByCurrentPhaseIndexDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'currentPhaseIndex', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> thenByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> thenByHabitIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitId', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> thenByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> thenByIsActiveDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isActive', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> thenByLastUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedAt', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy>
  thenByLastUpdatedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastUpdatedAt', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy>
  thenByRemainingSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingSeconds', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy>
  thenByRemainingSecondsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'remainingSeconds', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> thenBySession() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'session', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> thenBySessionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'session', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> thenByTimeLongBreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeLongBreak', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy>
  thenByTimeLongBreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeLongBreak', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> thenByTimePomodoro() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timePomodoro', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy>
  thenByTimePomodoroDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timePomodoro', Sort.desc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy> thenByTimeSortBreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSortBreak', Sort.asc);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QAfterSortBy>
  thenByTimeSortBreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeSortBreak', Sort.desc);
    });
  }
}

extension PomodoroIsarQueryWhereDistinct
    on QueryBuilder<PomodoroIsar, PomodoroIsar, QDistinct> {
  QueryBuilder<PomodoroIsar, PomodoroIsar, QDistinct>
  distinctByCompletedCycles() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'completedCycles');
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QDistinct> distinctByCreatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'createdAt');
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QDistinct>
  distinctByCurrentPhaseIndex() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'currentPhaseIndex');
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QDistinct> distinctByHabitId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'habitId');
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QDistinct> distinctByIsActive() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isActive');
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QDistinct>
  distinctByLastUpdatedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastUpdatedAt');
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QDistinct>
  distinctByRemainingSeconds() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'remainingSeconds');
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QDistinct> distinctBySession() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'session');
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QDistinct>
  distinctByTimeLongBreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeLongBreak');
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QDistinct> distinctByTimePomodoro() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timePomodoro');
    });
  }

  QueryBuilder<PomodoroIsar, PomodoroIsar, QDistinct>
  distinctByTimeSortBreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeSortBreak');
    });
  }
}

extension PomodoroIsarQueryProperty
    on QueryBuilder<PomodoroIsar, PomodoroIsar, QQueryProperty> {
  QueryBuilder<PomodoroIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<PomodoroIsar, int, QQueryOperations> completedCyclesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'completedCycles');
    });
  }

  QueryBuilder<PomodoroIsar, DateTime?, QQueryOperations> createdAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'createdAt');
    });
  }

  QueryBuilder<PomodoroIsar, int, QQueryOperations>
  currentPhaseIndexProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'currentPhaseIndex');
    });
  }

  QueryBuilder<PomodoroIsar, int?, QQueryOperations> habitIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'habitId');
    });
  }

  QueryBuilder<PomodoroIsar, bool, QQueryOperations> isActiveProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isActive');
    });
  }

  QueryBuilder<PomodoroIsar, DateTime?, QQueryOperations>
  lastUpdatedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastUpdatedAt');
    });
  }

  QueryBuilder<PomodoroIsar, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<PomodoroIsar, int, QQueryOperations> remainingSecondsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'remainingSeconds');
    });
  }

  QueryBuilder<PomodoroIsar, int, QQueryOperations> sessionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'session');
    });
  }

  QueryBuilder<PomodoroIsar, int, QQueryOperations> timeLongBreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeLongBreak');
    });
  }

  QueryBuilder<PomodoroIsar, int, QQueryOperations> timePomodoroProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timePomodoro');
    });
  }

  QueryBuilder<PomodoroIsar, int, QQueryOperations> timeSortBreakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeSortBreak');
    });
  }
}
