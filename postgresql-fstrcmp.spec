%define name postgresql-fstrcmp
%define version 1.0
%define release 1.1
#%%define release_number 1
#%%define _arch i586

Name:		%{name}
Vendor:		A. N. Shvetz
Summary:	Function fstrcmp to make fuzzy comparisons between strings
Version:	%{version}
Release:	%{release}
Source:		%{name}.tar.xz
URL:		svn://coneforest/projects/%{name}
Group:		Productivity/Databases/Tools
BuildRoot:	%{_tmppath}/%{name}-%{version}
#BuildArch:	%{_arch}
BuildRequires: gcc make postgresql-devel libicu-devel
Requires:	postgresql92 postgresql92-server
License:	zlib

%description
Function fstrcmp to make fuzzy comparisons between strings

%description -l ru

%prep
%setup -c

%build
%{__make} -C %{name}

%install
%makeinstall -C %{name}

#%post

#%preun

%postun
#if [ -x %{_sbindir}/update-dictd.conf ]; then
#fi

%clean
%{__rm} -rf %{buildroot}

%files
%defattr(-,root,root,0644)
%doc %{_defaultdocdir}/%{name}/README.fstrcmp
%{_prefix}/lib/postgresql92/lib64/fstrcmp.so
%{_datadir}/postgresql92/fstrcmp/*.sql
