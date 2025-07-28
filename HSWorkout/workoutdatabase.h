#ifndef WORKOUTDATABASE_H
#define WORKOUTDATABASE_H

#include <QObject>
#include <QSqlDatabase>
#include <QSqlQuery>
#include <QSqlRecord>
#include <QSqlError>
#include <QVariantList>
#include <QVariantMap>
#include <QStandardPaths>
#include <QDir>
#include <QDebug>
#include <QDateTime>

class WorkoutDatabase : public QObject
{
    Q_OBJECT

public:
    explicit WorkoutDatabase(QObject *parent = nullptr);
    ~WorkoutDatabase();

    // Inicialização da base de dados
    Q_INVOKABLE bool initialize();

    // CRUD Planos de Treino
    Q_INVOKABLE int createWorkoutPlan(const QString &name, const QString &description = "");
    Q_INVOKABLE QVariantList getAllWorkoutPlans();
    Q_INVOKABLE QVariantMap getWorkoutPlan(int planId);
    Q_INVOKABLE bool updateWorkoutPlan(int planId, const QString &name, const QString &description = "");
    Q_INVOKABLE bool deleteWorkoutPlan(int planId);

    // CRUD Treinos
    Q_INVOKABLE int createWorkout(int planId, const QString &name, const QString &description = "");
    Q_INVOKABLE QVariantList getWorkoutsByPlan(int planId);
    Q_INVOKABLE QVariantMap getWorkout(int workoutId);
    Q_INVOKABLE bool updateWorkout(int workoutId, const QString &name, const QString &description = "");
    Q_INVOKABLE bool deleteWorkout(int workoutId);

    // CRUD Exercícios
    Q_INVOKABLE int createExercise(int workoutId, const QString &name, int series,
                                   const QString &repetitions, const QString &weight,
                                   int restTime, const QString &videoUrl = "");
    Q_INVOKABLE QVariantList getExercisesByWorkout(int workoutId);
    Q_INVOKABLE QVariantMap getExercise(int exerciseId);
    Q_INVOKABLE bool updateExercise(int exerciseId, const QString &name, int series,
                                    const QString &repetitions, const QString &weight,
                                    int restTime, const QString &videoUrl = "");
    Q_INVOKABLE bool deleteExercise(int exerciseId);

    // Funções auxiliares
    Q_INVOKABLE QString getLastError() const;
    Q_INVOKABLE bool executeSql(const QString &query);
    Q_INVOKABLE QVariantList executeSelect(const QString &query);

signals:
    void databaseError(const QString &error);
    void operationCompleted(bool success, const QString &message = "");
    void databaseInitialized();

private:
    QSqlDatabase m_database;
    QString m_lastError;
    QString m_databasePath;

    void setLastError(const QString &error);
    QString getAppDataPath();
    bool createTables();
    bool tableExists(const QString &tableName);
};

#endif // WORKOUTDATABASE_H
