#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QtQml>

int main( int argc, char * argv[] )
{
    QGuiApplication app( argc, argv );

    QQmlApplicationEngine engine;
    engine.load( QUrl( QStringLiteral( "qrc:///qml/main.qml") ) );

    return app.exec();
}
