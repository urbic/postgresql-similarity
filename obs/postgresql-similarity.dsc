Format: 1.0
Version: __OBS_PACKAGE_VERSION__-0
Source: __OBS_PACKAGE_NAME__
Binary: __OBS_PACKAGE_NAME__
Maintainer: Anton Shvetz <tz@sectorb.msk.ru>
Architecture: any
Build-Depends: debhelper (>= 9),
	postgresql-common,
	postgresql-server-dev-all,
	libicu-dev
Debtransform-Tar: __OBS_PACKAGE_NAME__-__OBS_PACKAGE_VERSION__.tar.xz
Files:
	00000000000000000000000000000000 0 __OBS_PACKAGE_NAME__`_'__OBS_PACKAGE_VERSION__.orig.tar.xz
	00000000000000000000000000000000 0 __OBS_PACKAGE_NAME__`_'__OBS_PACKAGE_VERSION__-0.diff.tar.xz
