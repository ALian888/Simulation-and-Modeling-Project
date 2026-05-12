#include <omnetpp.h>
#include "Job.h"

using namespace omnetpp;
using namespace queueing;

class ShoppingDelay : public cSimpleModule {
  protected:
    virtual void handleMessage(cMessage *msg) override {
        if (msg->isSelfMessage()) {
            Job *job = static_cast<Job *>(msg->getContextPointer());
            send(job, "out");
            delete msg;
        }
        else {
            Job *job = check_and_cast<Job *>(msg);

            int items = intuniform(1, 50);
            job->addPar("numItems") = (long)items;

            simtime_t delay = (items * 2.0) + uniform(60, 300);

            EV_INFO << "Customer " << job->getName() << " shopping with " << items << " items.\n";

            cMessage *timer = new cMessage("shopping-timer");
            timer->setContextPointer(job);
            scheduleAt(simTime() + delay, timer);
        }
    }
};
Define_Module(ShoppingDelay);

class ItemClassifier : public cSimpleModule {
  protected:
    virtual void handleMessage(cMessage *msg) override {
        Job *job = check_and_cast<Job *>(msg);

        long items = job->hasPar("numItems") ? job->par("numItems").longValue() : 0;

        int gateIndex = (items < 10) ? 0 : 1;

        EV_INFO << "Routing " << job->getName() << " to gate " << gateIndex << " (" << items << " items)\n";
        send(job, "out", gateIndex);
    }
};
Define_Module(ItemClassifier);
