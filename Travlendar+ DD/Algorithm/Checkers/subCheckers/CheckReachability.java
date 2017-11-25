package checkers.subCheckers;

import checkers.CheckerInterface;
import mainServer.EventsManager;
import support.ActionParameters;
import support.Directions;
import support.EventInfo;

/**
 * Concrete class that implements the check interface. Its method check if the event is reachable from the previous
 * and the next one.
 */
public class CheckReachability implements CheckerInterface {

    private Directions directions = new Directions();
    private EventsManager manager = new EventsManager();

    @Override
    public Message check(ActionParameters eventInfo) {
        EventInfo info = (EventInfo)eventInfo;
        float timeNeeded = directions.getTimeNeeded(info.getEventDepartureCoord(), info.getEventArrivalCoord());

        if (  isReachble(timeNeeded, eventInfo) )
            return new Message(true, "check ok");

        return new Message(false, "Event not reachble on time!");
    }
















    private boolean isReachble(float timeNeeded, ActionParameters eventInfo) {
        manager.getTimeForTheNextEvent(eventInfo);
        return false;
    }
}
