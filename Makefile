VERSION=1.0.1
PKG=nupkg-build/local-package.$(VERSION).nupkg

.PHONY: pack
pack: ${PKG}

.PHONY: reinstall-tool
install:
	dotnet tool uninstall local-package --local || true
	dotnet tool install local-package --local --no-cache --configfile nupkg.localonly.config --version $(VERSION)

.PHONY: run-tool
run:
	dotnet local-package

${PKG}: Package/*.cs
	dotnet pack ./Package/Package.csproj /p:Version=$(VERSION)