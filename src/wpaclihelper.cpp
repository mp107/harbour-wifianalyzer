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

#include "wpaclihelper.h"

#include <stdio.h>

WpaCliHelper::WpaCliHelper(QObject *parent) :
    QObject(parent)
{
}

WpaCliHelper::~WpaCliHelper()
{
}


void WpaCliHelper::callWpaCli(QString password) {
    QProcess process;

    process.start(QString("/bin/bash -c \"echo %1 | devel-su wpa_cli scan\"").arg((password)));
    if (!process.waitForFinished()) {
        emit gotScanError();
        return;
    }
    mWifiInfo = process.readAll();

    if (mWifiInfo.contains("Auth failed")) {
        emit gotAuthError();
        return;
    }

    process.start(QString("/bin/bash -c \"echo %1 | devel-su wpa_cli scan_results\"").arg((password)));
    if (!process.waitForFinished()) {
        emit gotResultError();
        return;
    }
    mWifiInfo = process.readAll();

    emit calledWpaCli();
}

QString WpaCliHelper::getWifiInfo() {
    return mWifiInfo;
}
