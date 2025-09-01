################################################################################
#
# beep
#
################################################################################

BEEP_VERSION = 0d790fa45777896749a8
BEEP_SITE = https://github.com/johnath/beep.git
BEEP_SITE_METHOD = git
BEEP_LICENSE = GPL
BEEP_LICENSE_FILES = COPYING

define BEEP_BUILD_CMDS
	$(MAKE) -C $(@D) CC="$(TARGET_CC)" CFLAGS="$(TARGET_CFLAGS)"
endef

define BEEP_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/beep $(TARGET_DIR)/usr/bin/beep
endef

$(eval $(generic-package))
