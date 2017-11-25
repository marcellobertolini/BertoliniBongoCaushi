package checkers;

import checkers.subCheckers.CheckLunchGuaranteed;
import checkers.subCheckers.CheckOverlapping;
import checkers.subCheckers.CheckReachability;
import checkers.subCheckers.Message;
import support.ActionParameters;

import java.util.ArrayList;

/**
 * Composite concrete class of the Composite pattern. It contains a list of the so called "leafs" of the composite pattern
 * and it calls the method check on all of them.
 */
public class AddEventChecker implements CheckerInterface {
    private ArrayList<CheckerInterface> myCheckers = new ArrayList<>();

    public AddEventChecker(){
        myCheckers.add(new CheckOverlapping());
        myCheckers.add(new CheckLunchGuaranteed());
        myCheckers.add(new CheckReachability());
    }

    @Override
    public Message check(ActionParameters eventInfo) {
        for ( CheckerInterface checker : myCheckers ) {
            Message result = checker.check(eventInfo);
            if (!result.getTruthValue())
                return result;
        }
        return new Message(true, "All ok");
    }
}
