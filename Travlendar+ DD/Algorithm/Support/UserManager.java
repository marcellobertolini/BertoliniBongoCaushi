package support;

import mainServer.EventsManager;

/**
 * The class that has to handle all the client's requests and dispatch them to the right components
 */
public class UserManager {
    EventsManager eventsManager = new EventsManager();

    public String addEvent(ActionParameters eventInfo){
        return eventsManager.addEvent(eventInfo);
    }

}
