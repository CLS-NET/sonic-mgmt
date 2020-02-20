#!/usr/bin/python
# -*- coding: UTF-8 -*-

import time, re, sys, getopt

def cpu_g():
    f = open("/proc/stat", "r")
    for line in f:
        c = re.search("^cpu ", line)
        if c: 
            break
    f.close()
    line = line.split(" ")
    cpu_an = []
    for n in line:
        if n.isdigit():
            n=int(n)
            cpu_an.append(n)
    cpu_sum = sum(cpu_an)
    cpu_id = cpu_an[3]
    return cpu_sum, cpu_id

def cpu_usage(t_gap):
    a_sum, a_id = cpu_g()
    time.sleep(int(t_gap))
    b_sum, b_id = cpu_g()
    idle = b_id - a_id
    total = b_sum - a_sum
    t_us = total - idle
    cpu_us = (float(t_us)/total)*100
    return cpu_us

def main(argv):
    t_gap = 3
    try:
        opts, args = getopt.getopt(argv, "ht:")
    except getopt.GetopError:
        sys.exit(2)
    for opt, arg in opts:
        if opt == "-t":
            t_gap = arg
        elif opt == "-h":
            print "cal_cpu_us.py -t <intval>"
            sys.exit()

    us = cpu_usage(t_gap)

    output = open("/tmp/cpu_usage.txt", "w")
    output.write("Interval time " + str(t_gap) + "s, cpu usage is " + str(us) + "%\n")

if __name__ == "__main__":
    main(sys.argv[1:])
