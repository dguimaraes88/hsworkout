#include "CouchDbManager.h"
#include <QNetworkRequest>
#include <QJsonArray>
#include <QJsonDocument>
#include <QJsonObject>
#include <QUrlQuery>

CouchDbManager::CouchDbManager(QObject *parent)
    : QObject(parent)
{
}

void CouchDbManager::listarEntidades(QString entidade)
{
    QUrl url(m_baseUrl + "/_find");
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject selector;
    selector["type"] = entidade;

    QJsonObject payload;
    payload["selector"] = selector;

    QNetworkReply *reply = m_netManager.post(request, QJsonDocument(payload).toJson());

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
            QJsonArray docs = doc.object().value("docs").toArray();
            emit exerciciosRecebidos(docs);
        } else {
            emit operacaoConcluida(false, "Erro ao listar: " + reply->errorString());
        }
        reply->deleteLater();
    });
}

void CouchDbManager::listarExercicios()
{
    QUrl url(m_baseUrl + "/_find");
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject selector;
    selector["type"] = "exercicio";

    QJsonObject payload;
    payload["selector"] = selector;

    QNetworkReply *reply = m_netManager.post(request, QJsonDocument(payload).toJson());

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
            QJsonArray docs = doc.object().value("docs").toArray();
            emit exerciciosRecebidos(docs);
        } else {
            emit operacaoConcluida(false, "Erro ao listar: " + reply->errorString());
        }
        reply->deleteLater();
    });
}

void CouchDbManager::inserirExercicio(const QString &titulo, const QString &descricao, const QString &nivel, int duracao)
{
    QUrl url(m_baseUrl);
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject doc;
    doc["type"] = "exercicio";
    doc["titulo"] = titulo;
    doc["descricao"] = descricao;
    doc["nivel"] = nivel;
    doc["duracao"] = duracao;

    QNetworkReply *reply = m_netManager.post(request, QJsonDocument(doc).toJson());

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            emit operacaoConcluida(true, "Inserido com sucesso.");
        } else {
            emit operacaoConcluida(false, "Erro ao inserir: " + reply->errorString());
        }
        reply->deleteLater();
    });
}

void CouchDbManager::editarExercicio(const QString &id, const QString &rev, const QString &titulo, const QString &descricao, const QString &nivel, int duracao)
{
    QUrl url(m_baseUrl + "/" + id);
    QNetworkRequest request(url);
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject doc;
    doc["_id"] = id;
    doc["_rev"] = rev;
    doc["type"] = "exercicio";
    doc["titulo"] = titulo;
    doc["descricao"] = descricao;
    doc["nivel"] = nivel;
    doc["duracao"] = duracao;

    QNetworkReply *reply = m_netManager.put(request, QJsonDocument(doc).toJson());

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            emit operacaoConcluida(true, "Editado com sucesso.");
        } else {
            emit operacaoConcluida(false, "Erro ao editar: " + reply->errorString());
        }
        reply->deleteLater();
    });
}

void CouchDbManager::apagarExercicio(const QString &id, const QString &rev)
{
    QUrl url(m_baseUrl + "/" + id + "?rev=" + rev);
    QNetworkRequest request(url);

    QNetworkReply *reply = m_netManager.deleteResource(request);

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            emit operacaoConcluida(true, "Apagado com sucesso.");
        } else {
            emit operacaoConcluida(false, "Erro ao apagar: " + reply->errorString());
        }
        reply->deleteLater();
    });
}
