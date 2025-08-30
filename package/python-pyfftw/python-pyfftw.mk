################################################################################
#
# python-pyfftw
#
################################################################################

PYTHON_PYFFTW_VERSION = 0.15.0
PYTHON_PYFFTW_SOURCE = pyfftw-$(PYTHON_PYFFTW_VERSION).tar.gz
PYTHON_PYFFTW_SITE = https://files.pythonhosted.org/packages/4b/3f/ee1bc44b080fc1e81d293cd07bed563d254bc1997d63a3b8053804a87dfd
PYTHON_PYFFTW_SETUP_TYPE = setuptools
PYTHON_PYFFTW_LICENSE = BSD
PYTHON_PYFFTW_LICENSE_FILES = LICENSE
PYTHON_PYFFTW_BUILD_OPTS = --skip-dependency-check

PYTHON_PYFFTW_DEPENDENCIES += \
    host-python-cython \
    host-python-numpy \
    python3 \
    python-numpy

$(eval $(python-package))
