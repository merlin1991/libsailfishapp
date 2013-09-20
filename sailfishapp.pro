#
# sailfishapp.pro: Project file for libsailfishapp
#
# Copyright (c) 2013 Jolla Ltd.
# Contact: Thomas Perl <thomas.perl@jollamobile.com>
# All rights reserved.
#
# This file is part of libsailfishapp
#
# You may use this file under the terms of BSD license as follows:
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#     * Redistributions of source code must retain the above copyright
#       notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above copyright
#       notice, this list of conditions and the following disclaimer in the
#       documentation and/or other materials provided with the distribution.
#     * Neither the name of the Jolla Ltd nor the
#       names of its contributors may be used to endorse or promote products
#       derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE LIABLE FOR
# ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
# (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
# LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

TEMPLATE = lib
TARGET = sailfishapp
VERSION = 0.0.1

QT += quick qml

DEFINES += LIBSAILFISHAPP_LIBRARY

HEADERS += include/sailfishapp.h

SOURCES += src/sailfishapp.cpp
HEADERS += src/sailfishapp_priv.h

INCLUDEPATH += . include
DEPENDPATH += . include

CONFIG += create_pc create_prl no_install_prl
QMAKE_PKGCONFIG_NAME = sailfishapp
QMAKE_PKGCONFIG_DESCRIPTION = Sailfish Application Library
QMAKE_PKGCONFIG_LIBDIR = $$target.path
QMAKE_PKGCONFIG_INCDIR = $$target.path
QMAKE_PKGCONFIG_DESTDIR = pkgconfig

target.path = $$PREFIX/lib

feature.path = $$PREFIX/share/qt5/mkspecs/features/
feature.files = data/sailfishapp.prf

header.path = $$PREFIX/include/sailfishapp/
header.files = include/sailfishapp.h

launcher.path = $$PREFIX/bin
launcher.files = scripts/sailfish-app-launch

INSTALLS += target feature header launcher

CONFIG += link_pkgconfig
packagesExist(qdeclarative5-boostable) {
    message("Building with qdeclarative-boostable support")
    SOURCES += src/sailfishapp_priv_boosted.cpp

    #PKGCONFIG += qdeclarative5-boostable
    ## This gets added by qdeclarative5-boostable, but we must not have
    ## it when building the shared library (only when the app is linked)
    #LIBS -= -pie

    # XXX: Do not hardcode this; use PKGCONFIG += like above (but we
    # cannot do this at this point, because of the "-pie" linker flag)
    LIBS += -rdynamic -lmdeclarativecache5
    QMAKE_CXXFLAGS += -fPIC -fvisibility=hidden -fvisibility-inlines-hidden -I/usr/include/mdeclarativecache5

    # Use the right linker flags when linking the app
    QMAKE_PKGCONFIG_REQUIRES += qdeclarative5-boostable
} else {
    warning("qdeclarative-boostable not available; startup times will be slower")
    SOURCES += src/sailfishapp_priv_default.cpp
}