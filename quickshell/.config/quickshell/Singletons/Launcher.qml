// based on https://git.outfoxxed.me/outfoxxed/nixnew/src/commit/a277ffae67efccc34237db7f42fc0f3c535a71fe/modules/user/modules/quickshell/shell/launcher/Controller.qml

pragma Singleton
pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Io
import Quickshell.Wayland
import QtQuick
import QtQuick.Layouts

Singleton {
    FloatingWindow {
        id: launcher
        visible: false

        onVisibleChanged: searchInput.text = ""
        implicitWidth: 500
        implicitHeight: 50 + searchBox.implicitHeight + results.topMargin * 2 + results.delegateHeight * 10
        Behavior on height {
            NumberAnimation {
                duration: 200
                easing.type: Easing.OutCubic
            }
        }

        color: "transparent"

        WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
        WlrLayershell.namespace: "launcher"

        Rectangle {

            implicitHeight: 50 + searchBox.implicitHeight + results.topMargin + results.bottomMargin + Math.min(results.contentHeight, results.delegateHeight * 10)
            width: parent.width
            color: Theme.barColor
            radius: Theme.screenRounding

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 7
                anchors.bottomMargin: 0
                spacing: 0

                Rectangle {
                    id: searchBox
                    Layout.fillWidth: true
                    implicitHeight: searchRow.implicitHeight + 10
                    color: Theme.textColor
                    radius: 3

                    RowLayout {
                        id: searchRow
                        anchors.fill: parent
                        anchors.margins: 5

                        // Image {
                        //     // TODO search icon
                        // }
                        Rectangle {
                            color: Theme.textColor
                            radius: Theme.screenRounding
                            Layout.preferredWidth: 20
                            Layout.preferredHeight: 20

                            Text {
                                anchors.centerIn: parent
                                text: "🔍"
                                font.pointSize: 14
                            }
                        }

                        TextInput {
                            id: searchInput
                            Layout.fillWidth: true
                            color: Theme.barColor

                            focus: true
                            Keys.forwardTo: [results]
                            Keys.onEscapePressed: launcher.visible = false
                            font.pointSize: 10

                            onAccepted: {
                                if (results.currentItem) {
                                    results.currentItem.clicked(null);
                                }
                            }
                            onTextChanged: {
                                results.currentIndex = 0;
                            }
                        }
                    }
                }

                ListView {
                    id: results
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    clip: true
                    cacheBuffer: 0 // HACK: works around QTBUG-131106

                    model: ScriptModel {
                        values: {
                            const r = DesktopEntries.applications.values.map(object => {
                                const query = searchInput.text.toLowerCase();
                                const name = object.name.toLowerCase();

                                let score = 0;
                                let queryIndex = 0;
                                let nameIndex = 0;

                                while (queryIndex < query.length && nameIndex < name.length) {
                                    if (query[queryIndex] === name[nameIndex]) {
                                        score++;
                                        queryIndex++;
                                    } else {
                                        score--;
                                    }
                                    nameIndex++;
                                }

                                while (queryIndex < query.length) {
                                    score--;
                                    queryIndex++;
                                }

                                return {
                                    object: object,
                                    score: score
                                };
                            }).filter(entry => entry !== null).sort((a, b) => {
                                return b.score - a.score;
                            }).map(entry => entry.object);

                            console.log(r);
                            return r;
                        }

                        onValuesChanged: results.currentIndex = 0
                    }

                    topMargin: 7
                    bottomMargin: results.count == 0 ? 0 : 7

                    add: Transition {
                        NumberAnimation {
                            property: "opacity"
                            from: 0
                            to: 1
                            duration: 100
                        }
                    }

                    displaced: Transition {
                        NumberAnimation {
                            property: "y"
                            duration: 200
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            property: "opacity"
                            to: 1
                            duration: 100
                        }
                    }

                    move: Transition {
                        NumberAnimation {
                            property: "y"
                            duration: 100
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            property: "opacity"
                            to: 1
                            duration: 50
                        }
                    }

                    remove: Transition {
                        NumberAnimation {
                            property: "y"
                            duration: 100
                            easing.type: Easing.OutCubic
                        }
                        NumberAnimation {
                            property: "opacity"
                            to: 0
                            duration: 50
                        }
                    }

                    highlight: Rectangle {
                        radius: 5
                        color: Theme.inactiveColor
                    }

                    keyNavigationEnabled: true
                    keyNavigationWraps: true
                    highlightMoveVelocity: -1
                    highlightMoveDuration: 100
                    preferredHighlightBegin: results.topMargin
                    preferredHighlightEnd: results.height - results.bottomMargin
                    highlightRangeMode: ListView.ApplyRange
                    snapMode: ListView.SnapToItem

                    readonly property real delegateHeight: 20

                    delegate: MouseArea {
                        required property DesktopEntry modelData

                        implicitHeight: results.delegateHeight
                        implicitWidth: ListView.view.width // TODO: what?

                        onClicked: {
                            modelData.execute();
                            launcher.visible = false;
                        }
                        clip: true

                        RowLayout {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 5

                            Image {
                                asynchronous: true
                                Layout.alignment: Qt.AlignVCenter
                                Layout.preferredWidth: results.delegateHeight
                                Layout.preferredHeight: results.delegateHeight

                                source: Quickshell.iconPath(modelData.icon, true)
                            }
                            Text {
                                text: modelData.name
                                color: Theme.textColor
                                font.pointSize: 11
                                Layout.alignment: Qt.AlignVCenter
                            }
                        }
                    }
                }
            }
        }
        IpcHandler {
            target: "launcher"

            function toggle(): void {
                launcher.visible = !launcher.visible;
            }
        }

        function init() {
        }
    }
}
