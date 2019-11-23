# Install a particular commit of R package

## Idea

To compare for example a package's current `master` on github with a given commit ID, this script helps you install that commit ID of the package with a new package name `<package>.<commit_id>` (default), or any name you like (via `--alias` option).

## Usage

Here I show how to download and use the script to install commit `8c7c61b` for `susieR` package as `susieR.8c7c61b`, so one can test / compare `susieR.8c7c61b::susie()` vs `susieR::susie()`. To run the script you need to have `sos` command available (via `pip install sos`).

Download:

```
wget https://raw.githubusercontent.com/gaow/misc/master/workflow/commmit_install/commit_install.sos \
	&& chmod +x commit_install.sos
```

Install the aforementioned commit:

```
./commit_install.sos --pkg stephenslab/susieR --commit 8c7c61b 
```

You should see on screen:

```
other attached packages:
[1] susieR.8c7c61b_0.8.1.0545
```

To remove this package after use,

```
R --slave -e "remove.packages('susieR.8c7c61b')"
```

