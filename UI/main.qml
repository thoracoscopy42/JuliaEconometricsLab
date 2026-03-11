import QtQuick
import QtQuick.Controls.Fusion
import QtQuick.Layouts
import QtQuick.Dialogs
import jlqml

ApplicationWindow {
    id: window
    visible: true
    width: 1280
    height: 760
    minimumWidth: 1000
    minimumHeight: 650
    title: "EconometricsTools"

    property int currentSection: 0

    property color bgColor: "#020305"
    property color panelColor: "#070b10"
    property color surfaceColor: "#0b1117"
    property color borderColor: "#16202b"
    property color accent: "#0a84ff"
    property color accentHover: "#2896ff"
    property color textColor: "#8fe9ff"
    property color mutedTextColor: "#62b8c9"
    property color strongTextColor: "#c7f6ff"
    property color activeNavColor: "#0d1823"
    property color activeStripColor: "#33a1ff"

    color: bgColor

    component StyledButton: Button {
        id: control
        hoverEnabled: true
        implicitHeight: 40

        background: Rectangle {
            radius: 8
            color: control.down ? "#0669cc" : (control.hovered ? accentHover : accent)
            border.width: 1
            border.color: "#35a0ff"
        }

        contentItem: Text {
            text: control.text
            color: "#021018"
            font.bold: true
            font.pixelSize: 14
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }

    component NavButton: Button {
        id: control
        property bool active: false

        hoverEnabled: true
        Layout.fillWidth: true
        implicitHeight: 42

        background: Rectangle {
            radius: 8
            color: control.active
                   ? activeNavColor
                   : (control.down ? "#0d1620" : (control.hovered ? "#101a25" : "#0a1016"))
            border.width: 1
            border.color: control.active ? "#2b5d88" : "#1b2a38"

            Rectangle {
                visible: control.active
                anchors.left: parent.left
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                width: 4
                radius: 2
                color: activeStripColor
            }
        }

        contentItem: Text {
            text: control.text
            color: control.active ? strongTextColor : textColor
            font.pixelSize: 14
            font.bold: true
            leftPadding: 14
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
    }

    component StyledTextField: TextField {
        color: strongTextColor
        selectedTextColor: "#021018"
        selectionColor: accent
        placeholderTextColor: mutedTextColor
        implicitHeight: 40

        background: Rectangle {
            radius: 8
            color: "#060b10"
            border.width: 1
            border.color: borderColor
        }
    }

    component PanelBox: Rectangle {
        radius: 10
        color: surfaceColor
        border.width: 1
        border.color: borderColor
    }

    component SectionTitle: Label {
        color: strongTextColor
        font.pixelSize: 24
        font.bold: true
    }

    component FieldLabel: Label {
        color: textColor
        font.pixelSize: 14
    }

    component CardTitle: Label {
        color: textColor
        font.pixelSize: 16
        font.bold: true
    }

    SplitView {
        anchors.fill: parent

        Rectangle {
            SplitView.preferredWidth: 250
            SplitView.minimumWidth: 220
            color: panelColor

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 14
                spacing: 12

                Label {
                    text: "Modules"
                    color: strongTextColor
                    font.bold: true
                    font.pixelSize: 18
                }

                NavButton {
                    text: "Data"
                    active: window.currentSection === 0
                    onClicked: window.currentSection = 0
                }

                Item { Layout.fillHeight: true }

                PanelBox {
                    Layout.fillWidth: true
                    implicitHeight: 120

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 12
                        spacing: 6

                        CardTitle { text: "Session" }
                        Label { text: "Dataset: not loaded"; color: textColor }
                        Label { text: "Rows: -"; color: mutedTextColor }
                        Label { text: "Columns: -"; color: mutedTextColor }
                    }
                }
            }
        }

        Rectangle {
            SplitView.fillWidth: true
            color: bgColor

            StackLayout {
                anchors.fill: parent
                currentIndex: window.currentSection

                Item {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    ColumnLayout {
                        anchors.fill: parent
                        anchors.margins: 16
                        spacing: 12

                        RowLayout {
                            Layout.fillWidth: true

                            SectionTitle { text: "Data" }

                            Item { Layout.fillWidth: true }

                            StyledButton {
                                text: "Browse"
                                onClicked: fileDialog.open()
                            }

                            StyledButton {
                                text: "Load"
                                onClicked: {
                                    statusText.text = Julia.read_file(pathField.text)
                                }
                            }

                            StyledButton {
                                text: "Reset"
                                onClicked: statusText.text = "Reset: jeszcze niepodpięte"
                            }

                            StyledButton {
                                text: "Save CSV"
                                onClicked: statusText.text = "Save CSV: jeszcze niepodpięte"
                            }

                            StyledButton {
                                text: "Save XLSX"
                                onClicked: statusText.text = "Save XLSX: jeszcze niepodpięte"
                            }
                        }

                        PanelBox {
                            Layout.fillWidth: true
                            implicitHeight: 185

                            GridLayout {
                                anchors.fill: parent
                                anchors.margins: 14
                                columns: 2
                                columnSpacing: 12
                                rowSpacing: 10

                                FieldLabel { text: "Path:" }
                                StyledTextField {
                                    id: pathField
                                    Layout.fillWidth: true
                                    placeholderText: "M:/repos_new/JuliaEconometricsLab/iris_all_nums.csv"
                                }

                                FieldLabel { text: "Detected format:" }
                                Label {
                                    Layout.fillWidth: true
                                    color: mutedTextColor
                                    text: "Not loaded"
                                }

                                FieldLabel { text: "Status:" }
                                Label {
                                    id: statusText
                                    Layout.fillWidth: true
                                    color: textColor
                                    text: "Ready."
                                    wrapMode: Text.WrapAnywhere
                                }
                            }
                        }

                        PanelBox {
                            Layout.fillWidth: true
                            Layout.fillHeight: true

                            ColumnLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 8

                                CardTitle { text: "Data preview" }

                                Rectangle {
                                    Layout.fillWidth: true
                                    Layout.fillHeight: true
                                    radius: 8
                                    color: "#060b10"
                                    border.width: 1
                                    border.color: borderColor

                                    Text {
                                        anchors.centerIn: parent
                                        text: "Tutaj później wstawisz TableView"
                                        color: mutedTextColor
                                        font.pixelSize: 18
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    FileDialog {
    id: fileDialog
    title: "Wybierz plik danych"
    nameFilters: ["Data files (*.csv *.xlsx)", "CSV files (*.csv)", "Excel files (*.xlsx)"]

    onAccepted: {
         let rawPath = selectedFile.toString()
        pathField.text = rawPath.replace("file:///", "")
        statusText.text = "Wybrano plik: " + pathField.text
        }
}
}