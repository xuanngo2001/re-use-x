#!/bin/bash
set -e
# Description: Update Re-use-x in firstboot.

fb_re_use_x_run_dir=/media/master/github/firstboot/apps/re-use-x/run

rsync -r re-use-x/ ${fb_re_use_x_run_dir}
