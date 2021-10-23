#
# spec file for package postgresql-similarity
#
# Copyright (c) 2021 SUSE LLC
#
# All modifications and additions to the file contributed by third parties
# remain the property of their copyright owners, unless otherwise agreed
# upon. The license for this file, and modifications and additions to the
# file, is the same license as for the pristine package itself (unless the
# license for the pristine package is not an Open Source License, in which
# case the license is the MIT License). An "Open Source License" is a
# license that conforms to the Open Source Definition (Version 1.9)
# published by the Open Source Initiative.

# Please submit bugfixes or comments via https://bugs.opensuse.org/
#


%define _pg_libdir %(pg_config --pkglibdir)
%define _pg_sharedir %(pg_config --sharedir)
%define _pg_docdir %(pg_config --docdir)
Name:           __OBS_PACKAGE_NAME__
Version:        __OBS_PACKAGE_VERSION__
Release:        0
Summary:        __OBS_PACKAGE_SUMMARY__
License:        GPL-2.0-only
Group:          Productivity/Databases/Tools
URL:            https://github.com/urbic/%{name}
Source:         %{name}-%{version}.tar.xz
BuildRequires:  gcc
BuildRequires:  make
BuildRequires:  pkgconfig
BuildRequires:  postgresql-server-devel
BuildRequires:  pkgconfig(icu-i18n)
Requires:       postgresql
Requires:       postgresql-server

%description
PostgreSQL extension package which provides functions that calculate similarity
between two strings.

%prep
%autosetup

%build
%make_build

%install
%make_install docdir=%{_pg_docdir}/../%{name}

%files
%{_pg_docdir}/../%{name}
%dir %{_pg_libdir}
%{_pg_libdir}/*.so
%dir %{_pg_sharedir}/extension
%{_pg_sharedir}/extension/*

%changelog
