#!/usr/bin/env python

import urllib2
import os
import time
import socket

stats = {}

def print_stats():
  i = 1
  #for k,v in stats.items():
  for k,v in sorted(stats.items(), key=lambda x: x[1]):
    print "%2s. %s: %s" % (i, k, v)
    i += 1

def update_stats(k):
  if k in stats:
    stats[k] = stats[k]+1
  else:
    stats[k] = 1

while True:
  try:
    f1 = urllib2.urlopen("http://10.14.14.11", timeout=1)
    f2 = urllib2.urlopen("http://10.14.14.14", timeout=1)
  except (socket.timeout, urllib2.HTTPError):
    continue
  time.sleep(0.1)
  update_stats(f1.read().strip())
  update_stats(f2.read().strip())
  os.system("clear")
  print_stats()
