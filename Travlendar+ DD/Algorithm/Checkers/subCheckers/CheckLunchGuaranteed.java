package checkers.subCheckers;

import checkers.CheckerInterface;
import mainServer.EventsManager;
import support.ActionParameters;
import support.EventInfo;

/**
 * Concrete class that implements the check interface. Its method check if the Lunch is guaranteed
 */

public class CheckLunchGuaranteed implements CheckerInterface {

    private EventsManager manager = new EventsManager();

    @Override
    public Message check(ActionParameters eventInfo ) {
        EventInfo info = (EventInfo)eventInfo;

        if ( !checkLunchPreferenceRespected(info).getTruthValue())
            return new Message(false, "The new event do not respect the lunch constraits!");

        return new Message(true, "all ok");
    }









    private Message checkLunchPreferenceRespected(EventInfo info) {
        manager = new EventsManager();
        manager.getTimeForTheNextEvent(info);
        return null;
    }
}
