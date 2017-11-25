package mainServer;

import support.EventInfo;
import support.UserManager;

/**
 * Created by raffaelebongo on 20/11/17.
 */
public class Main {

    public static void main(String [ ] args)
    {
        UserManager userManager = new UserManager();
        EventInfo eventInfo = new EventInfo();
        System.out.println(userManager.addEvent(eventInfo));
    }
}
