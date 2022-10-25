#!/usr/bin/python3

import argparse
import os
import sys
import logging


parser = argparse.ArgumentParser(description="This Progream is a OSPerformance.")
parser.add_argument('--Lmbench', action='store_true',
                    help='Choice OSPerformance tools: Lmbench,')
parser.add_argument('--Stream', action='store_true',
                    help='Choice OSPerformance tools: Stream,')
parser.add_argument('--Libmicro', action='store_true',
                    help='Choice OSPerformance tools: Libmicro,')
parser.add_argument('--Fio', action='store_true',
                    help='Choice OSPerformance tools: Fio,')
parser.add_argument('--Netperf', action='store_true',
                    help='Choice OSPerformance tools: Netperf,')
parser.add_argument('--Unixbench', action='store_true',
                    help='Choice OSPerformance tools: Unixbench,')
parser.add_argument('--All', action='store_true',
                    help='Choice OSPerformance tools: All,')
args = parser.parse_args()

# 2. Call Subchecker's Handler
def checker_call_handler():
    print("args = %s\n" %(args))
    if args.All == True:
        print("This is All handler")
    else:
        if args.Lmbench == True:
            print("This is Lmbench handler")
        if args.Stream == True:
            print("This is Stream handler")
        if args.Libmicro == True:
            print("This is Libmicro handler")
        if args.Fio == True:
            print("This is Fio handler")
        if args.Netperf == True:
            print("This is Netperf handler")
        if args.Unixbench == True:
            print("This is Unixbench handler")
# Main entry point
if __name__ == '__main__':
    try:
        checker_call_handler()
    except Exception as e:
        print(e)
