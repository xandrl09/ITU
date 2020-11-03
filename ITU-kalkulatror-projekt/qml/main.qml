import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Layouts 1.11
import QtQuick.Controls 2.5

//Většinou se upravuje jen tenhle, soubor...

Window {
    //Parametry okna
    id: okno
    visible: true
    width: 400
    height: 500
    maximumHeight: 500
    maximumWidth: 400
    minimumHeight: 500
    minimumWidth: 400
    onVisibleChanged: if (visible) textA.forceActiveFocus()
    title: "ITU Kalkulačka"
    color: "#ccff99"
    //Seznam, použitý v historii
    ListModel {
        id: history;
    }

    //Seznam prvků pro menu
    ListModel {
        id: controls;
        ListElement { op: "KALKU\nLAČKA"; tog: true;}
        ListElement { op: "POMOC"; tog: false;}
        ListElement { op: "HOT-KEYS"; tog: false;}
        ListElement { op: "HISTORIE"; tog: false;}

    }

    //Seznam prvků pro klasické operace
    ListModel {
        id: basic_operations;
        ListElement { op: "+"; tog: false; }
        ListElement { op: "-"; tog: false; }
        ListElement { op: "*"; tog: false; }
        ListElement { op: "/"; tog: false; }
        ListElement { op: "^"; tog: false; }
        ListElement { op: "√"; tog: false; }
        ListElement { op: "("; tog: false; }
        ListElement { op: ")"; tog: false; }
    }

    //Seznam prvků pro složitější operace
    ListModel {
        id: extended_operations;
        ListElement { op: "sin"; tog: false; }
        ListElement { op: "cos"; tog: false; }
        ListElement { op: "tan"; tog: false; }
        ListElement { op: "log"; tog: false; }
        ListElement { op: "x"; tog: false; }
        ListElement { op: "y"; tog: false; }
        ListElement { op: "e"; tog: false; }
        ListElement { op: "π"; tog: false; }
        ListElement { op: "!"; tog: false; }
        ListElement { op: "ans"; tog: false; }
        ListElement { op: "del"; tog: false; }
        ListElement { op: "clr"; tog: false; }
    }

    //Seznam prvků pro číselník
    ListModel {
        id: numbers;
        ListElement { op: "7"; tog: false; }
        ListElement { op: "8"; tog: false; }
        ListElement { op: "9"; tog: false; }
        ListElement { op: "4"; tog: false; }
        ListElement { op: "5"; tog: false; }
        ListElement { op: "6"; tog: false; }
        ListElement { op: "1"; tog: false; }
        ListElement { op: "2"; tog: false; }
        ListElement { op: "3"; tog: false; }
        ListElement { op: "0"; tog: false; }
        ListElement { op: ","; tog: false; }
        ListElement { op: "="; tog: false; }
    }

    ListModel {
        id: shortcuts;
        ListElement { shcut: "CTRL+h"; shwrite: "sin "; }
        ListElement { shcut: "CTRL+j"; shwrite: "cos "; }
        ListElement { shcut: "CTRL+k"; shwrite: "tan "; }
    }

    //Cokoliv přidáš do seznamu, automaticky se zobrazí v aplikaci




    //Řádek pro menu, kde jsou ty prvky se seznamu pro menu

    Row{
        //Parametry toho řádku
        id: main_menu
        width: 400
        height: 50
        Repeater { //Tohle udělá ty tlačítka podle toho seznamu
            model: controls;
            delegate: MyMenuButton { //Tady se určí, že se budou tvořit tlačítka pro každou položku z seznamu
                btnColor: "#ccff99"
                text: model.op
                radius:5
                toggled: model.tog;
                onClicked: {
                    //Tady je definovaná funkčnost toho přepínání, prostě kontroluju toggle a podle toho dávám visible
                    for (var i = 0; i < controls.count; i++) {
                        controls.setProperty( i, "tog", (i == index) );
                    }
                    if (controls.get(0).tog === true)
                        calc.visible = true
                    else
                        calc.visible = false
                    if (controls.get(1).tog === true)
                        help.visible = true
                    else
                        help.visible = false
                    if (controls.get(2).tog === true)
                        hkeys.visible = true
                    else
                        hkeys.visible = false
                    if (controls.get(3).tog === true)
                        hist.visible = true
                    else
                        hist.visible = false
                }
            }

        }

    }

    Shortcut{
        sequence: "PGUP"
        onActivated: {
            for (var i = 0; i < controls.count; i++) {
                if (controls.get(i).tog === true){
                    controls.setProperty(i, "tog", false)
                    if (i==3)
                        controls.setProperty(0, "tog", true)
                    else
                        controls.setProperty(i+1, "tog", true)
                    break;
                }

            }
            if (controls.get(0).tog === true)
                calc.visible = true
            else
                calc.visible = false
            if (controls.get(1).tog === true)
                help.visible = true
            else
                help.visible = false
            if (controls.get(2).tog === true)
                hkeys.visible = true
            else
                hkeys.visible = false
            if (controls.get(3).tog === true)
                hist.visible = true
            else
                hist.visible = false
        }
    }
    Shortcut{
        sequence: "PGDOWN"
        onActivated: {
            for (var i = 0; i < controls.count; i++) {
                if (controls.get(i).tog === true){
                    controls.setProperty(i, "tog", false)
                    if (i==0)
                        controls.setProperty(3, "tog", true)
                    else
                        controls.setProperty(i-1, "tog", true)
                    break;
                }

            }
            if (controls.get(0).tog === true)
                calc.visible = true
            else
                calc.visible = false
            if (controls.get(1).tog === true)
                help.visible = true
            else
                help.visible = false
            if (controls.get(2).tog === true)
                hkeys.visible = true
            else
                hkeys.visible = false
            if (controls.get(3).tog === true)
                hist.visible = true
            else
                hist.visible = false
        }
    }

    Shortcut {
        sequence: "ENTER"
        onActivated: {
            result.text = "Výsledek " + (history.count+1);
            history.insert(0,{"expression": textA.text, "result": result.text})
        }
    }

    Rectangle {
        //Pro přepínání těch oken používám rectangle, kterej buď zviditelním nebo ne
        //Parametry toho rectanglu
        id: calc
        width: 400
        height: 450
        anchors.top: main_menu.bottom //ukotvení horní hrany rectanglu na spodek main menu
        color: "#bbbbbb"
        //Pole pro zadávání výrazu
        Rectangle {
            //Parametry toho rectanglu
            id: vstup;
            height: 100;
            width: 400;
            border.color: "#bbb";
            border.width: 3;
            anchors.margins: 2

            color: "#EEE"
            ScrollView{
                anchors.fill: parent
                TextField {
                    //anchors.fill: parent;
                    //anchors.margins: 2
                    //autoScroll: true
                    //focus: true
                    width: 400
                    height: 100
                    placeholderText : qsTr("Vložte výraz...")
                    horizontalAlignment: TextInput.AlignLeft
                    verticalAlignment: TextInput.AlignVCenter
                    id: textA
                    font.pointSize: 20
                    validator: RegExpValidator{ regExp: /([0-9]*[xy]*(log)*(sin)*(cos)*(tan)*(e)*(!)*(pi)*(,)*(=)*[+*/]*(-)*(\x5e)*(sqrt)*(\x28)*(\x29)*)*/ }
                }
            }
        }

        //Stejně jak u menu, vytvoří se tlačítko pro každou položku seznamu
        Row{
            id: func_row
            anchors.top:vstup.bottom //zase ukotvení
            GridLayout {
                id: numbers_layout
                columns: 3
                rows: 4
                columnSpacing : 0
                rowSpacing : 0
                Repeater {
                    model: numbers;
                    delegate: MyButton {
                        btnColor: "#ccff99"
                        text: model.op
                        toggled: model.tog;
                        onClicked: { //Definice toho co se stane po kliknutí
                            textA.text = textA.text + op;
                        }
                    }
                }
            }

            GridLayout {
                columns: 2
                rows : 4
                columnSpacing : 0
                rowSpacing : 0
                Repeater{
                    model: basic_operations;
                    delegate: MyButton {
                        btnColor: "#ccff99"
                        text: model.op
                        toggled: model.tog;
                        onClicked: {
                            textA.text = textA.text + op;
                        }
                    }
                }
            }
            GridLayout {
                columns: 3
                rows : 4
                columnSpacing : 0
                rowSpacing : 0
                Repeater{
                    model: extended_operations; //model volí seznam
                    delegate: MyButton {
                        btnColor: model.op == "ans" || model.op == "clr" || model.op == "del" ? "red" : "#ccff99"
                        text: model.op
                        toggled: model.tog;


                        onClicked: {
                            model.op == "ans" ? textA.text = textA.text + (history.count != 0 ? history.get(0).result : "") :
                            model.op == "clr" ? textA.text = "" :
                            model.op == "del" ? textA.remove(textA.length-1,textA.length) : textA.text = textA.text + op
                        }
                    }
                }
            }
        }

        //Tohle je pro to tlačítko "Spočítej", to tlačítko je definovaný v MyClickButton.qmll, ale i tak mu můžeš měnit parametry
        MyClickButton {
            width: 300;
            btnColor: "#ccff99"
            anchors.top: func_row.bottom
            text: qsTr( "Spočítej" )
            id: compute
            onClicked: { //Zase, co se stane po kliknutí, tady přidávám do historie)
                result.text = "Výsledek " + (history.count+1);
                history.insert(0,{"expression": textA.text, "result": result.text})
            }
        }
        MyClickButton {
            width: 100
            anchors.left:compute.right
            text: qsTr( "Graf" )
            id: graf
            anchors.top: func_row.bottom
            onClicked: {
                vysl.visible = true

            }

        }



        //Obdelník pro výsledek
        Rectangle {
            height: 70;
            width: 400;
            border.color: "black";
            border.width: 2;
            color: "#777"
            anchors.top: compute.bottom
            Text {
                id:  result;
                anchors.centerIn: parent
                height: 35;
                font.pointSize: 22
                color: "white"
                text: "Tady by měl být výsledek :)";
            }
        }
    } //Konec okna pro kalkulačku

    Rectangle {
        id: vysl
        visible: false
        width: 400
        height: 600
        anchors.top: main_menu.bottom
        Image{
            source: "../pics/function-plot.png"
            width: 400
            height: 450
        }
        MyClickButton {
            anchors.right: vysl.right
            anchors.top: vysl.top
            width: 40
            height: 40
            text: qsTr("X")
            onClicked: {
                vysl.visible = false
            }
        }

    }

    Rectangle{ //Okno pro help
        id: help
                width: 400
                height: 650
                anchors.top: main_menu.bottom
                visible: false
                color: "#ccff99"


                Rectangle{
                    id:  help2;
                    height: 160;
                    width: 400;

                    Text {
                        id:  help2_text;

                        x: 10
                        y: 10

                        height: 6;
                        font.pointSize: 12
                        color: "#000000"
                        text: "Výraz můžete do kalkulačky zadávat třemi způsoby:
        1. Zadávejte jej přímo pomocí klávesnice.
        2. Klikejte myší na tlačítka s číslicemi a operátory.
        3. Můžete zadávat výraz pomocí hot-keys
        Všechny způsoby zadávání můžete kombinovat.

        Kliknutím na tlačítko 'spočítej' získáte výsledek.";
                    }
                }

                Rectangle{
                    id:  help_hot_keys;
                    height: 115;
                    width: 400;
                    anchors.top: help2.bottom

                    Text {
                        id:  help_hot_keys_text;
                        x: 10
                        y: 5

                        height: 4;
                        font.pointSize: 12
                        color: "#000000"
                        text: "Pomocí kláves PageUp a PageDown lze jednoduše
        přepínat mezi okny. \n
Pro informace k používání horkých kláves klikněte na
        tlačítko 'hot-keys' \n" ;
                    }
                }

                Rectangle{
                    id:  help_history;
                    height: 60;
                    width: 400;
                    anchors.top: help_hot_keys.bottom

                    Text {
                        id:  help_history_text;

                        x: 10
                        y: 5

                        height: 4;
                        font.pointSize: 12
                        color: "#000000"
                        text: "Pro zobrazení historie výsledků příkladů klikněte na
        tlačítko 'historie'" ;
                    }
                }



    }

    Rectangle{ //Okno pro hotkeys
        id: hkeys
        width: 400
        height: 650
        anchors.top: main_menu.bottom
        visible: false
        color: "#cdcdcd"
        ListView { //List pro historii, používá to ten seznam definovaný nahoře, ale je to ještě dost simple
            id: listView_shortcuts
            model: shortcuts
            width: 400; height: 400
            displayMarginBeginning: -49
            displayMarginEnd: 451

            delegate: Rectangle {
                width: 400; height: 50
                color: "transparent"
                //border.color: "black"
                //border.width: 1
                id: item_rect_shcuts
                Rectangle {
                    border.color: "black"
                    border.width: 1
                    id: rect_shcut
                    height: 50
                    radius: 5
                    width: 140
                    color: "white"
                    TextEdit {
                        id: txt_shcut
                        //color: "#bbbbbb"


                        height: 50
                        width: 110
                        text: shcut
                        verticalAlignment: TextEdit.AlignVCenter
                        leftPadding: 5
                        font.pixelSize: 20
                        onEditingFinished: {
                            shortcuts.setProperty(index, "shcut", txt_shcut.text)
                        }

                        //anchors.horizontalCenter: this.horizontalCenter
                    }
                }
                Rectangle{
                    anchors.left: rect_shcut.right
                    height: 50
                    width: 170
                    border.color: "black"
                    border.width: 1
                    color: "white"
                    radius: 5
                    id: rect_shwrite
                    TextEdit {
                        id: txt_shwrite
                        //color: "#bbbbbb"


                        height: 50
                        width: 200
                        text: shwrite
                        verticalAlignment: TextEdit.AlignVCenter
                        leftPadding: 5
                        font.pixelSize: 20
                        onEditingFinished: {
                            shortcuts.setProperty(index, "shwrite", txt_shwrite.text)

                        }

                        //anchors.horizontalCenter: this.horizontalCenter
                    }
                }
                MyListButton {
                    btnColor: "white"

                    width: 90
                    height: 50
                    radius: 5
                    anchors.left: rect_shwrite.right
                    text: {"Vymazat"}
                    onClicked: {
                        shortcuts.remove(index)
                    }

                }
                Shortcut{
                    sequence: shcut
                    onActivated: {
                        //textA.insert(textA.cursorPosition, shwrite)
                        textA.text = textA.text+shwrite;

                    }
                }
            }
        }


        Rectangle{
            width: 400
            height:50
            color: "#ccff99"
            anchors.top: listView_shortcuts.bottom
            MyListButton {
                btnColor: "#ccff99"
                id: shcut_clear
                width: 133
                height: 50
                radius: 5

                onClicked: {
                    shortcuts.clear()
                }
                text: {"Smazat vše"}
            }
            MyListButton {
                btnColor: "#ccff99"
                id: shcut_add
                anchors.left: shcut_clear.right
                width: 134
                height: 50
                radius: 5
                onClicked: {
                    shortcuts.append({"shcut": "", "shwrite": ""})
                }
                text: {"Přidat hotkey"}
            }
            MyListButton {
                btnColor: "#ccff99"
                id: shcut_apply
                anchors.left: shcut_add.right
                width: 133
                height: 50
                radius: 5
                onClicked: {
                    textA.forceActiveFocus()
                }
                text: {"Uložit změny"}
            }
        }
    }
    Rectangle{ //Okno pro historii
        id: hist
        width: 400
        height: 450
        anchors.top: main_menu.bottom
        visible: false
        color: "#cdcdcd"
        ListView { //List pro historii, používá to ten seznam definovaný nahoře, ale je to ještě dost simple
            id: listView_history
            model: history
            width: 400; height: 400
            displayMarginBeginning: -49
            displayMarginEnd: 451

            delegate: Rectangle {
                width: 400; height: 50
                color: "transparent"
                //border.color: "black"
                //border.width: 1
                id: item_rect
                Row {

                    MyListButton {
                        id: expr_btn
                        btnColor: "white"
                        radius: 5
                        onClicked: {
                            textA.text = textA.text + expression
                            for (var i = 0; i < controls.count; i++) {
                                controls.setProperty( i, "tog", (i == 0) );
                            }
                            calc.visible = true
                            hist.visible = false
                        }
                        height: 50
                        width: 200
                        text: {text: expression}

                        //anchors.horizontalCenter: this.horizontalCenter
                    }
                    MyListButton {
                        btnColor: "white"
                        width: 140
                        height: 50
                        radius: 5
                        onClicked: {
                            textA.text = textA.text + result
                            for (var i = 0; i < controls.count; i++) {
                                controls.setProperty( i, "tog", (i == 0) );
                            }
                            calc.visible = true
                            hist.visible = false
                        }
                        text: {text: result}
                    }
                    MyListButton {
                        color: "white"
                        width: 60
                        height: 50
                        radius: 5
                        text: {Qt.formatTime(new Date(),"hh:mm")}
                    }
                }
            }
        }
        Rectangle{
            width: 400
            height:50
            color: "#ccff99"
            anchors.top: listView_history.bottom

            MyListButton {
                btnColor: "#ccff99"
                width: 145
                height: 50
                radius: 5
                onClicked: {
                    history.clear()
                }
                text: {"Smazat historii"}
            }
        }


    }


}
