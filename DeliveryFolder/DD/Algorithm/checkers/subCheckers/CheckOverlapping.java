/**
 * Concrete class that implements the check interface. Its method check if the event in creation overlaps other events
 * already existing in the calendar
 */
public class CheckOverlapping implements CheckerInterface {

    private EventsManager manager = new EventsManager();

    @Override
    public Message check(ActionParameters eventInfo ) {
        EventInfo info = (EventInfo)eventInfo;
        if ( startingTimeInAnotherEvent(eventInfo)
                && manager.getStartingTimeNextEvent(eventInfo) <= info.getEndingTime()  )
            return new Message(false, "The event overlaps the next one!");

        return new Message(true, "all ok");
    }
}
