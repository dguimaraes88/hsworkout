#include <QApplication>
#include <QQmlApplicationEngine>
#include <QSettings>
#include <QDir>
#include <QStandardPaths>
#include "workoutdatabase.h"

int main(int argc, char *argv[])
{   
    QApplication app(argc, argv);
    app.setOrganizationName("hsworkout");
    app.setApplicationName("hsworkout");
    QDir applicationDir(app.applicationDirPath());    
    QSettings deviceTypeSettings(applicationDir.absoluteFilePath("settings.ini"), QSettings::IniFormat);

    QSettings::setDefaultFormat(QSettings::IniFormat);
    QSettings::setPath(QSettings::IniFormat, QSettings::UserScope, QStandardPaths::writableLocation(QStandardPaths::AppLocalDataLocation));

    QQmlApplicationEngine engine;

    //Register
    qmlRegisterType<WorkoutDatabase>("WorkoutDB",1,0,"WorkoutManager");

    const QUrl url("qrc:/main.qml");
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
