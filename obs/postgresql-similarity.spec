%define _pg_libdir %(pg_config --pkglibdir)
%define _pg_sharedir %(pg_config --sharedir)
%define _pg_docdir %(pg_config --docdir)

Name:			__OBS_PACKAGE_NAME__
Summary:		__OBS_PACKAGE_SUMMARY__
Version:		__OBS_PACKAGE_VERSION__
Release:		0
Source:			%{name}-%{version}.tar.xz
URL:			https://github.com/urbic/%{name}
Group:			Productivity/Databases/Tools
BuildRoot:		%{_tmppath}/%{name}-%{version}
Requires:		postgresql postgresql-server
BuildRequires: 	gcc make postgresql-server-devel libicu-devel
%if 0%{?mageia}
BuildRequires:	postgresql9.6-devel
%endif
License:		GPL-2.0

%description
PostgreSQL extension package which provides functions that calculate similarity
between two strings.

%prep
%setup -q

%build
%{__make}

%install
%make_install docdir=%{_pg_docdir}/../%{name}

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-,root,root)
%{_pg_docdir}/../%{name}
%dir %{_pg_libdir}
%{_pg_libdir}/*.so
%dir %{_pg_sharedir}/extension
%{_pg_sharedir}/extension/*

%changelog
