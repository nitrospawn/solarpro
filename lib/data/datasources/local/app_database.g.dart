// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProjectsTable extends Projects with TableInfo<$ProjectsTable, Project> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _clientNameMeta =
      const VerificationMeta('clientName');
  @override
  late final GeneratedColumn<String> clientName = GeneratedColumn<String>(
      'client_name', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'created_at', aliasedName, false,
      type: DriftSqlType.dateTime,
      requiredDuringInsert: false,
      defaultValue: currentDateAndTime);
  @override
  List<GeneratedColumn> get $columns => [id, name, clientName, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(Insertable<Project> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('client_name')) {
      context.handle(
          _clientNameMeta,
          clientName.isAcceptableOrUnknown(
              data['client_name']!, _clientNameMeta));
    }
    if (data.containsKey('created_at')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Project map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Project(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      clientName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}client_name']),
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}created_at'])!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class Project extends DataClass implements Insertable<Project> {
  final String id;
  final String name;
  final String? clientName;
  final DateTime createdAt;
  const Project(
      {required this.id,
      required this.name,
      this.clientName,
      required this.createdAt});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || clientName != null) {
      map['client_name'] = Variable<String>(clientName);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      clientName: clientName == null && nullToAbsent
          ? const Value.absent()
          : Value(clientName),
      createdAt: Value(createdAt),
    );
  }

  factory Project.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Project(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      clientName: serializer.fromJson<String?>(json['clientName']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'clientName': serializer.toJson<String?>(clientName),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  Project copyWith(
          {String? id,
          String? name,
          Value<String?> clientName = const Value.absent(),
          DateTime? createdAt}) =>
      Project(
        id: id ?? this.id,
        name: name ?? this.name,
        clientName: clientName.present ? clientName.value : this.clientName,
        createdAt: createdAt ?? this.createdAt,
      );
  Project copyWithCompanion(ProjectsCompanion data) {
    return Project(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      clientName:
          data.clientName.present ? data.clientName.value : this.clientName,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Project(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('clientName: $clientName, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, clientName, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Project &&
          other.id == this.id &&
          other.name == this.name &&
          other.clientName == this.clientName &&
          other.createdAt == this.createdAt);
}

class ProjectsCompanion extends UpdateCompanion<Project> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> clientName;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.clientName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String name,
    this.clientName = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name);
  static Insertable<Project> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? clientName,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (clientName != null) 'client_name': clientName,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String?>? clientName,
      Value<DateTime>? createdAt,
      Value<int>? rowid}) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      clientName: clientName ?? this.clientName,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (clientName.present) {
      map['client_name'] = Variable<String>(clientName.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('clientName: $clientName, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppliancesTableTable extends AppliancesTable
    with TableInfo<$AppliancesTableTable, AppliancesTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppliancesTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _projectIdMeta =
      const VerificationMeta('projectId');
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
      'project_id', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _runningWattsMeta =
      const VerificationMeta('runningWatts');
  @override
  late final GeneratedColumn<double> runningWatts = GeneratedColumn<double>(
      'running_watts', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _surgeMultiplierMeta =
      const VerificationMeta('surgeMultiplier');
  @override
  late final GeneratedColumn<double> surgeMultiplier = GeneratedColumn<double>(
      'surge_multiplier', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dailyHoursMeta =
      const VerificationMeta('dailyHours');
  @override
  late final GeneratedColumn<double> dailyHours = GeneratedColumn<double>(
      'daily_hours', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _dutyCycleMeta =
      const VerificationMeta('dutyCycle');
  @override
  late final GeneratedColumn<double> dutyCycle = GeneratedColumn<double>(
      'duty_cycle', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(1.0));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        projectId,
        name,
        category,
        quantity,
        runningWatts,
        surgeMultiplier,
        dailyHours,
        dutyCycle
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'appliances_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<AppliancesTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(_projectIdMeta,
          projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('running_watts')) {
      context.handle(
          _runningWattsMeta,
          runningWatts.isAcceptableOrUnknown(
              data['running_watts']!, _runningWattsMeta));
    } else if (isInserting) {
      context.missing(_runningWattsMeta);
    }
    if (data.containsKey('surge_multiplier')) {
      context.handle(
          _surgeMultiplierMeta,
          surgeMultiplier.isAcceptableOrUnknown(
              data['surge_multiplier']!, _surgeMultiplierMeta));
    } else if (isInserting) {
      context.missing(_surgeMultiplierMeta);
    }
    if (data.containsKey('daily_hours')) {
      context.handle(
          _dailyHoursMeta,
          dailyHours.isAcceptableOrUnknown(
              data['daily_hours']!, _dailyHoursMeta));
    } else if (isInserting) {
      context.missing(_dailyHoursMeta);
    }
    if (data.containsKey('duty_cycle')) {
      context.handle(_dutyCycleMeta,
          dutyCycle.isAcceptableOrUnknown(data['duty_cycle']!, _dutyCycleMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AppliancesTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AppliancesTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      projectId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}project_id']),
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      runningWatts: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}running_watts'])!,
      surgeMultiplier: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}surge_multiplier'])!,
      dailyHours: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}daily_hours'])!,
      dutyCycle: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}duty_cycle'])!,
    );
  }

  @override
  $AppliancesTableTable createAlias(String alias) {
    return $AppliancesTableTable(attachedDatabase, alias);
  }
}

class AppliancesTableData extends DataClass
    implements Insertable<AppliancesTableData> {
  final String id;
  final String? projectId;
  final String name;
  final String category;
  final int quantity;
  final double runningWatts;
  final double surgeMultiplier;
  final double dailyHours;
  final double dutyCycle;
  const AppliancesTableData(
      {required this.id,
      this.projectId,
      required this.name,
      required this.category,
      required this.quantity,
      required this.runningWatts,
      required this.surgeMultiplier,
      required this.dailyHours,
      required this.dutyCycle});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    map['name'] = Variable<String>(name);
    map['category'] = Variable<String>(category);
    map['quantity'] = Variable<int>(quantity);
    map['running_watts'] = Variable<double>(runningWatts);
    map['surge_multiplier'] = Variable<double>(surgeMultiplier);
    map['daily_hours'] = Variable<double>(dailyHours);
    map['duty_cycle'] = Variable<double>(dutyCycle);
    return map;
  }

  AppliancesTableCompanion toCompanion(bool nullToAbsent) {
    return AppliancesTableCompanion(
      id: Value(id),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      name: Value(name),
      category: Value(category),
      quantity: Value(quantity),
      runningWatts: Value(runningWatts),
      surgeMultiplier: Value(surgeMultiplier),
      dailyHours: Value(dailyHours),
      dutyCycle: Value(dutyCycle),
    );
  }

  factory AppliancesTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AppliancesTableData(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      name: serializer.fromJson<String>(json['name']),
      category: serializer.fromJson<String>(json['category']),
      quantity: serializer.fromJson<int>(json['quantity']),
      runningWatts: serializer.fromJson<double>(json['runningWatts']),
      surgeMultiplier: serializer.fromJson<double>(json['surgeMultiplier']),
      dailyHours: serializer.fromJson<double>(json['dailyHours']),
      dutyCycle: serializer.fromJson<double>(json['dutyCycle']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String?>(projectId),
      'name': serializer.toJson<String>(name),
      'category': serializer.toJson<String>(category),
      'quantity': serializer.toJson<int>(quantity),
      'runningWatts': serializer.toJson<double>(runningWatts),
      'surgeMultiplier': serializer.toJson<double>(surgeMultiplier),
      'dailyHours': serializer.toJson<double>(dailyHours),
      'dutyCycle': serializer.toJson<double>(dutyCycle),
    };
  }

  AppliancesTableData copyWith(
          {String? id,
          Value<String?> projectId = const Value.absent(),
          String? name,
          String? category,
          int? quantity,
          double? runningWatts,
          double? surgeMultiplier,
          double? dailyHours,
          double? dutyCycle}) =>
      AppliancesTableData(
        id: id ?? this.id,
        projectId: projectId.present ? projectId.value : this.projectId,
        name: name ?? this.name,
        category: category ?? this.category,
        quantity: quantity ?? this.quantity,
        runningWatts: runningWatts ?? this.runningWatts,
        surgeMultiplier: surgeMultiplier ?? this.surgeMultiplier,
        dailyHours: dailyHours ?? this.dailyHours,
        dutyCycle: dutyCycle ?? this.dutyCycle,
      );
  AppliancesTableData copyWithCompanion(AppliancesTableCompanion data) {
    return AppliancesTableData(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      name: data.name.present ? data.name.value : this.name,
      category: data.category.present ? data.category.value : this.category,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      runningWatts: data.runningWatts.present
          ? data.runningWatts.value
          : this.runningWatts,
      surgeMultiplier: data.surgeMultiplier.present
          ? data.surgeMultiplier.value
          : this.surgeMultiplier,
      dailyHours:
          data.dailyHours.present ? data.dailyHours.value : this.dailyHours,
      dutyCycle: data.dutyCycle.present ? data.dutyCycle.value : this.dutyCycle,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AppliancesTableData(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity, ')
          ..write('runningWatts: $runningWatts, ')
          ..write('surgeMultiplier: $surgeMultiplier, ')
          ..write('dailyHours: $dailyHours, ')
          ..write('dutyCycle: $dutyCycle')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, projectId, name, category, quantity,
      runningWatts, surgeMultiplier, dailyHours, dutyCycle);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AppliancesTableData &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.category == this.category &&
          other.quantity == this.quantity &&
          other.runningWatts == this.runningWatts &&
          other.surgeMultiplier == this.surgeMultiplier &&
          other.dailyHours == this.dailyHours &&
          other.dutyCycle == this.dutyCycle);
}

class AppliancesTableCompanion extends UpdateCompanion<AppliancesTableData> {
  final Value<String> id;
  final Value<String?> projectId;
  final Value<String> name;
  final Value<String> category;
  final Value<int> quantity;
  final Value<double> runningWatts;
  final Value<double> surgeMultiplier;
  final Value<double> dailyHours;
  final Value<double> dutyCycle;
  final Value<int> rowid;
  const AppliancesTableCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.category = const Value.absent(),
    this.quantity = const Value.absent(),
    this.runningWatts = const Value.absent(),
    this.surgeMultiplier = const Value.absent(),
    this.dailyHours = const Value.absent(),
    this.dutyCycle = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppliancesTableCompanion.insert({
    required String id,
    this.projectId = const Value.absent(),
    required String name,
    required String category,
    required int quantity,
    required double runningWatts,
    required double surgeMultiplier,
    required double dailyHours,
    this.dutyCycle = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        category = Value(category),
        quantity = Value(quantity),
        runningWatts = Value(runningWatts),
        surgeMultiplier = Value(surgeMultiplier),
        dailyHours = Value(dailyHours);
  static Insertable<AppliancesTableData> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? name,
    Expression<String>? category,
    Expression<int>? quantity,
    Expression<double>? runningWatts,
    Expression<double>? surgeMultiplier,
    Expression<double>? dailyHours,
    Expression<double>? dutyCycle,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (category != null) 'category': category,
      if (quantity != null) 'quantity': quantity,
      if (runningWatts != null) 'running_watts': runningWatts,
      if (surgeMultiplier != null) 'surge_multiplier': surgeMultiplier,
      if (dailyHours != null) 'daily_hours': dailyHours,
      if (dutyCycle != null) 'duty_cycle': dutyCycle,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppliancesTableCompanion copyWith(
      {Value<String>? id,
      Value<String?>? projectId,
      Value<String>? name,
      Value<String>? category,
      Value<int>? quantity,
      Value<double>? runningWatts,
      Value<double>? surgeMultiplier,
      Value<double>? dailyHours,
      Value<double>? dutyCycle,
      Value<int>? rowid}) {
    return AppliancesTableCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      category: category ?? this.category,
      quantity: quantity ?? this.quantity,
      runningWatts: runningWatts ?? this.runningWatts,
      surgeMultiplier: surgeMultiplier ?? this.surgeMultiplier,
      dailyHours: dailyHours ?? this.dailyHours,
      dutyCycle: dutyCycle ?? this.dutyCycle,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (runningWatts.present) {
      map['running_watts'] = Variable<double>(runningWatts.value);
    }
    if (surgeMultiplier.present) {
      map['surge_multiplier'] = Variable<double>(surgeMultiplier.value);
    }
    if (dailyHours.present) {
      map['daily_hours'] = Variable<double>(dailyHours.value);
    }
    if (dutyCycle.present) {
      map['duty_cycle'] = Variable<double>(dutyCycle.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppliancesTableCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('category: $category, ')
          ..write('quantity: $quantity, ')
          ..write('runningWatts: $runningWatts, ')
          ..write('surgeMultiplier: $surgeMultiplier, ')
          ..write('dailyHours: $dailyHours, ')
          ..write('dutyCycle: $dutyCycle, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $AppliancesTableTable appliancesTable =
      $AppliancesTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [projects, appliancesTable];
}

typedef $$ProjectsTableCreateCompanionBuilder = ProjectsCompanion Function({
  required String id,
  required String name,
  Value<String?> clientName,
  Value<DateTime> createdAt,
  Value<int> rowid,
});
typedef $$ProjectsTableUpdateCompanionBuilder = ProjectsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String?> clientName,
  Value<DateTime> createdAt,
  Value<int> rowid,
});

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get clientName => $composableBuilder(
      column: $table.clientName, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get clientName => $composableBuilder(
      column: $table.clientName, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get clientName => $composableBuilder(
      column: $table.clientName, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$ProjectsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ProjectsTable,
    Project,
    $$ProjectsTableFilterComposer,
    $$ProjectsTableOrderingComposer,
    $$ProjectsTableAnnotationComposer,
    $$ProjectsTableCreateCompanionBuilder,
    $$ProjectsTableUpdateCompanionBuilder,
    (Project, BaseReferences<_$AppDatabase, $ProjectsTable, Project>),
    Project,
    PrefetchHooks Function()> {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String?> clientName = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProjectsCompanion(
            id: id,
            name: name,
            clientName: clientName,
            createdAt: createdAt,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String?> clientName = const Value.absent(),
            Value<DateTime> createdAt = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              ProjectsCompanion.insert(
            id: id,
            name: name,
            clientName: clientName,
            createdAt: createdAt,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ProjectsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ProjectsTable,
    Project,
    $$ProjectsTableFilterComposer,
    $$ProjectsTableOrderingComposer,
    $$ProjectsTableAnnotationComposer,
    $$ProjectsTableCreateCompanionBuilder,
    $$ProjectsTableUpdateCompanionBuilder,
    (Project, BaseReferences<_$AppDatabase, $ProjectsTable, Project>),
    Project,
    PrefetchHooks Function()>;
typedef $$AppliancesTableTableCreateCompanionBuilder = AppliancesTableCompanion
    Function({
  required String id,
  Value<String?> projectId,
  required String name,
  required String category,
  required int quantity,
  required double runningWatts,
  required double surgeMultiplier,
  required double dailyHours,
  Value<double> dutyCycle,
  Value<int> rowid,
});
typedef $$AppliancesTableTableUpdateCompanionBuilder = AppliancesTableCompanion
    Function({
  Value<String> id,
  Value<String?> projectId,
  Value<String> name,
  Value<String> category,
  Value<int> quantity,
  Value<double> runningWatts,
  Value<double> surgeMultiplier,
  Value<double> dailyHours,
  Value<double> dutyCycle,
  Value<int> rowid,
});

class $$AppliancesTableTableFilterComposer
    extends Composer<_$AppDatabase, $AppliancesTableTable> {
  $$AppliancesTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get runningWatts => $composableBuilder(
      column: $table.runningWatts, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get surgeMultiplier => $composableBuilder(
      column: $table.surgeMultiplier,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get dailyHours => $composableBuilder(
      column: $table.dailyHours, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get dutyCycle => $composableBuilder(
      column: $table.dutyCycle, builder: (column) => ColumnFilters(column));
}

class $$AppliancesTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AppliancesTableTable> {
  $$AppliancesTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get projectId => $composableBuilder(
      column: $table.projectId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get runningWatts => $composableBuilder(
      column: $table.runningWatts,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get surgeMultiplier => $composableBuilder(
      column: $table.surgeMultiplier,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get dailyHours => $composableBuilder(
      column: $table.dailyHours, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get dutyCycle => $composableBuilder(
      column: $table.dutyCycle, builder: (column) => ColumnOrderings(column));
}

class $$AppliancesTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppliancesTableTable> {
  $$AppliancesTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get projectId =>
      $composableBuilder(column: $table.projectId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get runningWatts => $composableBuilder(
      column: $table.runningWatts, builder: (column) => column);

  GeneratedColumn<double> get surgeMultiplier => $composableBuilder(
      column: $table.surgeMultiplier, builder: (column) => column);

  GeneratedColumn<double> get dailyHours => $composableBuilder(
      column: $table.dailyHours, builder: (column) => column);

  GeneratedColumn<double> get dutyCycle =>
      $composableBuilder(column: $table.dutyCycle, builder: (column) => column);
}

class $$AppliancesTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AppliancesTableTable,
    AppliancesTableData,
    $$AppliancesTableTableFilterComposer,
    $$AppliancesTableTableOrderingComposer,
    $$AppliancesTableTableAnnotationComposer,
    $$AppliancesTableTableCreateCompanionBuilder,
    $$AppliancesTableTableUpdateCompanionBuilder,
    (
      AppliancesTableData,
      BaseReferences<_$AppDatabase, $AppliancesTableTable, AppliancesTableData>
    ),
    AppliancesTableData,
    PrefetchHooks Function()> {
  $$AppliancesTableTableTableManager(
      _$AppDatabase db, $AppliancesTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppliancesTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppliancesTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppliancesTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String?> projectId = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<double> runningWatts = const Value.absent(),
            Value<double> surgeMultiplier = const Value.absent(),
            Value<double> dailyHours = const Value.absent(),
            Value<double> dutyCycle = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppliancesTableCompanion(
            id: id,
            projectId: projectId,
            name: name,
            category: category,
            quantity: quantity,
            runningWatts: runningWatts,
            surgeMultiplier: surgeMultiplier,
            dailyHours: dailyHours,
            dutyCycle: dutyCycle,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            Value<String?> projectId = const Value.absent(),
            required String name,
            required String category,
            required int quantity,
            required double runningWatts,
            required double surgeMultiplier,
            required double dailyHours,
            Value<double> dutyCycle = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AppliancesTableCompanion.insert(
            id: id,
            projectId: projectId,
            name: name,
            category: category,
            quantity: quantity,
            runningWatts: runningWatts,
            surgeMultiplier: surgeMultiplier,
            dailyHours: dailyHours,
            dutyCycle: dutyCycle,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AppliancesTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AppliancesTableTable,
    AppliancesTableData,
    $$AppliancesTableTableFilterComposer,
    $$AppliancesTableTableOrderingComposer,
    $$AppliancesTableTableAnnotationComposer,
    $$AppliancesTableTableCreateCompanionBuilder,
    $$AppliancesTableTableUpdateCompanionBuilder,
    (
      AppliancesTableData,
      BaseReferences<_$AppDatabase, $AppliancesTableTable, AppliancesTableData>
    ),
    AppliancesTableData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$AppliancesTableTableTableManager get appliancesTable =>
      $$AppliancesTableTableTableManager(_db, _db.appliancesTable);
}
