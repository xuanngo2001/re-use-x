#!/bin/bash
set -e
# Description: Update re-use-x in firstboot.

fb_run_dir=$(readlink -ev /media/master/github/firstboot/apps/re-use-x/run)
re_use_x_script_dir=$(readlink -ev ./re-use-x)

# Update re-use-x to firstboot.
  rsync -a --delete ${re_use_x_script_dir}/ ${fb_run_dir}

# Commit re-use-x at firstboot.
  (
    cd "${fb_run_dir}"
    git ls-files --deleted -z | xargs -r -0 git rm && git commit -m 're-use-x: commit deleted files.' || true
    git ls-files --modified -z | xargs -r -0 git commit -m 're-use-x: commit changed files.'
    git ls-files --others -z | xargs -r -0 git add && git commit -m 're-use-x: commit new files.' || true
  )