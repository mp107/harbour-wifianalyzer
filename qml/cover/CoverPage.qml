/*
  Copyright (C) 2015 Petr Vytovtov
  Contact: Petr Vytovtov <osanwe@protonmail.ch>
  All rights reserved.

  This file is part of WiFi Analyzer for Sailfish OS.

  WiFi Analyzer is free software: you can redistribute it and/or modify
  it under the terms of the GNU General Public License as published by
  the Free Software Foundation, either version 3 of the License, or
  (at your option) any later version.

  WiFi Analyzer is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
  GNU General Public License for more details.

  You should have received a copy of the GNU General Public License
  along with WiFi Analyzer.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

CoverBackground {

    function calculateWifiNetworksCount(output) {
        var wifiNetworksCount = output.split('\n').length - 3
        switch (wifiNetworksCount) {
        case -2:
            infoColumn.visible = false
            errorMessage.visible = true
            errorMessage.text = "Please, turn WiFi on"
            return

        default:
            infoColumn.visible = true
            errorMessage.visible = false
            wifiCounter.text = wifiNetworksCount
            return
        }
    }

    Column {
        id: infoColumn
        anchors.centerIn: parent

        Label {
            id: wifiCounter
            font.bold: true
            font.pixelSize: Theme.fontSizeHuge
            text: "0"
        }

        Label {
            text: "WiFi networks"
        }
    }

    Label {
        id: errorMessage
        anchors.fill: parent
        anchors.leftMargin: Theme.paddingSmall
        anchors.rightMargin: Theme.paddingSmall
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.Wrap
        text: ""
    }

    Connections {
        target: wpaCliHelper
        onCalledWpaCli: calculateWifiNetworksCount(wpaCliHelper.getWifiInfo())
        onGotAuthError: console.log("onGotAuthError")
        onGotResultError: console.log("onGotResultError")
        onGotScanError: console.log("onGotScanError")
    }
}


