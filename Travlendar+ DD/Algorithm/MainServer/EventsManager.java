package mainServer;

import checkers.AddEventChecker;
import checkers.CheckerInterface;
import checkers.subCheckers.Message;
import support.ActionParameters;
import support.EventInfo;
import support.RepositoryManager;

/**
 * The EventManager is the class that manage all the operations concerning the events.
 * In this case is handled the add event operation
 */
public class EventsManager {

    public String addEvent(ActionParameters eventInfo){
        CheckerInterface operationChecker = new AddEventChecker();
        RepositoryManager repositoryManager = new RepositoryManager();

        Message result = operationChecker.check(eventInfo);
        if (result.getTruthValue())
            return repositoryManager.addEvent(eventInfo);
        else
            return result.getMessage();
    }


    float departureCoord;
    float arrivalCoord;
    float timeUntilNextEvent;
    public int getLunchDuration;


    public float getDepartureCoord() {
        //in relatà getterà dal DB
        return departureCoord;
    }

    public float getArrivalCoord() {
        return arrivalCoord;
    }

    public float getTimeUntilNextEvent() {
        return timeUntilNextEvent;
    }



    public float getTimeForTheNextEvent(ActionParameters eventInfo) {
        //compute the time between the passed event and its successor
        return (float)1;
    }

    public int getLunchStartingTime(EventInfo info) {

        return 0;
    }

    public int getLunchEndingTime() {
        return 0;
    }

    public Message checkLunchPreferenceRespected(EventInfo info) {
        return new Message(true, "ciao");
    }

    public float getTimeOnTheSameTime(ActionParameters eventInfo) {

        return 0;
    }

    public boolean isReachble(float timeNeeded, ActionParameters eventInfo) {

        return false;
    }

    public boolean getEventOnTheSameTime(ActionParameters eventInfo) {

        return false;
    }

    public float getStartingTimeNextEvent(ActionParameters eventInfo) {

        return 0;
    }
}
