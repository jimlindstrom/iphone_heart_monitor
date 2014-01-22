iphone_heart_monitor
====================

## Overview

This was a Saturday hacking project spawned from the idea, "I can actually see my own chest move 
when my heart beats; could I use a phone's sensors (accelerometer, gyroscope and magnetometer)
to make a crude EKG?"

I experimented with a few different techniques for acquiring, processing, and graphing the data,
and ended up with a pretty decent result.  (Obvious disclaimer #1: When I say "pretty decent
result," this is engineer-me talking, not (non-existant) doctor-me.  Don't make medical 
decisions based on this ;)


## Usage

#### Step 1: Grab data from your iPhone

I used the iPhone app, [Data Collection](https://itunes.apple.com/us/app/data-collection-free/id485523535?mt=8). 
The free version allows you to collect 10 seconds at a time, and email the results to yourself. 

In order to collect the data, first locate where your pulse is strongest in your neck. Then open 
the app and get it ready to record. Press the phone against your neck (obvious disclaimer #2: don't
cut off circulation here and kill yourself.) So that your neck pushes the phone out (horizontally 
away from your body) with each pulse. Ideally, hold your breath for the 10-second duration while 
you record data, in order to reduce measurement noise. When you've got the phone absolutely
steady, hit record, and let it go until it takes all 10 seconds of data.

When you're done, email yourself the data, then save it to disk.

#### Step 2: Pre-process the data

Next, run it through this script to parse the data and produce timestamped measurements:

    # this script parses the data, and dumps out a CSV. Each row is timestamped, and 
    # contains a snapshot of measurements
    $ ./log_to_csv.rb data/DataCollection_2013-12-22_122004.txt > deltas.csv
    
    # this is what the lines in the file look like:
    $ cat deltas.csv | tail -n 3
    0.016477549295648236, 2.217682732965143, 2.5656536532370398, 0.022953534197879565, 0.3849459484540247, 0.0121163092844825, 0.015510027662551724, 1.3091565421778875, 0.21348266956502787, 1.0128895559617868, 0.2591349355433496, 1.687705417618541
    0.0007138775682232276, 0.9122580498980946, 1.3171108054134935, 0.06569031090622286, 0.3547676838726715, 0.0007675931225747195, 0.140033392331782, 1.7536356166635304e-05, 0.38662408210868804, 0.0, 1.0365877143003286, 0.0
    3.1106750306428865, 0.02865759647583068, 0.21275287913973998, 0.0016750792229415226, 0.16466083174362314, 0.012414103072449743, 0.5510055104137556, 0.0004638187263665092, 0.07675630598735214, 0.06332226163909936, 3.174534134027905, 2.2970956121731025
    
#### Step 3: Plot the data

After that, go ahead and plot:
    
    # use gnuplot to read in 'deltas.csv' and plot 'deltas.png'
    $ gnuplot < show_deltas.gnuplot
    
