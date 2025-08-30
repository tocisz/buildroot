################################################################################
#
# python-fast-histogram
#
################################################################################

PYTHON_FAST_HISTOGRAM_VERSION = 0.14
PYTHON_FAST_HISTOGRAM_SOURCE = fast_histogram-$(PYTHON_FAST_HISTOGRAM_VERSION).tar.gz
PYTHON_FAST_HISTOGRAM_SITE = https://files.pythonhosted.org/packages/e8/77/04a9b4b5caa6e6b3a2f633b15dec0996c1559fc26e9ba73bb3d1d844c874
PYTHON_FAST_HISTOGRAM_SETUP_TYPE = setuptools
PYTHON_FAST_HISTOGRAM_LICENSE = BSD
PYTHON_FAST_HISTOGRAM_LICENSE_FILES = LICENSE
PYTHON_FAST_HISTOGRAM_BUILD_OPTS = --skip-dependency-check

PYTHON_FAST_HISTOGRAM_DEPENDENCIES += \
    host-python-numpy \
    python3 \
    python-numpy

$(eval $(python-package))
