#!/usr/bin/env python3
import shlex
import subprocess
import sys


LOCATION = "Ulm"


def run_cmd(*args, **kwargs):
    return subprocess.check_output(*args, **kwargs).decode().strip()


def get_weather_cast():
    cmd = "ansiweather -a False -p {}".format(LOCATION)
    raw_data = run_cmd(shlex.split(cmd))

    overall_sep_index = raw_data.find(":")
    print(raw_data[:overall_sep_index])
    raw_weather_data = (raw_data[overall_sep_index+1:]).split()
    print(" ".join(raw_weather_data[0:2]))
    print(" ".join(raw_weather_data[3:5]))
    print(" ".join(raw_weather_data[6:10]))
    print(" ".join(raw_weather_data[11:13]))


def get_weather_cast_five_days():
    cmd = "ansiweather -a False -p {} -F".format(LOCATION)
    raw_data = run_cmd(shlex.split(cmd))

    overall_sep_index = raw_data.find(":")
    print(raw_data[:overall_sep_index])

    raw_weather_data = (raw_data[overall_sep_index+1:] + ' - ').split()
    for index_begin in range(0, len(raw_weather_data), 6):
        print(" ".join(raw_weather_data[index_begin: index_begin+5]))


def main():
    get_weather_cast()
    sys.stdout.write("\n")
    get_weather_cast_five_days()


if __name__ == "__main__":
    main()
