# Project Sage

Analyze usage of a Black Duck system and offer sage advice for how to improve usage and get the most value out of the product. Identifies issues which represent poor practices and/or areas where best practices could/should be applied.

## Table Of Contents

- [Goals](#goals)
- [How to Run and Get Results](#run)
- [Release History](#release-history)

## Goals <a name="goals"/>

* Detect bad scanning practices which will result in poor system performance and/or inaccurate analysis results
* Easy to run
* Easy to understand guidance
* Easy to share results

# How to Run and Get Results <a name="run" />

Sage uses:

- Python3
- Credentials or an API token from your Black Duck server
  - The associated user account needs to have visibility to all the projects, versions, and scans you want to analyze, e.g. has role 'System Administrator', 'Super User', or 'Global Code Scanner'
- Highly recommended: [virtualenv](https://virtualenv.pypa.io/en/latest/), [virtualenvwrapper](https://virtualenvwrapper.readthedocs.io/en/latest/)

Sage produces analysis output in json format so it's easy to read (using a tool like jq) and it's easy to use as input to the other tools which might want to act on the information.

To run,

```bash
mkvirtualenv sage # optional, but again, nice to use virtualenv and virtualenvwrapper
pip3 install -r requirements.txt
python3 sage.py -h # for help
python3 sage.py https://your-hub-dns {api-token}
python3 sage.py https://your-hub-dns {api-token} -j # include jobs statistics
```

## Using a Proxy

Sage uses the blackduck PyPi library which, in turn, uses the Python requests library. The requests library supports use of proxies which can be configured via environment variables (see details at https://requests.readthedocs.io/en/master/user/advanced/), e.g.

```
$ export HTTP_PROXY="http://10.10.1.10:3128"
$ export HTTPS_PROXY="http://10.10.1.10:1080"
```

## Output

Analysis output is written, by default, to `/var/log/sage_says.json`. Use the -f option to specify a different path/filename to write the output into.

What you can expect to get,

```json
jq 'keys' < sage_says.json
[
  "hub_url",
  "hub_version",
  "job_statistics",
  "number_bom_scans",
  "number_signature_scans",
  "policies",
  "projects",
  "projects_with_too_many_versions",
  "sage_version",
  "scans",
  "time_of_analysis",
  "total_projects",
  "total_scan_size",
  "total_scans",
  "total_unmapped_scans",
  "total_versions",
  "unmapped_scans",
  "versions_with_too_many_scans",
  "versions_with_zero_scans"
]
```

```
 jq '.projects_with_too_many_versions' < sage_says.json # shows projects with > X versions
 jq '.total_unmapped_scans' < sage_says.json # show number of un-mapped scans
 jq '.unmapped_scans' < sage_says.json # show the list of un-mapped scans
 jq '.projects[] | "\(.name), \(.scanSize), \(.num_versions)"' sage_says.json | sed -e 's&^"&&' -e 's&"$&&' > projects_and_sizes.csv # Generate a CSV list of projects with their scan sizes
```

Output from Sage can form the input to other tools. For instance, the list of unmapped scans can be fed into another program that reads the scan (aka code location) URL and performs a DELETE on it to delete the un-mapped scan (aka code location).

You can also use https://viewer.dadroit.com tool for analysis of .JSON output.

# Release History <a name=release-history />

## Version 2.3.1
2021-04-28

- Add projectOwner
- Add project version activity to csv script
- Add filter activity script

## Version 2.3
2021-04-27

- Refactor to use new Client from hub-rest-api-python
- Copy common attributes for scan summaries

## Version 2.2
2021-04-12

- Robustness and performance improvements by utilizing the same requests.Session
- retries, timeouts (default 3 retries, 15 sec timeout)
- allow password in addition to access token authentication
- bearer token auto-renewal to allow > 2h running time
- fetch entities through pagination instead of hard-coded limits
- added elapsed time
- output warning about incomplete scan-summaries with 2020.8 and 2020.10
- identify projects without an owner

Bugs fixed:
- crash with missing createdAt or updatedAt
- crash with spans with < 2 elements
- analysis output messages no longer overwrite each other


## Version 2.0
2020-02-14

- Refactored the code to make it simpler, easier to maintain and test
- Added unit tests using pytest
- Adding more metadata, e.g.
  - total scans
  - total scan size (for all signature scans)
  - total projects
  - total versions
  - ...and more

## March 6, 2019

Adding more fine-grained analysis of projects

## March 3, 2019

Added job information
