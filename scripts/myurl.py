#!/usr/bin/env python

import urllib
import os
import time

stats = {}

def print_stats():
  for k,v in stats.items():
    print "%s: %s" % (k,v)

def update_stats(k):
  if k in stats:
    stats[k] = stats[k]+1
  else:
    stats[k] = 1

while True:
  f = urllib.urlopen("http://nomad1")
  update_stats(f.read().strip())
  if int(time.time()) % 3 == 0:
    os.system("clear")
    print_stats()
