import QtQuick 2.12
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.12
import QtQuick.Dialogs 1.0
import Qt.labs.lottieqt 1.0

Window {
    visible: true
    height: 800
    width: 480
    title: qsTr("QtLottieTester")
    color: "black"

    function getFileExtenion(filePath){
        var ext = filePath.split('.').pop();
        return ext;
    }

    function validateFileExtension(filePath) {
        var ext = filePath.split('.').pop();
        return ext === "json"
    }

    FileDialog {
        id: fileDialog
        title: "Please choose a file"
        onAccepted: {
            console.log("You chose: " + fileDialog.fileUrl)
            lottieCanvas.source = Qt.resolvedUrl(fileDialog.fileUrl)
            console.log(lottieCanvas.source)
            fileDialog.visible = false
        }
        onRejected: {
            console.log("Canceled")
            fileDialog.visible = false
        }
    }

    Rectangle {
        id: footerArea
        anchors.bottom: parent.bottom
        width: parent.width
        height: 40
        color: "#222"

        RowLayout {
            anchors.fill: parent

            Button {
                id: selectFileButton
                Layout.fillWidth: true
                text: "F"
                onClicked: {
                    fileDialog.visible = true
                }
            }
            Button {
                id: playFileButton
                Layout.fillWidth: true
                text: ">"
                onClicked: {
                    console.log(lottieCanvas.status)
                    if (lottieCanvas.status == LottieAnimation.Ready) {
                        console.log("inReady")
                        lottieCanvas.play()
                    } else if(lottieCanvas.status == LottieAnimation.Loading) {
                        console.log("NotReady")
                    }
                }
            }
            Button {
                id: stopFileButton
                Layout.fillWidth: true
                text: "[]"
                onClicked: {
                    lottieCanvas.pause()
                }
            }
        }
    }

    Item {
        width: parent.width
        anchors.top: parent.top
        anchors.bottom: footerArea.bottom
        anchors.left: parent.left
        anchors.right: parent.right

        DropArea {
            id: dragTarget
            anchors.fill: parent

            onEntered: {
                for(var i = 0; i < drag.urls.length; i++)
                    if(validateFileExtension(drag.urls[i]))
                        return
                console.log("No valid files, refusing drag event")
                drag.accept()
            }

            onDropped: {
                for(var i = 0; i < drop.urls.length; i++){
                    var ext = getFileExtenion(drop.urls[i]);
                    if(ext === "json"){
                        var durl = String(drop.urls[i]);
                        lottieCanvas.source = Qt.resolvedUrl(durl)
                    }
                }
            }

            LottieAnimation {
                id: lottieCanvas
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                autoPlay: false
                loops: LottieAnimation.Infinite
                quality: LottieAnimation.HighQuality
            }
        }
    }
}
