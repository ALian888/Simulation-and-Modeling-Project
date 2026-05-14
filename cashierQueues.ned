import org.omnetpp.queueing.Source;
import org.omnetpp.queueing.Classifier;
import org.omnetpp.queueing.PassiveQueue;
import org.omnetpp.queueing.Server;
import org.omnetpp.queueing.Sink;

simple ItemClassifier
{
    parameters:
        @display("i=block/rout");
    gates:
        input in;
        output out[];
}

simple ShoppingDelay
{
    parameters:
        @display("i=block/delay");
    gates:
        input in;
        output out;
}

network cashierQueues
{
    parameters:
        int numCashiers = default(7);
        int numSelfCheckouts = default(3);
        @display("bgb=1150,1600");
    submodules:
        entrance: Source {
            @display("p=50,300;i=block/source");
        }
        shopping: ShoppingDelay {
            @display("p=150,300;i=misc/globe");
        }
        router: ItemClassifier {
            @display("p=250,300;i=block/dispatch");
        }
        selfCheckoutQueue: PassiveQueue {
            @display("p=400,150;i=block/queue");
        }
        selfCheckouts[numSelfCheckouts]: Server {
            @display("p=555,149,m,1,50;i=block/server");
        }
        cashierQueue: PassiveQueue {
            @display("p=398,439;i=block/queue");
        }
        cashiers[numCashiers]: Server {
            @display("p=556,438,m,1,50;i=block/server");

        }
        receiptQueue: PassiveQueue {
            @display("p=700,300;i=block/queue");
        }
        receiptChecker: Server {
            @display("p=800,300;i=block/user");
        }
        exit: Sink {
            @display("p=900,300;i=block/sink");
        }
    connections allowunconnected:

        entrance.out --> shopping.in;
        shopping.out --> router.in;

        router.out++ --> selfCheckoutQueue.in++;
        router.out++ --> cashierQueue.in++;

        for i=0..numSelfCheckouts-1 {
            selfCheckoutQueue.out++ --> selfCheckouts[i].in++;
        }

        for i=0..numCashiers-1 {
            cashierQueue.out++ --> cashiers[i].in++;
        }

        for i=0..numSelfCheckouts-1 {
            selfCheckouts[i].out --> receiptQueue.in++;
        }

        for i=0..numCashiers-1 {
            cashiers[i].out --> receiptQueue.in++;
        }

        receiptQueue.out++ --> receiptChecker.in++;
        receiptChecker.out --> exit.in++;
}
