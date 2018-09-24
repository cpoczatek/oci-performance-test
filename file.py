with open('data.out', 'w') as f:
  for i in xrange(3000000):
    f.write("%s\n" % str(i))
