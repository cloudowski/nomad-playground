#!/usr/bin/env python

import urllib2
import os
import time
import socket

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
