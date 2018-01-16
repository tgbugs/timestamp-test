github implementation of branch@{epoch} broken?

I think I have found a bug in how github urls deal with epoch time for commits.

Steps to reproduce:
1. Make a commit to a branch and note the epoch time using `git log --date=unix` or similar.
2. Push the commit to the corresponding branch on a remote that hosted on github.
3. Use a url with the format `https://github.com/userorg/blob/branch@{epoch}/file` to try to access the commit.
4. The commit with the recorded epoch time will not be what is resolved to. Instead github will resolve to the previous commit.

Cause:
Further testing revealed that it is possible to resolve to the commit, but you cannot use the epoch time of the commit itself, you must use the time at which github first saw the commit. So for example if I run `date +%s && git push && date +%s` I can check in the range of epochs and find the one where github first saw the commit.

Real example:
1. `git clone https://github.com/tgbugs/timestamp-test.git`
2. `git diff master@{1516067434} master@{1516067435}` will show results
3. Navigating to https://github.com/tgbugs/timestamp-test/compare/master@{1516067434}...master@{1516067435} claims that there is no difference.
4. Navigating to https://github.com/tgbugs/timestamp-test/compare/master@{1516067470}...master@{1516067471} does show the difference because that is when github recorded the record of my push.

I do not know if this is 'working as intended' but it is completely maddening because the behavior of a local git client and of github diverges completely and it is extremely difficult to impossible to determine the exact epoch that github saw/will see a change. (This behavior also breaks a huge number of very useful timestamp based use cases). As far as I can tell this is documented nowhere. Is this a bug? If not, is there a way to get the github url api to have the native behavior of the git client (i.e. use the actual commit time stamps and not magical github time)?
