#!/usr/bin/env python

import urllib2
import os
import time
import socket

stats = {}

def print_stats():
  i = 1
  for k,v in stats.items():
  #for k,v in sorted(stats.items(), key=lambda x: x[1]):
    print "%2s. %s: %s" % (i, k, v)
    i += 1

def update_stats(k):
  if k in stats:
    stats[k] = stats[k]+1
  else:
    stats[k] = 1

while True:
  try:
    for h in ('10.14.14.11', '10.14.14.14', '10.24.14.16'):
      try:
        f = urllib2.urlopen("http://%s" % h, timeout=1)
      except (socket.timeout, urllib2.HTTPError):
        print "%s failed" % h
        raise Exception
  except Exception:
    continue
  
  time.sleep(0.1)
  update_stats(f.read().strip())
  os.system("clear")
  print_stats()
