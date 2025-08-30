################################################################################
#
# python-pyadi-iio
#
################################################################################

PYTHON_PYADI_IIO_VERSION = 0.0.19
PYTHON_PYADI_IIO_SOURCE = pyadi_iio-$(PYTHON_PYADI_IIO_VERSION).tar.gz
PYTHON_PYADI_IIO_SITE = https://files.pythonhosted.org/packages/31/d4/14cbf3844abf651858bcdc0b222c8e3dd10273ebdd498ad58aaf7b3fbf3b
PYTHON_PYADI_IIO_SETUP_TYPE = setuptools
PYTHON_PYADI_IIO_LICENSE = ADIBSD
PYTHON_PYADI_IIO_LICENSE_FILES = LICENSE

$(eval $(python-package))
