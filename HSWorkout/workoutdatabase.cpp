#include "workoutdatabase.h"

WorkoutDatabase::WorkoutDatabase(QObject *parent)
    : QObject(parent)
{
    m_database = QSqlDatabase::addDatabase("QSQLITE");
    m_databasePath = getAppDataPath() + "/workout_database.sqlite";
    qDebug() << "Workout Manager Init" << "DB Path:" << m_databasePath;
}

WorkoutDatabase::~WorkoutDatabase()
{
    if (m_database.isOpen()) {
        m_database.close();
    }
}

bool WorkoutDatabase::initialize()
{
    // Criar diretório se não existir
    QDir dir;
    if (!dir.exists(getAppDataPath())) {
        if (!dir.mkpath(getAppDataPath())) {
            setLastError("Não foi possível criar o diretório da base de dados");
            return false;
        }
    }

    m_database.setDatabaseName(m_databasePath);

    if (!m_database.open()) {
        setLastError("Erro ao abrir a base de dados: " + m_database.lastError().text());
        return false;
    }

    if (!createTables()) {
        return false;
    }

    qDebug() << "Base de dados inicializada em:" << m_databasePath;
    emit databaseInitialized();
    emit operationCompleted(true, "Base de dados inicializada com sucesso");
    return true;
}

bool WorkoutDatabase::createTables()
{
    QSqlQuery query(m_database);

    // Tabela de Planos de Treino
    QString createPlansTable = R"(
        CREATE TABLE IF NOT EXISTS workout_plans (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            description TEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP
        )
    )";

    if (!query.exec(createPlansTable)) {
        setLastError("Erro ao criar tabela workout_plans: " + query.lastError().text());
        return false;
    }

    // Tabela de Treinos
    QString createWorkoutsTable = R"(
        CREATE TABLE IF NOT EXISTS workouts (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            plan_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            description TEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (plan_id) REFERENCES workout_plans(id) ON DELETE CASCADE
        )
    )";

    if (!query.exec(createWorkoutsTable)) {
        setLastError("Erro ao criar tabela workouts: " + query.lastError().text());
        return false;
    }

    // Tabela de Exercícios
    QString createExercisesTable = R"(
        CREATE TABLE IF NOT EXISTS exercises (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            workout_id INTEGER NOT NULL,
            name TEXT NOT NULL,
            series INTEGER NOT NULL,
            repetitions TEXT NOT NULL,
            weight TEXT,
            rest_time INTEGER DEFAULT 60,
            video_url TEXT,
            created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            updated_at DATETIME DEFAULT CURRENT_TIMESTAMP,
            FOREIGN KEY (workout_id) REFERENCES workouts(id) ON DELETE CASCADE
        )
    )";

    if (!query.exec(createExercisesTable)) {
        setLastError("Erro ao criar tabela exercises: " + query.lastError().text());
        return false;
    }

    return true;
}

// CRUD Planos de Treino
int WorkoutDatabase::createWorkoutPlan(const QString &name, const QString &description)
{
    if (!m_database.isOpen()) {
        setLastError("Base de dados não está aberta");
        return -1;
    }

    QSqlQuery query(m_database);
    query.prepare("INSERT INTO workout_plans (name, description) VALUES (?, ?)");
    query.addBindValue(name);
    query.addBindValue(description);

    if (!query.exec()) {
        setLastError("Erro ao criar plano de treino: " + query.lastError().text());
        return -1;
    }

    int planId = query.lastInsertId().toInt();
    emit operationCompleted(true, "Plano de treino criado com sucesso");
    return planId;
}

QVariantList WorkoutDatabase::getAllWorkoutPlans()
{
    QVariantList plans;

    if (!m_database.isOpen()) {
        setLastError("Base de dados não está aberta");
        return plans;
    }

    QSqlQuery query(m_database);
    query.prepare(R"(
        SELECT p.*, COUNT(w.id) as workout_count
        FROM workout_plans p
        LEFT JOIN workouts w ON p.id = w.plan_id
        GROUP BY p.id
        ORDER BY p.created_at DESC
    )");

    if (!query.exec()) {
        setLastError("Erro ao buscar planos de treino: " + query.lastError().text());
        return plans;
    }

    while (query.next()) {
        QVariantMap plan;
        plan["id"] = query.value("id");
        plan["name"] = query.value("name");
        plan["description"] = query.value("description");
        plan["created_at"] = query.value("created_at");
        plan["updated_at"] = query.value("updated_at");
        plan["workout_count"] = query.value("workout_count");
        plans.append(plan);
    }

    return plans;
}

QVariantMap WorkoutDatabase::getWorkoutPlan(int planId)
{
    QVariantMap plan;

    if (!m_database.isOpen()) {
        setLastError("Base de dados não está aberta");
        return plan;
    }

    QSqlQuery query(m_database);
    query.prepare("SELECT * FROM workout_plans WHERE id = ?");
    query.addBindValue(planId);

    if (!query.exec()) {
        setLastError("Erro ao buscar plano de treino: " + query.lastError().text());
        return plan;
    }

    if (query.next()) {
        plan["id"] = query.value("id");
        plan["name"] = query.value("name");
        plan["description"] = query.value("description");
        plan["created_at"] = query.value("created_at");
        plan["updated_at"] = query.value("updated_at");
    }

    return plan;
}

bool WorkoutDatabase::updateWorkoutPlan(int planId, const QString &name, const QString &description)
{
    if (!m_database.isOpen()) {
        setLastError("Base de dados não está aberta");
        return false;
    }

    QSqlQuery query(m_database);
    query.prepare("UPDATE workout_plans SET name = ?, description = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?");
    query.addBindValue(name);
    query.addBindValue(description);
    query.addBindValue(planId);

    if (!query.exec()) {
        setLastError("Erro ao atualizar plano de treino: " + query.lastError().text());
        return false;
    }

    emit operationCompleted(true, "Plano de treino atualizado com sucesso");
    return true;
}

bool WorkoutDatabase::deleteWorkoutPlan(int planId)
{
    if (!m_database.isOpen()) {
        setLastError("Base de dados não está aberta");
        return false;
    }

    QSqlQuery query(m_database);
    query.prepare("DELETE FROM workout_plans WHERE id = ?");
    query.addBindValue(planId);

    if (!query.exec()) {
        setLastError("Erro ao eliminar plano de treino: " + query.lastError().text());
        return false;
    }

    emit operationCompleted(true, "Plano de treino eliminado com sucesso");
    return true;
}

// CRUD Treinos
int WorkoutDatabase::createWorkout(int planId, const QString &name, const QString &description)
{
    if (!m_database.isOpen()) {
        setLastError("Base de dados não está aberta");
        return -1;
    }

    QSqlQuery query(m_database);
    query.prepare("INSERT INTO workouts (plan_id, name, description) VALUES (?, ?, ?)");
    query.addBindValue(planId);
    query.addBindValue(name);
    query.addBindValue(description);

    if (!query.exec()) {
        setLastError("Erro ao criar treino: " + query.lastError().text());
        return -1;
    }

    int workoutId = query.lastInsertId().toInt();
    emit operationCompleted(true, "Treino criado com sucesso");
    return workoutId;
}

QVariantList WorkoutDatabase::getWorkoutsByPlan(int planId)
{
    QVariantList workouts;

    if (!m_database.isOpen()) {
        setLastError("Base de dados não está aberta");
        return workouts;
    }

    QSqlQuery query(m_database);
    query.prepare(R"(
        SELECT w.*, COUNT(e.id) as exercise_count
        FROM workouts w
        LEFT JOIN exercises e ON w.id = e.workout_id
        WHERE w.plan_id = ?
        GROUP BY w.id
        ORDER BY w.created_at ASC
    )");
    query.addBindValue(planId);

    if (!query.exec()) {
        setLastError("Erro ao buscar treinos: " + query.lastError().text());
        return workouts;
    }

    while (query.next()) {
        QVariantMap workout;
        workout["id"] = query.value("id");
        workout["plan_id"] = query.value("plan_id");
        workout["name"] = query.value("name");
        workout["description"] = query.value("description");
        workout["created_at"] = query.value("created_at");
        workout["updated_at"] = query.value("updated_at");
        workout["exercise_count"] = query.value("exercise_count");
        workouts.append(workout);
    }

    return workouts;
}

QVariantMap WorkoutDatabase::getWorkout(int workoutId)
{
    QVariantMap workout;

    if (!m_database.isOpen()) {
        setLastError("Base de dados não está aberta");
        return workout;
    }

    QSqlQuery query(m_database);
    query.prepare("SELECT * FROM workouts WHERE id = ?");
    query.addBindValue(workoutId);

    if (!query.exec()) {
        setLastError("Erro ao buscar treino: " + query.lastError().text());
        return workout;
    }

    if (query.next()) {
        workout["id"] = query.value("id");
        workout["plan_id"] = query.value("plan_id");
        workout["name"] = query.value("name");
        workout["description"] = query.value("description");
        workout["created_at"] = query.value("created_at");
        workout["updated_at"] = query.value("updated_at");
    }

    return workout;
}

bool WorkoutDatabase::updateWorkout(int workoutId, const QString &name, const QString &description)
{
    if (!m_database.isOpen()) {
        setLastError("Base de dados não está aberta");
        return false;
    }

    QSqlQuery query(m_database);
    query.prepare("UPDATE workouts SET name = ?, description = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?");
    query.addBindValue(name);
    query.addBindValue(description);
    query.addBindValue(workoutId);

    if (!query.exec()) {
        setLastError("Erro ao atualizar treino: " + query.lastError().text());
        return false;
    }

    emit operationCompleted(true, "Treino atualizado com sucesso");
    return true;
}

bool WorkoutDatabase::deleteWorkout(int workoutId)
{
    if (!m_database.isOpen()) {
        setLastError("Base de dados não está aberta");
        return false;
    }

    QSqlQuery query(m_database);
    query.prepare("DELETE FROM workouts WHERE id = ?");
    query.addBindValue(workoutId);

    if (!query.exec()) {
        setLastError("Erro ao eliminar treino: " + query.lastError().text());
        return false;
    }

    emit operationCompleted(true, "Treino eliminado com sucesso");
    return true;
}

// CRUD Exercícios
int WorkoutDatabase::createExercise(int workoutId, const QString &name, int series,
                                    const QString &repetitions, const QString &weight,
                                    int restTime, const QString &videoUrl)
{
    if (!m_database.isOpen()) {
        setLastError("Base de dados não está aberta");
        return -1;
    }

    QSqlQuery query(m_database);
    query.prepare("INSERT INTO exercises (workout_id, name, series, repetitions, weight, rest_time, video_url) VALUES (?, ?, ?, ?, ?, ?, ?)");
    query.addBindValue(workoutId);
    query.addBindValue(name);
    query.addBindValue(series);
    query.addBindValue(repetitions);
    query.addBindValue(weight);
    query.addBindValue(restTime);
    query.addBindValue(videoUrl);

    if (!query.exec()) {
        setLastError("Erro ao criar exercício: " + query.lastError().text());
        return -1;
    }

    int exerciseId = query.lastInsertId().toInt();
    emit operationCompleted(true, "Exercício criado com sucesso");
    return exerciseId;
}

QVariantList WorkoutDatabase::getExercisesByWorkout(int workoutId)
{
    QVariantList exercises;

    if (!m_database.isOpen()) {
        setLastError("Base de dados não está aberta");
        return exercises;
    }

    QSqlQuery query(m_database);
    query.prepare("SELECT * FROM exercises WHERE workout_id = ? ORDER BY created_at ASC");
    query.addBindValue(workoutId);

    if (!query.exec()) {
        setLastError("Erro ao buscar exercícios: " + query.lastError().text());
        return exercises;
    }

    while (query.next()) {
        QVariantMap exercise;
        exercise["id"] = query.value("id");
        exercise["workout_id"] = query.value("workout_id");
        exercise["name"] = query.value("name");
        exercise["series"] = query.value("series");
        exercise["repetitions"] = query.value("repetitions");
        exercise["weight"] = query.value("weight");
        exercise["rest_time"] = query.value("rest_time");
        exercise["video_url"] = query.value("video_url");
        exercise["created_at"] = query.value("created_at");
        exercise["updated_at"] = query.value("updated_at");
        exercises.append(exercise);
    }

    return exercises;
}

QVariantMap WorkoutDatabase::getExercise(int exerciseId)
{
    QVariantMap exercise;

    if (!m_database.isOpen()) {
        setLastError("Base de dados não está aberta");
        return exercise;
    }

    QSqlQuery query(m_database);
    query.prepare("SELECT * FROM exercises WHERE id = ?");
    query.addBindValue(exerciseId);

    if (!query.exec()) {
        setLastError("Erro ao buscar exercício: " + query.lastError().text());
        return exercise;
    }

    if (query.next()) {
        exercise["id"] = query.value("id");
        exercise["workout_id"] = query.value("workout_id");
        exercise["name"] = query.value("name");
        exercise["series"] = query.value("series");
        exercise["repetitions"] = query.value("repetitions");
        exercise["weight"] = query.value("weight");
        exercise["rest_time"] = query.value("rest_time");
        exercise["video_url"] = query.value("video_url");
        exercise["created_at"] = query.value("created_at");
        exercise["updated_at"] = query.value("updated_at");
    }

    return exercise;
}

bool WorkoutDatabase::updateExercise(int exerciseId, const QString &name, int series,
                                     const QString &repetitions, const QString &weight,
                                     int restTime, const QString &videoUrl)
{
    if (!m_database.isOpen()) {
        setLastError("Base de dados não está aberta");
        return false;
    }

    QSqlQuery query(m_database);
    query.prepare("UPDATE exercises SET name = ?, series = ?, repetitions = ?, weight = ?, rest_time = ?, video_url = ?, updated_at = CURRENT_TIMESTAMP WHERE id = ?");
    query.addBindValue(name);
    query.addBindValue(series);
    query.addBindValue(repetitions);
    query.addBindValue(weight);
    query.addBindValue(restTime);
    query.addBindValue(videoUrl);
    query.addBindValue(exerciseId);

    if (!query.exec()) {
        setLastError("Erro ao atualizar exercício: " + query.lastError().text());
        return false;
    }

    emit operationCompleted(true, "Exercício atualizado com sucesso");
    return true;
}

bool WorkoutDatabase::deleteExercise(int exerciseId)
{
    if (!m_database.isOpen()) {
        setLastError("Base de dados não está aberta");
        return false;
    }

    QSqlQuery query(m_database);
    query.prepare("DELETE FROM exercises WHERE id = ?");
    query.addBindValue(exerciseId);

    if (!query.exec()) {
        setLastError("Erro ao eliminar exercício: " + query.lastError().text());
        return false;
    }

    emit operationCompleted(true, "Exercício eliminado com sucesso");
    return true;
}

// Funções auxiliares
QString WorkoutDatabase::getLastError() const
{
    return m_lastError;
}

bool WorkoutDatabase::executeSql(const QString &queryString)
{
    if (!m_database.isOpen()) {
        setLastError("Base de dados não está aberta");
        return false;
    }

    QSqlQuery query(m_database);
    if (!query.exec(queryString)) {
        setLastError("Erro ao executar SQL: " + query.lastError().text());
        return false;
    }

    emit operationCompleted(true, "SQL executado com sucesso");
    return true;
}

QVariantList WorkoutDatabase::executeSelect(const QString &queryString)
{
    QVariantList results;

    if (!m_database.isOpen()) {
        setLastError("Base de dados não está aberta");
        return results;
    }

    QSqlQuery query(m_database);
    if (!query.exec(queryString)) {
        setLastError("Erro na consulta: " + query.lastError().text());
        return results;
    }

    while (query.next()) {
        QVariantMap record;
        QSqlRecord sqlRecord = query.record();

        for (int i = 0; i < sqlRecord.count(); ++i) {
            record[sqlRecord.fieldName(i)] = query.value(i);
        }

        results.append(record);
    }

    return results;
}

void WorkoutDatabase::setLastError(const QString &error)
{
    m_lastError = error;
    qDebug() << "WorkoutDatabase Error:" << error;
    emit databaseError(error);
}

QString WorkoutDatabase::getAppDataPath()
{
    return QStandardPaths::writableLocation(QStandardPaths::AppDataLocation);
}

bool WorkoutDatabase::tableExists(const QString &tableName)
{
    QSqlQuery query(m_database);
    query.prepare("SELECT name FROM sqlite_master WHERE type='table' AND name=?");
    query.addBindValue(tableName);

    if (query.exec() && query.next()) {
        return true;
    }

    return false;
}
