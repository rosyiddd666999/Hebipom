// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_habit.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetHabitIsarCollection on Isar {
  IsarCollection<HabitIsar> get habitIsars => this.collection();
}

const HabitIsarSchema = CollectionSchema(
  name: r'HabitIsar',
  id: 8869242832082541991,
  properties: {
    r'category': PropertySchema(
      id: 0,
      name: r'category',
      type: IsarType.string,
    ),
    r'habitFrequency': PropertySchema(
      id: 1,
      name: r'habitFrequency',
      type: IsarType.string,
    ),
    r'isCompleted': PropertySchema(
      id: 2,
      name: r'isCompleted',
      type: IsarType.bool,
    ),
    r'lastCompletedDate': PropertySchema(
      id: 3,
      name: r'lastCompletedDate',
      type: IsarType.dateTime,
    ),
    r'name': PropertySchema(id: 4, name: r'name', type: IsarType.string),
    r'streak': PropertySchema(id: 5, name: r'streak', type: IsarType.long),
    r'timeReminderHour': PropertySchema(
      id: 6,
      name: r'timeReminderHour',
      type: IsarType.long,
    ),
    r'timeReminderMinute': PropertySchema(
      id: 7,
      name: r'timeReminderMinute',
      type: IsarType.long,
    ),
  },

  estimateSize: _habitIsarEstimateSize,
  serialize: _habitIsarSerialize,
  deserialize: _habitIsarDeserialize,
  deserializeProp: _habitIsarDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},

  getId: _habitIsarGetId,
  getLinks: _habitIsarGetLinks,
  attach: _habitIsarAttach,
  version: '3.3.0',
);

int _habitIsarEstimateSize(
  HabitIsar object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.category.length * 3;
  bytesCount += 3 + object.habitFrequency.length * 3;
  bytesCount += 3 + object.name.length * 3;
  return bytesCount;
}

void _habitIsarSerialize(
  HabitIsar object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.category);
  writer.writeString(offsets[1], object.habitFrequency);
  writer.writeBool(offsets[2], object.isCompleted);
  writer.writeDateTime(offsets[3], object.lastCompletedDate);
  writer.writeString(offsets[4], object.name);
  writer.writeLong(offsets[5], object.streak);
  writer.writeLong(offsets[6], object.timeReminderHour);
  writer.writeLong(offsets[7], object.timeReminderMinute);
}

HabitIsar _habitIsarDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = HabitIsar();
  object.category = reader.readString(offsets[0]);
  object.habitFrequency = reader.readString(offsets[1]);
  object.id = id;
  object.isCompleted = reader.readBool(offsets[2]);
  object.lastCompletedDate = reader.readDateTimeOrNull(offsets[3]);
  object.name = reader.readString(offsets[4]);
  object.streak = reader.readLong(offsets[5]);
  object.timeReminderHour = reader.readLong(offsets[6]);
  object.timeReminderMinute = reader.readLong(offsets[7]);
  return object;
}

P _habitIsarDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readString(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readBool(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readLong(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _habitIsarGetId(HabitIsar object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _habitIsarGetLinks(HabitIsar object) {
  return [];
}

void _habitIsarAttach(IsarCollection<dynamic> col, Id id, HabitIsar object) {
  object.id = id;
}

extension HabitIsarQueryWhereSort
    on QueryBuilder<HabitIsar, HabitIsar, QWhere> {
  QueryBuilder<HabitIsar, HabitIsar, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension HabitIsarQueryWhere
    on QueryBuilder<HabitIsar, HabitIsar, QWhereClause> {
  QueryBuilder<HabitIsar, HabitIsar, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(lower: id, upper: id));
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<HabitIsar, HabitIsar, QAfterWhereClause> idGreaterThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterWhereClause> idLessThan(
    Id id, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterWhereClause> idBetween(
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

extension HabitIsarQueryFilter
    on QueryBuilder<HabitIsar, HabitIsar, QFilterCondition> {
  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> categoryEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> categoryGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> categoryLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> categoryBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'category',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> categoryStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> categoryEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> categoryContains(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'category',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> categoryMatches(
    String pattern, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'category',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> categoryIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'category', value: ''),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  categoryIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'category', value: ''),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  habitFrequencyEqualTo(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(
          property: r'habitFrequency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  habitFrequencyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'habitFrequency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  habitFrequencyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'habitFrequency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  habitFrequencyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'habitFrequency',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  habitFrequencyStartsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.startsWith(
          property: r'habitFrequency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  habitFrequencyEndsWith(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.endsWith(
          property: r'habitFrequency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  habitFrequencyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.contains(
          property: r'habitFrequency',
          value: value,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  habitFrequencyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.matches(
          property: r'habitFrequency',
          wildcard: pattern,
          caseSensitive: caseSensitive,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  habitFrequencyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'habitFrequency', value: ''),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  habitFrequencyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'habitFrequency', value: ''),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> idEqualTo(
    Id value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'id', value: value),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> idBetween(
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

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> isCompletedEqualTo(
    bool value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'isCompleted', value: value),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  lastCompletedDateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNull(property: r'lastCompletedDate'),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  lastCompletedDateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        const FilterCondition.isNotNull(property: r'lastCompletedDate'),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  lastCompletedDateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'lastCompletedDate', value: value),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  lastCompletedDateGreaterThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'lastCompletedDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  lastCompletedDateLessThan(DateTime? value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'lastCompletedDate',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  lastCompletedDateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'lastCompletedDate',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> nameEqualTo(
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

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> nameGreaterThan(
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

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> nameLessThan(
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

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> nameBetween(
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

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
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

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> nameEndsWith(
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

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> nameContains(
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

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> nameMatches(
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

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(property: r'name', value: ''),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> streakEqualTo(
    int value,
  ) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'streak', value: value),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> streakGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'streak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> streakLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'streak',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition> streakBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'streak',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  timeReminderHourEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timeReminderHour', value: value),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  timeReminderHourGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'timeReminderHour',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  timeReminderHourLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'timeReminderHour',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  timeReminderHourBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'timeReminderHour',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  timeReminderMinuteEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.equalTo(property: r'timeReminderMinute', value: value),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  timeReminderMinuteGreaterThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.greaterThan(
          include: include,
          property: r'timeReminderMinute',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  timeReminderMinuteLessThan(int value, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.lessThan(
          include: include,
          property: r'timeReminderMinute',
          value: value,
        ),
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterFilterCondition>
  timeReminderMinuteBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(
        FilterCondition.between(
          property: r'timeReminderMinute',
          lower: lower,
          includeLower: includeLower,
          upper: upper,
          includeUpper: includeUpper,
        ),
      );
    });
  }
}

extension HabitIsarQueryObject
    on QueryBuilder<HabitIsar, HabitIsar, QFilterCondition> {}

extension HabitIsarQueryLinks
    on QueryBuilder<HabitIsar, HabitIsar, QFilterCondition> {}

extension HabitIsarQuerySortBy on QueryBuilder<HabitIsar, HabitIsar, QSortBy> {
  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> sortByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> sortByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> sortByHabitFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitFrequency', Sort.asc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> sortByHabitFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitFrequency', Sort.desc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> sortByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> sortByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> sortByLastCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDate', Sort.asc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy>
  sortByLastCompletedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDate', Sort.desc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> sortByStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.asc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> sortByStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.desc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> sortByTimeReminderHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeReminderHour', Sort.asc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy>
  sortByTimeReminderHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeReminderHour', Sort.desc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> sortByTimeReminderMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeReminderMinute', Sort.asc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy>
  sortByTimeReminderMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeReminderMinute', Sort.desc);
    });
  }
}

extension HabitIsarQuerySortThenBy
    on QueryBuilder<HabitIsar, HabitIsar, QSortThenBy> {
  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> thenByCategory() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.asc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> thenByCategoryDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'category', Sort.desc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> thenByHabitFrequency() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitFrequency', Sort.asc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> thenByHabitFrequencyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'habitFrequency', Sort.desc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> thenByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.asc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> thenByIsCompletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isCompleted', Sort.desc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> thenByLastCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDate', Sort.asc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy>
  thenByLastCompletedDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastCompletedDate', Sort.desc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> thenByStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.asc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> thenByStreakDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'streak', Sort.desc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> thenByTimeReminderHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeReminderHour', Sort.asc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy>
  thenByTimeReminderHourDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeReminderHour', Sort.desc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy> thenByTimeReminderMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeReminderMinute', Sort.asc);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QAfterSortBy>
  thenByTimeReminderMinuteDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'timeReminderMinute', Sort.desc);
    });
  }
}

extension HabitIsarQueryWhereDistinct
    on QueryBuilder<HabitIsar, HabitIsar, QDistinct> {
  QueryBuilder<HabitIsar, HabitIsar, QDistinct> distinctByCategory({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'category', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QDistinct> distinctByHabitFrequency({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(
        r'habitFrequency',
        caseSensitive: caseSensitive,
      );
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QDistinct> distinctByIsCompleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isCompleted');
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QDistinct> distinctByLastCompletedDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastCompletedDate');
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QDistinct> distinctByName({
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QDistinct> distinctByStreak() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'streak');
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QDistinct> distinctByTimeReminderHour() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeReminderHour');
    });
  }

  QueryBuilder<HabitIsar, HabitIsar, QDistinct> distinctByTimeReminderMinute() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'timeReminderMinute');
    });
  }
}

extension HabitIsarQueryProperty
    on QueryBuilder<HabitIsar, HabitIsar, QQueryProperty> {
  QueryBuilder<HabitIsar, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<HabitIsar, String, QQueryOperations> categoryProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'category');
    });
  }

  QueryBuilder<HabitIsar, String, QQueryOperations> habitFrequencyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'habitFrequency');
    });
  }

  QueryBuilder<HabitIsar, bool, QQueryOperations> isCompletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isCompleted');
    });
  }

  QueryBuilder<HabitIsar, DateTime?, QQueryOperations>
  lastCompletedDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastCompletedDate');
    });
  }

  QueryBuilder<HabitIsar, String, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<HabitIsar, int, QQueryOperations> streakProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'streak');
    });
  }

  QueryBuilder<HabitIsar, int, QQueryOperations> timeReminderHourProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeReminderHour');
    });
  }

  QueryBuilder<HabitIsar, int, QQueryOperations> timeReminderMinuteProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'timeReminderMinute');
    });
  }
}
