/**
 * Concrete class that implements the check interface. Its method check if the event is reachable from the previous
 * and the next one.
 */
public class CheckReachability implements CheckerInterface {

    @Override
    public Message check(ActionParameters eventInfo) {

        if (  isReachble(eventInfo) )
            return new Message(true, "check ok");

        return new Message(false, "Event not reachble on time!");
    }

}
