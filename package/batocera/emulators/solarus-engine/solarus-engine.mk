################################################################################
#
# solarus-engine
#
################################################################################
# Version.: Release 1.6.5
SOLARUS_ENGINE_VERSION = b0bd6b85ccfcfd85409211e3abc550e33b992a8a
SOLARUS_ENGINE_SITE = https://gitlab.com/solarus-games/solarus
SOLARUS_ENGINE_SITE_METHOD=git

SOLARUS_ENGINE_LICENSE = GPL-3.0 (code), CC-BY-SA-4.0 (Solarus logos and icons), \
	CC-BY-SA-3.0 (GUI icons)
SOLARUS_ENGINE_LICENSE_FILES = license.txt

# Install libsolarus.so
SOLARUS_ENGINE_INSTALL_STAGING = YES

SOLARUS_ENGINE_DEPENDENCIES = glm libmodplug libogg libvorbis openal physfs \
	sdl2 sdl2_image sdl2_ttf

# Disable launcher GUI (requires Qt5)
SOLARUS_ENGINE_CONF_OPTS = \
	-DSOLARUS_GUI=OFF \
	-DSOLARUS_TESTS=OFF

ifeq ($(BR2_PACKAGE_HAS_LIBGL),y)
# Batocera - RPi4 prefer GLES
  ifeq ($(!BR2_PACKAGE_BATOCERA_RPI4_WITH_XORG),y)
    SOLARUS_ENGINE_DEPENDENCIES += libgl
  endif
else
ifeq ($(BR2_PACKAGE_HAS_LIBGLES),y)
SOLARUS_ENGINE_DEPENDENCIES += libgles
SOLARUS_ENGINE_CONF_OPTS += -DSOLARUS_GL_ES=ON
endif
endif

SOLARUS_ENGINE_CONF_OPTS += -DSOLARUS_BASE_WRITE_DIR=/userdata/saves
SOLARUS_ENGINE_CONF_OPTS += -DSOLARUS_WRITE_DIR=solarus

ifeq ($(BR2_aarch64),y) # https://github.com/kubernetes/ingress-nginx/issues/2802
SOLARUS_ENGINE_CONF_OPTS += -DSOLARUS_USE_LUAJIT=OFF
SOLARUS_ENGINE_DEPENDENCIES += lua
else
ifeq ($(BR2_PACKAGE_LUAJIT),y)
SOLARUS_ENGINE_CONF_OPTS += -DSOLARUS_USE_LUAJIT=ON
SOLARUS_ENGINE_DEPENDENCIES += luajit
else
SOLARUS_ENGINE_CONF_OPTS += -DSOLARUS_USE_LUAJIT=OFF
SOLARUS_ENGINE_DEPENDENCIES += lua
endif
endif

$(eval $(cmake-package))
