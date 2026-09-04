# OMNeT++ Supermarket Checkout Simulation

This repository contains the discrete event simulation of a supermarket checkout process built with **OMNeT++** and the library **queueinglib**.

The simulation models a beginning-to-end shopping process for an average customer, from entering the store and picking up items from aisles to determining which checkout station to visit, either self-checkout with fewer than 15 items or waiting in longer queues when there are more than 15 amount of items. After checkout, there would be a system where receipt checkers check the products before having the customer leave the store.
## Simulation Scenarios:
* **`[Config Normal]`**: This is the normal setup with an adequate number of 7 human cashiers and 3 self-checkout stations
* **`[Config Understaff]`**: This is a setup to test the system for being under stress with fewer cashiers (7 --> 3).
* **`[Config peakDay]`**: To simulate a busy store day (e.g., holidays) by increasing customer arrivals but keeping human cashiers at 7.

## Files Included are below:
* **`cashierQueues.cc`**: The C++ file with the logic and operation behind our system.
* **`cashierQueues.ned`**: The network file, which was used for the design and source
* **`omnetpp.ini`**: This is the configuration file containing the parameters, data trackers, and three different configurations/scenarios.
