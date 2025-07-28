#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include "CouchDbManager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    // Registo do tipo C++ para o QML
    qmlRegisterType<CouchDbManager>("Backend", 1, 0, "CouchDbManager");

    QQmlApplicationEngine engine;
    const QUrl url(QStringLiteral("qrc:/main.qml"));
    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreated,
        &app,
        [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}
