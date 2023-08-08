# The dotnet install tool caching bug

This repro repo (that's fun to say) demonstrates what happens when you attempt to install a local-only nupkg tool with the --no-cache flag. Essentially, the flag is ignored, and if there is a nuget package cached with the provided version number, it will reinstall from there.

The included makefile has all of the steps to reproduce the error. My repro here is done on Mac OS, but the scripts are really simple.

## Steps to reproduce
1. [`make pack`] - Pack a new tool (`dotnet pack`) into `./nupkg-build`.
2. [`make install`] - Install the new local tool using a local-dir-only config AND specifying `--no-cache`
3. [`make run`] - Run the tool and observe the output `I'm just a silly local tool`
4. Edit `Package/Program.cs` and change the output string on line 9.
5. [`make pack`] - Repack your tool using the same version number
6. [`make install`] - Uninstall and reinstall the local tool, still specifying `--no-cache`
7. [`make run`] - Run the tool and observe the terminal output.

### Expected outcome
The tool should output the updated text from step 4.

### Actual outcome
The output text still reads `I'm just a silly local tool`, indicating we're using a cached build.

The package that was installed should be the new build. We've specified twice that `nupkg-build/local-package.1.0.1.nupkg` should be installed fresh. First by using `nupkg.localonly.config` to specify the `nupkg-build` directory, and then again by using the `--no-cache` flag during install to ensure that we don't use the previously installed version.

## Workaround
`nuget locals all -clear`
You need to manually clear your nuget cach using this command to make sure that we refetch the locally built nupkg on next install.