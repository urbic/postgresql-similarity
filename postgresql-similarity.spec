%define extension similarity

%define _pg_libdir %(pg_config --libdir)
%define _pg_sharedir %(pg_config --sharedir)
%define _pg_docdir %(pg_config --docdir)

Name:			postgresql-%{extension}
Summary:		PostgreSQL extension that calculates similarity between two strings
Version:		1.0
Release:		0
Source:			%{name}-%{version}.tar.xz
URL:			https://github.com/urbic/%{name}
Group:			Productivity/Databases/Tools
BuildRoot:		%{_tmppath}/%{name}-%{version}
BuildRequires: 	gcc make postgresql-devel libicu-devel
Requires:		postgresql postgresql-server
License:		GPL-2.0

%description
PostgreSQL extension package which provides functions that calculate similarity
between two strings.

%prep
%setup -q

%build
%{__make}

%install
%{__make} install DESTDIR=%{buildroot} docdir=%{_pg_docdir}/../%{name}

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-,root,root,0644)
%{_pg_docdir}/../%{name}
%{_pg_libdir}/%{extension}.so
%{_pg_sharedir}/extension
%{_pg_sharedir}/extension/%{extension}--%{version}.sql
%{_pg_sharedir}/extension/%{extension}.control

%changelog
