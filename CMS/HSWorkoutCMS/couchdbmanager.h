#include <QObject>
#include <QNetworkAccessManager>
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkReply>

class CouchDbManager : public QObject
{
    Q_OBJECT
public:
    explicit CouchDbManager(QObject *parent = nullptr);

    Q_INVOKABLE void listarExercicios();
    Q_INVOKABLE void inserirExercicio(const QString &titulo, const QString &descricao, const QString &nivel, int duracao);
    Q_INVOKABLE void editarExercicio(const QString &id, const QString &rev, const QString &titulo, const QString &descricao, const QString &nivel, int duracao);
    Q_INVOKABLE void apagarExercicio(const QString &id, const QString &rev);
    Q_INVOKABLE void listarEntidades(QString entidade);

signals:
    void exerciciosRecebidos(const QJsonArray &exercicios);
    void operacaoConcluida(bool sucesso, const QString &mensagem);

private:
    QNetworkAccessManager m_netManager;
    QString m_baseUrl = "http://localhost:5984/hsworkout-db";
};
