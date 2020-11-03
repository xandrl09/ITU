import QtQuick 2.12

// Základem každého prvku je čtverec
Rectangle {
    id: btn;
    width: 100
    height: 80
    radius: 5
    property alias text: txt.text;

    // Proměnné, které mají parametr property jsou přístupné z venčí
    property color btnColor: "#777777";
    property color textColor: mouse.pressed ? "#0066FF" : "black"

    // Definování signálu
    signal clicked();

    color: mouse.pressed ? Qt.darker(btnColor) : btnColor;
    //radius: 1;
    border.color: "black";
    border.width: 1 ;

    // TODO
    // Upravte nastavení hodnoty color tak,
    // aby při stisknutí myši se změnila barva tlačítka (1 bod)


    // Samotná třída Rectangle nijak nezachytává signály
    // ze vstupních zařízení. Pro jejich zachytávání a zpracování
    // je potřeba vložit třídy k tomu určené.
    // Oblast zachytávající události myši
    // Lze použít definovat oblushu události (onClicked, atd.)
    // uvnitř i mimo tento prvek, pak je zapotřebí použít
    // referenci přes id prvku. Lze i přistupovat k vlastnostem
    // objektu (vnitřní hodnoty), např. mouse.pressed (viz výše).
    MouseArea {
        id: mouse;
        anchors.fill: parent;
        onClicked: {
            btn.clicked();
            //radius : 1;
        }
    }

    // Textový prvek pro zobrazení textu
    Text {
        id: txt;
        
        font.pixelSize: 20
       // height: 2 * width
font.bold: false
        //anchors.left: btn.left
        //anchors.centerIn: btn.Center
        //horizontalAlignment: center
        anchors.horizontalCenter: btn.horizontalLeft
        leftPadding: 5
        anchors.verticalCenter: btn.verticalCenter
        //elide: Text.ElideMiddle

        // TODO
        // Nastavte parametry tohoto prvku tak,
        // aby výsledný text byl zarovnán na střed tlačítka
        // a měl vhodné formátování (1 bod)
    }

}
