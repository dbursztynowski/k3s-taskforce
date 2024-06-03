# Loop intIter times, sleep for tsleep time [ms], and repeat these steps for time duration lifeTme or outIter times.
# Basic run: $ python busycontainer.py <intIter> <tsleep> {otime=<time-in-seconds> | oiter=<integer-number>}
#   - example: $ python busycontainer.py 10000 5 otime=60
#   - but see the default settings below.

import sys
from time import sleep, monotonic

# Default settings
# These defaults are equivalet to running: $ python busycontainer.py 10000 5 otime=60
# The setting: intIter=10000 and tsleep=5 will gives approx. 100 outer loop iteartions per seconnd
#             and consumes around 2% of CPU capacity on Intel(R) Core(TM) i7-8850H CPU @ 2.60GHz.
#---------------
INT_ITER = 10000   # default number of inner loop iterations
T_SLEEP = 5        # default time in milliseconds to sleep after one complete inner loop run
LIFE_TIME = 60     # default time duration in seconds of the outer loop (i.e., expected life time of the process/container)
TIME_LOOP = True   # indicates that outer loop is time controlled, i.e., will stop after specified time duration 

def main():

  intIter = INT_ITER
  tsleep = T_SLEEP
  lifeTime = LIFE_TIME
  timeLoop = TIME_LOOP

  args = len(sys.argv) - 1
  print ("Default args are: inner iteration %i, sleep time %smsec, lifetime %isec" % (intIter, tsleep, lifeTime))
  print ("The script was called with %s arguments" % (args))

  if args != 3 and args != 0:
    print ("  wrong number of arguments (should be 3: inner loop iterations, sleep time, outer loop timelife in seconds or iterations)")
    quit()
  
  # convert the arguments
  if args == 3:
    intIter = int(sys.argv[1])
    tsleep = float(sys.argv[2])
    third = sys.argv[3]
    # convert the third argument; format examples: "otime=60" or "oiter=1000"
    if third.find("otime=") == 0:
      timeLoop = True
      try:
        lifeTime = float(third[len("otime="):])
      except:
        print("Wrong parameter %s - should be, e.g., otime=60, without spaces, etc." % (third))
        quit()
      print ("Running with args: inner iteration %i, sleep time %smsec, life time %.3fsec" % (intIter, tsleep, lifeTime))
    else:
      timeLoop = False
      if third.find("oiter=") == 0:
        try:
          outIter = int(third[len("oiter="):])
        except:
          print("Wrong parameter %s - should be, e.g., oiter=100, without spaces, etc" % (third))
          quit()
        print ("Running with args: inner iteration %i, sleep time %smsec, outer iterations %i" % (intIter, tsleep, outIter))
      else:
        print("Wrong parameter %s - should be, e.g., otime=60 or oiter=100, without spaces, etc." % (third))
        quit()
  else: print ("Running with args: inner iteration %i, sleep time %smsec, life time %.3fsec" % (intIter, tsleep, lifeTime))

  iout=0
  # cont==True => continue outer loop
  if (not timeLoop) and outIter == 0: cont = False
  else: cont = lifeTime != 0

  pi=3.14
  secstart = monotonic()     
  while cont:
  
    i=0
    while i<intIter:
      j = pi*pi*pi*pi
      i += 1
    sleep(tsleep/1000)
    
    if timeLoop and lifeTime > 0:     # otherwise infinite loop      
      if monotonic() - secstart >= lifeTime: cont = False
    else:
      if outIter > -1:                # otherwise infinite loop
        iout += 1
        if iout == outIter: cont = False

if __name__ == "__main__":
    main()
    print("Finished")
