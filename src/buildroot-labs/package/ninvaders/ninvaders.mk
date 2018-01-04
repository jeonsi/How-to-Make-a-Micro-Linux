###############################################################################$
#
# ninvaders
#
################################################################################

NINVADERS_VERSION = 0.1.1
NINVADERS_SITE = http://downloads.sourceforge.net/project/ninvaders/ninvaders/0.1.1
NINVADERS_DEPENDENCIES = ncurses

define NINVADERS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(TARGET_CONFIGURE_OPTS) -C $(@D)
endef

define NINVADERS_INSTALL_TARGET_CMDS
	$(INSTALL) -m 0755 -D $(@D)/nInvaders $(TARGET_DIR)/usr/bin/nInvaders
endef

$(eval $(generic-package))
