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
  f1 = urllib.urlopen("http://10.14.14.11")
  f2 = urllib.urlopen("http://10.14.14.14")
  time.sleep(0.1)
  update_stats(f1.read().strip())
  update_stats(f2.read().strip())
  os.system("clear")
  print_stats()
